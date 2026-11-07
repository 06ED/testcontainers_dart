import 'dart:async';
import 'dart:io';

import '../container/container_config.dart';
import '../container/started_container.dart';
import '../errors/exceptions.dart';

abstract interface class WaitStrategy {
  Future<void> waitUntilReady(StartedContainer container);
}

class NoWaitStrategy implements WaitStrategy {
  const NoWaitStrategy();

  @override
  Future<void> waitUntilReady(StartedContainer container) async {}
}

abstract final class Wait {
  static WaitStrategy forNothing() => const NoWaitStrategy();

  static WaitStrategy forLogMessage(
    Pattern message, {
    int times = 1,
    Duration timeout = const Duration(seconds: 60),
    Duration pollInterval = const Duration(milliseconds: 100),
  }) {
    if (times < 1 || message is String && message.isEmpty) {
      throw ArgumentError(
        'A non-empty pattern and positive occurrence count are required',
      );
    }

    return _PollingWaitStrategy(
      'log message "$message" ($times times)',
      (container, _, _) async {
        // shortcut: searches the last 1000 lines, use streaming for very verbose startup logs.
        return message.allMatches(await container.logs()).length >= times;
      },
      timeout,
      pollInterval,
    );
  }

  static WaitStrategy forListeningPort({
    required int port,
    Duration timeout = const Duration(seconds: 60),
    Duration pollInterval = const Duration(milliseconds: 100),
  }) {
    Port.tcp(port).validate();

    return _PollingWaitStrategy(
      'TCP port $port',
      (container, _, remaining) async {
        final socket = await Socket.connect(
          container.host,
          await container.mappedPort(port),
          timeout: remaining,
        );
        socket.destroy();
        return true;
      },
      timeout,
      pollInterval,
    );
  }

  static WaitStrategy forHttp({
    required int port,
    String path = '/',
    int statusCode = 200,
    Duration timeout = const Duration(seconds: 60),
    Duration pollInterval = const Duration(milliseconds: 100),
  }) {
    Port.tcp(port).validate();

    if (!path.startsWith('/') ||
        path.startsWith('//') ||
        statusCode < 100 ||
        statusCode > 599) {
      throw ArgumentError(
        'An absolute HTTP path on the container and valid status code are required',
      );
    }

    return _PollingWaitStrategy(
      'HTTP $path returning $statusCode',
      (container, _, remaining) async {
        final client = HttpClient()..connectionTimeout = remaining;
        client.findProxy = (_) => 'DIRECT';
        try {
          final url = Uri(
            scheme: 'http',
            host: container.host,
            port: await container.mappedPort(port),
          ).resolve(path);
          final request = await client.getUrl(url);
          request.followRedirects = false;
          final response = await request.close().timeout(remaining);
          return response.statusCode == statusCode;
        } finally {
          client.close(force: true);
        }
      },
      timeout,
      pollInterval,
    );
  }

  static WaitStrategy forHealthcheck({
    Duration timeout = const Duration(seconds: 60),
    Duration pollInterval = const Duration(milliseconds: 100),
  }) => _PollingWaitStrategy(
    'Docker healthcheck',
    (_, info, _) async {
      final status = info['State']?['Health']?['Status'];
      if (status == null) {
        throw StateError('Container does not define a Docker healthcheck');
      }
      return status == 'healthy';
    },
    timeout,
    pollInterval,
  );

  static WaitStrategy forSuccessfulCommand(
    List<String> command, {
    Duration timeout = const Duration(seconds: 60),
    Duration pollInterval = const Duration(milliseconds: 100),
  }) {
    if (command.isEmpty || command.any((arg) => arg.contains('\u0000'))) {
      throw ArgumentError('A command argument array without NUL is required');
    }
    final args = List<String>.unmodifiable(command);
    return _PollingWaitStrategy(
      'successful exec',
      (container, _, _) async => (await container.exec(args)).exitCode == 0,
      timeout,
      pollInterval,
    );
  }

  /// Runs strategies sequentially, each with its own timeout.
  static WaitStrategy forAll(List<WaitStrategy> strategies) =>
      _AllWaitStrategy(List.unmodifiable(strategies));
}

class _PollingWaitStrategy implements WaitStrategy {
  _PollingWaitStrategy(
    this.description,
    this.check,
    this.timeout,
    this.interval,
  ) {
    if (timeout <= Duration.zero || interval <= Duration.zero) {
      throw ArgumentError('Timeout and poll interval must be positive');
    }
  }

  final String description;
  final Future<bool> Function(StartedContainer, Map<String, dynamic>, Duration)
  check;
  final Duration timeout;
  final Duration interval;

  @override
  Future<void> waitUntilReady(StartedContainer container) async {
    final clock = Stopwatch()..start();
    Object? lastError;

    while (clock.elapsed < timeout) {
      try {
        final info = await container.inspect().timeout(timeout - clock.elapsed);
        final state = info['State'];

        if (state is! Map<String, dynamic> || state['Running'] is! bool) {
          throw const FormatException(
            'Docker inspect response is missing State.Running',
          );
        }

        if (state['Running'] == false) {
          throw ContainerExitedException(
            container.id,
            state['ExitCode'] as int?,
          );
        }

        final remaining = timeout - clock.elapsed;
        if (remaining <= Duration.zero) break;
        if (await check(container, info, remaining).timeout(remaining)) return;
      } on SocketException catch (error) {
        lastError = error;
      } on HttpException catch (error) {
        lastError = error;
      } on TimeoutException catch (error) {
        lastError = error;
      }

      final remaining = timeout - clock.elapsed;
      if (remaining <= Duration.zero) break;
      await Future<void>.delayed(interval < remaining ? interval : remaining);
    }

    throw WaitTimeoutException(description, timeout, lastError);
  }
}

class _AllWaitStrategy implements WaitStrategy {
  const _AllWaitStrategy(this.strategies);
  final List<WaitStrategy> strategies;

  @override
  Future<void> waitUntilReady(StartedContainer container) async {
    for (final strategy in strategies) {
      await strategy.waitUntilReady(container);
    }
  }
}
