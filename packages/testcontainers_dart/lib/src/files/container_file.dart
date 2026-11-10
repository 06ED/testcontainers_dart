import 'dart:io';

import 'package:docker_engine/docker_engine.dart';
import 'package:tar/tar.dart';

import '../errors/exceptions.dart';

/// One regular file copied into a created container before its process starts.
class ContainerFile {
  new fromPath(
    String path,
    this.target, {
    this.mode = 0x1a4,
    this.uid = 0,
    this.gid = 0,
  }) : _path = path,
       _bytes = null;

  new fromBytes(
    List<int> bytes,
    this.target, {
    this.mode = 0x1a4,
    this.uid = 0,
    this.gid = 0,
  }) : _bytes = List.unmodifiableOf(bytes),
       _path = null;

  final String? _path;
  final List<int>? _bytes;
  final String target;
  final int mode;
  final int uid;
  final int gid;

  void validate() {
    validateContainerFilePath(target);
    if (mode < 0 ||
        mode > 0x1ff ||
        uid < 0 ||
        gid < 0 ||
        uid > 0xffffffff ||
        gid > 0xffffffff) {
      throw ArgumentError('Invalid file permissions or owner');
    }

    if (_path != null && (_path.isEmpty || _path.contains('\u0000'))) {
      throw ArgumentError('A local source path without NUL is required');
    }

    if (_bytes?.any((byte) => byte < 0 || byte > 255) ?? false) {
      throw ArgumentError('File bytes must be in the range 0–255');
    }
  }

  Future<void> copyTo(Docker api, String containerId) async {
    validate();

    try {
      final name = target.substring(target.lastIndexOf('/') + 1);
      final directory = target.substring(0, target.lastIndexOf('/') + 1);
      final path = _path;
      final bytes = _bytes;
      final TarEntry entry;

      if (path != null) {
        if (await FileSystemEntity.type(path, followLinks: false) !=
            FileSystemEntityType.file) {
          throw const FileSystemException('Source must be a regular file');
        }

        final file = File(path);
        final length = await file.length();
        entry = TarEntry(
          TarHeader(
            name: name,
            mode: mode,
            userId: uid,
            groupId: gid,
            size: length,
          ),
          file.openRead(0, length),
        );
      } else {
        entry = TarEntry.data(
          TarHeader(name: name, mode: mode, userId: uid, groupId: gid),
          bytes!,
        );
      }

      await api.putArchive(
        id: containerId,
        path: directory,
        archive: Stream<TarEntry>.value(entry).transform(tarWriter),
      );
    } catch (error) {
      throw FileCopyException(
        'Copy to container failed',
        statusCode: error is DockerException ? error.statusCode : null,
      );
    }
  }
}

void validateContainerFilePath(String path) {
  if (!path.startsWith('/') ||
      path.contains('\u0000') ||
      path.contains('\\') ||
      path
          .split('/')
          .skip(1)
          .any((part) => part.isEmpty || part == '.' || part == '..')) {
    throw ArgumentError(
      'An absolute POSIX file path without empty, dot or parent segments is required',
    );
  }
}
