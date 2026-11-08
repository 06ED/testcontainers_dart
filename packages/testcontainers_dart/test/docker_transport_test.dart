import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:testcontainers_dart/testcontainers_dart.dart';

import 'utils/docker_server.dart';

void main() {
  test('configuration reads Docker host and service host override', () {
    final config = DockerConfig.fromEnvironment({
      'DOCKER_HOST': 'tcp://docker.example:2375',
      'TESTCONTAINERS_HOST_OVERRIDE': 'services.example',
    });
    expect(config.endpoint.toString(), 'http://docker.example:2375');
    expect(config.host, 'services.example');
    expect(
      DockerConfig(endpoint: Uri.parse('unix:///var/run/docker.sock')).host,
      'localhost',
    );
  });

  test('default discovery recognizes Docker Desktop Unix sockets', () async {
    final home = await Directory.systemTemp.createTemp('tc-');
    final directory = await Directory('${home.path}/.docker/run')
        .create(recursive: true);
    final path = '${directory.path}/docker.sock';
    final socket = await ServerSocket.bind(
      InternetAddress(path, type: InternetAddressType.unix),
      0,
    );
    addTearDown(() async {
      await socket.close();
      await home.delete(recursive: true);
    });
    expect(
      DockerConfig.fromEnvironment({'HOME': home.path}).endpoint.path,
      path,
    );
  }, skip: Platform.isWindows);

  test('configuration rejects unsupported transports and TLS env instead of downgrading', () {
    expect(
      () => DockerConfig(endpoint: Uri.parse('ssh://docker')),
      throwsUnsupportedError,
    );
    expect(
      () => DockerConfig.fromEnvironment({
        'DOCKER_HOST': 'tcp://docker:2376',
        'DOCKER_TLS_VERIFY': '1',
      }),
      throwsUnsupportedError,
    );
  });

  group('Engine HTTP API', () {
    late DockerServer server;
    late DockerProvider provider;

    setUp(() async {
      server = await DockerServer.start();
    });
    tearDown(() async {
      await server.close();
    });

    Future<void> connect() async {
      provider = await DockerProvider.connect(
        config: DockerConfig(endpoint: server.endpoint),
        ryuk: const RyukConfig(enabled: false),
      );
      addTearDown(provider.close);
    }

    test(
      'negotiates API version, runs and removes a container over TCP',
      () async {
        await connect();
        final container = await provider.start(
          const ContainerConfig(image: 'redis:7-alpine'),
        );
        expect(container.host, '127.0.0.1');
        expect(await container.mappedPort(6379), 32768);
        await container.terminate();
        expect(server.paths, [
          '/version',
          '/v1.53/images/redis:7-alpine/json',
          '/v1.53/images/create',
          '/v1.53/containers/create',
          '/v1.53/containers/container-1/start',
          '/v1.53/containers/container-1/json',
          '/v1.53/containers/container-1',
        ]);
        expect(jsonDecode(server.bodies[3])['Image'], 'redis:7-alpine');
      },
    );

    test('uses the older server API version when necessary', () async {
      server.apiVersion = '1.45';
      await connect();
      await provider.start(const ContainerConfig(image: 'redis'));
      expect(server.paths[1], '/v1.45/images/redis/json');
      expect(server.paths[2], '/v1.45/images/create');
    });

    test('rejects malformed API version', () async {
      server.apiVersion = 'not-a-version';
      await expectLater(connect(), throwsFormatException);
    });

    test('decodes multiplexed logs without corrupting split UTF-8', () async {
      final bytes = utf8.encode('привет');
      server.handler = (request) async {
        if (!request.uri.path.endsWith('/logs')) return false;
        await DockerServer.respond(request, [
          ...frame(1, bytes.sublist(0, 1)),
          ...frame(1, bytes.sublist(1)),
          ...frame(2, utf8.encode('error\n')),
        ], contentType: 'application/vnd.docker.raw-stream');
        return true;
      };
      await connect();
      final container = await provider.start(
        const ContainerConfig(image: 'redis'),
      );
      expect(await container.logs(), 'приветerror\n');
    });

    test(
      'log readiness finds a message before the latest 1000 lines',
      () async {
        final lines = ['ready', ...List.filled(1500, 'startup noise')];
        final requestedTails = <String?>[];
        server.handler = (request) async {
          if (!request.uri.path.endsWith('/logs')) return false;
          final tail = request.uri.queryParameters['tail'];
          requestedTails.add(tail);
          final count = int.tryParse(tail ?? '');
          final output = count == null
              ? lines
              : lines.skip(lines.length - count);
          await DockerServer.respond(
            request,
            frame(1, utf8.encode(output.join('\n'))),
            contentType: 'application/vnd.docker.raw-stream',
          );
          return true;
        };
        await connect();
        await provider.start(
          ContainerConfig(
            image: 'redis',
            waitStrategy: .forLogMessage(
              'ready',
              timeout: const Duration(seconds: 1),
            ),
          ),
        );
        expect(requestedTails, ['all']);
      },
    );

    test('snapshot logs preserve tail selection and validate it', () async {
      final requestedTails = <String?>[];
      server.handler = (request) async {
        if (!request.uri.path.endsWith('/logs')) return false;
        requestedTails.add(request.uri.queryParameters['tail']);
        await DockerServer.respond(request, 'output');
        return true;
      };
      await connect();
      final container = await provider.start(
        const ContainerConfig(image: 'redis'),
      );
      for (final tail in [1000, 100, 0, null]) {
        expect(await container.logs(tail: tail), 'output');
      }
      expect(await container.logs(), 'output');
      await expectLater(container.logs(tail: -1), throwsArgumentError);
      expect(requestedTails, ['1000', '100', '0', 'all', '1000']);
    });

    test('reports truncated multiplex frames', () async {
      server.handler = (request) async {
        if (!request.uri.path.endsWith('/logs')) return false;
        await DockerServer.respond(request, [
          1,
          0,
          0,
          0,
          0,
          0,
          0,
          10,
          65,
        ], contentType: 'application/vnd.docker.raw-stream');
        return true;
      };
      await connect();
      final container = await provider.start(
        const ContainerConfig(image: 'redis'),
      );
      await expectLater(container.logs(), throwsFormatException);
    });

    test('exec sends argument arrays, separates output and retains nonzero exit code', () async {
      server.handler = (request) async {
        if (request.uri.path.endsWith('/container-1/exec')) {
          await DockerServer.respond(request, {'Id': 'exec-1'}, status: 201);
        } else if (request.uri.path.endsWith('/exec/exec-1/start')) {
          await DockerServer.respond(request, [
            ...frame(1, utf8.encode('hello')),
            ...frame(2, utf8.encode('bad')),
          ], contentType: 'application/vnd.docker.raw-stream');
        } else if (request.uri.path.endsWith('/exec/exec-1/json')) {
          await DockerServer.respond(request, {
            'Running': false,
            'ExitCode': 7,
          });
        } else {
          return false;
        }
        return true;
      };
      await connect();
      final container = await provider.start(
        const ContainerConfig(image: 'redis'),
      );
      final result = await container.exec(['sh', '-c', 'echo hello; exit 7']);
      expect(result.exitCode, 7);
      expect(result.stdout, 'hello');
      expect(result.stderr, 'bad');
      final body = jsonDecode(server.bodies[5]);
      expect(body['Cmd'], ['sh', '-c', 'echo hello; exit 7']);
      expect(body['Tty'], false);
    });

    test('exec rejects incomplete Docker command results', () async {
      var result = <String, dynamic>{'Running': true, 'ExitCode': 0};
      server.handler = (request) async {
        if (request.uri.path.endsWith('/container-1/exec')) {
          await DockerServer.respond(request, {'Id': 'exec-1'}, status: 201);
        } else if (request.uri.path.endsWith('/exec/exec-1/start')) {
          await DockerServer.respond(
            request,
            'output',
            contentType: 'application/vnd.docker.raw-stream',
          );
        } else if (request.uri.path.endsWith('/exec/exec-1/json')) {
          await DockerServer.respond(request, result);
        } else {
          return false;
        }
        return true;
      };
      await connect();
      final container = await provider.start(
        const ContainerConfig(image: 'redis'),
      );
      await expectLater(container.exec(['echo']), throwsStateError);
      result = {'Running': false};
      await expectLater(container.exec(['echo']), throwsStateError);
    });

    test('Testcontainers.run closes its provider after failed startup', () async {
      final disconnected = Completer<void>();
      Socket? connection;
      addTearDown(() => connection?.destroy());
      server.handler = (request) async {
        if (!request.uri.path.endsWith('/images/create')) return false;
        const body = '{"message":"pull denied"}';
        request.response
          ..statusCode = 403
          ..contentLength = utf8.encode(body).length;
        // Observe client EOF without closing the server side of the connection.
        final socket = await request.response.detachSocket();
        connection = socket;
        socket.listen((_) {}, onDone: disconnected.complete);
        socket.write(body);
        await socket.flush();
        return true;
      };
      await expectLater(
        Testcontainers.run(
          const ContainerConfig(image: 'private/image'),
          config: DockerConfig(endpoint: server.endpoint),
          ryuk: const RyukConfig(enabled: false),
        ),
        throwsA(
          isA<DockerException>().having(
            (e) => e.message,
            'message',
            'pull denied',
          ),
        ),
      );
      expect(server.paths, [
        '/version',
        '/v1.53/images/private/image/json',
        '/v1.53/images/create',
      ]);
      await disconnected.future.timeout(const Duration(seconds: 3));
    });

    test('propagates real HTTP errors with Docker messages', () async {
      server.handler = (request) async {
        if (!request.uri.path.endsWith('/images/create')) return false;
        await DockerServer.respond(request, {
          'message': 'access denied',
        }, status: 403);
        return true;
      };
      await connect();
      await expectLater(
        provider.start(const ContainerConfig(image: 'private/image')),
        throwsA(
          isA<DockerException>().having(
            (e) => e.message,
            'message',
            'access denied',
          ),
        ),
      );
    });

    test('closed providers reject new containers', () async {
      await connect();
      provider.close();
      await expectLater(
        provider.start(const ContainerConfig(image: 'redis')),
        throwsStateError,
      );
    });

    test('request timeout aborts a stalled Docker response', () async {
      server.handler = (request) async => request.uri.path == '/version';
      await expectLater(
        DockerProvider.connect(
          config: DockerConfig(
            endpoint: server.endpoint,
            requestTimeout: const Duration(milliseconds: 30),
          ),
        ),
        throwsA(isA<TimeoutException>()),
      );
    });

    test('request timeout also aborts a stalled response body', () async {
      server.handler = (request) async {
        if (request.uri.path != '/version') return false;
        request.response.headers.contentType = ContentType.json;
        request.response.write('{');
        await request.response.flush();
        return true;
      };
      await expectLater(
        DockerProvider.connect(
          config: DockerConfig(
            endpoint: server.endpoint,
            requestTimeout: const Duration(milliseconds: 50),
          ),
        ),
        throwsA(isA<TimeoutException>()),
      );
    });

    test('rejects a server minimum newer than the generated API', () async {
      server.handler = (request) async {
        if (request.uri.path != '/version') return false;
        await DockerServer.respond(request, {
          'ApiVersion': '1.60',
          'MinAPIVersion': '1.54',
        });
        return true;
      };
      await expectLater(connect(), throwsUnsupportedError);
    });

    test(
      'Testcontainers.run owns its connection and supports explicit cleanup',
      () async {
        final container = await Testcontainers.run(
          const ContainerConfig(image: 'redis'),
          config: DockerConfig(endpoint: server.endpoint),
          ryuk: const RyukConfig(enabled: false),
        );
        expect(await container.mappedPort(6379), 32768);
        await container.terminate();
        await container.terminate();
        expect(
          server.paths.where((path) => path == '/v1.53/containers/container-1'),
          hasLength(1),
        );
      },
    );
  });

  test('connects to an actual Unix domain socket', () async {
    final directory = await Directory.systemTemp.createTemp('tc-');
    final path = '${directory.path}/docker.sock';
    final server = DockerServer(
      await HttpServer.bind(
        InternetAddress(path, type: InternetAddressType.unix),
        0,
      ),
    );
    addTearDown(() async {
      await server.close();
      await directory.delete(recursive: true);
    });
    final provider = await DockerProvider.connect(
      ryuk: const RyukConfig(enabled: false),
      config: DockerConfig(
        endpoint: Uri(scheme: 'unix', path: path),
      ),
    );
    addTearDown(provider.close);
    final container = await provider.start(
      const ContainerConfig(image: 'redis'),
    );
    expect(await container.mappedPort(6379), 32768);
    await container.terminate();
  }, skip: Platform.isWindows ? 'Unix sockets require POSIX' : false);
}
