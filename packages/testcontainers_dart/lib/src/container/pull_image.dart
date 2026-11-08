import 'dart:convert';

import 'package:docker_engine/docker_engine.dart';

import 'pull_policy.dart';

Future<void> pullImage(
  Docker api,
  String image, {
  required PullPolicy policy,
}) async {
  if (policy != .always) {
    final inspected = await api.imagesNameJsonGet(name: image);
    if (inspected.isSuccessful) return;
    if (policy == .never || inspected.statusCode != 404) {
      checkResponse(inspected);
    }
  }

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
