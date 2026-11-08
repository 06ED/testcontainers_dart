import 'dart:async';
import 'dart:convert';
import 'dart:math';

enum DockerLogSource() {
  stdout,
  stderr,
}

/// A decoded text fragment, not necessarily a complete line.
class const DockerLogChunk({
  required final DockerLogSource source,
  required final String text,
});

Stream<DockerLogChunk> decodeDockerLogStream(
  Stream<List<int>> bytes, {
  required bool tty,
}) => Stream.eventTransformed(bytes, (sink) => _DockerOutputSink(tty, sink));

class _DockerOutputSink(bool tty, final EventSink<DockerLogChunk> sink)
    implements EventSink<List<int>> {
  final _DockerOutputDecoder decoder = _DockerOutputDecoder(tty, sink.add);
  bool _closed = false;

  @override
  void add(List<int> bytes) {
    if (_closed) return;
    try {
      decoder.add(bytes);
    } catch (error, stack) {
      addError(error, stack);
    }
  }

  @override
  void addError(Object error, [StackTrace? stack]) {
    if (_closed) return;
    _closed = true;
    sink.addError(error, stack);
    sink.close();
  }

  @override
  void close() {
    if (_closed) return;
    try {
      decoder.close();
    } catch (error, stack) {
      sink.addError(error, stack);
    }
    _closed = true;
    sink.close();
  }
}

({String stdout, String stderr, String combined}) decodeDockerOutput(
  List<int> bytes,
) {
  final stdout = StringBuffer();
  final stderr = StringBuffer();
  final combined = StringBuffer();
  final decoder = _DockerOutputDecoder(
    bytes.isEmpty || bytes.first != 1 && bytes.first != 2,
    (chunk) {
      (chunk.source == DockerLogSource.stdout ? stdout : stderr).write(
        chunk.text,
      );
      combined.write(chunk.text);
    },
  );
  decoder.add(bytes);
  decoder.close();
  return (stdout: '$stdout', stderr: '$stderr', combined: '$combined');
}

class _DockerOutputDecoder(final bool tty, void Function(DockerLogChunk) emit) {
  this {
    ByteConversionSink sink(DockerLogSource source) =>
        const Utf8Decoder(allowMalformed: true).startChunkedConversion(
          _TextSink((text) {
            if (text.isNotEmpty) {
              emit(DockerLogChunk(source: source, text: text));
            }
          }),
        );
    _stdout = sink(DockerLogSource.stdout);
    _stderr = sink(DockerLogSource.stderr);
  }

  late final ByteConversionSink _stdout;
  late final ByteConversionSink _stderr;
  final _header = <int>[];
  var _remaining = 0;
  var _stream = 1;

  void add(List<int> bytes) {
    if (tty) {
      _stdout.add(bytes);
      return;
    }
    var offset = 0;
    while (offset < bytes.length) {
      if (_remaining == 0) {
        final end = min(bytes.length, offset + 8 - _header.length);
        _header.addAll(bytes.sublist(offset, end));
        offset = end;
        if (_header.length < 8) break;
        _stream = _header[0];
        if ((_stream != 1 && _stream != 2) ||
            _header[1] != 0 ||
            _header[2] != 0 ||
            _header[3] != 0) {
          throw const FormatException('Invalid Docker stream header');
        }
        _remaining =
            (_header[4] << 24) |
            (_header[5] << 16) |
            (_header[6] << 8) |
            _header[7];
        _header.clear();
      } else {
        final end = min(bytes.length, offset + _remaining);
        (_stream == 1 ? _stdout : _stderr).addSlice(bytes, offset, end, false);
        _remaining -= end - offset;
        offset = end;
      }
    }
  }

  void close() {
    if (_header.isNotEmpty) {
      throw const FormatException('Truncated Docker stream header');
    }
    if (_remaining != 0) {
      throw const FormatException('Truncated Docker stream payload');
    }
    _stdout.close();
    _stderr.close();
  }
}

class _TextSink(final void Function(String) write)
    extends StringConversionSinkBase {
  @override
  void addSlice(String chunk, int start, int end, bool isLast) {
    write(chunk.substring(start, end));
    if (isLast) close();
  }

  @override
  void close() {}
}
