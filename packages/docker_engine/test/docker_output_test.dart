import 'dart:async';
import 'dart:convert';

import 'package:docker_engine/docker_engine.dart';
import 'package:test/test.dart';

import 'utils/docker_frames.dart';

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

  test(
    'stream decoder handles every split in headers, payloads and UTF-8',
    () async {
      final bytes = [
        ...frame(1, utf8.encode('я').sublist(0, 1)),
        ...frame(2, utf8.encode('error')),
        ...frame(1, utf8.encode('я').sublist(1)),
      ];
      for (var split = 0; split <= bytes.length; split++) {
        final chunks = await decodeDockerLogStream(
          Stream.fromIterable([bytes.sublist(0, split), bytes.sublist(split)]),
          tty: false,
        ).toList();
        expect(
          chunks
              .where((c) => c.source == DockerLogSource.stdout)
              .map((c) => c.text)
              .join(),
          'я',
        );
        expect(
          chunks
              .where((c) => c.source == DockerLogSource.stderr)
              .map((c) => c.text)
              .join(),
          'error',
        );
      }
    },
  );

  test(
    'TTY decoding does not mistake leading control bytes for frame headers',
    () async {
      final chunks = await decodeDockerLogStream(
        Stream.fromIterable([
          [1, 2],
          ...utf8.encode('я').map((byte) => [byte]),
        ]),
        tty: true,
      ).toList();
      expect(chunks.map((c) => c.text).join(), '\u0001\u0002я');
      expect(chunks.every((c) => c.source == DockerLogSource.stdout), true);
    },
  );

  test(
    'stream decoder rejects truncated frames and flushes incomplete UTF-8',
    () async {
      for (final bytes in [
        [1],
        [1, 0, 0, 0, 0, 0, 0, 2, 65],
        [2, 1, 0, 0, 0, 0, 0, 0],
      ]) {
        await expectLater(
          decodeDockerLogStream(Stream.value(bytes), tty: false).toList(),
          throwsFormatException,
        );
      }
      final chunks = await decodeDockerLogStream(
        Stream.value(frame(2, [0xD1])),
        tty: false,
      ).toList();
      expect(chunks.single.source, DockerLogSource.stderr);
      expect(chunks.single.text, '\uFFFD');
    },
  );

  test(
    'stream decoder forwards pause and cancellation to its source',
    () async {
      final paused = Completer<void>();
      final cancelled = Completer<void>();
      final source = StreamController<List<int>>(
        onPause: () {
          if (!paused.isCompleted) paused.complete();
        },
        onCancel: cancelled.complete,
      );
      addTearDown(source.close);
      final received = Completer<void>();
      final subscription = decodeDockerLogStream(
        source.stream,
        tty: false,
      ).listen((_) => received.complete());
      source.add(frame(1, utf8.encode('hello')));
      await received.future;
      subscription.pause();
      await paused.future.timeout(const Duration(seconds: 2));
      await subscription.cancel();
      await cancelled.future.timeout(const Duration(seconds: 2));
    },
  );
}
