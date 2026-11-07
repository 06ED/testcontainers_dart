# Testcontainers Dart

[![Dart SDK: ^3.11.3](https://img.shields.io/badge/Dart-%5E3.11.3-0175C2?style=flat-square&logo=dart&logoColor=white)](https://dart.dev/get-dart)
[![Docker required](https://img.shields.io/badge/Docker-required-2496ED?style=flat-square&logo=docker&logoColor=white)](https://docs.docker.com/get-started/get-docker/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENCE)
![Made with love](https://img.shields.io/badge/Made_with-%E2%9D%A4-ff4757?style=flat-square)

Dart building blocks for disposable Docker containers. Requires a running Docker daemon.

## Quick start

```dart
import 'package:testcontainers/testcontainers.dart';

Future<void> main() async {
  final container = await Testcontainers.run(ContainerConfig(
    image: 'redis:7-alpine',
    exposedPorts: const [Port.tcp(6379)],
    waitStrategy: Wait.forSuccessfulCommand(['redis-cli', 'ping']),
  ));
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

`Testcontainers.run` owns a connection and closes it after successful termination.
To share a connection across containers, use `DockerProvider.connect()`, call
`provider.start(config)`, terminate every container, then call `provider.close()`.
Closing a provider **does not delete containers**. An injected `dockerApi` remains
owned by its caller.

## Container API

- `ContainerConfig`: image, optional name, environment, command argument array,
  TCP/UDP ports, labels and bind mounts. Bind mounts are read-only by default;
  source paths refer to the **Docker daemon's host**, not necessarily your machine.
- `StartedContainer`: `id`, `image`, `host`, `inspect()`,
  `mappedPort(port, protocol: 'tcp')`, `logs(tail: 1000)`, `exec(command)`,
  `stop(timeout: ...)`, `terminate()`.
- `exec` returns `ExecResult` with `exitCode`, `stdout` and `stderr`. Nonzero
  exit codes are returned, not thrown. Commands are argument arrays, not shell
  strings; invoke `['sh', '-c', '...']` explicitly when a shell is needed.
- `stop` leaves the container in Docker; `terminate` force-removes it and its
  anonymous volumes, not named volumes or bind-mounted files. Repeated/concurrent
  termination is safe, and failed deletion can be retried.

Startup currently always pulls the requested image. An omitted tag means `latest`,
not all tags. Prefer explicit image versions for reproducible tests.
If startup/readiness fails after creation, cleanup is attempted automatically.
`ContainerStartException` preserves the original cause, recent logs, container ID
and any cleanup failure.

## Readiness

```dart
Wait.forNothing(); // Default: start only, no readiness guarantee.
Wait.forListeningPort(port: 8080);
Wait.forLogMessage(RegExp(r'Listening on port \d+'), times: 1);
Wait.forHttp(port: 8080, path: '/health', statusCode: 200);
Wait.forHealthcheck(); // The image must define a Docker HEALTHCHECK.
Wait.forSuccessfulCommand(['redis-cli', 'ping']);
Wait.forAll([firstStrategy, secondStrategy]);
```

Polling strategies accept `timeout` (default 60 seconds) and `pollInterval`
(default 100 milliseconds). They check for premature container exit and bound
individual readiness attempts by the remaining timeout. `forAll` runs strategies
sequentially, **each with its own timeout**. TCP availability alone does not prove
that a database is ready; prefer an application-level check.

## Docker connection

The connection negotiates an API version in the supported range **1.41–1.53**.
Transports: Unix domain socket, HTTP/TCP, and HTTPS with system-trusted server
certificates. Docker does not need to be installed as a CLI executable.
`DockerConfig` and `DockerException` are re-exported from `docker_engine`.

By default, configuration reads:

| Variable                       | Meaning                                                          |
| ------------------------------ | ---------------------------------------------------------------- |
| `DOCKER_HOST`                  | For example `unix:///var/run/docker.sock` or `tcp://docker:2375` |
| `TESTCONTAINERS_HOST_OVERRIDE` | Address used to connect to published service ports               |

Without `DOCKER_HOST`, `$HOME/.docker/run/docker.sock` is used when it is a Unix
socket, otherwise `/var/run/docker.sock`. Docker CLI contexts are not read.
For explicit configuration:

```dart
final provider = await DockerProvider.connect(
  config: DockerConfig(
    endpoint: Uri.parse('unix:///path/to/docker.sock'),
    requestTimeout: const Duration(minutes: 3),
  ),
);
```

Published ports bind to `127.0.0.1` by default. For a remote daemon, explicitly set
`ContainerConfig.portBindingHost` to an appropriate daemon interface and ensure
`DockerConfig.host` / `TESTCONTAINERS_HOST_OVERRIDE` is reachable. Binding to
`0.0.0.0` exposes services beyond loopback; do this only on a trusted network.
Unencrypted TCP gives control over Docker: never expose it to untrusted networks.
HTTP requests, including response bodies, have a timeout (default two minutes).

## Workspace

A [Pub workspace](https://dart.dev/tools/pub/workspaces) with two library packages:

| Package                                      | Responsibility                                                                               |
| -------------------------------------------- | -------------------------------------------------------------------------------------------- |
| [`docker_engine`](packages/docker_engine/)   | Generated Docker Engine API, Unix/TCP transport, API negotiation, errors and stream decoding |
| [`testcontainers`](packages/testcontainers/) | Disposable container lifecycle, readiness strategies and cleanup                             |

```text
packages/
├── docker_engine/           # Public Docker client, generated API and tests
└── testcontainers/          # Lifecycle, readiness and tests
examples/
└── testcontainers/          # Runnable Dart package
    ├── pubspec.yaml
    └── bin/testcontainers_example.dart
```

Requires Dart **3.11.3+**. The root is not published. Each member declares
`resolution: workspace`; one root `pubspec.lock` and `.dart_tool/package_config.json`
serve the entire repository. Commit the root lockfile.

`testcontainers` depends on `docker_engine: ^0.1.0`. Pub resolves this to the
local workspace package automatically, without path dependencies or overrides.
The dependency is one-way: `docker_engine` knows nothing about Testcontainers.

## Development

From the repository root:

```sh
dart pub get
dart pub workspace list
dart analyze
dart test packages
```

Run `dart test` from an individual package directory to test just that package.
The default tests do not require Docker. To run the real-Docker smoke test:

```sh
TESTCONTAINERS_INTEGRATION=1 dart test packages/testcontainers/test/integration/docker_test.dart
```

The Docker client is generated from the Engine v1.53 schema using Swagger/Chopper.
Generated sources are included. Regenerate from its package directory:

```sh
cd packages/docker_engine
dart run build_runner build --delete-conflicting-outputs
```

## Examples

Examples live in `examples/` as separate, unpublished Dart packages in the same
workspace. They use the local library packages and share the root lockfile.

With Docker running, launch the existing example from the repository root:

```sh
dart run examples/testcontainers/bin/testcontainers_example.dart
```

Or run `dart run` from `examples/testcontainers/`. The example pulls
`busybox:1.37`, waits for its startup log, executes `uname -m`, and removes the
container in `finally`.

Docker client details: [Docker Engine client](packages/docker_engine/README.md).

Packages can be published separately; publish `docker_engine` before a
`testcontainers` release that depends on it. Package names/versions on pub.dev
have not been checked or reserved.

## Deliberate limits

- No Ryuk yet: explicit teardown and startup-failure cleanup cannot guarantee
  removal after process crashes, forced termination or an ambiguous create timeout.
- No registry authentication, Docker client-certificate env configuration, SSH,
  Windows named pipes, Compose, image builds, file copy, network management or reuse.
- Logs/exec output and pull responses are buffered, not exposed as live streams.
  Log readiness searches only the most recent 1000 lines.
- A readiness timeout does not cancel an already running exec command; startup
  failure removes the container. Real Docker compatibility must be checked with
  the opt-in integration test on your target daemon/platform.
