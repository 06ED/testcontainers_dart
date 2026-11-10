import 'dart:async';

class FileCopyException(final String message, {final int? statusCode})
    implements Exception {
  @override
  String toString() =>
      'FileCopyException${statusCode == null ? '' : ' ($statusCode)'}: $message';
}

class NetworkCreateException(final Object cause, final Object cleanupError)
    implements Exception {
  @override
  String toString() =>
      'Network creation failed: $cause; cleanup failed: $cleanupError';
}

class WaitTimeoutException(
  String strategy,
  Duration timeout,
  final Object? lastError,
) extends TimeoutException {
  this
    : super(
        'Timed out waiting for $strategy${lastError == null ? '' : ': $lastError'}',
        timeout,
      );
}

class const ContainerExitedException(final String id, final int? exitCode)
    implements Exception {
  @override
  String toString() =>
      'Container $id exited before becoming ready (exit code: $exitCode)';
}

class const ContainerStartException(
  final Object cause, {
  required final String containerId,
  final String logs = '',
  final Object? cleanupError,
}) implements Exception {
  @override
  String toString() =>
      'ContainerStartException ($containerId): $cause'
      '${logs.isEmpty ? '' : '\nContainer logs:\n$logs'}'
      '${cleanupError == null ? '' : '\nCleanup failed: $cleanupError'}';
}
