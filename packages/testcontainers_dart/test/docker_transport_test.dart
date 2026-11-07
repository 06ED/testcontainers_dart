import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:testcontainers_dart/testcontainers_dart.dart';

import 'support/docker_server.dart';

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
    final directory = await Directory(
      '${home.path}/.docker/run',
    ).create(recursive: true);
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

  test(
    'configuration rejects unsupported transports and TLS env instead of downgrading',
    () {
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
    },
  );

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
          '/v1.53/images/create',
          '/v1.53/containers/create',
          '/v1.53/containers/container-1/start',
          '/v1.53/containers/container-1/json',
          '/v1.53/containers/container-1',
        ]);
        expect(jsonDecode(server.bodies[2])['Image'], 'redis:7-alpine');
      },
    );

    test('uses the older server API version when necessary', () async {
      server.apiVersion = '1.45';
      await connect();
      await provider.start(const ContainerConfig(image: 'redis'));
      expect(server.paths[1], '/v1.45/images/create');
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

    test(
      'exec sends argument arrays, separates output and retains nonzero exit code',
      () async {
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
        final body = jsonDecode(server.bodies[4]);
        expect(body['Cmd'], ['sh', '-c', 'echo hello; exit 7']);
        expect(body['Tty'], false);
      },
    );

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
