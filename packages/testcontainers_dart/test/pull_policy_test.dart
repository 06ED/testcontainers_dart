import 'package:test/test.dart';
import 'package:testcontainers_dart/testcontainers_dart.dart';

import 'utils/docker_server.dart';

void main() {
  late DockerServer server;
  late DockerProvider provider;
  late List<String> inspected;
  late List<String> pulled;
  var inspectStatus = 404;

  setUp(() async {
    inspected = [];
    pulled = [];
    inspectStatus = 404;
    server = await DockerServer.start();

    server.handler = (request) async {
      final segments = request.uri.pathSegments;

      if (segments.length > 3 &&
          segments[1] == 'images' &&
          segments.last == 'json') {
        final image = segments.sublist(2, segments.length - 1).join('/');
        inspected.add(image);
        await DockerServer.respond(
          request,
          inspectStatus == 200
              ? <String, dynamic>{}
              : {'message': 'Cannot inspect $image'},
          status: inspectStatus,
        );
        return true;
      }

      if (request.uri.path.endsWith('/images/create')) {
        pulled.add(request.uri.queryParameters['fromImage']!);
        inspectStatus = 200;
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
    'default policy uses local images without contacting the registry',
    () async {
      inspectStatus = 200;
      await provider.start(const ContainerConfig(image: 'local/app:test'));

      expect(inspected, ['local/app:test']);
      expect(pulled, isEmpty);
      expect(server.paths, contains('/v1.55/containers/container-1/start'));
    },
  );

  test(
    'default policy pulls a missing image once and reuses it on the next start',
    () async {
      await provider.start(const ContainerConfig(image: 'redis'));
      await provider.start(const ContainerConfig(image: 'redis'));

      expect(inspected, ['redis', 'redis']);
      expect(pulled, ['redis:latest']);
    },
  );

  for (final present in [false, true]) {
    test('always pulls on every start (local image: $present)', () async {
      inspectStatus = present ? 200 : 404;
      for (var i = 0; i < 2; i++) {
        await provider.start(
          const ContainerConfig(image: 'redis', pullPolicy: .always),
        );
      }
      expect(inspected, isEmpty);
      expect(pulled, ['redis:latest', 'redis:latest']);
    });
  }

  test('never uses a local image without pulling', () async {
    inspectStatus = 200;
    await provider.start(
      const ContainerConfig(image: 'local/app:test', pullPolicy: .never),
    );
    expect(inspected, ['local/app:test']);
    expect(pulled, isEmpty);
    expect(server.paths, contains('/v1.55/containers/container-1/start'));
  });

  test(
    'never fails on a missing image without pulling or creating a container',
    () async {
      await expectLater(
        provider.start(
          const ContainerConfig(image: 'local/app:test', pullPolicy: .never),
        ),
        throwsA(
          isA<DockerException>()
              .having((e) => e.statusCode, 'status', 404)
              .having((e) => e.message, 'message', contains('local/app:test')),
        ),
      );
      expect(inspected, ['local/app:test']);
      expect(pulled, isEmpty);
      expect(
        server.paths.where((path) => path.endsWith('/containers/create')),
        isEmpty,
      );
    },
  );

  test('inspect preserves untagged references, registry ports, digests and image IDs', () async {
    inspectStatus = 200;
    final images = [
      'redis',
      'registry.example:5000/team/redis',
      'registry.example:5000/team/redis:7',
      'team/redis@sha256:${'a' * 64}',
      'sha256:${'b' * 64}',
      'c' * 64,
    ];
    for (final image in images) {
      await provider.start(ContainerConfig(image: image));
    }
    expect(inspected, images);
    expect(pulled, isEmpty);
  });

  test(
    'missing tagged and digest references are pulled without appending latest',
    () async {
      final images = [
        'registry.example:5000/team/redis:7',
        'team/redis@sha256:${'a' * 64}',
      ];
      for (final image in images) {
        inspectStatus = 404;
        await provider.start(ContainerConfig(image: image));
      }
      expect(inspected, images);
      expect(pulled, images);
    },
  );

  for (final status in [403, 500]) {
    test('inspect HTTP $status is not treated as a missing image', () async {
      inspectStatus = status;
      await expectLater(
        provider.start(const ContainerConfig(image: 'local/app:test')),
        throwsA(
          isA<DockerException>().having((e) => e.statusCode, 'status', status),
        ),
      );
      expect(pulled, isEmpty);
      expect(
        server.paths.where((path) => path.endsWith('/containers/create')),
        isEmpty,
      );
    });
  }
}
