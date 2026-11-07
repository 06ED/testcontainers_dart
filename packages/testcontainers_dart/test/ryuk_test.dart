import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:testcontainers_dart/testcontainers_dart.dart';

import 'utils/docker_server.dart';

void main() {
  test('Ryuk configuration reads environment and validates unsafe values', () {
    final config = RyukConfig.fromEnvironment({
      'TESTCONTAINERS_RYUK_DISABLED': 'true',
      'TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE': '/run/docker.sock',
      'TESTCONTAINERS_RYUK_CONTAINER_IMAGE': 'mirror/ryuk:0.14.0',
    });

    expect(config.enabled, false);
    expect(config.socketPath, '/run/docker.sock');
    expect(config.image, 'mirror/ryuk:0.14.0');
    expect(RyukConfig.fromEnvironment({}).enabled, true);

    for (final config in [
      const RyukConfig(image: ''),
      const RyukConfig(socketPath: 'relative'),
      const RyukConfig(startupTimeout: Duration.zero),
      const RyukConfig(portBindingHost: ''),
    ]) {
      expect(config.validate, throwsArgumentError);
    }
    expect(
      () =>
          RyukConfig.fromEnvironment({'TESTCONTAINERS_RYUK_DISABLED': 'typo'}),
      throwsArgumentError,
    );
  });

  group('Ryuk session', () {
    late DockerServer docker;
    late ServerSocket server;
    late DockerProvider provider;
    late Completer<String> filter;
    late Completer<void> disconnected;
    late List<Socket> clients;
    late void Function(Socket) acknowledge;
    var creates = 0;

    setUp(() async {
      docker = await DockerServer.start();
      server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
      filter = Completer<String>();
      disconnected = Completer<void>();
      clients = [];
      creates = 0;
      acknowledge = (socket) => socket.write('ACK\n');
      server.listen((socket) {
        clients.add(socket);
        socket
            .cast<List<int>>()
            .transform(utf8.decoder)
            .transform(const LineSplitter())
            .listen(
              (line) {
                if (!filter.isCompleted) filter.complete(line);
                acknowledge(socket);
              },
              onDone: () {
                if (!disconnected.isCompleted) disconnected.complete();
                socket.destroy();
              },
            );
      });
      docker.handler = (request) async {
        final path = request.uri.path;
        if (path.endsWith('/containers/create')) {
          final body = jsonDecode(docker.bodies.last);
          if (body['Labels']['org.testcontainers.ryuk'] != 'true') return false;
          creates++;
          await DockerServer.respond(request, {
            'Id': 'ryuk-1',
            'Warnings': [],
          }, status: 201);
        } else if (path.endsWith('/ryuk-1/start')) {
          await DockerServer.respond(request, '', status: 204);
        } else if (path.endsWith('/ryuk-1/json')) {
          await DockerServer.respond(request, {
            'State': {'Running': true},
            'NetworkSettings': {
              'Ports': {
                '8080/tcp': [
                  {'HostPort': '${server.port}'},
                ],
              },
            },
          });
        } else {
          return false;
        }
        return true;
      };
      provider = await DockerProvider.connect(
        config: DockerConfig(endpoint: docker.endpoint),
        ryuk: const RyukConfig(startupTimeout: Duration(milliseconds: 300)),
      );
    });

    tearDown(() async {
      provider.close();
      for (final client in clients) {
        client.destroy();
      }
      await server.close();
      await docker.close();
    });

    List<Map<String, dynamic>> bodies() => [
      for (var i = 0; i < docker.paths.length; i++)
        if (docker.paths[i].endsWith('/containers/create'))
          jsonDecode(docker.bodies[i]) as Map<String, dynamic>,
    ];

    test(
      'starts lazily, waits for split ACK and shares one session across concurrent starts',
      () async {
        expect(creates, 0);
        final ack = Completer<Socket>();
        acknowledge = ack.complete;
        final labels = {'owner': 'test'};
        final started = Future.wait([
          provider.start(ContainerConfig(image: 'redis', labels: labels)),
          provider.start(const ContainerConfig(image: 'redis')),
        ]);
        labels['owner'] = 'changed';
        final socket = await ack.future;
        expect(bodies(), hasLength(1));
        socket.write('AC');
        await socket.flush();
        socket.write('K\n');
        final containers = await started;
        expect(creates, 1);
        final requests = bodies();
        final ryuk = requests.first;
        expect(ryuk['HostConfig']['AutoRemove'], true);
        expect(ryuk['HostConfig']['Privileged'], isNot(true));
        expect(ryuk['HostConfig']['Mounts'], [
          {
            'Type': 'bind',
            'Source': '/var/run/docker.sock',
            'Target': '/var/run/docker.sock',
            'ReadOnly': false,
          },
        ]);
        expect(
          ryuk['HostConfig']['PortBindings']['8080/tcp'][0]['HostIp'],
          '127.0.0.1',
        );
        final session = requests[1]['Labels']['org.testcontainers.sessionId'];
        expect(session, matches(RegExp(r'^[a-f0-9]{32}$')));
        expect(requests[1]['Labels']['owner'], 'test');
        expect(requests[2]['Labels']['org.testcontainers.sessionId'], session);
        expect(requests[1]['Labels']['org.testcontainers'], 'true');
        expect(
          await filter.future,
          'label=org.testcontainers.sessionId=$session',
        );
        await containers.first.terminate();
        expect(disconnected.isCompleted, false);
        provider.close();
        provider.close();
        await disconnected.future.timeout(const Duration(seconds: 1));
      },
    );

    test('rejects reserved labels before any Docker operation', () async {
      await expectLater(
        provider.start(
          const ContainerConfig(
            image: 'redis',
            labels: {'org.testcontainers.sessionId': 'other'},
          ),
        ),
        throwsArgumentError,
      );
      expect(docker.paths, ['/version']);
    });

    for (final stage in ['pull', 'create', 'start', 'inspect']) {
      test('Ryuk $stage failure never starts a user container', () async {
        final handler = docker.handler!;
        docker.handler = (request) async {
          final path = request.uri.path;
          final failed = switch (stage) {
            'pull' => path.endsWith('/images/create'),
            'create' => path.endsWith('/containers/create'),
            'start' => path.endsWith('/ryuk-1/start'),
            _ => path.endsWith('/ryuk-1/json'),
          };
          if (!failed) return handler(request);
          await DockerServer.respond(request, {
            'message': 'Ryuk $stage failed',
          }, status: 500);
          return true;
        };
        await expectLater(
          provider.start(const ContainerConfig(image: 'redis')),
          throwsA(isA<ContainerStartException>()),
        );
        expect(bodies().where((body) => body['Image'] == 'redis'), isEmpty);
        if (stage == 'start' || stage == 'inspect') {
          expect(docker.paths, contains('/v1.53/containers/ryuk-1'));
        }
      });
    }

    test(
      'failed Ryuk cleanup preserves the original and cleanup errors',
      () async {
        acknowledge = (socket) => socket.write('NO\n');
        final handler = docker.handler!;
        docker.handler = (request) async {
          if (request.method != 'DELETE') return handler(request);
          await DockerServer.respond(request, {
            'message': 'cannot delete',
          }, status: 500);
          return true;
        };
        await expectLater(
          provider.start(const ContainerConfig(image: 'redis')),
          throwsA(
            isA<ContainerStartException>()
                .having((error) => error.cause, 'cause', isA<FormatException>())
                .having(
                  (error) => error.cleanupError,
                  'cleanupError',
                  isA<DockerException>(),
                ),
          ),
        );
      },
    );

    test(
      'rejected Ryuk create never deletes an existing container by name',
      () async {
        final handler = docker.handler!;
        docker.handler = (request) async {
          if (!request.uri.path.endsWith('/containers/create')) {
            return handler(request);
          }
          await DockerServer.respond(request, {
            'message': 'name already in use',
          }, status: 409);
          return true;
        };
        await expectLater(
          provider.start(const ContainerConfig(image: 'redis')),
          throwsA(isA<ContainerStartException>()),
        );
        expect(
          docker.paths.where(
            (path) => path.contains('/containers/testcontainers-ryuk-'),
          ),
          isEmpty,
        );
      },
    );

    test(
      'missing Ryuk create ID cleans up by its unique generated name',
      () async {
        final handler = docker.handler!;
        docker.handler = (request) async {
          if (!request.uri.path.endsWith('/containers/create')) {
            return handler(request);
          }
          await DockerServer.respond(request, {'Warnings': []}, status: 201);
          return true;
        };
        await expectLater(
          provider.start(const ContainerConfig(image: 'redis')),
          throwsA(isA<ContainerStartException>()),
        );
        expect(
          docker.paths.where(
            (path) => path.contains('/containers/testcontainers-ryuk-'),
          ),
          hasLength(1),
        );
        final count = docker.paths.length;
        await expectLater(
          provider.start(const ContainerConfig(image: 'redis')),
          throwsA(isA<ContainerStartException>()),
        );
        expect(docker.paths, hasLength(count));
      },
    );

    test(
      'uses explicit image, daemon socket and port binding overrides',
      () async {
        provider.close();
        provider = await DockerProvider.connect(
          config: DockerConfig(endpoint: docker.endpoint),
          ryuk: const RyukConfig(
            image: 'mirror/ryuk:0.14.0',
            socketPath: '/run/docker.sock',
            portBindingHost: '0.0.0.0',
          ),
        );
        await provider.start(const ContainerConfig(image: 'redis'));
        final body = bodies().first;
        expect(body['Image'], 'mirror/ryuk:0.14.0');
        expect(body['HostConfig']['Mounts'][0]['Source'], '/run/docker.sock');
        expect(
          body['HostConfig']['PortBindings']['8080/tcp'][0]['HostIp'],
          '0.0.0.0',
        );
      },
    );

    test(
      'user startup failure still removes that container and leaves shared Ryuk alive',
      () async {
        final handler = docker.handler!;
        docker.handler = (request) async {
          if (!request.uri.path.endsWith('/container-1/start')) {
            return handler(request);
          }
          await DockerServer.respond(request, {
            'message': 'cannot start',
          }, status: 500);
          return true;
        };
        await expectLater(
          provider.start(const ContainerConfig(image: 'redis')),
          throwsA(isA<ContainerStartException>()),
        );
        expect(docker.paths, contains('/v1.53/containers/container-1'));
        expect(disconnected.isCompleted, false);
        provider.close();
        await disconnected.future.timeout(const Duration(seconds: 1));
      },
    );

    test('close while pulling user image prevents a later create', () async {
      final pulling = Completer<void>();
      final release = Completer<void>();
      final handler = docker.handler!;
      docker.handler = (request) async {
        if (request.uri.queryParameters['fromImage'] == 'redis:latest') {
          pulling.complete();
          await release.future;
        }
        return handler(request);
      };
      final started = provider.start(const ContainerConfig(image: 'redis'));
      final assertion = expectLater(started, throwsStateError);
      await pulling.future;
      provider.close();
      release.complete();
      await assertion;
      expect(bodies(), hasLength(1));
    });

    for (final failure in ['timeout', 'invalid ACK', 'EOF']) {
      test(
        '$failure removes Ryuk and never creates a user container',
        () async {
          acknowledge = (socket) {
            if (failure == 'invalid ACK') socket.write('NO\n');
            if (failure == 'EOF') socket.destroy();
          };
          await expectLater(
            provider.start(const ContainerConfig(image: 'redis')),
            throwsA(isA<ContainerStartException>()),
          );
          expect(bodies(), hasLength(1));
          expect(docker.paths, contains('/v1.53/containers/ryuk-1'));
        },
      );
    }

    test('retries a port-forwarder EOF before Ryuk is ready', () async {
      var attempts = 0;
      acknowledge = (socket) {
        if (++attempts == 1) {
          socket.destroy();
        } else {
          socket.write('ACK\n');
        }
      };
      await provider.start(const ContainerConfig(image: 'redis'));
      expect(attempts, 2);
      expect(creates, 1);
    });

    test('connection loss prevents new container starts', () async {
      await provider.start(const ContainerConfig(image: 'redis'));
      clients.single.destroy();
      // Let the client observe EOF before attempting another Docker operation.
      await Future<void>.delayed(const Duration(milliseconds: 30));
      final count = docker.paths.length;
      await expectLater(
        provider.start(const ContainerConfig(image: 'redis')),
        throwsStateError,
      );
      expect(docker.paths, hasLength(count));
    });

    test(
      'close during handshake cancels startup without user resources',
      () async {
        acknowledge = (_) {};
        final started = provider.start(const ContainerConfig(image: 'redis'));
        final assertion = expectLater(
          started,
          throwsA(
            isA<ContainerStartException>().having(
              (error) => error.cleanupError,
              'cleanupError',
              isNull,
            ),
          ),
        );
        await filter.future;
        provider.close();
        await assertion;
        expect(bodies(), hasLength(1));
        expect(docker.paths, contains('/v1.53/containers/ryuk-1'));
      },
    );

    test('disabled Ryuk preserves explicit cleanup behavior', () async {
      provider.close();
      provider = await DockerProvider.connect(
        config: DockerConfig(endpoint: docker.endpoint),
        ryuk: const RyukConfig(enabled: false),
      );
      await provider.start(
        const ContainerConfig(image: 'redis', labels: {'owner': 'test'}),
      );
      expect(creates, 0);
      expect(bodies().single['Labels'], {'owner': 'test'});
    });
  });
}
