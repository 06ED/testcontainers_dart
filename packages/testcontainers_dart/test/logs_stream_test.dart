import 'dart:async';
import 'dart:convert';

import 'package:test/test.dart';
import 'package:testcontainers_dart/testcontainers_dart.dart';

import 'utils/docker_server.dart';

void main() {
  late DockerServer server;
  late DockerProvider provider;
  late StartedContainer container;

  setUp(() async {
    server = await DockerServer.start();
    provider = await DockerProvider.connect(
      registryEnvironment: const {},
      config: DockerConfig(endpoint: server.endpoint),
      ryuk: const RyukConfig(enabled: false),
    );
    container = await provider.start(const ContainerConfig(image: 'redis'));
  });
  tearDown(() async {
    provider.close();
    await server.close();
  });

  test('opens lazily, reads TTY from inspect and forwards the tail', () async {
    server.handler = (request) async {
      if (request.uri.path.endsWith('/json')) {
        await DockerServer.respond(request, {
          'Config': {'Tty': true},
        });
      } else if (request.uri.path.endsWith('/logs')) {
        expect(request.uri.queryParameters['tail'], '100');
        expect(request.uri.queryParameters['follow'], 'true');
        await DockerServer.respond(request, [
          1,
          2,
          ...utf8.encode('TTY'),
        ], contentType: 'application/vnd.docker.raw-stream');
      } else {
        return false;
      }
      return true;
    };
    final count = server.paths.length;
    final logs = container.logsStream();
    expect(server.paths, hasLength(count));
    final chunks = await logs.toList();
    expect(chunks.map((c) => c.text).join(), '\u0001\u0002TTY');
    expect(chunks.every((c) => c.source == DockerLogSource.stdout), true);
  });

  test('closing a provider aborts its active follow stream', () async {
    final received = Completer<void>();
    final done = Completer<void>();
    final errors = <Object>[];
    server.handler = (request) async {
      if (!request.uri.path.endsWith('/logs')) return false;
      request.response.bufferOutput = false;
      request.response.add(frame(1, utf8.encode('ready')));
      await request.response.flush();
      return true;
    };
    final subscription = container
        .logsStream(tail: 0)
        .listen(
          (_) => received.complete(),
          onError: errors.add,
          onDone: done.complete,
        );
    addTearDown(subscription.cancel);
    await received.future.timeout(const Duration(seconds: 2));
    provider.close();
    await done.future.timeout(const Duration(seconds: 2));
    expect(errors, hasLength(1));
  });

  test('cancelling during inspect does not open a later log request', () async {
    final inspecting = Completer<void>();
    final release = Completer<void>();
    final replied = Completer<void>();

    addTearDown(() {
      if (!release.isCompleted) release.complete();
    });

    server.handler = (request) async {
      if (!request.uri.path.endsWith('/json')) return false;

      inspecting.complete();
      await release.future;
      await DockerServer.respond(request, {
        'Config': {'Tty': false},
      });

      replied.complete();
      return true;
    };

    final subscription = container.logsStream().listen((_) {});
    await inspecting.future;
    await subscription.cancel().timeout(const Duration(seconds: 2));

    release.complete();

    await replied.future;
    await Future.pause(Duration.zero);
    expect(server.paths.where((path) => path.endsWith('/logs')), isEmpty);
  });

  test('rejects invalid tail values before contacting Docker', () {
    final count = server.paths.length;
    expect(() => container.logsStream(tail: -1), throwsArgumentError);
    expect(server.paths, hasLength(count));
  });
}
