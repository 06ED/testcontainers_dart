import 'dart:convert';

import 'package:docker_engine/docker_engine.dart'
    show DockerConnection, checkResponse, responseText;
import 'package:test/test.dart';
import 'package:testcontainers_dart/src/auth/registry_auth.dart';
import 'package:testcontainers_dart/src/container/pull_image.dart';
import 'package:testcontainers_dart/testcontainers_dart.dart';

void main() {
  test('real private registry authenticates application and Ryuk pulls', () async {
    // Public test-only credentials; Distribution's htpasswd backend requires bcrypt.
    const htpasswd =
        r'testcontainers:$2y$05$jqQMr6wUwWl0QeZcZppVme.eT1AO.KRmSFbfR1Zaw9xQnqKepDPuC';

    final connection = await DockerConnection.connect(
      DockerConfig.fromEnvironment(),
    );
    addTearDown(connection.close);
    await pullImage(
      connection.api,
      'registry:2.8.3',
      policy: .ifNotPresent,
      auth: RegistryAuth(),
    );

    final body = ContainerConfig(
      image: 'registry:2.8.3',
      environment: {
        'REGISTRY_HTTP_ADDR': '127.0.0.1:0',
        'REGISTRY_AUTH': 'htpasswd',
        'REGISTRY_AUTH_HTPASSWD_REALM': 'testcontainers',
        'REGISTRY_AUTH_HTPASSWD_PATH': '/tmp/htpasswd',
      },
      command: [
        'sh',
        '-c',
        "printf '%s\\n' '$htpasswd' > /tmp/htpasswd; exec registry serve /etc/docker/registry/config.yml",
      ],
    ).toJson();
    // Daemon-loopback avoids exposing a test registry and works inside Docker Desktop's VM.
    body['HostConfig']['NetworkMode'] = 'host';
    final created = await connection.api.containersCreatePost(body: body);
    checkResponse(created);

    final registry = StartedContainer(
      api: connection.api,
      id: created.body!.id,
      image: 'registry:2.8.3',
      host: connection.host,
    );
    addTearDown(registry.terminate);
    checkResponse(await connection.api.containersIdStartPost(id: registry.id));
    await Wait.forLogMessage('listening on').waitUntilReady(registry);
    final port = RegExp(r'listening on 127\.0\.0\.1:(\d+)')
        .firstMatch(await registry.logs())!
        .group(1)!;
    final address = '127.0.0.1:$port';

    final warm = await Testcontainers.run(
      const ContainerConfig(image: 'busybox:1.37', command: ['sleep', '300']),
    );
    addTearDown(warm.terminate);
    await warm.terminate();

    final credentials = RegistryCredentials(
      username: 'testcontainers',
      password: 'testcontainers',
    );
    final header = base64Url.encode(
      utf8.encode(jsonEncode(credentials.toJson(address))),
    );
    final prefix = '$address/test-${DateTime.now().microsecondsSinceEpoch}';
    final images = <String>[];

    addTearDown(() async {
      for (final image in images) {
        final clock = Stopwatch()..start();
        while (true) {
          final removed = await connection.api.imagesNameDelete(name: image);
          if (removed.statusCode != 409 ||
              clock.elapsed > const Duration(seconds: 30)) {
            checkResponse(removed);
            break;
          }
          // Ryuk may still be removing its own container after provider.close().
          await Future.pause(const Duration(milliseconds: 100));
        }
      }
    });

    for (final (source, repo) in [
      ('busybox:1.37', '$prefix/app'),
      (const RyukConfig().image, '$prefix/ryuk'),
    ]) {
      checkResponse(
        await connection.api.imagesNameTagPost(
          name: source,
          repo: repo,
          tag: 'test',
        ),
      );

      images.add('$repo:test');
      final pushed = await connection.api.imagesNamePushPost(
        name: repo,
        tag: 'test',
        xRegistryAuth: header,
      );

      checkResponse(pushed);
      for (final line in const LineSplitter().convert(responseText(pushed))) {
        if (line.trim().isNotEmpty) expect(jsonDecode(line)['error'], isNull);
      }
    }

    await expectLater(
      Testcontainers.run(
        ContainerConfig(image: images[0], pullPolicy: .always),
        ryuk: const RyukConfig(enabled: false),
        registryCredentials: {
          address: RegistryCredentials(username: 'wrong', password: 'wrong'),
        },
      ),
      throwsA(isA<DockerException>()),
    );

    final provider = await DockerProvider.connect(
      registryCredentials: {address: credentials},
      ryuk: RyukConfig(image: images[1], pullPolicy: .always),
    );
    addTearDown(provider.close);

    final container = await provider.start(
      ContainerConfig(
        image: images[0],
        pullPolicy: .always,
        command: const ['sleep', '300'],
      ),
    );
    addTearDown(container.terminate);
    expect(
      (await container.exec(['echo', 'authenticated'])).stdout.trim(),
      'authenticated',
    );

    await container.terminate();
  }, timeout: const Timeout(Duration(minutes: 5)));
}
