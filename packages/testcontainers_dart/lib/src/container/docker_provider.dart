import 'package:docker_engine/docker_engine.dart' hide ContainerConfig;
import 'package:uuid/uuid.dart';

import '../auth/registry_auth.dart';
import '../auth/registry_credentials.dart';
import '../errors/exceptions.dart';
import '../network/managed_network.dart';
import '../ryuk/ryuk_config.dart';
import '../ryuk/ryuk_session.dart';
import 'container_config.dart';
import 'pull_image.dart';
import 'started_container.dart';

class DockerProvider {
  new({
    required Docker dockerApi,
    this.host = 'localhost',
    RyukConfig? ryuk,
    Map<String, RegistryCredentials> registryCredentials = const {},
  }) : _api = dockerApi,
       _connection = null,
       _registryAuth = RegistryAuth(credentials: registryCredentials) {
    _configureRyuk(ryuk);
  }

  new _(DockerConnection connection, RyukConfig ryuk, this._registryAuth)
    : _connection = connection,
      _api = connection.api,
      host = connection.host {
    _configureRyuk(ryuk);
  }

  final DockerConnection? _connection;
  final Docker _api;
  final RegistryAuth _registryAuth;
  final String host;
  bool _closed = false;
  int _operations = 0;
  final String _sessionId = const Uuid().v4();
  RyukSession? _ryuk;

  static Future<DockerProvider> connect({
    DockerConfig? config,
    RyukConfig? ryuk,
    Map<String, RegistryCredentials> registryCredentials = const {},
  }) async {
    final settings = ryuk ?? RyukConfig.fromEnvironment();
    settings.validate();
    final auth = RegistryAuth(credentials: registryCredentials);
    return DockerProvider._(
      await DockerConnection.connect(config ?? DockerConfig.fromEnvironment()),
      settings,
      auth,
    );
  }

  void _configureRyuk(RyukConfig? config) {
    final settings = config ?? RyukConfig.fromEnvironment();
    settings.validate();
    if (settings.enabled) {
      _ryuk = RyukSession(_api, host, settings, _registryAuth, _sessionId);
    }
  }

  void _checkActive() {
    if (_closed) throw StateError('DockerProvider is closed');
    _ryuk?.checkActive();
  }

  Future<StartedContainer> start(ContainerConfig request) => _start(request);

  Map<String, String> get _sessionLabels => {
    'org.testcontainers': 'true',
    'org.testcontainers.sessionId': _sessionId,
  };

  Future<ManagedNetwork> createNetwork() async {
    if (_closed) throw StateError('DockerProvider is closed');
    _operations++;
    final name = 'testcontainers-${const Uuid().v4()}';
    var cleanupId = name;
    var created = false;
    try {
      await _ryuk?.ensureStarted();
      _checkActive();
      created = true;
      final response = await _api.networksCreatePost(
        networkConfig: {
          'Name': name,
          'Driver': 'bridge',
          'Labels': _sessionLabels,
        },
      );
      if (!response.isSuccessful) created = false;
      checkResponse(response);
      final id = response.body?.id;
      if (id == null || id.isEmpty) {
        throw const FormatException(
          'Docker network create response is missing Id',
        );
      }
      cleanupId = id;
      _checkActive();
      return ManagedNetwork(api: _api, owner: this, id: id, name: name);
    } catch (error) {
      if (created) {
        try {
          checkResponse(
            await _api.networksIdDelete(id: cleanupId),
            allowed: {404},
          );
        } catch (cleanupError) {
          throw NetworkCreateException(error, cleanupError);
        }
      }
      rethrow;
    } finally {
      _operations--;
      if (_closed && _operations == 0) _connection?.close();
    }
  }

  Future<StartedContainer> _start(
    ContainerConfig request, {
    bool closeOnTerminate = false,
  }) async {
    _operations++;
    try {
      return await _startContainer(request, closeOnTerminate: closeOnTerminate);
    } finally {
      _operations--;
      if (_closed && _operations == 0) _connection?.close();
    }
  }

  Future<StartedContainer> _startContainer(
    ContainerConfig request, {
    required bool closeOnTerminate,
  }) async {
    if (_closed) throw StateError('DockerProvider is closed');

    request.validate();
    request.network?.checkOwner(this);
    final body = request.toJson();
    final session = _ryuk;

    if (session != null || request.network != null) {
      body['Labels'].addAll(_sessionLabels);
    }
    await session?.ensureStarted();

    _checkActive();
    await pullImage(
      _api,
      request.image,
      policy: request.pullPolicy,
      auth: _registryAuth,
    );
    _checkActive();
    request.network?.checkOwner(this);
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
      for (final file in request.files) {
        await file.copyTo(_api, id);
        _checkActive();
      }
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

    // Let in-flight resource creation finish cleanup before closing the transport.
    if (_operations == 0) _connection?.close();
  }
}

abstract final class Testcontainers() {
  static Future<StartedContainer> run(
    ContainerConfig request, {
    DockerConfig? config,
    RyukConfig? ryuk,
    Map<String, RegistryCredentials> registryCredentials = const {},
  }) async {
    request.validate();
    final provider = await DockerProvider.connect(
      config: config,
      ryuk: ryuk,
      registryCredentials: registryCredentials,
    );

    try {
      return await provider._start(request, closeOnTerminate: true);
    } catch (_) {
      provider.close();
      rethrow;
    }
  }
}
