import '../wait/wait.dart';
import 'pull_policy.dart';

class Port {
  const new tcp(this.number) : protocol = 'tcp';
  const new udp(this.number) : protocol = 'udp';

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

class const BindMount({
  required final String source,
  required final String target,
  final bool readOnly = true,
});

class const ContainerConfig({
  required final String image,
  final PullPolicy pullPolicy = .ifNotPresent,
  final String? name,
  final Map<String, String> environment = const {},
  final List<String>? command,
  final List<Port> exposedPorts = const [],
  final List<BindMount> mounts = const [],
  final Map<String, String> labels = const {},
  final String portBindingHost = '127.0.0.1',
  final Wait waitStrategy = const Wait.forNothing(),
}) {
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
    if (command case final command?) 'Cmd': List.of(command),

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
