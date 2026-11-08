import '../container/started_container.dart';
import 'strategy/all_wait_strategy.dart';
import 'strategy/healthcheck_wait_strategy.dart';
import 'strategy/http_wait_strategy.dart';
import 'strategy/listening_port_wait_strategy.dart';
import 'strategy/log_wait_strategy.dart';
import 'strategy/no_wait_strategy.dart';
import 'strategy/successful_command_wait_strategy.dart';

abstract interface class Wait {
  const factory forNothing() = NoWaitStrategy;

  factory forLogMessage(
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

  factory forListeningPort({
    required int port,
    Duration timeout = const Duration(seconds: 60),
    Duration pollInterval = const Duration(milliseconds: 100),
  }) => createListeningPortWaitStrategy(
    port: port,
    timeout: timeout,
    pollInterval: pollInterval,
  );

  factory forHttp({
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

  factory forHealthcheck({
    Duration timeout = const Duration(seconds: 60),
    Duration pollInterval = const Duration(milliseconds: 100),
  }) => createHealthcheckWaitStrategy(
    timeout: timeout,
    pollInterval: pollInterval,
  );

  factory forSuccessfulCommand(
    List<String> command, {
    Duration timeout = const Duration(seconds: 60),
    Duration pollInterval = const Duration(milliseconds: 100),
  }) => createSuccessfulCommandWaitStrategy(
    command,
    timeout: timeout,
    pollInterval: pollInterval,
  );

  /// Runs strategies sequentially, each with its own timeout.
  factory forAll(List<Wait> strategies) =>
      AllWaitStrategy(List.unmodifiableOf(strategies));

  Future<void> waitUntilReady(StartedContainer container);
}
