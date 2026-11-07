import '../wait_strategy.dart';
import 'polling_wait_strategy.dart';

Wait createSuccessfulCommandWaitStrategy(
  List<String> command, {
  required Duration timeout,
  required Duration pollInterval,
}) {
  if (command.isEmpty || command.any((arg) => arg.contains('\u0000'))) {
    throw ArgumentError('A command argument array without NUL is required');
  }
  final args = List<String>.unmodifiable(command);
  return PollingWait(
    'successful exec',
    (container, _, _) async => (await container.exec(args)).exitCode == 0,
    timeout,
    pollInterval,
  );
}
