import 'package:docker_engine/docker_engine.dart' show DockerConnection;
import 'package:testcontainers_dart/testcontainers_dart.dart';

Future<void> main() async {
  final connection = await DockerConnection.connect(
    DockerConfig.fromEnvironment(),
  );
  try {
    final provider = DockerProvider(
      dockerApi: connection.api,
      host: connection.host,
    );
    try {
      await provider.start(const ContainerConfig(image: 'redis'));
    } finally {
      provider.close();
    }
  } finally {
    connection.close();
  }
}
