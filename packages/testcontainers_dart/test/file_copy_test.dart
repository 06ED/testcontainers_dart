import 'dart:convert';
import 'dart:io';

import 'package:tar/tar.dart';
import 'package:test/test.dart';
import 'package:testcontainers_dart/testcontainers_dart.dart';

import 'utils/docker_server.dart';

void main() {
  late DockerServer server;
  late DockerProvider provider;
  late Directory directory;
  setUp(() async {
    directory = await Directory.systemTemp.createTemp('container-files-');
    server = await DockerServer.start();
    provider = await DockerProvider.connect(
      config: DockerConfig(endpoint: server.endpoint),
      ryuk: const RyukConfig(enabled: false),
    );
  });
  tearDown(() async {
    provider.close();
    await server.close();
    await directory.delete(recursive: true);
  });

  Future<StartedContainer> start([List<ContainerFile> files = const []]) =>
      provider.start(ContainerConfig(image: 'busybox', files: files));

  test(
    'binary, empty and local files are uploaded before start with permissions',
    () async {
      final file = File('${directory.path}/source');
      await file.writeAsBytes([0, 255, 128]);
      final names = <String>[];
      final data = <List<int>>[];
      server.handler = (request) async {
        if (request.method != 'PUT') return false;
        expect(request.uri.queryParameters['path'], '/tmp/');
        final reader = TarReader(Stream.value(server.rawBodies.last));
        expect(await reader.moveNext(), true);
        names.add(reader.current.name);
        data.add(
          await reader.current.contents.expand((bytes) => bytes).toList(),
        );
        expect(reader.current.header.mode, 0x180);
        expect(reader.current.header.userId, 123);
        expect(reader.current.header.groupId, 456);
        expect(await reader.moveNext(), false);
        await DockerServer.respond(request, '', status: 200);
        return true;
      };
      await start([
        ContainerFile.fromPath(
          file.path,
          '/tmp/сертификат',
          mode: 0x180,
          uid: 123,
          gid: 456,
        ),
        ContainerFile.fromBytes(
          [],
          '/tmp/empty',
          mode: 0x180,
          uid: 123,
          gid: 456,
        ),
      ]);
      expect(names, ['сертификат', 'empty']);
      expect(data, [
        [0, 255, 128],
        [],
      ]);
      final startIndex = server.paths.indexWhere(
        (path) => path.endsWith('/start'),
      );
      expect(
        server.paths.where((path) => path.endsWith('/archive')),
        hasLength(2),
      );
      expect(
        server.paths
            .sublist(startIndex + 1)
            .where((path) => path.endsWith('/archive')),
        isEmpty,
      );
    },
  );

  test('missing source and Docker upload errors remove container without starting it', () async {
    await expectLater(
      start([ContainerFile.fromPath('${directory.path}/missing', '/tmp/file')]),
      throwsA(isA<ContainerStartException>()),
    );
    expect(server.paths.where((path) => path.endsWith('/start')), isEmpty);
    expect(server.paths.last, '/v1.55/containers/container-1');
    server.handler = (request) async {
      if (request.method != 'PUT') return false;
      await DockerServer.respond(request, {
        'message': 'secret-file-content',
      }, status: 500);
      return true;
    };
    await expectLater(
      start([
        ContainerFile.fromBytes(
          utf8.encode('secret-file-content'),
          '/tmp/file',
        ),
      ]),
      throwsA(
        isA<ContainerStartException>().having(
          (e) => e.toString(),
          'safe diagnostics',
          isNot(contains('secret-file-content')),
        ),
      ),
    );
  });

  test(
    'unsafe targets, modes and owners fail before creating a container',
    () async {
      final count = server.paths.length;
      for (final target in [
        'relative',
        '/',
        '/tmp/../file',
        '/tmp/./file',
        '/tmp/file\u0000',
      ]) {
        await expectLater(
          start([
            ContainerFile.fromBytes([1], target),
          ]),
          throwsArgumentError,
        );
      }
      await expectLater(
        start([
          ContainerFile.fromBytes([1], '/tmp/file', mode: 0x800),
        ]),
        throwsArgumentError,
      );
      expect(server.paths.length, count);
    },
  );

  test('downloads one file atomically to the requested destination, not archive name', () async {
    final container = await start();
    final output = File('${directory.path}/output');
    await output.writeAsString('old');
    final archive = await Stream<TarEntry>.value(
      TarEntry.data(TarHeader(name: '../../escape', mode: 0x1a4), [
        0,
        255,
        128,
      ]),
    ).transform(tarWriter).expand((bytes) => bytes).toList();
    server.handler = (request) async {
      await DockerServer.respond(
        request,
        archive,
        contentType: 'application/x-tar',
      );
      return true;
    };
    await container.copyFileFromContainer('/tmp/file', output.path);
    expect(await output.readAsBytes(), [0, 255, 128]);
    if (!Platform.isWindows) expect((await output.stat()).mode & 0x1ff, 0x180);
    expect((await directory.list().toList()).map((file) => file.path), [
      output.path,
    ]);
  });

  test('local directories and symlinks are not followed on upload', () async {
    await expectLater(
      start([ContainerFile.fromPath(directory.path, '/tmp/file')]),
      throwsA(isA<ContainerStartException>()),
    );
    if (!Platform.isWindows) {
      final source = File('${directory.path}/source');
      await source.writeAsString('secret');
      final link = Link('${directory.path}/link');
      await link.create(source.path);
      await expectLater(
        start([ContainerFile.fromPath(link.path, '/tmp/file')]),
        throwsA(isA<ContainerStartException>()),
      );
    }
    expect(server.paths.where((path) => path.endsWith('/start')), isEmpty);
  });

  test('download failure cancels the response and preserves the destination directory', () async {
    final container = await start();
    final destination = Directory('${directory.path}/output');
    await destination.create();
    final archive = await Stream<TarEntry>.value(
      TarEntry.data(TarHeader(name: 'file', mode: 0x1a4), [1]),
    ).transform(tarWriter).expand((bytes) => bytes).toList();
    server.handler = (request) async {
      await DockerServer.respond(
        request,
        archive,
        contentType: 'application/x-tar',
      );
      return true;
    };
    await expectLater(
      container.copyFileFromContainer('/tmp/file', destination.path),
      throwsA(isA<FileCopyException>()),
    );
    expect(await destination.exists(), true);
    expect(await directory.list().length, 1);
  });

  test('download HTTP failures expose status without body and clean temporary files', () async {
    final container = await start();
    final output = File('${directory.path}/output');
    await output.writeAsString('old');
    server.handler = (request) async {
      await DockerServer.respond(request, {'message': 'secret'}, status: 404);
      return true;
    };
    await expectLater(
      container.copyFileFromContainer('/tmp/missing', output.path),
      throwsA(
        isA<FileCopyException>()
            .having((e) => e.statusCode, 'status', 404)
            .having(
              (e) => e.toString(),
              'safe error',
              isNot(contains('secret')),
            ),
      ),
    );
    expect(await output.readAsString(), 'old');
    expect(await directory.list().length, 1);
    await expectLater(
      container.copyFileFromContainer('/tmp/file', ''),
      throwsArgumentError,
    );
  });

  for (final kind in [
    'symlink',
    'hardlink',
    'directory',
    'multiple',
    'corrupt',
    'truncated',
    'no-trailer',
  ]) {
    test('rejects $kind archives without changing an existing file', () async {
      final container = await start();
      final output = File('${directory.path}/output');
      await output.writeAsString('old');
      final entries = [
        TarEntry.data(
          TarHeader(
            name: 'file',
            mode: 0x1a4,
            typeFlag: switch (kind) {
              'symlink' => TypeFlag.symlink,
              'hardlink' => TypeFlag.link,
              'directory' => TypeFlag.dir,
              _ => TypeFlag.reg,
            },
            linkName: kind == 'symlink' || kind == 'hardlink'
                ? '/secret'
                : null,
          ),
          utf8.encode('secret-file-content'),
        ),
      ];
      if (kind == 'multiple') {
        entries.add(TarEntry.data(TarHeader(name: 'second', mode: 0x1a4), []));
      }
      var archive = await Stream<TarEntry>.fromIterable(entries)
          .transform(tarWriter)
          .expand((bytes) => bytes)
          .toList();
      if (kind == 'corrupt') archive[0] ^= 1;
      if (kind == 'truncated') archive = archive.sublist(0, 520);
      if (kind == 'no-trailer') archive = archive.sublist(0, 1024);
      server.handler = (request) async {
        await DockerServer.respond(
          request,
          archive,
          contentType: 'application/x-tar',
        );
        return true;
      };
      await expectLater(
        container.copyFileFromContainer('/tmp/file', output.path),
        throwsA(
          isA<FileCopyException>().having(
            (e) => e.toString(),
            'safe diagnostics',
            isNot(contains('secret-file-content')),
          ),
        ),
      );
      expect(await output.readAsString(), 'old');
      expect(await directory.list().length, 1);
    });
  }
}
