import '../../container/started_container.dart';
import '../wait_strategy.dart';

class NoWaitStrategy implements Wait {
  const NoWaitStrategy();

  @override
  Future<void> waitUntilReady(StartedContainer container) async {}
}
