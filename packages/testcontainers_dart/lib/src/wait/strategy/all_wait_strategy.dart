import '../../container/started_container.dart';
import '../wait_strategy.dart';

class const AllWaitStrategy(final List<Wait> strategies) implements Wait {
  @override
  Future<void> waitUntilReady(StartedContainer container) async {
    for (final strategy in strategies) {
      await strategy.waitUntilReady(container);
    }
  }
}
