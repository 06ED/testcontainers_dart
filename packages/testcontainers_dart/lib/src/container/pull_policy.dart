/// Controls whether starting a container downloads its image from a registry.
enum PullPolicy() {
  /// Use the local image, downloading it only when Docker reports it missing.
  ifNotPresent,

  /// Pull on every startup, even when the image is already available locally.
  always,

  /// Require a local image and fail without pulling when it is missing.
  never,
}
