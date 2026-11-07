import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:docker_engine/docker_engine.dart' hide ContainerConfig;

import '../container/container_config.dart';
import '../container/pull_image.dart';
import '../container/started_container.dart';
import '../errors/exceptions.dart';
import 'ryuk_config.dart';

class RyukSession {
  RyukSession(this.api, this.host, this.config)
    : id = List.generate(
        16,
        (_) => Random.secure().nextInt(256).toRadixString(16).padLeft(2, '0'),
      ).join();

  final Docker api;
  final String host;
  final RyukConfig config;
  final String id;
  Future<void>? _startup;
  Socket? _socket;
  Completer<void>? _ack;
  bool _closed = false;
  bool _connected = false;

  Future<void> ensureStarted() async {
    await (_startup ??= _start());
    checkActive();
  }

  void checkActive() {
    if (_closed || !_connected) {
      throw StateError(
        'Ryuk session is closed or disconnected; create a new DockerProvider',
      );
    }
  }

  void _checkOpen() {
    if (_closed) throw StateError('Ryuk session is closed');
  }

  Future<void> _start() async {
    final name = 'testcontainers-ryuk-$id';
    StartedContainer? container;
    var creating = false;
    try {
      _checkOpen();
      await pullImage(api, config.image);
      _checkOpen();
      final body = ContainerConfig(
        image: config.image,
        exposedPorts: const [Port.tcp(8080)],
        portBindingHost: config.portBindingHost,
        mounts: [
          BindMount(
            source: config.socketPath,
            target: '/var/run/docker.sock',
            readOnly: false,
          ),
        ],
        labels: const {
          'org.testcontainers': 'true',
          'org.testcontainers.ryuk': 'true',
        },
      ).toJson();
      body['HostConfig']['AutoRemove'] = true;
      creating = true;
      final created = await api.containersCreatePost(name: name, body: body);
      if (!created.isSuccessful) creating = false;
      checkResponse(created);
      final containerId = created.body?.id;
      if (containerId == null || containerId.isEmpty) {
        throw const FormatException('Ryuk create response is missing Id');
      }
      container = StartedContainer(
        api: api,
        id: containerId,
        image: config.image,
        host: host,
      );
      _checkOpen();
      checkResponse(await api.containersIdStartPost(id: container.id));
      _checkOpen();
      final port = await container.mappedPort(8080);
      _checkOpen();
      final watch = Stopwatch()..start();
      Duration remaining() {
        final left = config.startupTimeout - watch.elapsed;
        if (left <= Duration.zero) {
          throw TimeoutException(
            'Timed out connecting to Ryuk',
            config.startupTimeout,
          );
        }
        return left;
      }

      while (true) {
        _checkOpen();
        try {
          _socket = await Socket.connect(host, port, timeout: remaining());
          _checkOpen();
          await _handshake(_socket!, remaining());
          checkActive();
          break;
        } on SocketException {
          _checkOpen();
          final left = remaining();
          await Future<void>.delayed(
            left < const Duration(milliseconds: 100)
                ? left
                : const Duration(milliseconds: 100),
          );
        }
      }
    } catch (error) {
      close();
      var logs = '';
      Object? cleanupError;
      if (container != null) {
        try {
          logs = await container
              .logs(tail: 100)
              .timeout(const Duration(seconds: 2));
        } catch (_) {
          // Diagnostics must not prevent cleanup.
        }
      }
      if (creating) {
        try {
          checkResponse(
            await api.containersIdDelete(
              id: container?.id ?? name,
              force: true,
              v: true,
            ),
            allowed: {404},
          );
        } catch (error) {
          cleanupError = error;
        }
      }
      throw ContainerStartException(
        error,
        containerId: container?.id ?? name,
        logs: logs,
        cleanupError: cleanupError,
      );
    }
  }

  Future<void> _handshake(Socket socket, Duration timeout) async {
    final ack = _ack = Completer<void>();
    var offset = 0;
    void lost([Object? error]) {
      if (identical(_socket, socket)) _connected = false;
      if (!ack.isCompleted) {
        ack.completeError(
          error ?? const SocketException('Ryuk disconnected before ACK'),
        );
      }
      socket.destroy();
    }

    socket.listen(
      (bytes) {
        if (ack.isCompleted) return;
        const expected = [65, 67, 75, 10]; // ACK\n
        for (final byte in bytes) {
          if (byte != expected[offset++]) {
            lost(const FormatException('Invalid Ryuk ACK'));
            return;
          }
          if (offset == expected.length) {
            _connected = true;
            ack.complete();
            return;
          }
        }
      },
      onError: lost,
      onDone: lost,
    );
    socket.write('label=org.testcontainers.sessionId=$id\n');
    await ack.future.timeout(timeout);
  }

  void close() {
    _closed = true;
    _connected = false;
    final ack = _ack;
    if (ack != null && !ack.isCompleted) {
      ack.completeError(StateError('Ryuk session closed before ACK'));
    }
    _socket?.destroy();
  }
}
