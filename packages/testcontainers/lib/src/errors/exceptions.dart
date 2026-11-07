import 'dart:async';

class WaitTimeoutException extends TimeoutException {
  WaitTimeoutException(String strategy, Duration timeout, this.lastError)
    : super(
        'Timed out waiting for $strategy${lastError == null ? '' : ': $lastError'}',
        timeout,
      );

  final Object? lastError;
}

class ContainerExitedException implements Exception {
  const ContainerExitedException(this.id, this.exitCode);

  final String id;
  final int? exitCode;

  @override
  String toString() =>
      'Container $id exited before becoming ready (exit code: $exitCode)';
}

class ContainerStartException implements Exception {
  const ContainerStartException(
    this.cause, {
    required this.containerId,
    this.logs = '',
    this.cleanupError,
  });

  final Object cause;
  final String containerId;
  final String logs;
  final Object? cleanupError;

  @override
  String toString() =>
      'ContainerStartException ($containerId): $cause'
      '${logs.isEmpty ? '' : '\nContainer logs:\n$logs'}'
      '${cleanupError == null ? '' : '\nCleanup failed: $cleanupError'}';
}
