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
- Generated `Docker` methods and response models are exported publicly. Prefix
  the import to avoid collisions between Docker model names and SDK types.

The connection negotiates Docker API **1.41–1.53**. HTTPS uses system-trusted server
certificates. Client-certificate environment settings, SSH, named pipes, Docker CLI
contexts and registry authentication are not implemented. Never expose unencrypted
Docker TCP to untrusted networks.

Responses are buffered and requests are bounded by `requestTimeout` (default two
minutes). Pull uses NDJSON and exec/logs use Docker binary streams, so callers
must handle application-level pull errors and decode output explicitly.
This package does not automatically create or clean up containers.

## Development

This package is a member of the repository's Pub workspace. From this directory:

```sh
dart test
dart run build_runner build --delete-conflicting-outputs
```

The generated sources and Engine v1.53 schema are included. Generation uses
Swagger/Chopper; no code generation is needed to consume the package.
