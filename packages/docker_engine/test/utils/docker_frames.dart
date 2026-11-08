List<int> frame(int stream, List<int> bytes) => [
  stream,
  0,
  0,
  0,
  (bytes.length >> 24) & 255,
  (bytes.length >> 16) & 255,
  (bytes.length >> 8) & 255,
  bytes.length & 255,
  ...bytes,
];
