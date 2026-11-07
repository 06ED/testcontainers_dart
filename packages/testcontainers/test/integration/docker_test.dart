import 'dart:io';

import 'package:test/test.dart';
import 'package:testcontainers/testcontainers.dart';

void main() {
  test(
    'real Docker: HTTP readiness, mapped ports, logs, exec, stop and removal',
    () async {
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
          waitStrategy: Wait.forAll([
            Wait.forLogMessage('ready'),
            Wait.forHttp(port: 8080),
          ]),
        ),
      );
      addTearDown(container.terminate);

      expect(await container.mappedPort(8080), inInclusiveRange(1, 65535));
      expect(await container.logs(), contains('ready'));
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
    },
    skip: Platform.environment['TESTCONTAINERS_INTEGRATION'] == '1'
        ? false
        : 'Set TESTCONTAINERS_INTEGRATION=1 to use a real Docker daemon',
    timeout: const Timeout(Duration(minutes: 5)),
  );
}
