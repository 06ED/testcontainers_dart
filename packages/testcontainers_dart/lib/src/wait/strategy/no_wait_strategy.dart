import '../../container/started_container.dart';
import '../wait_strategy.dart';

class const NoWaitStrategy() implements Wait {
  @override
  Future<void> waitUntilReady(StartedContainer container) async {}
}
