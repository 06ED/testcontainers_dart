# docker_engine

Standalone Docker Engine API client for the Dart VM. No dependency on
Testcontainers, readiness strategies or test lifecycle.

```dart
import 'package:docker_engine/docker_engine.dart' as docker;

Future<void> main() async {
  final connection = await docker.DockerConnection.connect(
    docker.DockerConfig.fromEnvironment(),
  );
  try {
    final response = await connection.api.containersJsonGet(all: true);
    docker.checkResponse(response);
    for (final container in response.body ?? []) {
      print(container.id);
    }
  } finally {
    connection.close();
  }
}
```

## API

- `DockerConnection.connect(config)` owns the transport and exposes the generated
  API as `connection.api`, the service host as `connection.host`, and `close()`.
- `DockerConfig` accepts a Unix socket or HTTP/HTTPS endpoint, optional service
  host override and request timeout. `tcp://` is normalized to HTTP.
- `DockerConfig.fromEnvironment()` reads `DOCKER_HOST` and
  `TESTCONTAINERS_HOST_OVERRIDE`. Without a host it checks the Docker Desktop socket
  at `$HOME/.docker/run/docker.sock`, then uses `/var/run/docker.sock`.
- `checkResponse(response)` raises `DockerException` for HTTP errors;
  `responseText(response)` reads response text without losing the raw response.
- `decodeDockerOutput(bytes)` decodes Docker multiplexed output into
  `stdout`, `stderr` and `combined` strings, preserving UTF-8 across frames.
- `connection.api.logsStream(id: id, tty: tty, tail: 100)` returns a live
  `Stream<DockerLogChunk>` with separate stdout/stderr sources. Set `tty` from
  the container's `Config.Tty`; TTY output is merged and reported as stdout.
  Subscribe to start, cancel to abort only that request, or close the connection
  to abort all its active log requests. `tail: 0` skips historical output.
- `decodeDockerLogStream(bytes, tty: tty)` incrementally decodes raw output,
  including split frame headers and UTF-8 characters. Events are text fragments,
  not necessarily complete lines.
- Generated `Docker` methods and response models are exported publicly. Prefix
  the import to avoid collisions between Docker model names and SDK types.

### Binary archives

Use the handwritten binary methods instead of the generated String-based TAR upload:

```dart
await connection.api.putArchive(
  id: containerId,
  path: '/tmp',
  archive: File('input.tar').openRead(),
);
await connection.api
    .getArchive(id: containerId, path: '/tmp/result')
    .pipe(File('result.tar').openWrite());
```

Import `dart:io` for this example. Both methods stream bytes over the configured
transport and negotiated API version. `putArchive` preserves archive UID/GID and
forbids replacing directories with non-directories. The destination directory
must exist. Download cancellation aborts only that request; connection close
aborts all active archive and log requests. The entire archive transfer is bounded
by `requestTimeout`, including upload, response body and paused time. HTTP errors
retain their status but omit response bodies, which may contain sensitive data.
This layer does not encode, extract or validate the TAR itself.

The connection negotiates Docker API **1.41–1.55**. HTTPS uses system-trusted server
certificates. Client-certificate environment settings, SSH, named pipes, Docker CLI
contexts and registry authentication are not implemented. Never expose unencrypted
Docker TCP to untrusted networks.

Generated API responses are buffered and requests are bounded by `requestTimeout`
(default two minutes). `logsStream` bypasses buffering; its timeout bounds headers
and error responses, not the lifetime or idle time of a successful stream.
Stream errors terminate the subscription without automatic reconnection.
Pull uses NDJSON and generated exec/log methods return Docker binary streams,
so callers must handle application-level pull errors and decode output explicitly.
This package does not automatically create or clean up containers.

## Development

This package is a member of the repository's Pub workspace. From this directory:

```sh
dart test
dart run build_runner build --delete-conflicting-outputs
dart format lib/src/generated
```

The generated sources and Engine v1.55 schema are included. Generation uses
Swagger/Chopper; no code generation is needed to consume the package.
