import 'dart:convert';
import 'dart:io';

import 'package:testcontainers_dart/testcontainers_dart.dart';

Future<void> main(List<String> arguments) async {
  final mode = arguments.first;
  if (mode == 'startup-failure') {
    try {
      await Testcontainers.run(
        const ContainerConfig(
          image: 'busybox:1.37',
          command: ['sleep', '300'],
          waitStrategy: _FailAfterReport(),
        ),
        ryuk: const RyukConfig(),
      );
    } on ContainerStartException catch (error) {
      if (error.cause is! StateError || error.cleanupError != null) rethrow;
      return;
    }
    throw StateError('Expected startup to fail');
  }
  final provider = mode == 'terminate'
      ? null
      : await DockerProvider.connect(ryuk: const RyukConfig());
  const config = ContainerConfig(
    image: 'busybox:1.37',
    command: ['sleep', '300'],
  );
  final container = provider == null
      ? await Testcontainers.run(config, ryuk: const RyukConfig())
      : await provider.start(config);
  await report(container);
  if (mode == 'terminate') {
    await container.terminate();
  } else if (mode == 'close') {
    provider!.close();
  } else if (mode == 'crash') {
    await stdin.drain<void>();
  } else {
    throw ArgumentError.value(mode, 'mode');
  }
}

Future<void> report(StartedContainer container) async {
  final info = await container.inspect();
  final session = info['Config']['Labels']['org.testcontainers.sessionId'];
  stdout.writeln(
    jsonEncode({
      'id': container.id,
      'ryuk': 'testcontainers-ryuk-$session',
      'session': session,
    }),
  );
  await stdout.flush();
}

class const _FailAfterReport() implements Wait {
  @override
  Future<void> waitUntilReady(StartedContainer container) async {
    await report(container);
    throw StateError('Intentional readiness failure');
  }
}
