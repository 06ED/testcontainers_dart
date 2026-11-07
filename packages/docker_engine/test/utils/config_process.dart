import 'dart:convert';

import 'package:docker_engine/docker_engine.dart';

void main() {
  final config = DockerConfig.fromEnvironment();
  print(jsonEncode({'endpoint': '${config.endpoint}', 'host': config.host}));
}
