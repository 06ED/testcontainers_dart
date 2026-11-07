# Testcontainers Dart

[![CI](https://github.com/06ED/testcontainers_dart/actions/workflows/ci.yml/badge.svg)](https://github.com/06ED/testcontainers_dart/actions/workflows/ci.yml)
[![Coverage](https://codecov.io/gh/06ED/testcontainers_dart/branch/main/graph/badge.svg)](https://codecov.io/gh/06ED/testcontainers_dart)
[![Dart SDK: ^3.11.3](https://img.shields.io/badge/Dart-%5E3.11.3-0175C2?style=flat-square&logo=dart&logoColor=white)](https://dart.dev/get-dart)
[![Docker required](https://img.shields.io/badge/Docker-required-2496ED?style=flat-square&logo=docker&logoColor=white)](https://docs.docker.com/get-started/get-docker/)
[![License: MIT](https://img.shields.io/badge/License-MIT-green?style=flat-square)](LICENCE)
![Made with love](https://img.shields.io/badge/Made_with-%E2%9D%A4-ff4757?style=flat-square)

Dart building blocks for disposable Docker containers. Requires a running Docker daemon.

## Quick start

```dart
import 'package:testcontainers_dart/testcontainers_dart.dart';

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
With Ryuk enabled (the default), closing a provider ends its session and triggers
delayed cleanup of any remaining containers. `close()` does not wait for that
cleanup; use `terminate()` for immediate removal. With Ryuk disabled, closing a
provider only closes its connection. An injected `dockerApi` remains owned by its
caller.

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

## Ryuk cleanup

Each provider lazily starts one `testcontainers/ryuk:0.14.0` container before its
first user container. Concurrent starts share that Ryuk instance. Every
`Testcontainers.run()` owns a separate provider/session; share a provider to use
one Ryuk for a group of containers.

Containers receive `org.testcontainers=true` and a random
`org.testcontainers.sessionId` label at creation. The `org.testcontainers` label
namespace is reserved. The library registers the session filter with Ryuk and
waits for `ACK` before creating user containers. If startup fails, it reports the
error rather than silently proceeding without cleanup protection.

The TCP connection stays open until the provider closes or its process dies.
After the last connection is lost, Ryuk waits its reconnection grace period
(currently 10 seconds), removes matching containers and their anonymous volumes,
then exits and auto-removes itself. Other sessions, pulled images, named volumes
and bind-mounted files are not targeted. Continue to use `finally` or
`addTearDown`: Ryuk is a fallback, not immediate teardown. Always close shared
providers; an open Ryuk socket keeps the Dart process alive. If an established
connection is lost, new starts fail; create a new provider rather than reusing
that session. Existing containers may be removed after the grace period.

Ryuk mounts the daemon's Docker socket with read/write access. **That grants
control over the Docker daemon**, even without privileged container mode. The
default mount source is `/var/run/docker.sock`, including on Docker Desktop;
it is not the client's `$HOME/.docker/run/docker.sock`.

```dart
final provider = await DockerProvider.connect(
  ryuk: const RyukConfig(
    socketPath: '/var/run/docker.sock', // Path on the daemon's host.
    startupTimeout: Duration(seconds: 30),
  ),
);
// Start containers, register teardown, and close the provider when finished.
```

`RyukConfig` is also accepted by `Testcontainers.run()` and the injected
`DockerProvider` constructor. `image` overrides the pinned image;
`portBindingHost` defaults to `127.0.0.1`. With a remote daemon, configure both a
reachable binding and `DockerConfig.host`; never expose Ryuk's unauthenticated
port to an untrusted network. `startupTimeout` bounds TCP connection retries and
the ACK wait after Docker startup; image pulls and Docker API calls use
`DockerConfig.requestTimeout`.

Without an explicit `RyukConfig`, these environment variables apply:

| Variable | Meaning |
| --- | --- |
| `TESTCONTAINERS_RYUK_DISABLED` | `true` disables Ryuk; default `false` |
| `TESTCONTAINERS_RYUK_CONTAINER_IMAGE` | Override `testcontainers/ryuk:0.14.0` |
| `TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE` | Socket mount source on the daemon host |

Use `ryuk: const RyukConfig(enabled: false)` where socket mounting is prohibited
and an external system handles cleanup. Crash cleanup depends on Ryuk and Docker
remaining available; it is not an unconditional guarantee. Failure during Ryuk's
own creation is cleaned up by its generated name on a best-effort basis.

## Workspace

A [Pub workspace](https://dart.dev/tools/pub/workspaces) with two library packages:

| Package                                      | Responsibility                                                                               |
| -------------------------------------------- | -------------------------------------------------------------------------------------------- |
| [`docker_engine`](packages/docker_engine/)   | Generated Docker Engine API, Unix/TCP transport, API negotiation, errors and stream decoding |
| [`testcontainers_dart`](packages/testcontainers_dart/) | Disposable container lifecycle, readiness strategies and cleanup                             |

```text
packages/
├── docker_engine/           # Public Docker client, generated API and tests
└── testcontainers_dart/     # Lifecycle, readiness and tests
examples/
└── testcontainers/          # Runnable Dart package
    ├── pubspec.yaml
    └── bin/testcontainers_example.dart
```

Requires Dart **3.11.3+**. The root is not published. Each member declares
`resolution: workspace`; one root `pubspec.lock` and `.dart_tool/package_config.json`
serve the entire repository. Commit the root lockfile.

`testcontainers_dart` depends on `docker_engine: ^0.1.0`. Pub resolves this to the
local workspace package automatically, without path dependencies or overrides.
The dependency is one-way: `docker_engine` knows nothing about Testcontainers.

## Development

From the repository root:

```sh
dart pub get
dart pub workspace list
dart analyze
dart test packages/docker_engine/test packages/testcontainers_dart/test
```

Run `dart test` from an individual package directory to run its `test/` suite.
These tests do not require Docker. Real-Docker tests live separately in
`packages/testcontainers_dart/integration_test/`; with Docker running, use:

```sh
dart test packages/testcontainers_dart/integration_test
```

No environment flag is required. The Ryuk process tests require POSIX signals
and are skipped on Windows. Avoid `dart test packages` for Docker-free checks:
that recursive command also discovers `integration_test/`.

### CI and coverage

GitHub Actions runs on pull requests and pushes to `main`:

- [Very Good Workflows v2.0.3](https://github.com/VeryGoodOpenSource/very_good_workflows)
  checks formatting, analysis and VM tests for each package on stable Dart.
- Unit-test line coverage includes all `lib/` files, including unimported files,
  except `docker_engine/lib/src/generated/`. Minimums are **80%** for
  `docker_engine` and **95%** for `testcontainers_dart`.
- A separate job checks analysis and unit tests on the minimum SDK,
  **Dart 3.11.3**, without VGV's CLI (which requires Dart 3.13+). This also checks
  the workspace examples. Formatting is checked on stable Dart to avoid
  differences between formatter versions.
- A Docker-enabled Ubuntu job runs `integration_test/` separately. Integration
  tests and their child processes are not included in the coverage badge.
- Package LCOV artifacts are uploaded together to Codecov using GitHub OIDC;
  no `CODECOV_TOKEN` secret is needed. The badge shows combined unit-test coverage.

Codecov allows a one-percentage-point drop from the base commit and requires 90%
coverage of changed lines. Package minimums are enforced independently by VGV.
The coverage badge becomes available after the first successful upload on `main`.

To reproduce the coverage checks locally, use Dart 3.13+ and run from each
package directory (use `80` instead of `95` for `docker_engine`):

```sh
dart pub global activate very_good_cli 1.5.0
very_good dart test --coverage --platform vm --collect-coverage-from all \
  --report-on lib --exclude-coverage '**/src/generated/**' \
  --min-coverage 95 --no-check-ignore --no-optimization \
  --test-randomize-ordering-seed random
```

Reports are written to each package's `coverage/lcov.info`. Coverage exclusions
are applied to the VGV threshold and Codecov display; raw LCOV may still contain
generated files.

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
`testcontainers_dart` release that depends on it. Package names/versions on pub.dev
have not been checked or reserved.

## Deliberate limits

- Ryuk needs a mountable Docker socket and a reachable published TCP port. Cleanup
  cannot be guaranteed if the Docker daemon or Ryuk itself fails.
- No registry authentication, Docker client-certificate env configuration, SSH,
  Windows named pipes, Compose, image builds, file copy, network management or reuse.
- Logs/exec output and pull responses are buffered, not exposed as live streams.
  Log readiness searches only the most recent 1000 lines.
- A readiness timeout does not cancel an already running exec command; startup
  failure removes the container. Real Docker compatibility must be checked with
  the opt-in integration test on your target daemon/platform.
