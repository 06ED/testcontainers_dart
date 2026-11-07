import '../container/started_container.dart';
import 'strategy/all_wait_strategy.dart';
import 'strategy/healthcheck_wait_strategy.dart';
import 'strategy/http_wait_strategy.dart';
import 'strategy/listening_port_wait_strategy.dart';
import 'strategy/log_wait_strategy.dart';
import 'strategy/no_wait_strategy.dart';
import 'strategy/successful_command_wait_strategy.dart';

abstract interface class Wait {
  const factory Wait.forNothing() = NoWaitStrategy;

  factory Wait.forLogMessage(
    Pattern message, {
    int times = 1,
    Duration timeout = const Duration(seconds: 60),
    Duration pollInterval = const Duration(milliseconds: 100),
  }) => createLogWaitStrategy(
    message,
    times: times,
    timeout: timeout,
    pollInterval: pollInterval,
  );

  factory Wait.forListeningPort({
    required int port,
    Duration timeout = const Duration(seconds: 60),
    Duration pollInterval = const Duration(milliseconds: 100),
  }) => createListeningPortWaitStrategy(
    port: port,
    timeout: timeout,
    pollInterval: pollInterval,
  );

  factory Wait.forHttp({
    required int port,
    String path = '/',
    int statusCode = 200,
    Duration timeout = const Duration(seconds: 60),
    Duration pollInterval = const Duration(milliseconds: 100),
  }) => createHttpWaitStrategy(
    port: port,
    path: path,
    statusCode: statusCode,
    timeout: timeout,
    pollInterval: pollInterval,
  );

  factory Wait.forHealthcheck({
    Duration timeout = const Duration(seconds: 60),
    Duration pollInterval = const Duration(milliseconds: 100),
  }) => createHealthcheckWaitStrategy(
    timeout: timeout,
    pollInterval: pollInterval,
  );

  factory Wait.forSuccessfulCommand(
    List<String> command, {
    Duration timeout = const Duration(seconds: 60),
    Duration pollInterval = const Duration(milliseconds: 100),
  }) => createSuccessfulCommandWaitStrategy(
    command,
    timeout: timeout,
    pollInterval: pollInterval,
  );

  /// Runs strategies sequentially, each with its own timeout.
  factory Wait.forAll(List<Wait> strategies) =>
      AllWaitStrategy(List.unmodifiable(strategies));

  Future<void> waitUntilReady(StartedContainer container);
}
