import 'dart:async';
import 'dart:io';

import 'package:docker_engine/docker_engine.dart' hide Platform;
import 'package:test/test.dart';

void main() {
  late HttpServer server;
  late DockerConnection connection;
  late Future<void> Function(HttpRequest) handler;
  setUp(() async {
    server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    handler = (request) async {
      request.response.statusCode = 200;
      await request.response.close();
    };
    server.listen((request) async {
      if (request.uri.path == '/version') {
        request.response.write('{"ApiVersion":"1.55","MinAPIVersion":"1.41"}');
        await request.response.close();
      } else {
        await handler(request);
      }
    });
    connection = await DockerConnection.connect(
      DockerConfig(
        endpoint: Uri.parse('http://127.0.0.1:${server.port}'),
        requestTimeout: const Duration(seconds: 2),
      ),
    );
  });
  tearDown(() async {
    connection.close();
    await server.close(force: true);
  });

  test('upload reaches Docker before source EOF, preserving binary bytes and query', () async {
    final received = Completer<void>();
    final body = <int>[];
    handler = (request) async {
      expect(request.method, 'PUT');
      expect(request.uri.path, '/v1.55/containers/container/archive');
      expect(request.uri.queryParameters['path'], '/tmp/a b');
      expect(request.uri.queryParameters['noOverwriteDirNonDir'], 'true');
      expect(request.headers.contentType!.mimeType, 'application/x-tar');
      await for (final chunk in request) {
        body.addAll(chunk);
        if (!received.isCompleted) received.complete();
      }
      await request.response.close();
    };
    final source = StreamController<List<int>>();
    final upload = connection.api.putArchive(
      id: 'container',
      path: '/tmp/a b',
      archive: source.stream,
    );
    source.add(List.filled(65536, 255));
    await received.future.timeout(const Duration(seconds: 1));
    source.add([0, 128, 254]);
    await source.close();
    await upload;
    expect(body, [...List.filled(65536, 255), 0, 128, 254]);
  });

  test(
    'download delivers before HTTP EOF and cancellation isolates requests',
    () async {
      final release = Completer<void>();
      handler = (request) async {
        if (!request.uri.path.endsWith('/archive')) {
          request.response.write('[]');
          await request.response.close();
          return;
        }
        request.response.bufferOutput = false;
        request.response.add(List.filled(4096, 255));
        await request.response.flush();
        await release.future;
        await request.response.close();
      };
      final stream = StreamIterator(
        connection.api.getArchive(id: 'container', path: '/file'),
      );
      expect(await stream.moveNext().timeout(const Duration(seconds: 1)), true);
      expect(stream.current, everyElement(255));
      await stream.cancel();
      release.complete();
      expect((await connection.api.containersJsonGet()).isSuccessful, true);
    },
  );

  test(
    'cancellation before headers and provider close abort pending downloads',
    () async {
      final entered = Completer<void>();
      final release = Completer<void>();
      handler = (request) async {
        if (!entered.isCompleted) entered.complete();
        await release.future;
        await request.response.close();
      };
      final first = connection.api
          .getArchive(id: 'container', path: '/file')
          .listen(null);
      await entered.future;
      await first.cancel().timeout(const Duration(seconds: 1));
      final pending = connection.api
          .getArchive(id: 'container', path: '/file')
          .drain<void>();
      final error = expectLater(pending, throwsA(isA<Exception>()));
      connection.close();
      await error;
      release.complete();
    },
  );

  test('source errors cancel upload without poisoning the transport', () async {
    await expectLater(
      connection.api.putArchive(
        id: 'container',
        path: '/tmp',
        archive: Stream.error(StateError('source failed')),
      ),
      throwsA(anything),
    );
    expect((await connection.api.containersJsonGet()).isSuccessful, true);
  });

  test('HTTP errors do not buffer unbounded response bodies', () async {
    handler = (request) async {
      request.response.statusCode = 404;
      request.response.write('missing');
      await request.response.close();
    };
    await expectLater(
      connection.api
          .getArchive(id: 'container', path: '/missing')
          .drain<void>(),
      throwsA(
        isA<DockerException>().having((e) => e.statusCode, 'status', 404),
      ),
    );
  });

  test(
    'invalid paths and closed transports fail without sending a request',
    () async {
      expect(
        () => connection.api.getArchive(id: '', path: '/tmp'),
        throwsArgumentError,
      );
      expect(
        () => connection.api.getArchive(id: 'container', path: 'relative'),
        throwsArgumentError,
      );
      connection.close();
      await expectLater(
        connection.api.getArchive(id: 'container', path: '/tmp').drain<void>(),
        throwsStateError,
      );
    },
  );

  for (final upload in [false, true]) {
    test(
      'timeout bounds ${upload ? 'upload' : 'download'} and releases its source',
      () async {
        connection.close();
        connection = await DockerConnection.connect(
          DockerConfig(
            endpoint: Uri.parse('http://127.0.0.1:${server.port}'),
            requestTimeout: const Duration(milliseconds: 100),
          ),
        );
        final release = Completer<void>();
        handler = (request) async {
          request.response.bufferOutput = false;
          if (upload) {
            try {
              await request.drain<void>();
            } catch (_) {}
          } else {
            request.response.add([0, 1]);
            await request.response.flush();
          }
          await release.future;
          await request.response.close();
        };
        final cancelled = Completer<void>();
        final source = StreamController<List<int>>(
          onCancel: cancelled.complete,
        );
        final result = upload
            ? connection.api.putArchive(
                id: 'container',
                path: '/tmp',
                archive: source.stream,
              )
            : connection.api
                  .getArchive(id: 'container', path: '/tmp')
                  .drain<void>();
        if (upload) source.add(List.filled(65536, 255));
        await expectLater(result, throwsA(isA<TimeoutException>()));
        if (upload) await cancelled.future.timeout(const Duration(seconds: 1));
        release.complete();
        if (upload) await source.close();
      },
    );
  }
}
