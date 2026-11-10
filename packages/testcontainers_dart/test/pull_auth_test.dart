import 'dart:convert';

import 'package:docker_engine/docker_engine.dart' show DockerConnection;
import 'package:test/test.dart';
import 'package:testcontainers_dart/src/auth/registry_auth.dart';
import 'package:testcontainers_dart/src/container/pull_image.dart';
import 'package:testcontainers_dart/testcontainers_dart.dart';

import 'utils/docker_server.dart';

void main() {
  late DockerServer server;
  late DockerConnection connection;
  late RegistryAuth auth;
  const secret = 'secret-never-in-diagnostics';

  setUp(() async {
    server = await DockerServer.start();
    connection = await DockerConnection.connect(
      DockerConfig(endpoint: server.endpoint),
    );
    auth = RegistryAuth(
      credentials: {
        'registry.test': RegistryCredentials(
          username: 'user',
          password: secret,
        ),
      },
      environment: {},
    );
  });

  tearDown(() async {
    connection.close();
    await server.close();
  });

  test('pull sends base64url auth only to the pull endpoint', () async {
    final requests = <String, String?>{};
    server.handler = (request) async {
      requests[request.uri.path] = request.headers.value('x-registry-auth');
      return false;
    };
    await pullImage(
      connection.api,
      'registry.test/app',
      policy: .ifNotPresent,
      auth: auth,
    );

    expect(
      requests.entries.where((e) => e.key.endsWith('/json')).single.value,
      isNull,
    );

    final header = requests.entries
        .where((e) => e.key.endsWith('/images/create'))
        .single
        .value!;
    expect(jsonDecode(utf8.decode(base64Url.decode(header))), {
      'username': 'user',
      'password': secret,
      'serveraddress': 'registry.test',
    });
  });

  test('anonymous pull omits the header', () async {
    server.handler = (request) async {
      expect(request.headers.value('x-registry-auth'), isNull);
      return false;
    };

    await pullImage(
      connection.api,
      'other.test/app',
      policy: .always,
      auth: auth,
    );
  });

  test('local images and never policy do not parse credentials', () async {
    auth = RegistryAuth(environment: {'DOCKER_AUTH_CONFIG': 'secret-invalid'});
    server.handler = (request) async {
      if (request.uri.path.endsWith('/json')) {
        await DockerServer.respond(request, <String, dynamic>{});
        return true;
      }
      fail('Local images must not be pulled');
    };

    for (final policy in [PullPolicy.ifNotPresent, PullPolicy.never]) {
      await pullImage(
        connection.api,
        'registry.test/app',
        policy: policy,
        auth: auth,
      );
    }

    server.handler = null;
    await expectLater(
      pullImage(
        connection.api,
        'registry.test/app',
        policy: .never,
        auth: auth,
      ),
      throwsA(
        isA<DockerException>().having((e) => e.statusCode, 'status', 404),
      ),
    );
  });

  for (final kind in ['http', 'ndjson', 'malformed']) {
    test('authenticated $kind failures cannot reflect credentials', () async {
      server.handler = (request) async {
        if (!request.uri.path.endsWith('/images/create')) return false;
        final header = request.headers.value('x-registry-auth')!;
        final message =
            '$secret $header ${base64Encode(utf8.encode('user:$secret'))}';
        await DockerServer.respond(
          request,
          kind == 'http'
              ? {'message': message}
              : kind == 'ndjson'
              ? '${jsonEncode({
                  'errorDetail': {'message': message},
                })}\n'
              : message,
          status: kind == 'http' ? 401 : 200,
        );
        return true;
      };

      try {
        await pullImage(
          connection.api,
          'registry.test/app',
          policy: .always,
          auth: auth,
        );
        fail('Pull must fail');
      } catch (error) {
        expect(
          error,
          anyOf(isA<DockerException>(), isA<RegistryAuthException>()),
        );
        expect(error.toString(), isNot(contains(secret)));
        expect(
          error.toString(),
          isNot(contains(base64Encode(utf8.encode('user:$secret')))),
        );
        if (kind == 'http') expect((error as DockerException).statusCode, 401);
      }

      expect(
        server.paths.where((p) => p.endsWith('/images/create')),
        hasLength(1),
      );
    });
  }

  test(
    'Testcontainers.run forwards explicit credentials and terminates normally',
    () async {
      String? header;
      server.handler = (request) async {
        if (request.uri.path.endsWith('/images/create')) {
          header = request.headers.value('x-registry-auth');
        }

        return false;
      };

      final container = await Testcontainers.run(
        const ContainerConfig(image: 'registry.test/app'),
        config: DockerConfig(endpoint: server.endpoint),
        ryuk: const RyukConfig(enabled: false),
        registryCredentials: {
          'registry.test': RegistryCredentials(
            username: 'user',
            password: secret,
          ),
        },
      );

      addTearDown(container.terminate);
      expect(
        jsonDecode(utf8.decode(base64Url.decode(header!)))['password'],
        secret,
      );

      await container.terminate();
    },
  );

  test(
    'injected Docker API uses the same explicit registry credentials',
    () async {
      String? header;
      server.handler = (request) async {
        if (request.uri.path.endsWith('/images/create')) {
          header = request.headers.value('x-registry-auth');
        }
        return false;
      };
      final provider = DockerProvider(
        dockerApi: connection.api,
        ryuk: const RyukConfig(enabled: false),
        registryCredentials: {
          'registry.test': RegistryCredentials.identityToken(secret),
        },
      );
      addTearDown(provider.close);
      final container = await provider.start(
        const ContainerConfig(image: 'registry.test/app'),
      );
      addTearDown(container.terminate);
      expect(
        jsonDecode(utf8.decode(base64Url.decode(header!)))['identitytoken'],
        secret,
      );
    },
  );
}
