import '../wait_strategy.dart';
import 'polling_wait_strategy.dart';

Wait createLogWaitStrategy(
  Pattern message, {
  required int times,
  required Duration timeout,
  required Duration pollInterval,
}) {
  if (times < 1 || message is String && message.isEmpty) {
    throw ArgumentError(
      'A non-empty pattern and positive occurrence count are required',
    );
  }

  return PollingWait(
    'log message "$message" ($times times)',
    (container, _, _) async {
      return message.allMatches(await container.logs(tail: null)).length >=
          times;
    },
    timeout,
    pollInterval,
  );
}
