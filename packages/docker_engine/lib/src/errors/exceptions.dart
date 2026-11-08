class const DockerException(
  final String message, {
  required final int statusCode,
}) implements Exception {
  @override
  String toString() => 'DockerException ($statusCode): $message';
}
