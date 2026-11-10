import 'dart:convert';
import 'dart:io';

import 'package:docker_engine/docker_engine.dart' show DockerConnection;
import 'package:test/test.dart';
import 'package:testcontainers_dart/testcontainers_dart.dart';

void main() {
  test(
    'real Docker: DNS aliases without published ports and file round trips',
    () async {
      final directory = await Directory.systemTemp.createTemp('network-files-');
      addTearDown(() => directory.delete(recursive: true));
      final source = File('${directory.path}/source');
      final bytes = List.generate(5 * 1024 * 1024, (i) => i % 256);
      await source.writeAsBytes(bytes);
      final provider = await DockerProvider.connect();
      addTearDown(provider.close);
      final network = await provider.createNetwork();
      addTearDown(network.terminate);
      final server = await provider.start(
        ContainerConfig(
          image: 'busybox:1.37',
          network: network,
          networkAliases: const ['database'],
          files: [
            ContainerFile.fromBytes(
              utf8.encode('copied before startup'),
              '/tmp/index.html',
            ),
            ContainerFile.fromPath(
              source.path,
              '/tmp/сертификат',
              mode: 0x180,
              uid: 123,
              gid: 456,
            ),
          ],
          command: const [
            'sh',
            '-c',
            'test -s /tmp/index.html && exec httpd -f -p 8080 -h /tmp',
          ],
          waitStrategy: .forSuccessfulCommand([
            'sh',
            '-c',
            r'test "$(stat -c %a /tmp/сертификат)" = 600 && test "$(stat -c %u:%g /tmp/сертификат)" = 123:456',
          ]),
        ),
      );
      addTearDown(server.terminate);
      final client = await provider.start(
        ContainerConfig(
          image: 'busybox:1.37',
          network: network,
          command: const ['sleep', '300'],
          waitStrategy: .forSuccessfulCommand([
            'wget',
            '-q',
            '-O',
            '/tmp/result',
            'http://database:8080/index.html',
          ]),
        ),
      );
      addTearDown(client.terminate);
      expect(
        (await server.inspect())['HostConfig']['PortBindings'],
        anyOf(isNull, isEmpty),
      );
      expect(
        (await client.inspect())['HostConfig']['PortBindings'],
        anyOf(isNull, isEmpty),
      );
      await expectLater(network.terminate(), throwsA(isA<DockerException>()));
      await client.stop();
      final output = File('${directory.path}/result');
      await client.copyFileFromContainer('/tmp/result', output.path);
      expect(await output.readAsString(), 'copied before startup');
      await server.stop();
      await server.copyFileFromContainer('/tmp/сертификат', output.path);
      expect(await output.readAsBytes(), bytes);
      await client.terminate();
      await server.terminate();
      await network.terminate();
      await network.terminate();
      final connection = await DockerConnection.connect(
        DockerConfig.fromEnvironment(),
      );
      addTearDown(connection.close);
      expect(
        (await connection.api.networksIdGet(id: network.id)).statusCode,
        404,
      );
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );
}
