import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:docker_engine/docker_engine.dart' hide Platform;
import 'package:test/test.dart';

void main() {
  test(
    'reads a controlled process environment when none is supplied',
    () async {
      final library = await Isolate.resolvePackageUri(
        Uri.parse('package:docker_engine/docker_engine.dart'),
      );
      final result = await Process.run(
        Platform.resolvedExecutable,
        [library!.resolve('../test/utils/config_process.dart').toFilePath()],
        environment: {
          'DOCKER_HOST': 'tcp://docker.example:2375',
          'TESTCONTAINERS_HOST_OVERRIDE': 'services.example',
          'DOCKER_TLS_VERIFY': '',
          'DOCKER_CERT_PATH': '',
        },
      );

      expect(result.exitCode, 0, reason: '${result.stderr}');
      expect(jsonDecode(result.stdout as String), {
        'endpoint': 'http://docker.example:2375',
        'host': 'services.example',
      });
    },
  );

  test('uses the default socket when the Desktop socket does not exist', () {
    final config = DockerConfig.fromEnvironment({'HOME': '/nonexistent-home'});

    expect(config.endpoint.toString(), 'unix:///var/run/docker.sock');
    expect(config.host, 'localhost');
  });

  test('discovers the Docker Desktop socket', () async {
    final home = await Directory.systemTemp.createTemp('de-');
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

  test('rejects unsupported transports and insecure TLS fallbacks', () {
    expect(
      () => DockerConfig(endpoint: Uri.parse('ssh://docker')),
      throwsUnsupportedError,
    );

    for (final key in ['DOCKER_TLS_VERIFY', 'DOCKER_CERT_PATH']) {
      expect(
        () => DockerConfig.fromEnvironment({key: 'configured'}),
        throwsUnsupportedError,
      );
    }
  });

  test('validates endpoints, host overrides and timeouts', () {
    for (final endpoint in [
      'unix:relative.sock',
      'unix:',
      'http:/missing-host',
    ]) {
      expect(
        () => DockerConfig(endpoint: Uri.parse(endpoint)),
        throwsArgumentError,
      );
    }

    final endpoint = Uri.parse('https://docker.example:2376');
    for (final timeout in [Duration.zero, const Duration(seconds: -1)]) {
      expect(
        () => DockerConfig(endpoint: endpoint, requestTimeout: timeout),
        throwsArgumentError,
      );
    }
    expect(
      () => DockerConfig(endpoint: endpoint, host: ''),
      throwsArgumentError,
    );

    final config = DockerConfig.fromEnvironment({
      'DOCKER_HOST': '$endpoint',
      'TESTCONTAINERS_HOST_OVERRIDE': 'services.example',
    });
    expect(config.endpoint, endpoint);
    expect(config.host, 'services.example');
  });
}
