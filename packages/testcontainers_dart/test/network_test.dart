import 'dart:async';
import 'dart:convert';

import 'package:test/test.dart';
import 'package:testcontainers_dart/testcontainers_dart.dart';

import 'utils/docker_server.dart';

void main() {
  late DockerServer server;
  late DockerProvider provider;

  setUp(() async {
    server = await DockerServer.start();
    server.handler = (request) async {
      if (request.uri.path.endsWith('/networks/create')) {
        await DockerServer.respond(request, {
          'Id': 'network-1',
          'Warning': '',
        }, status: 201);
        return true;
      }
      return false;
    };

    provider = await DockerProvider.connect(
      registryEnvironment: const {},
      config: DockerConfig(endpoint: server.endpoint),
      ryuk: const RyukConfig(enabled: false),
    );
  });

  tearDown(() async {
    provider.close();
    await server.close();
  });

  test(
    'managed bridge network and attached containers share session labels',
    () async {
      final network = await provider.createNetwork();
      final created = jsonDecode(server.bodies.last);

      expect(created['Driver'], 'bridge');
      expect(created['Name'], network.name);
      expect(created['Labels']['org.testcontainers'], 'true');

      await provider.start(
        ContainerConfig(
          image: 'busybox',
          network: network,
          networkAliases: ['database'],
        ),
      );

      final index = server.paths.indexWhere(
        (path) => path.endsWith('/containers/create'),
      );
      final container = jsonDecode(server.bodies[index]);

      expect(container['Labels'], created['Labels']);
      expect(container['NetworkingConfig']['EndpointsConfig'], {
        network.id: {
          'Aliases': ['database'],
        },
      });
      expect(container['HostConfig']['PortBindings'], isEmpty);

      await network.terminate();
      await network.terminate();

      expect(
        server.paths.where((path) => path.endsWith('/networks/network-1')),
        hasLength(1),
      );
    },
  );

  test('foreign or deleted networks and aliases without a network fail before Docker calls', () async {
    final network = await provider.createNetwork();
    final other = await DockerProvider.connect(
      registryEnvironment: const {},
      config: DockerConfig(endpoint: server.endpoint),
      ryuk: const RyukConfig(enabled: false),
    );
    addTearDown(other.close);

    final count = server.paths.length;
    await expectLater(
      other.start(ContainerConfig(image: 'busybox', network: network)),
      throwsStateError,
    );
    await expectLater(
      provider.start(
        const ContainerConfig(image: 'busybox', networkAliases: ['database']),
      ),
      throwsArgumentError,
    );
    await expectLater(
      provider.start(
        ContainerConfig(
          image: 'busybox',
          network: network,
          networkAliases: ['bad alias'],
        ),
      ),
      throwsArgumentError,
    );
    expect(server.paths, hasLength(count));

    await network.terminate();
    await expectLater(
      provider.start(ContainerConfig(image: 'busybox', network: network)),
      throwsStateError,
    );
  });

  test(
    'network removal may be retried after active endpoints, and 404 is success',
    () async {
      final network = await provider.createNetwork();
      var attempts = 0;

      server.handler = (request) async {
        attempts++;
        await DockerServer.respond(request, {
          'message': 'active endpoints',
        }, status: attempts == 1 ? 403 : 404);
        return true;
      };

      await expectLater(network.terminate(), throwsA(isA<DockerException>()));
      await network.terminate();
      await network.terminate();
      expect(attempts, 2);
    },
  );

  test('close during creation rolls back the created network', () async {
    final entered = Completer<void>();
    final release = Completer<void>();

    server.handler = (request) async {
      if (!request.uri.path.endsWith('/networks/create')) return false;
      entered.complete();
      await release.future;
      await DockerServer.respond(request, {
        'Id': 'network-1',
        'Warning': '',
      }, status: 201);
      return true;
    };
    final result = provider.createNetwork();
    final failed = expectLater(result, throwsStateError);

    await entered.future;

    provider.close();
    release.complete();

    await failed;

    expect(server.paths.last, '/v1.55/networks/network-1');
    await expectLater(provider.createNetwork(), throwsStateError);
  });

  test('failed creates never delete a network; malformed success rolls back by unique name', () async {
    server.handler = (request) async {
      await DockerServer.respond(request, {
        'message': 'forbidden',
      }, status: 403);
      return true;
    };

    await expectLater(
      provider.createNetwork(),
      throwsA(isA<DockerException>()),
    );

    expect(
      server.paths.where(
        (path) => path.contains('/networks/') && !path.endsWith('/create'),
      ),
      isEmpty,
    );

    String? name;
    server.handler = (request) async {
      if (!request.uri.path.endsWith('/create')) return false;
      name = jsonDecode(server.bodies.last)['Name'] as String;
      await DockerServer.respond(request, {
        'Id': '',
        'Warning': '',
      }, status: 201);
      return true;
    };

    await expectLater(provider.createNetwork(), throwsFormatException);
    expect(server.paths.last, '/v1.55/networks/$name');
  });

  test('rollback failure preserves both errors', () async {
    server.handler = (request) async {
      if (request.uri.path.endsWith('/create')) {
        provider.close();
        await DockerServer.respond(request, {
          'Id': 'network-1',
          'Warning': '',
        }, status: 201);
      } else {
        await DockerServer.respond(request, {
          'message': 'cleanup failed',
        }, status: 500);
      }
      return true;
    };

    await expectLater(
      provider.createNetwork(),
      throwsA(
        isA<NetworkCreateException>()
            .having((e) => e.cause, 'cause', isA<StateError>())
            .having(
              (e) => e.cleanupError,
              'cleanup error',
              isA<DockerException>(),
            ),
      ),
    );
  });
}
