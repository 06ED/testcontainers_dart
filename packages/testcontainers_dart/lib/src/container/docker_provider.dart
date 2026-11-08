import 'package:docker_engine/docker_engine.dart' hide ContainerConfig;

import '../errors/exceptions.dart';
import '../ryuk/ryuk_config.dart';
import '../ryuk/ryuk_session.dart';
import 'container_config.dart';
import 'pull_image.dart';
import 'started_container.dart';

class DockerProvider {
  new({required Docker dockerApi, this.host = 'localhost', RyukConfig? ryuk})
    : _api = dockerApi,
      _connection = null {
    _configureRyuk(ryuk);
  }

  new _(DockerConnection connection, RyukConfig ryuk)
    : _connection = connection,
      _api = connection.api,
      host = connection.host {
    _configureRyuk(ryuk);
  }

  final DockerConnection? _connection;
  final Docker _api;
  final String host;
  bool _closed = false;
  int _starts = 0;
  RyukSession? _ryuk;

  static Future<DockerProvider> connect({
    DockerConfig? config,
    RyukConfig? ryuk,
  }) async {
    final settings = ryuk ?? RyukConfig.fromEnvironment();
    settings.validate();
    return DockerProvider._(
      await DockerConnection.connect(config ?? DockerConfig.fromEnvironment()),
      settings,
    );
  }

  void _configureRyuk(RyukConfig? config) {
    final settings = config ?? RyukConfig.fromEnvironment();
    settings.validate();
    if (settings.enabled) _ryuk = RyukSession(_api, host, settings);
  }

  void _checkActive() {
    if (_closed) throw StateError('DockerProvider is closed');
    _ryuk?.checkActive();
  }

  Future<StartedContainer> start(ContainerConfig request) => _start(request);

  Future<StartedContainer> _start(
    ContainerConfig request, {
    bool closeOnTerminate = false,
  }) async {
    _starts++;
    try {
      return await _startContainer(request, closeOnTerminate: closeOnTerminate);
    } finally {
      _starts--;
      if (_closed && _starts == 0) _connection?.close();
    }
  }

  Future<StartedContainer> _startContainer(
    ContainerConfig request, {
    required bool closeOnTerminate,
  }) async {
    if (_closed) throw StateError('DockerProvider is closed');

    request.validate();
    final body = request.toJson();
    final session = _ryuk;

    if (session != null) {
      body['Labels'].addAll({
        'org.testcontainers': 'true',
        'org.testcontainers.sessionId': session.id,
      });
      await session.ensureStarted();
    }

    _checkActive();
    await pullImage(_api, request.image);
    _checkActive();
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
      _checkActive();
      checkResponse(await _api.containersIdStartPost(id: id));
      _checkActive();
      await request.waitStrategy.waitUntilReady(container);
      _checkActive();
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
    _ryuk?.close();

    // Let in-flight startup finish its cleanup before closing the transport.
    if (_starts == 0) _connection?.close();
  }
}

abstract final class Testcontainers() {
  static Future<StartedContainer> run(
    ContainerConfig request, {
    DockerConfig? config,
    RyukConfig? ryuk,
  }) async {
    request.validate();
    final provider = await DockerProvider.connect(config: config, ryuk: ryuk);

    try {
      return await provider._start(request, closeOnTerminate: true);
    } catch (_) {
      provider.close();
      rethrow;
    }
  }
}
