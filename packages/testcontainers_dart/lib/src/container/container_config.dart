import '../wait/wait_strategy.dart';

class Port {
  const Port.tcp(this.number) : protocol = 'tcp';
  const Port.udp(this.number) : protocol = 'udp';

  final int number;
  final String protocol;

  @override
  String toString() => '$number/$protocol';

  void validate() {
    if (number < 1 || number > 65535) {
      throw ArgumentError.value(number, 'port', 'Must be between 1 and 65535');
    }
  }
}

class BindMount {
  const BindMount({
    required this.source,
    required this.target,
    this.readOnly = true,
  });

  final String source;
  final String target;
  final bool readOnly;
}

class ContainerConfig {
  const ContainerConfig({
    required this.image,
    this.name,
    this.environment = const {},
    this.command,
    this.exposedPorts = const [],
    this.mounts = const [],
    this.labels = const {},
    this.portBindingHost = '127.0.0.1',
    this.waitStrategy = const NoWaitStrategy(),
  });

  final String image;
  final String? name;
  final Map<String, String> environment;
  final List<String>? command;
  final List<Port> exposedPorts;
  final List<BindMount> mounts;
  final Map<String, String> labels;
  final String portBindingHost;
  final WaitStrategy waitStrategy;

  void validate() {
    if (image.trim().isEmpty || image.contains('\u0000')) {
      throw ArgumentError.value(image, 'image', 'An image is required');
    }

    if (labels.keys.any(
      (key) =>
          key == 'org.testcontainers' || key.startsWith('org.testcontainers.'),
    )) {
      throw ArgumentError('The org.testcontainers label namespace is reserved');
    }

    for (final port in exposedPorts) {
      port.validate();
    }

    for (final entry in environment.entries) {
      if (entry.key.isEmpty ||
          entry.key.contains('=') ||
          entry.key.contains('\u0000') ||
          entry.value.contains('\u0000')) {
        throw ArgumentError(
          'Environment keys must be non-empty and contain no = or NUL; values must contain no NUL',
        );
      }
    }

    for (final mount in mounts) {
      if (!mount.source.startsWith('/') ||
          !mount.target.startsWith('/') ||
          mount.source.contains('\u0000') ||
          mount.target.contains('\u0000')) {
        throw ArgumentError(
          'Bind mount paths must be absolute POSIX paths without NUL',
        );
      }
    }
  }

  Map<String, dynamic> toJson() => {
    'Image': image,
    'Env': [
      for (final entry in environment.entries) '${entry.key}=${entry.value}',
    ],
    if (command != null) 'Cmd': List<String>.of(command!),

    'Labels': Map<String, String>.of(labels),
    'ExposedPorts': {
      for (final port in exposedPorts) '$port': <String, dynamic>{},
    },
    'HostConfig': {
      'PortBindings': {
        for (final port in exposedPorts)
          '$port': [
            {'HostIp': portBindingHost, 'HostPort': ''},
          ],
      },
      'Mounts': [
        for (final mount in mounts)
          {
            'Type': 'bind',
            'Source': mount.source,
            'Target': mount.target,
            'ReadOnly': mount.readOnly,
          },
      ],
    },
  };
}
