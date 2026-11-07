class DockerException implements Exception {
  const DockerException(this.message, {required this.statusCode});

  final String message;
  final int statusCode;

  @override
  String toString() => 'DockerException ($statusCode): $message';
}
