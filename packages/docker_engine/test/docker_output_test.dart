import 'dart:convert';

import 'package:docker_engine/docker_engine.dart';
import 'package:test/test.dart';

void main() {
  test('decodes empty and unframed TTY output', () {
    expect(decodeDockerOutput([]), (stdout: '', stderr: '', combined: ''));
    expect(decodeDockerOutput(utf8.encode('привет')), (
      stdout: 'привет',
      stderr: '',
      combined: 'привет',
    ));
    expect(decodeDockerOutput([255]).stdout, '\uFFFD');
  });

  test('keeps independent UTF-8 decoders and interleaved stream order', () {
    final out = utf8.encode('я');
    final err = utf8.encode('ё');
    final result = decodeDockerOutput([
      ...frame(1, out.sublist(0, 1)),
      ...frame(2, err.sublist(0, 1)),
      ...frame(1, out.sublist(1)),
      ...frame(2, err.sublist(1)),
      ...frame(1, utf8.encode('!')),
    ]);
    expect(result, (stdout: 'я!', stderr: 'ё', combined: 'яё!'));
  });

  test('flushes incomplete UTF-8 at the end of the stream', () {
    expect(decodeDockerOutput(frame(1, [0xD1])), (
      stdout: '\uFFFD',
      stderr: '',
      combined: '\uFFFD',
    ));
  });

  test('rejects truncated and invalid multiplex headers and payloads', () {
    for (final bytes in [
      [1],
      [1, 1, 0, 0, 0, 0, 0, 0],
      [...frame(1, []), ...frame(3, [])],
      [1, 0, 0, 0, 0, 0, 0, 2, 65],
    ]) {
      expect(() => decodeDockerOutput(bytes), throwsFormatException);
    }
  });
}

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
