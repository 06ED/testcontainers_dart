## Unreleased

- Require Dart 3.13.7 and adopt primary constructors and concise constructor syntax.
- Add cancellable `Docker.logsStream()` streaming over the configured transport,
  with incremental frame/UTF-8 decoding and stdout/stderr text chunks.
- Accept null or missing storage driver metadata in Docker inspect responses.

## 0.1.0

- Extract the Docker Engine API client, configuration, Unix/TCP transport,
  API negotiation, request timeouts, errors and output decoding from Testcontainers.
