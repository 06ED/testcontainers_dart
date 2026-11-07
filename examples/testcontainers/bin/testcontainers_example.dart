import 'package:testcontainers_dart/testcontainers_dart.dart';

Future<void> main() async {
  final container = await Testcontainers.run(
    ContainerConfig(
      image: 'busybox:1.37',
      command: const ['sh', '-c', 'echo ready; exec sleep 300'],
      waitStrategy: Wait.forLogMessage('ready'),
    ),
  );

  try {
    final result = await container.exec(['uname', '-m']);
    print(result.stdout.trim());
  } finally {
    await container.terminate();
  }
}
