import 'dart:async';

import 'package:test/test.dart';
import 'package:testcontainers_dart/testcontainers_dart.dart';

void main() {
  test('real Docker: HTTP readiness, mapped ports, snapshot/live logs, exec, stop and removal', () async {
    final provider = await DockerProvider.connect();
    addTearDown(provider.close);

    final container = await provider.start(
      ContainerConfig(
        image: 'busybox:1.37',
        command: [
          'sh',
          '-c',
          'mkdir -p /www; echo ready >/www/index.html; echo ready; exec httpd -f -p 8080 -h /www',
        ],
        exposedPorts: const [Port.tcp(8080)],
        waitStrategy: .forAll([.forLogMessage('ready'), .forHttp(port: 8080)]),
      ),
    );
    addTearDown(container.terminate);

    expect(await container.mappedPort(8080), inInclusiveRange(1, 65535));
    expect(await container.logs(), contains('ready'));
    final live = StreamIterator(container.logsStream());
    try {
      expect(await live.moveNext().timeout(const Duration(seconds: 5)), true);
      final write = await container.exec([
        'sh',
        '-c',
        'printf "live-out\\n" >/proc/1/fd/1; printf "live-err\\n" >/proc/1/fd/2',
      ]);
      expect(write.exitCode, 0);
      var stdout = '';
      var stderr = '';
      while (!stdout.contains('live-out') || !stderr.contains('live-err')) {
        expect(await live.moveNext().timeout(const Duration(seconds: 5)), true);
        final chunk = live.current;
        if (chunk.source == DockerLogSource.stdout) {
          stdout += chunk.text;
        } else {
          stderr += chunk.text;
        }
      }
    } finally {
      await live.cancel();
    }
    final result = await container.exec([
      'sh',
      '-c',
      'printf out; printf err >&2; exit 7',
    ]);
    expect(result.exitCode, 7);
    expect(result.stdout, 'out');
    expect(result.stderr, 'err');
    await container.stop();
    expect((await container.inspect())['State']['Running'], false);
    await container.terminate();
    await expectLater(
      container.inspect(),
      throwsA(
        isA<DockerException>().having((e) => e.statusCode, 'status', 404),
      ),
    );
  }, timeout: const Timeout(Duration(minutes: 5)));
}
