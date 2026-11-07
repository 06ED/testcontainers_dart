# Testcontainers Dart

[![CI](https://img.shields.io/github/actions/workflow/status/06ED/testcontainers_dart/ci.yml?branch=main&style=flat-square&label=CI)](https://github.com/06ED/testcontainers_dart/actions/workflows/ci.yml)
[![Coverage](https://img.shields.io/codecov/c/github/06ED/testcontainers_dart/main?style=flat-square&label=coverage)](https://codecov.io/gh/06ED/testcontainers_dart)
[![Dart SDK: ^3.11.3](https://img.shields.io/badge/Dart-%5E3.11.3-0175C2?style=flat-square&logo=dart&logoColor=white)](https://dart.dev/get-dart)
[![Docker required](https://img.shields.io/badge/Docker-required-2496ED?style=flat-square&logo=docker&logoColor=white)](https://docs.docker.com/get-started/get-docker/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green?style=flat-square)](https://github.com/06ED/testcontainers_dart/blob/main/LICENCE)
![Made with love](https://img.shields.io/badge/Made_with-%E2%9D%A4-ff4757?style=flat-square)

Run disposable Docker containers in Dart integration tests. Configure a service,
wait until it is ready, run your tests, and remove it when finished.

## Installation

Requires Dart **3.11.3+** and a running Docker daemon. The Docker CLI is not required.

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

Images are pulled on startup. An omitted tag means `latest`; prefer an explicit
version for reproducible tests.

## Container configuration

`ContainerConfig` accepts an image, optional name, environment variables, command,
TCP/UDP ports, labels, bind mounts and a readiness strategy:

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

## Waiting for readiness

Create a `Wait` using a named factory constructor. Where Dart can infer the type
(such as `waitStrategy:`), the class name can be omitted:

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

## Docker connection

Local Docker is detected automatically. Override connection settings with:

| Environment variable | Purpose |
| --- | --- |
| `DOCKER_HOST` | Docker endpoint, e.g. `unix:///var/run/docker.sock` or `tcp://docker:2375` |
| `TESTCONTAINERS_HOST_OVERRIDE` | Reachable address for published container ports |

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
supported. Docker Engine API versions **1.41–1.53** are supported.

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

| Environment variable | Purpose |
| --- | --- |
| `TESTCONTAINERS_RYUK_DISABLED` | `true` disables Ryuk; default `false` |
| `TESTCONTAINERS_RYUK_CONTAINER_IMAGE` | Override the Ryuk image |
| `TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE` | Docker socket path on the daemon's host; default `/var/run/docker.sock` |

An explicit `RyukConfig` takes precedence over these environment variables. It
also accepts `image`, `socketPath`, `portBindingHost` and `startupTimeout`.
`startupTimeout` bounds the connection wait; Docker API calls and image pulls use
`DockerConfig.requestTimeout` (default two minutes). If the cleanup connection is
lost, containers may be removed and new starts on that provider fail; create a
new provider.

## Packages and examples

| Package | Purpose |
| --- | --- |
| [`testcontainers_dart`](https://github.com/06ED/testcontainers_dart/tree/main/packages/testcontainers_dart) | Disposable containers, readiness checks and cleanup |
| [`docker_engine`](https://github.com/06ED/testcontainers_dart/tree/main/packages/docker_engine) | Standalone Docker Engine API client |

A runnable example is available in
[`examples/testcontainers`](https://github.com/06ED/testcontainers_dart/tree/main/examples/testcontainers).
From the repository root, with Docker running:

```sh
dart run examples/testcontainers/bin/testcontainers_example.dart
```

## Current limitations

- No registry authentication, Docker client-certificate environment settings,
  SSH, Windows named pipes, Compose, image builds, file copy, network management
  or container reuse.
- Logs and exec output are returned after the request completes, not as live
  streams. Log readiness checks the most recent 1000 lines.
- A readiness timeout does not cancel an already running exec command;
  startup-failure cleanup removes the container instead.
