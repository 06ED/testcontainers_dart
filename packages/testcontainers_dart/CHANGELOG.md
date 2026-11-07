## Unreleased

- **Breaking:** Rename the readiness interface from `WaitStrategy` to `Wait` and
  move the `Wait.for...` helpers into factory constructors on that interface.
- Split readiness strategies into separate files with a shared wait export.
- Handle Ryuk socket write errors during connection retries without unhandled
  asynchronous exceptions.
- Add default-on, per-provider Ryuk sessions for crash cleanup, with reserved
  session labels, acknowledged filter registration and configurable image,
  daemon socket, port binding and connection timeout.
- **Breaking:** `DockerProvider.close()` now ends the Ryuk session and triggers
  delayed cleanup of remaining containers. Disable Ryuk to retain connection-only
  close behavior. The `org.testcontainers` label namespace is now reserved.
- Test handshake failures, concurrent startup, startup rollback, process exit and
  real-Docker cleanup after `SIGKILL`, including isolation between sessions.

## 0.1.0

- Use the package name `testcontainers_dart` and the matching public library.
- Name the container launch configuration `ContainerConfig`.
- Move into a Pub workspace and depend on the standalone `docker_engine` package;
  keep public Testcontainers imports and Docker configuration/errors available.
- Implement generic async container lifecycle, env/command/ports/bind mounts,
  inspect, multiplexed logs and exec output.
- Add Unix/TCP connections, API negotiation, request timeouts and explicit cleanup.
- Add TCP/log/HTTP/healthcheck/exec/composite readiness strategies.
- Cover the core with unit and local socket tests; add an opt-in Docker smoke test.
