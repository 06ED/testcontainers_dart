import 'dart:convert';

({String stdout, String stderr, String combined}) decodeDockerOutput(
  List<int> bytes,
) {
  if (bytes.isEmpty) return (stdout: '', stderr: '', combined: '');
  if (bytes.first != 1 && bytes.first != 2) {
    final text = utf8.decode(bytes, allowMalformed: true);
    return (stdout: text, stderr: '', combined: text);
  }
  final stdout = StringBuffer();
  final stderr = StringBuffer();
  final combined = StringBuffer();
  final out = const Utf8Decoder(allowMalformed: true).startChunkedConversion(
    _TextSink((text) {
      stdout.write(text);
      combined.write(text);
    }),
  );
  final err = const Utf8Decoder(allowMalformed: true).startChunkedConversion(
    _TextSink((text) {
      stderr.write(text);
      combined.write(text);
    }),
  );
  var offset = 0;
  while (offset < bytes.length) {
    if (bytes.length - offset < 8) {
      throw const FormatException('Truncated Docker stream header');
    }
    final stream = bytes[offset];
    if ((stream != 1 && stream != 2) ||
        bytes[offset + 1] != 0 ||
        bytes[offset + 2] != 0 ||
        bytes[offset + 3] != 0) {
      throw const FormatException('Invalid Docker stream header');
    }
    final length =
        (bytes[offset + 4] << 24) |
        (bytes[offset + 5] << 16) |
        (bytes[offset + 6] << 8) |
        bytes[offset + 7];
    offset += 8;
    if (bytes.length - offset < length) {
      throw const FormatException('Truncated Docker stream payload');
    }
    (stream == 1 ? out : err).add(bytes.sublist(offset, offset + length));
    offset += length;
  }
  out.close();
  err.close();
  return (
    stdout: stdout.toString(),
    stderr: stderr.toString(),
    combined: combined.toString(),
  );
}

class _TextSink extends StringConversionSinkBase {
  _TextSink(this.write);
  final void Function(String) write;
  @override
  void add(String str) => write(str);
  @override
  void addSlice(String chunk, int start, int end, bool isLast) {
    write(chunk.substring(start, end));
    if (isLast) close();
  }

  @override
  void close() {}
}
