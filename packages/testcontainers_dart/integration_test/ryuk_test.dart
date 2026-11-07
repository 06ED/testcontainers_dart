import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:docker_engine/docker_engine.dart' show DockerConnection;
import 'package:test/test.dart';
import 'package:testcontainers_dart/testcontainers_dart.dart';

void main() {
  group(
    'real Ryuk',
    () {
      late DockerConnection connection;

      setUp(() async {
        connection = await DockerConnection.connect(
          DockerConfig.fromEnvironment(),
        );
      });
      tearDown(() => connection.close());

      Future<bool> exists(String id) async {
        final response = await connection.api.containersIdJsonGet(id: id);
        if (response.statusCode == 404) return false;
        if (!response.isSuccessful) {
          throw StateError('Docker inspect failed: ${response.statusCode}');
        }
        return true;
      }

      Future<void> removed(List<String> ids) async {
        final deadline = DateTime.now().add(const Duration(seconds: 60));
        while (DateTime.now().isBefore(deadline)) {
          if (!(await Future.wait(ids.map(exists))).any((value) => value)) {
            return;
          }
          await Future<void>.delayed(const Duration(milliseconds: 200));
        }
        fail('Ryuk did not remove $ids');
      }

      Future<
        ({Process process, Map<String, dynamic> resource, StringBuffer errors})
      >
      launch(String mode) async {
        final library = await Isolate.resolvePackageUri(
          Uri.parse('package:testcontainers_dart/testcontainers_dart.dart'),
        );
        final script = library!.resolve(
          '../integration_test/utils/ryuk_process.dart',
        );
        final process = await Process.start(Platform.resolvedExecutable, [
          script.toFilePath(),
          mode,
        ]);
        final errors = StringBuffer();
        process.stderr.transform(utf8.decoder).listen(errors.write);
        final output = StreamIterator(
          process.stdout
              .transform(utf8.decoder)
              .transform(const LineSplitter()),
        );
        addTearDown(() async {
          process.kill(ProcessSignal.sigkill);
          await process.exitCode;
          await output.cancel();
        });
        final hasOutput = await output.moveNext().timeout(
          const Duration(minutes: 3),
        );
        expect(hasOutput, true, reason: errors.toString());
        final resource = jsonDecode(output.current) as Map<String, dynamic>;
        addTearDown(() async {
          // Only delete resources created by this test if the assertion fails.
          for (final key in ['id', 'ryuk']) {
            await connection.api.containersIdDelete(
              id: resource[key] as String,
              force: true,
              v: true,
            );
          }
        });
        return (process: process, resource: resource, errors: errors);
      }

      test(
        'SIGKILL cleans its session but leaves a different live session untouched',
        () async {
          final victim = await launch('crash');
          final survivor = await launch('crash');
          expect(
            victim.resource['session'],
            isNot(survivor.resource['session']),
          );
          expect(await exists(victim.resource['id']), true);
          expect(await exists(survivor.resource['id']), true);
          victim.process.kill(ProcessSignal.sigkill);
          await victim.process.exitCode;
          await removed([victim.resource['id'], victim.resource['ryuk']]);
          expect(await exists(survivor.resource['id']), true);
          expect(await exists(survivor.resource['ryuk']), true);
          survivor.process.kill(ProcessSignal.sigkill);
          await survivor.process.exitCode;
          await removed([survivor.resource['id'], survivor.resource['ryuk']]);
        },
      );

      for (final mode in ['close', 'terminate', 'startup-failure']) {
        test(
          '$mode exits without a dangling socket and removes resources',
          () async {
            final child = await launch(mode);
            expect(
              await child.process.exitCode.timeout(const Duration(seconds: 15)),
              0,
              reason: child.errors.toString(),
            );
            await removed([child.resource['id'], child.resource['ryuk']]);
          },
        );
      }
    },
    skip: Platform.isWindows
        ? 'Ryuk process tests require POSIX signals'
        : false,
    timeout: const Timeout(Duration(minutes: 5)),
  );
}
