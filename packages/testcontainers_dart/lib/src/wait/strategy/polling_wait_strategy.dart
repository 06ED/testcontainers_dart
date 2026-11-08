import 'dart:async';
import 'dart:io';

import '../../container/started_container.dart';
import '../../errors/exceptions.dart';
import '../wait_strategy.dart';

class PollingWait(
  final String description,
  final Future<bool> Function(StartedContainer, Map<String, dynamic>, Duration)
  check,
  final Duration timeout,
  final Duration interval,
) implements Wait {
  this {
    if (timeout <= Duration.zero || interval <= Duration.zero) {
      throw ArgumentError('Timeout and poll interval must be positive');
    }
  }

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
      await Future.pause(interval < remaining ? interval : remaining);
    }

    throw WaitTimeoutException(description, timeout, lastError);
  }
}
