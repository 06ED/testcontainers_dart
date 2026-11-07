import '../wait_strategy.dart';
import 'polling_wait_strategy.dart';

Wait createHealthcheckWaitStrategy({
  required Duration timeout,
  required Duration pollInterval,
}) => PollingWait(
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
