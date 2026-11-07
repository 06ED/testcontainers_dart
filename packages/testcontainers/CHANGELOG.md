## 0.1.0

- Name the container launch configuration `ContainerConfig`.
- Move into a Pub workspace and depend on the standalone `docker_engine` package;
  keep public Testcontainers imports and Docker configuration/errors available.
- Implement generic async container lifecycle, env/command/ports/bind mounts,
  inspect, multiplexed logs and exec output.
- Add Unix/TCP connections, API negotiation, request timeouts and explicit cleanup.
- Add TCP/log/HTTP/healthcheck/exec/composite readiness strategies.
- Cover the core with unit and local socket tests; add an opt-in Docker smoke test.
