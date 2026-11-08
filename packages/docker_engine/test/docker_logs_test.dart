import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:docker_engine/docker_engine.dart' hide Platform;
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:test/test.dart';

import 'utils/docker_frames.dart';

void main() {
  late HttpServer server;
  late DockerConnection connection;
  late Future<void> Function(HttpRequest) logs;
  late List<Socket> sockets;
  var logRequests = 0;
  const timeout = Duration(seconds: 3);

  setUp(() async {
    sockets = [];
    logRequests = 0;
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    addTearDown(() async {
      for (final socket in sockets) {
        socket.destroy();
      }
      await server.close(force: true);
    });
    server.listen((request) async {
      await request.drain<void>();
      if (request.uri.path == '/version') {
        request.response.headers.contentType = ContentType.json;
        request.response.write('{"ApiVersion":"1.45"}');
        await request.response.close();
      } else if (request.uri.path == '/v1.45/containers/container-1/logs') {
        logRequests++;
        expect(request.uri.queryParameters, {
          'follow': 'true',
          'stdout': 'true',
          'stderr': 'true',
          'tail': '0',
        });
        await logs(request);
      } else {
        request.response.statusCode = 404;
        await request.response.close();
      }
    });
    connection = await DockerConnection.connect(
      DockerConfig(
        endpoint: Uri.parse('http://127.0.0.1:${server.port}'),
        requestTimeout: timeout,
      ),
    );
    addTearDown(connection.close);
  });

  Future<Socket> detach(
    HttpRequest request,
    Completer<void> disconnected, {
    bool headers = true,
  }) async {
    if (headers) request.response.headers.chunkedTransferEncoding = true;
    final socket = await request.response.detachSocket(writeHeaders: headers);
    sockets.add(socket);
    void closed() {
      if (!disconnected.isCompleted) disconnected.complete();
    }

    socket.listen((_) {}, onDone: closed, onError: (Object _) => closed());
    return socket;
  }

  test('delivers live output before EOF, tolerates silence and cancels only its request', () async {
    final disconnected = Completer<void>();
    final opened = Completer<Socket>();
    logs = (request) async {
      final socket = await detach(request, disconnected);
      opened.complete(socket);
      writeChunk(socket, frame(1, utf8.encode('first')));
      await socket.flush();
    };
    final stream = connection.api.logsStream(
      id: 'container-1',
      tty: false,
      tail: 0,
    );
    expect(logRequests, 0);
    final output = StreamIterator(stream);
    addTearDown(output.cancel);
    expect(await output.moveNext().timeout(const Duration(seconds: 2)), true);
    expect(output.current.text, 'first');
    expect(output.current.source, DockerLogSource.stdout);
    await Future.pause(timeout + const Duration(milliseconds: 100));
    final socket = await opened.future;
    writeChunk(socket, frame(2, utf8.encode('second')));
    await socket.flush();
    expect(await output.moveNext().timeout(const Duration(seconds: 2)), true);
    expect(output.current.text, 'second');
    expect(output.current.source, DockerLogSource.stderr);
    await output.cancel().timeout(const Duration(seconds: 2));
    await disconnected.future.timeout(const Duration(seconds: 2));
    final response = await connection.transport.get(
      connection.api.client.baseUrl.replace(path: '/version'),
    );
    expect(response.statusCode, 200);
  });

  test('cancels while waiting for headers', () async {
    final disconnected = Completer<void>();
    final opened = Completer<void>();
    logs = (request) async {
      await detach(request, disconnected, headers: false);
      opened.complete();
    };
    final subscription = connection.api
        .logsStream(id: 'container-1', tty: false, tail: 0)
        .listen((_) {});
    await opened.future;
    await subscription.cancel().timeout(const Duration(seconds: 2));
    await disconnected.future.timeout(const Duration(seconds: 2));
  });

  test('cancelling one follower leaves another follower active', () async {
    final disconnected = [Completer<void>(), Completer<void>()];
    final opened = [Completer<Socket>(), Completer<Socket>()];
    logs = (request) async {
      final index = logRequests - 1;
      final socket = await detach(request, disconnected[index]);
      opened[index].complete(socket);
      writeChunk(socket, frame(1, utf8.encode('ready')));
      await socket.flush();
    };
    final first = StreamIterator(
      connection.api.logsStream(id: 'container-1', tty: false, tail: 0),
    );
    addTearDown(first.cancel);
    expect(await first.moveNext(), true);
    final second = StreamIterator(
      connection.api.logsStream(id: 'container-1', tty: false, tail: 0),
    );
    addTearDown(second.cancel);
    expect(await second.moveNext(), true);
    await first.cancel();
    await disconnected[0].future.timeout(const Duration(seconds: 2));
    final socket = await opened[1].future;
    writeChunk(socket, frame(2, utf8.encode('still live')));
    await socket.flush();
    expect(await second.moveNext().timeout(const Duration(seconds: 2)), true);
    expect(second.current.text, 'still live');
    expect(second.current.source, DockerLogSource.stderr);
    await second.cancel();
    await disconnected[1].future.timeout(const Duration(seconds: 2));
  });

  test(
    'disposes a late response from an injected client after cancellation',
    () async {
      final requested = Completer<void>();
      final response = Completer<http.StreamedResponse>();
      final cancelled = Completer<void>();
      final bytes = StreamController<List<int>>(onCancel: cancelled.complete);
      addTearDown(bytes.close);
      final client = MockClient.streaming((request, body) async {
        requested.complete();
        return response.future;
      });
      addTearDown(client.close);
      final api = Docker.create(
        baseUrl: Uri.parse('http://docker/v1.53'),
        httpClient: client,
      );
      addTearDown(api.client.dispose);
      final subscription = api
          .logsStream(id: 'container-1', tty: false, tail: 0)
          .listen((_) => fail('Cancelled stream emitted output'));
      await requested.future;
      await subscription.cancel().timeout(const Duration(seconds: 2));
      response.complete(http.StreamedResponse(bytes.stream, 200));
      await cancelled.future.timeout(const Duration(seconds: 2));
    },
  );

  test('times out stalled headers and closes the request', () async {
    final disconnected = Completer<void>();
    logs = (request) async {
      await detach(request, disconnected, headers: false);
    };
    await expectLater(
      connection.api
          .logsStream(id: 'container-1', tty: false, tail: 0)
          .toList(),
      throwsA(isA<TimeoutException>()),
    );
    await disconnected.future.timeout(const Duration(seconds: 2));
  });

  test('closing the connection releases a paused log request', () async {
    final disconnected = Completer<void>();
    final received = Completer<void>();
    logs = (request) async {
      final socket = await detach(request, disconnected);
      writeChunk(socket, frame(1, utf8.encode('ready')));
      await socket.flush();
    };
    final subscription = connection.api
        .logsStream(id: 'container-1', tty: false, tail: 0)
        .listen((_) => received.complete(), onError: (Object _) {});
    await received.future;
    subscription.pause();
    connection.close();
    await disconnected.future.timeout(const Duration(seconds: 2));
    await subscription.cancel();
  });

  test(
    'propagates Docker errors instead of treating them as log text',
    () async {
      logs = (request) async {
        request.response
          ..statusCode = 404
          ..write('{"message":"missing container"}');
        await request.response.close();
      };
      await expectLater(
        connection.api
            .logsStream(id: 'container-1', tty: false, tail: 0)
            .toList(),
        throwsA(
          isA<DockerException>()
              .having((e) => e.statusCode, 'status', 404)
              .having((e) => e.message, 'message', 'missing container'),
        ),
      );
    },
  );

  test('ends on clean EOF without emitting empty text chunks', () async {
    logs = (request) async {
      request.response.add([...frame(1, []), ...frame(2, utf8.encode('done'))]);
      await request.response.close();
    };
    final chunks = await connection.api
        .logsStream(id: 'container-1', tty: false, tail: 0)
        .toList();
    expect(chunks.single.text, 'done');
    expect(chunks.single.source, DockerLogSource.stderr);
  });

  test('malformed frames end the stream and release the request even with an error listener', () async {
    final disconnected = Completer<void>();
    final done = Completer<void>();
    final errors = <Object>[];
    logs = (request) async {
      final socket = await detach(request, disconnected);
      writeChunk(socket, [1, 9, 0, 0, 0, 0, 0, 0]);
      await socket.flush();
    };
    final subscription = connection.api
        .logsStream(id: 'container-1', tty: false, tail: 0)
        .listen(
          (_) => fail('Malformed frames must not produce text'),
          onError: errors.add,
          onDone: done.complete,
        );
    addTearDown(subscription.cancel);
    await done.future.timeout(const Duration(seconds: 2));
    expect(errors, [isA<FormatException>()]);
    await disconnected.future.timeout(const Duration(seconds: 2));
  });

  test('forwards a broken HTTP body as a stream error', () async {
    logs = (request) async {
      final socket = await detach(request, Completer<void>());
      socket.write('20\r\nshort');
      await socket.flush();
      await socket.close();
    };
    await expectLater(
      connection.api
          .logsStream(id: 'container-1', tty: false, tail: 0)
          .toList(),
      throwsException,
    );
  });

  test('bounds reading an incomplete Docker error response', () async {
    final disconnected = Completer<void>();
    logs = (request) async {
      request.response.statusCode = 500;
      final socket = await detach(request, disconnected);
      writeChunk(socket, utf8.encode('{'));
      await socket.flush();
    };
    await expectLater(
      connection.api
          .logsStream(id: 'container-1', tty: false, tail: 0)
          .toList(),
      throwsA(isA<TimeoutException>()),
    );
    await disconnected.future.timeout(const Duration(seconds: 2));
  });

  test(
    'rejects invalid input and subscriptions after closing the connection',
    () async {
      expect(
        () => connection.api.logsStream(id: '', tty: false),
        throwsArgumentError,
      );
      expect(
        () =>
            connection.api.logsStream(id: 'container-1', tty: false, tail: -1),
        throwsArgumentError,
      );
      final stream = connection.api.logsStream(
        id: 'container-1',
        tty: false,
        tail: 0,
      );
      connection.close();
      await expectLater(stream.toList(), throwsStateError);
      expect(logRequests, 0);
    },
  );
}

void writeChunk(Socket socket, List<int> bytes) {
  socket.write('${bytes.length.toRadixString(16)}\r\n');
  socket.add(bytes);
  socket.write('\r\n');
}
