import 'dart:convert';

import 'package:docker_engine/docker_engine.dart' hide ContainerConfig;

import '../errors/exceptions.dart';
import 'container_config.dart';
import 'started_container.dart';

typedef DockerApi = Docker;

class DockerProvider {
  DockerProvider({required DockerApi dockerApi, this.host = 'localhost'})
    : _api = dockerApi,
      _connection = null;

  DockerProvider._(DockerConnection connection)
    : _connection = connection,
      _api = connection.api,
      host = connection.host;

  static Future<DockerProvider> connect({DockerConfig? config}) async =>
      DockerProvider._(
        await DockerConnection.connect(
          config ?? DockerConfig.fromEnvironment(),
        ),
      );

  final DockerConnection? _connection;
  final DockerApi _api;
  final String host;
  bool _closed = false;

  Future<StartedContainer> start(ContainerConfig request) => _start(request);

  Future<StartedContainer> _start(
    ContainerConfig request, {
    bool closeOnTerminate = false,
  }) async {
    if (_closed) throw StateError('DockerProvider is closed');
    request.validate();
    final body = request.toJson();
    final image = request.image;
    final tagged =
        image.contains('@') || image.lastIndexOf(':') > image.lastIndexOf('/');
    final pull = await _api.imagesCreatePost(
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
    final created = await _api.containersCreatePost(
      name: request.name,
      body: body,
    );
    checkResponse(created);
    final id = created.body?.id;
    if (id == null || id.isEmpty) {
      throw const FormatException('Docker create response is missing Id');
    }
    final container = StartedContainer(
      api: _api,
      id: id,
      image: request.image,
      host: host,
      onTerminate: closeOnTerminate ? close : null,
    );
    try {
      checkResponse(await _api.containersIdStartPost(id: id));
      await request.waitStrategy.waitUntilReady(container);
      return container;
    } catch (error) {
      var logs = '';
      Object? cleanupError;
      try {
        logs = await container
            .logs(tail: 100)
            .timeout(const Duration(seconds: 2));
      } catch (_) {
        // Diagnostics must not prevent cleanup.
      }
      try {
        await container.terminate();
      } catch (error) {
        cleanupError = error;
      }
      throw ContainerStartException(
        error,
        containerId: id,
        logs: logs,
        cleanupError: cleanupError,
      );
    }
  }

  void close() {
    if (_closed) return;
    _closed = true;
    _connection?.close();
  }
}

abstract final class Testcontainers {
  // shortcut: explicit cleanup only, add Ryuk before promising crash-safe teardown.
  static Future<StartedContainer> run(
    ContainerConfig request, {
    DockerConfig? config,
  }) async {
    request.validate();
    final provider = await DockerProvider.connect(config: config);
    try {
      return await provider._start(request, closeOnTerminate: true);
    } catch (_) {
      provider.close();
      rethrow;
    }
  }
}
