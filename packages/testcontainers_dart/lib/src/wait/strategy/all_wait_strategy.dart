import '../../container/started_container.dart';
import '../wait_strategy.dart';

class AllWaitStrategy implements Wait {
  const AllWaitStrategy(this.strategies);

  final List<Wait> strategies;

  @override
  Future<void> waitUntilReady(StartedContainer container) async {
    for (final strategy in strategies) {
      await strategy.waitUntilReady(container);
    }
  }
}
