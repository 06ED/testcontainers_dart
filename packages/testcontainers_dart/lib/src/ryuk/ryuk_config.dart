import 'dart:io';

class RyukConfig {
  const RyukConfig({
    this.enabled = true,
    this.image = 'testcontainers/ryuk:0.14.0',
    this.socketPath = '/var/run/docker.sock',
    this.portBindingHost = '127.0.0.1',
    this.startupTimeout = const Duration(seconds: 30),
  });

  factory RyukConfig.fromEnvironment([Map<String, String>? environment]) {
    final env = environment ?? Platform.environment;
    final disabled = env['TESTCONTAINERS_RYUK_DISABLED'] ?? 'false';

    if (disabled != 'true' && disabled != 'false') {
      throw ArgumentError.value(
        disabled,
        'TESTCONTAINERS_RYUK_DISABLED',
        'Expected true or false',
      );
    }

    return RyukConfig(
      enabled: disabled != 'true',
      image:
          env['TESTCONTAINERS_RYUK_CONTAINER_IMAGE'] ??
          'testcontainers/ryuk:0.14.0',
      socketPath:
          env['TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE'] ??
          '/var/run/docker.sock',
    )..validate();
  }

  final bool enabled;
  final String image;

  /// Socket path on the Docker daemon's host, not the client machine.
  final String socketPath;
  final String portBindingHost;

  /// Bounds TCP connection retries and filter acknowledgement after Docker start.
  /// Docker API calls use `DockerConfig.requestTimeout`.
  final Duration startupTimeout;

  void validate() {
    if (image.trim().isEmpty || image.contains('\u0000')) {
      throw ArgumentError.value(image, 'image');
    }
    if (!socketPath.startsWith('/') || socketPath.contains('\u0000')) {
      throw ArgumentError.value(socketPath, 'socketPath');
    }
    if (portBindingHost.trim().isEmpty || portBindingHost.contains('\u0000')) {
      throw ArgumentError.value(portBindingHost, 'portBindingHost');
    }
    if (startupTimeout <= Duration.zero) {
      throw ArgumentError.value(startupTimeout, 'startupTimeout');
    }
  }
}
