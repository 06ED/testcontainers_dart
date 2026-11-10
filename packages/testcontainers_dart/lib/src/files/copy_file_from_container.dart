import 'dart:io';

import 'package:docker_engine/docker_engine.dart' hide Platform;
import 'package:tar/tar.dart';

import '../errors/exceptions.dart';
import 'container_file.dart';

Future<void> copyFileFromContainer(
  Docker api,
  String id,
  String path,
  String destination,
) async {
  validateContainerFilePath(path);

  if (destination.isEmpty || destination.contains('\u0000')) {
    throw ArgumentError('A local destination path without NUL is required');
  }

  try {
    final target = File(destination).absolute;
    final reader = TarReader(
      _checkedArchive(api.getArchive(id: id, path: path)),
      disallowTrailingData: true,
    );

    await target.parent.create(recursive: true);
    final temporary = await target.parent.createTemp('.testcontainers-');
    final file = File('${temporary.path}/file');
    RandomAccessFile? output;

    try {
      if (!await reader.moveNext() || reader.current.type != .reg) {
        throw const FormatException('Expected one regular file');
      }

      output = await file.open(mode: FileMode.write);
      // A downloaded certificate/key must not become world-readable on rename.
      if (!Platform.isWindows) {
        final permissions = await Process.run('/bin/chmod', ['600', file.path]);
        if (permissions.exitCode != 0) {
          throw const FileSystemException(
            'Cannot restrict downloaded file permissions',
          );
        }
      }

      await for (final bytes in reader.current.contents) {
        await output.writeFrom(bytes);
      }

      await output.flush();
      await output.close();
      output = null;
      if (await reader.moveNext()) {
        throw const FormatException('Expected only one file');
      }

      // The caller chooses the destination; never extract names from an untrusted TAR.
      await file.rename(target.path);
    } finally {
      await reader.cancel();
      await output?.close();
      await temporary.delete(recursive: true);
    }
  } catch (error) {
    throw FileCopyException(
      'Copy from container failed',
      statusCode: error is DockerException ? error.statusCode : null,
    );
  }
}

Stream<List<int>> _checkedArchive(Stream<List<int>> source) async* {
  var length = 0;
  var trailingZeroes = 0;

  await for (final chunk in source) {
    length += chunk.length;
    var zeroes = 0;

    for (var i = chunk.length - 1; i >= 0 && chunk[i] == 0; i--) {
      zeroes++;
    }

    trailingZeroes = zeroes == chunk.length ? trailingZeroes + zeroes : zeroes;
    yield chunk;
  }

  // TarReader accepts EOF without a trailer; require a complete Docker TAR here.
  if (length % 512 != 0 || trailingZeroes < 1024) {
    throw const FormatException('Incomplete archive trailer');
  }
}
