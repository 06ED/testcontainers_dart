import 'dart:io';

import '../../container/container_config.dart';
import '../wait_strategy.dart';
import 'polling_wait_strategy.dart';

Wait createListeningPortWaitStrategy({
  required int port,
  required Duration timeout,
  required Duration pollInterval,
}) {
  Port.tcp(port).validate();

  return PollingWait(
    'TCP port $port',
    (container, _, remaining) async {
      final socket = await Socket.connect(
        container.host,
        await container.mappedPort(port),
        timeout: remaining,
      );
      socket.destroy();
      return true;
    },
    timeout,
    pollInterval,
  );
}
