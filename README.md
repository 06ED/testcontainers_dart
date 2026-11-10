# Testcontainers Dart

[![CI](https://img.shields.io/github/actions/workflow/status/06ED/testcontainers_dart/ci.yml?branch=main&style=flat-square&label=CI)](https://github.com/06ED/testcontainers_dart/actions/workflows/ci.yml)
[![Coverage](https://img.shields.io/codecov/c/github/06ED/testcontainers_dart/main?style=flat-square&label=coverage)](https://codecov.io/gh/06ED/testcontainers_dart)
[![Dart SDK: ^3.13.7](https://img.shields.io/badge/Dart-%5E3.13.7-0175C2?style=flat-square&logo=dart&logoColor=white)](https://dart.dev/get-dart)
[![Docker required](https://img.shields.io/badge/Docker-required-2496ED?style=flat-square&logo=docker&logoColor=white)](https://docs.docker.com/get-started/get-docker/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green?style=flat-square)](https://github.com/06ED/testcontainers_dart/blob/main/LICENCE)
![Made with love](https://img.shields.io/badge/Made_with-%E2%9D%A4-ff4757?style=flat-square)

Run disposable Docker containers in Dart.

## Installation

Requires Dart **3.13.7+** and a running Docker daemon. The Docker CLI is not required.

```sh
dart pub add --dev testcontainers_dart
```

## Quick start

```dart
import 'package:testcontainers_dart/testcontainers_dart.dart';

Future<void> main() async {
  final container = await Testcontainers.run(
    ContainerConfig(
      image: 'redis:7-alpine',
      exposedPorts: const [Port.tcp(6379)],
      waitStrategy: .forSuccessfulCommand(['redis-cli', 'ping']),
    ),
  );

  try {
    final port = await container.mappedPort(6379);
    print('Redis is available on ${container.host}:$port');
  } finally {
    await container.terminate();
  }
}
```

In `package:test`, register cleanup immediately after startup:

```dart
final container = await Testcontainers.run(config);
addTearDown(container.terminate);
```

Images are pulled only when missing from the local Docker daemon by default.
An omitted tag means `latest`; prefer an explicit version for reproducible tests.

## Container configuration

`ContainerConfig` accepts an image, optional name, environment variables, command,
TCP/UDP ports, labels, bind mounts, files, a managed network and a readiness strategy:

```dart
final config = ContainerConfig(
  image: 'redis:7-alpine',
  environment: const {'MODE': 'test'},
  command: const ['redis-server', '--appendonly', 'yes'],
  exposedPorts: const [Port.tcp(6379)],
  labels: const {'project': 'my-app'},
  waitStrategy: .forSuccessfulCommand(['redis-cli', 'ping']),
);
```

Ports are assigned automatically. Use `container.host` and
`await container.mappedPort(port)` rather than hardcoding `localhost` or a host
port. For UDP, use `Port.udp(port)` and `mappedPort(port, protocol: 'udp')`.

Bind mounts use `BindMount(source: '/absolute/path', target: '/container/path')`
and are read-only unless `readOnly: false` is set. Source paths must exist on the
**Docker daemon's host**, not necessarily the machine running your tests.
The `org.testcontainers` label namespace is reserved.

### Image pull policy

`ContainerConfig.pullPolicy` and `RyukConfig.pullPolicy` default to
`PullPolicy.ifNotPresent`:

- `ifNotPresent`: use the local image; pull only when Docker reports it missing.
- `always`: pull on every startup, even when the image is already cached.
- `never`: require a local image; fail without pulling if it is missing.

```dart
final container = await Testcontainers.run(
  const ContainerConfig(image: 'my-local-app:test', pullPolicy: .never),
  ryuk: const RyukConfig(pullPolicy: .never),
);
```

Local images are those on the **Docker daemon's host**, including locally built
images. A cached application image and Ryuk image allow startup without registry
access. `ifNotPresent` does not check for updated tags; use `always` to refresh them.
For `ifNotPresent`, only an image-inspect 404 triggers a pull; permission, daemon
and connection errors are propagated instead of falling back to the registry.

## Networks and container DNS

Use one provider for containers sharing a managed bridge network. Aliases resolve
inside that network; internal service ports do not need host publication:

```dart
final provider = await DockerProvider.connect();
addTearDown(provider.close);
final network = await provider.createNetwork();
addTearDown(network.terminate);

final database = await provider.start(
  ContainerConfig(
    image: 'postgres:17-alpine',
    network: network,
    networkAliases: ['database'],
    environment: {'POSTGRES_PASSWORD': 'test'},
    files: [
      ContainerFile.fromPath(
        'fixtures/init.sql',
        '/docker-entrypoint-initdb.d/001-init.sql',
      ),
    ],
    waitStrategy: .forSuccessfulCommand(['pg_isready', '-U', 'postgres']),
  ),
);
addTearDown(database.terminate);

final client = await provider.start(
  ContainerConfig(
    image: 'postgres:17-alpine',
    network: network,
    command: ['sleep', '300'],
    waitStrategy: .forSuccessfulCommand([
      'pg_isready', '-h', 'database', '-U', 'postgres',
    ]),
  ),
);
addTearDown(client.terminate);
```

Containers and networks share session labels. With Ryuk enabled, provider close
or process death triggers cleanup of both. Remove containers before calling
`network.terminate()` for immediate cleanup; an in-use network is not forcibly
disconnected, and failed removal can be retried. A network cannot be passed to a
different provider or reused after removal. With Ryuk disabled, explicitly remove
containers and networks before closing the provider.

HTTP/TCP waits connect through published host ports. For services without host
bindings, use a healthcheck, log wait or command executed inside a container.

## Copying files

`ContainerConfig.files` uploads regular files after container creation and before
its process starts. A copy failure removes the container without starting it.
Local paths are read on the **Dart client's machine**, including with remote Docker:

```dart
ContainerFile.fromPath('fixtures/init.sql', '/tmp/init.sql');
ContainerFile.fromBytes(certificateBytes, '/tmp/client.crt', mode: 0x180); // 0600
```

Targets must be absolute POSIX file paths; their parent directories must already
exist in the image. Existing regular files may be overwritten, but directories
are not replaced with files. `mode` defaults to `0x1a4` (0644), and `uid`/`gid`
default to 0; use explicit permissions for private keys. Local symlinks and
directories are not accepted as sources.

Retrieve one regular file while a container is running or stopped, before removal:

```dart
await container.copyFileFromContainer('/tmp/report.json', 'artifacts/report.json');
```

Transfers stream TAR data without buffering the complete file. Downloads go to a
temporary file beside the destination and replace it only after validating the
archive and finishing the HTTP response. A failure preserves the existing file;
archive filenames are never used as local extraction paths. Links, directories
and multi-file archives are rejected. Downloaded files use 0600 permissions on
POSIX (requires `/bin/chmod`); on Windows they inherit local filesystem ACLs.
File contents and raw archive errors are omitted from copy diagnostics.
`DockerConfig.requestTimeout` bounds the entire transfer, including paused time.

## Waiting for readiness

```dart
final config = ContainerConfig(
  image: 'nginx:1.28-alpine',
  exposedPorts: const [Port.tcp(80)],
  waitStrategy: .forAll([
    .forLogMessage('Configuration complete'),
    .forHttp(port: 80),
  ]),
);
```

```dart
Wait.forNothing(); // Default: starts the container without checking readiness.
Wait.forListeningPort(port: 8080);
Wait.forLogMessage(RegExp(r'Listening on port \d+'), times: 1);
Wait.forHttp(port: 8080, path: '/health', statusCode: 200);
Wait.forHealthcheck(); // Requires a Docker HEALTHCHECK in the image.
Wait.forSuccessfulCommand(['redis-cli', 'ping']);
Wait.forAll([firstStrategy, secondStrategy]);
```

Polling strategies accept `timeout` (default 60 seconds) and `pollInterval` (default
100 milliseconds). `forAll` runs strategies sequentially, each with its own
timeout. An open TCP port alone does not prove that a service is ready; prefer
an application-level check.

## Working with a container

```dart
final info = await container.inspect();
final logs = await container.logs(tail: 100);
final result = await container.exec(['sh', '-c', 'echo hello; echo error >&2']);
print(result.stdout);
print(result.stderr);
print(result.exitCode);
```

- `exec()` takes an argument array. Nonzero exit codes are returned, not thrown.
- `stop(timeout: ...)` stops the container but leaves it in Docker.
- `terminate()` force-removes the container and its anonymous volumes. It does
  not remove named volumes or bind-mounted files. Repeated calls are safe;
  a failed removal can be retried.
- If startup or readiness fails after creation, cleanup is attempted.
  `ContainerStartException` includes the cause, container ID, recent logs and
  any cleanup failure.

### Live logs

`logs()` returns a snapshot of the last 1000 lines by default; use
`logs(tail: null)` for all available history. Use `logsStream()` to receive output while the
container is running:

```dart
import 'dart:io';

final subscription = container.logsStream(tail: 100).listen(
  (chunk) {
    final output = chunk.source == DockerLogSource.stdout ? stdout : stderr;
    output.write(chunk.text);
  },
  onError: (Object error) => stderr.writeln(error),
);

try {
  // Run your tests.
} finally {
  await subscription.cancel();
}
```

- The request starts on subscription. `tail: 100` replays the last 100 lines
  before following new output; `tail: 0` receives only new output.
- Each `DockerLogChunk` contains a `source` and a `text` fragment, not necessarily
  a complete line. UTF-8 characters are decoded across incoming chunks.
- TTY containers combine stdout and stderr; their chunks use `DockerLogSource.stdout`.
- Cancelling a subscription closes only that log request. Pausing it pauses
  reading; silence does not trigger a timeout. The connection/header wait is
  bounded by `DockerConfig.requestTimeout`.
- Docker/network errors end the stream with an error. There is no automatic
  reconnection. Normal EOF ends it without an error.
- Closing a provider created by `DockerProvider.connect()` also aborts its active
  log requests. With an injected Docker API, the caller owns the client's lifetime.

### Sharing a provider

For several containers, share a `DockerProvider` and close it when finished:

```dart
final provider = await DockerProvider.connect();
try {
  final container = await provider.start(config);
  try {
    // Use the container.
  } finally {
    await container.terminate();
  }
} finally {
  provider.close();
}
```

With cleanup enabled, `provider.close()` schedules removal of any remaining
containers; it does not wait for that removal. Use `terminate()` for immediate
cleanup. Always close shared providers to allow the Dart process to exit.

## Private registries

Application and Ryuk images share the same credential resolution. Pass credentials
by registry address (including its port), not by image name:

```dart
final provider = await DockerProvider.connect(
  registryCredentials: {
    'registry.example.com:5000': RegistryCredentials(
      username: 'ci',
      password: registryToken,
    ),
  },
);
```

`Testcontainers.run()` and the injected-API `DockerProvider` constructor accept the
same parameter. Use `RegistryCredentials.identityToken(token)` for identity tokens.

Credentials are resolved for each registry, in order:

1. Explicit `registryCredentials`.
2. JSON from `DOCKER_AUTH_CONFIG`.
3. `$DOCKER_CONFIG/config.json`, or `~/.docker/config.json` when unset.
4. Anonymous pull if no credentials are found.

Within a config, `credHelpers[registry]` takes precedence over `credsStore`, which
takes precedence over inline `auths`. Helpers run on the Dart client's machine
as `docker-credential-<name> get` using `PATH`; Docker CLI itself is not required.
Both configs support Base64 `auth`, username/password and `identitytoken` entries.
Docker Hub aliases are recognized, including `https://index.docker.io/v1/`.

Missing files or credentials allow fallback. Invalid configuration, unreadable
files and helper failures raise `RegistryAuthException`; a selected helper does
not fall back to stale inline passwords. Helpers have a 10-second timeout and
a 1 MiB limit on each output pipe. Credentials are not cached or written to disk.
Local images satisfying the pull policy do not read credentials or run helpers.

Credentials go only in the pull request's `X-Registry-Auth`, never in container
configuration. Authenticated pull errors retain HTTP status but omit raw response
text, and resolver errors omit secret input and helper output. Custom HTTP
interceptors/loggers must also avoid logging this header. Base64 is not encryption:
use a trusted Unix socket or verified HTTPS for the Docker connection.

## Docker connection

Local Docker is detected automatically. Override connection settings with:

| Environment variable           | Purpose                                                                    |
| ------------------------------ | -------------------------------------------------------------------------- |
| `DOCKER_HOST`                  | Docker endpoint, e.g. `unix:///var/run/docker.sock` or `tcp://docker:2375` |
| `TESTCONTAINERS_HOST_OVERRIDE` | Reachable address for published container ports                            |

Without `DOCKER_HOST`, the package checks `$HOME/.docker/run/docker.sock`, then
`/var/run/docker.sock`. Docker CLI contexts are not read.

For explicit configuration, pass `config` to `Testcontainers.run()` or
`DockerProvider.connect()`:

```dart
final provider = await DockerProvider.connect(
  config: DockerConfig(
    endpoint: Uri.parse('unix:///path/to/docker.sock'),
    requestTimeout: const Duration(minutes: 3),
  ),
);
```

Unix sockets, HTTP/TCP and HTTPS with system-trusted server certificates are
supported. Docker Engine API versions **1.41–1.55** are supported.

Ports bind to `127.0.0.1` by default. For remote Docker, set
`ContainerConfig.portBindingHost` and `RyukConfig.portBindingHost` to an appropriate
daemon interface, and `DockerConfig.host` to a reachable address. Binding to
`0.0.0.0` exposes ports beyond loopback. Only use trusted networks; Docker TCP and
Ryuk's port must not be exposed to untrusted clients.

## Automatic cleanup

Ryuk is enabled by default to remove leftover test containers after the test
process crashes. Keep using `finally` or `addTearDown` for normal cleanup.
Ryuk requires read/write access to the daemon's Docker socket, which grants
control over Docker. Cleanup depends on Docker and Ryuk remaining available.

Pass `ryuk: const RyukConfig(enabled: false)` to `Testcontainers.run()` or
`DockerProvider.connect()` only when cleanup is handled externally. With Ryuk
disabled, closing a provider does not remove containers.

| Environment variable                    | Purpose                                                                 |
| --------------------------------------- | ----------------------------------------------------------------------- |
| `TESTCONTAINERS_RYUK_DISABLED`          | `true` disables Ryuk; default `false`                                   |
| `TESTCONTAINERS_RYUK_CONTAINER_IMAGE`   | Override the Ryuk image                                                 |
| `TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE` | Docker socket path on the daemon's host; default `/var/run/docker.sock` |

An explicit `RyukConfig` takes precedence over these environment variables. It
also accepts `image`, `pullPolicy`, `socketPath`, `portBindingHost` and `startupTimeout`.
`startupTimeout` bounds the connection wait; Docker API calls and image pulls use
`DockerConfig.requestTimeout` (default two minutes). If the cleanup connection is
lost, containers may be removed and new starts on that provider fail; create a
new provider.

## Packages and examples

| Package                                                                                                     | Purpose                                             |
| ----------------------------------------------------------------------------------------------------------- | --------------------------------------------------- |
| [`testcontainers_dart`](https://github.com/06ED/testcontainers_dart/tree/main/packages/testcontainers_dart) | Disposable containers, readiness checks and cleanup |
| [`docker_engine`](https://github.com/06ED/testcontainers_dart/tree/main/packages/docker_engine)             | Standalone Docker Engine API client                 |

A runnable example is available in
[`examples/testcontainers`](https://github.com/06ED/testcontainers_dart/tree/main/examples/testcontainers).
From the repository root, with Docker running:

```sh
dart run examples/testcontainers/bin/testcontainers_example.dart
```

## Current limitations

- No Docker client-certificate environment settings,
  SSH, Windows named pipes, Compose, image builds or container reuse.
- File copying supports individual regular files, not recursive directories or
  links. Networking supports one managed bridge network per container, not
  attaching existing networks or runtime connect/disconnect.
- A readiness timeout does not cancel an already running exec command;
  startup-failure cleanup removes the container instead.
