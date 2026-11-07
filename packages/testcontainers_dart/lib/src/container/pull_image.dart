import 'dart:convert';

import 'package:docker_engine/docker_engine.dart';

Future<void> pullImage(Docker api, String image) async {
  final tagged =
      image.contains('@') || image.lastIndexOf(':') > image.lastIndexOf('/');

  final pull = await api.imagesCreatePost(
    fromImage: tagged ? image : '$image:latest',
  );

  checkResponse(pull);

  for (final line in const LineSplitter().convert(responseText(pull))) {
    if (line.trim().isEmpty) continue;

    final event = jsonDecode(line) as Map<String, dynamic>;

    if (event['error'] != null || event['errorDetail'] != null) {
      throw DockerException(
        '${event['error'] ?? event['errorDetail']}',
        statusCode: pull.statusCode,
      );
    }
  }
}
