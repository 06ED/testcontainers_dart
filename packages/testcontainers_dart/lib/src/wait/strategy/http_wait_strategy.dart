import 'dart:io';

import '../../container/container_config.dart';
import '../wait_strategy.dart';
import 'polling_wait_strategy.dart';

Wait createHttpWaitStrategy({
  required int port,
  required String path,
  required int statusCode,
  required Duration timeout,
  required Duration pollInterval,
}) {
  Port.tcp(port).validate();

  if (!path.startsWith('/') ||
      path.startsWith('//') ||
      statusCode < 100 ||
      statusCode > 599) {
    throw ArgumentError(
      'An absolute HTTP path on the container and valid status code are required',
    );
  }

  return PollingWait(
    'HTTP $path returning $statusCode',
    (container, _, remaining) async {
      final client = HttpClient()..connectionTimeout = remaining;
      client.findProxy = (_) => 'DIRECT';
      try {
        final url = Uri(
          scheme: 'http',
          host: container.host,
          port: await container.mappedPort(port),
        ).resolve(path);
        final request = await client.getUrl(url);
        request.followRedirects = false;
        final response = await request.close().timeout(remaining);
        return response.statusCode == statusCode;
      } finally {
        client.close(force: true);
      }
    },
    timeout,
    pollInterval,
  );
}
