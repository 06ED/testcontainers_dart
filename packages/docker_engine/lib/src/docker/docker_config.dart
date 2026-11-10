import 'dart:io';

class DockerConfig({
  required Uri endpoint,
  String? host,
  final Duration requestTimeout = const Duration(minutes: 2),
}) {
  final Uri endpoint = endpoint.scheme == 'tcp'
      ? endpoint.replace(scheme: 'http')
      : endpoint;
  final String host =
      host ?? (endpoint.scheme == 'unix' ? 'localhost' : endpoint.host);

  this {
    if (!{'unix', 'http', 'https'}.contains(this.endpoint.scheme)) {
      throw UnsupportedError(
        'Supported Docker transports: unix, tcp, http, https',
      );
    }

    if (endpoint.scheme == 'unix'
        ? !endpoint.path.startsWith('/') || endpoint.path.isEmpty
        : endpoint.host.isEmpty) {
      throw ArgumentError.value(
        endpoint,
        'endpoint',
        'An absolute socket path or hostname is required',
      );
    }

    if (requestTimeout <= Duration.zero) {
      throw ArgumentError.value(requestTimeout, 'requestTimeout');
    }

    if (this.host.isEmpty) throw ArgumentError.value(host, 'host');
  }

  factory fromEnvironment([Map<String, String>? environment]) {
    final env = environment ?? Platform.environment;

    if ((env['DOCKER_TLS_VERIFY'] ?? '').isNotEmpty ||
        (env['DOCKER_CERT_PATH'] ?? '').isNotEmpty) {
      throw UnsupportedError(
        'Docker client-certificate environment settings are not supported; no insecure fallback is used',
      );
    }

    var endpoint = env['DOCKER_HOST'];
    if (endpoint == null || endpoint.isEmpty) {
      final desktop = '${env['HOME']}/.docker/run/docker.sock';
      endpoint =
          FileSystemEntity.typeSync(desktop) ==
              FileSystemEntityType.unixDomainSock
          ? 'unix://$desktop'
          : 'unix:///var/run/docker.sock';
    }

    return DockerConfig(
      endpoint: Uri.parse(endpoint),
      host: env['TESTCONTAINERS_HOST_OVERRIDE'],
    );
  }
}
