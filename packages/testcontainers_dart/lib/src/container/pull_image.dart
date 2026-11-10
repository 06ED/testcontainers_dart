import 'dart:convert';

import 'package:docker_engine/docker_engine.dart';

import '../auth/registry_auth.dart';
import '../auth/registry_credentials.dart';
import 'pull_policy.dart';

Future<void> pullImage(
  Docker api,
  String image, {
  required PullPolicy policy,
  required RegistryAuth auth,
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

  final header = await auth.resolve(image);
  try {
    final pull = await api.imagesCreatePost(
      fromImage: tagged ? image : '$image:latest',
      xRegistryAuth: header,
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
  } catch (error) {
    if (header == null) rethrow;
    // Authenticated responses and transport errors can echo the secret header.
    if (error is DockerException) {
      throw DockerException(
        'Authenticated image pull failed',
        statusCode: error.statusCode,
      );
    }
    throw RegistryAuthException('Authenticated image pull failed');
  }
}
