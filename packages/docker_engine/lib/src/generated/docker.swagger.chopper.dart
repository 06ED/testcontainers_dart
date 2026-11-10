// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

part of 'docker.swagger.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$Docker extends Docker {
  _$Docker([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = Docker;

  @override
  Future<Response<List<ContainerSummary>>> _containersJsonGet({
    bool? all,
    int? limit,
    bool? size,
    String? filters,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description:
          '''Returns a list of containers. For details on the format, see the
[inspect endpoint](#operation/ContainerInspect).

Note that it uses a different, smaller representation of a container
than inspecting a single container. For example, the list of linked
containers is not propagated .
''',
      summary: 'List containers',
      operationId: 'ContainerList',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Container"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/containers/json');
    final Map<String, dynamic> $params = <String, dynamic>{
      'all': all,
      'limit': limit,
      'size': size,
      'filters': filters,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<List<ContainerSummary>, ContainerSummary>($request);
  }

  @override
  Future<Response<ContainerCreateResponse>> _containersCreatePost({
    String? name,
    String? platform,
    required Object? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Create a container',
      operationId: 'ContainerCreate',
      consumes: ["application/json", "application/octet-stream"],
      produces: ["application/json"],
      security: [],
      tags: ["Container"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/containers/create');
    final Map<String, dynamic> $params = <String, dynamic>{
      'name': name,
      'platform': platform,
    };
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<ContainerCreateResponse, ContainerCreateResponse>(
      $request,
    );
  }

  @override
  Future<Response<ContainerInspectResponse>> _containersIdJsonGet({
    required String? id,
    bool? size,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: 'Return low-level information about a container.',
      summary: 'Inspect a container',
      operationId: 'ContainerInspect',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Container"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/containers/${id}/json');
    final Map<String, dynamic> $params = <String, dynamic>{'size': size};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<ContainerInspectResponse, ContainerInspectResponse>(
      $request,
    );
  }

  @override
  Future<Response<ContainerTopResponse>> _containersIdTopGet({
    required String? id,
    String? psArgs,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '''On Unix systems, this is done by running the `ps` command. This endpoint
is not supported on Windows.
''',
      summary: 'List processes running inside a container',
      operationId: 'ContainerTop',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Container"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/containers/${id}/top');
    final Map<String, dynamic> $params = <String, dynamic>{'ps_args': psArgs};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<ContainerTopResponse, ContainerTopResponse>($request);
  }

  @override
  Future<Response<String>> _containersIdLogsGet({
    required String? id,
    bool? follow,
    bool? stdout,
    bool? stderr,
    int? since,
    int? until,
    bool? timestamps,
    String? tail,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '''Get `stdout` and `stderr` logs from a container.

Note: This endpoint works only for containers with the `json-file` or
`journald` logging driver.
''',
      summary: 'Get container logs',
      operationId: 'ContainerLogs',
      consumes: [],
      produces: [
        "application/vnd.docker.raw-stream",
        "application/vnd.docker.multiplexed-stream",
      ],
      security: [],
      tags: ["Container"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/containers/${id}/logs');
    final Map<String, dynamic> $params = <String, dynamic>{
      'follow': follow,
      'stdout': stdout,
      'stderr': stderr,
      'since': since,
      'until': until,
      'timestamps': timestamps,
      'tail': tail,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<String, String>($request);
  }

  @override
  Future<Response<List<FilesystemChange>>> _containersIdChangesGet({
    required String? id,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '''Returns which files in a container\'s filesystem have been added, deleted,
or modified. The `Kind` of modification can be one of:

- `0`: Modified ("C")
- `1`: Added ("A")
- `2`: Deleted ("D")
''',
      summary: 'Get changes on a container’s filesystem',
      operationId: 'ContainerChanges',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Container"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/containers/${id}/changes');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<List<FilesystemChange>, FilesystemChange>($request);
  }

  @override
  Future<Response<dynamic>> _containersIdExportGet({
    required String? id,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: 'Export the contents of a container as a tarball.',
      summary: 'Export a container',
      operationId: 'ContainerExport',
      consumes: [],
      produces: ["application/octet-stream"],
      security: [],
      tags: ["Container"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/containers/${id}/export');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<ContainerStatsResponse>> _containersIdStatsGet({
    required String? id,
    bool? stream,
    bool? oneShot,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description:
          '''This endpoint returns a live stream of a container’s resource usage
statistics.

The `precpu_stats` is the CPU statistic of the *previous* read, and is
used to calculate the CPU usage percentage. It is not an exact copy
of the `cpu_stats` field.

If either `precpu_stats.online_cpus` or `cpu_stats.online_cpus` is
nil then for compatibility with older daemons the length of the
corresponding `cpu_usage.percpu_usage` array should be used.

On a cgroup v2 host, the following fields are not set
* `blkio_stats`: all fields other than `io_service_bytes_recursive`
* `cpu_stats`: `cpu_usage.percpu_usage`
* `memory_stats`: `max_usage` and `failcnt`
Also, `memory_stats.stats` fields are incompatible with cgroup v1.

To calculate the values shown by the `stats` command of the docker cli tool
the following formulas can be used:
* used_memory = `memory_stats.usage - memory_stats.stats.cache` (cgroups v1)
* used_memory = `memory_stats.usage - memory_stats.stats.inactive_file` (cgroups v2)
* available_memory = `memory_stats.limit`
* Memory usage % = `(used_memory / available_memory) * 100.0`
* cpu_delta = `cpu_stats.cpu_usage.total_usage - precpu_stats.cpu_usage.total_usage`
* system_cpu_delta = `cpu_stats.system_cpu_usage - precpu_stats.system_cpu_usage`
* number_cpus = `length(cpu_stats.cpu_usage.percpu_usage)` or `cpu_stats.online_cpus`
* CPU usage % = `(cpu_delta / system_cpu_delta) * number_cpus * 100.0`
''',
      summary: 'Get container stats based on resource usage',
      operationId: 'ContainerStats',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Container"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/containers/${id}/stats');
    final Map<String, dynamic> $params = <String, dynamic>{
      'stream': stream,
      'one-shot': oneShot,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<ContainerStatsResponse, ContainerStatsResponse>(
      $request,
    );
  }

  @override
  Future<Response<dynamic>> _containersIdResizePost({
    required String? id,
    required int? h,
    required int? w,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: 'Resize the TTY for a container.',
      summary: 'Resize a container TTY',
      operationId: 'ContainerResize',
      consumes: ["application/octet-stream"],
      produces: ["application/json"],
      security: [],
      tags: ["Container"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/containers/${id}/resize');
    final Map<String, dynamic> $params = <String, dynamic>{'h': h, 'w': w};
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _containersIdStartPost({
    required String? id,
    String? detachKeys,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Start a container',
      operationId: 'ContainerStart',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Container"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/containers/${id}/start');
    final Map<String, dynamic> $params = <String, dynamic>{
      'detachKeys': detachKeys,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _containersIdStopPost({
    required String? id,
    String? signal,
    int? t,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Stop a container',
      operationId: 'ContainerStop',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Container"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/containers/${id}/stop');
    final Map<String, dynamic> $params = <String, dynamic>{
      'signal': signal,
      't': t,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _containersIdRestartPost({
    required String? id,
    String? signal,
    int? t,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Restart a container',
      operationId: 'ContainerRestart',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Container"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/containers/${id}/restart');
    final Map<String, dynamic> $params = <String, dynamic>{
      'signal': signal,
      't': t,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _containersIdKillPost({
    required String? id,
    String? signal,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description:
          '''Send a POSIX signal to a container, defaulting to killing to the
container.
''',
      summary: 'Kill a container',
      operationId: 'ContainerKill',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Container"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/containers/${id}/kill');
    final Map<String, dynamic> $params = <String, dynamic>{'signal': signal};
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<ContainerUpdateResponse>> _containersIdUpdatePost({
    required String? id,
    required Object? update,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '''Change various configuration options of a container without having to
recreate it.
''',
      summary: 'Update a container',
      operationId: 'ContainerUpdate',
      consumes: ["application/json"],
      produces: ["application/json"],
      security: [],
      tags: ["Container"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/containers/${id}/update');
    final $body = update;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<ContainerUpdateResponse, ContainerUpdateResponse>(
      $request,
    );
  }

  @override
  Future<Response<dynamic>> _containersIdRenamePost({
    required String? id,
    required String? name,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Rename a container',
      operationId: 'ContainerRename',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Container"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/containers/${id}/rename');
    final Map<String, dynamic> $params = <String, dynamic>{'name': name};
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _containersIdPausePost({
    required String? id,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description:
          '''Use the freezer cgroup to suspend all processes in a container.

Traditionally, when suspending a process the `SIGSTOP` signal is used,
which is observable by the process being suspended. With the freezer
cgroup the process is unaware, and unable to capture, that it is being
suspended, and subsequently resumed.
''',
      summary: 'Pause a container',
      operationId: 'ContainerPause',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Container"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/containers/${id}/pause');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _containersIdUnpausePost({
    required String? id,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: 'Resume a container which has been paused.',
      summary: 'Unpause a container',
      operationId: 'ContainerUnpause',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Container"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/containers/${id}/unpause');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _containersIdAttachPost({
    required String? id,
    String? detachKeys,
    bool? logs,
    bool? stream,
    bool? stdin,
    bool? stdout,
    bool? stderr,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '''Attach to a container to read its output or send it input. You can attach
to the same container multiple times and you can reattach to containers
that have been detached.

Either the `stream` or `logs` parameter must be `true` for this endpoint
to do anything.

See the [documentation for the `docker attach` command](https://docs.docker.com/engine/reference/commandline/attach/)
for more details.

### Hijacking

This endpoint hijacks the HTTP connection to transport `stdin`, `stdout`,
and `stderr` on the same socket.

This is the response from the daemon for an attach request:

```
HTTP/1.1 200 OK
Content-Type: application/vnd.docker.raw-stream

[STREAM]
```

After the headers and two new lines, the TCP connection can now be used
for raw, bidirectional communication between the client and server.

To hint potential proxies about connection hijacking, the Docker client
can also optionally send connection upgrade headers.

For example, the client sends this request to upgrade the connection:

```
POST /containers/16253994b7c4/attach?stream=1&stdout=1 HTTP/1.1
Upgrade: tcp
Connection: Upgrade
```

The Docker daemon will respond with a `101 UPGRADED` response, and will
similarly follow with the raw stream:

```
HTTP/1.1 101 UPGRADED
Content-Type: application/vnd.docker.raw-stream
Connection: Upgrade
Upgrade: tcp

[STREAM]
```

### Stream format

When the TTY setting is disabled in [`POST /containers/create`](#operation/ContainerCreate),
the HTTP Content-Type header is set to application/vnd.docker.multiplexed-stream
and the stream over the hijacked connected is multiplexed to separate out
`stdout` and `stderr`. The stream consists of a series of frames, each
containing a header and a payload.

The header contains the information which the stream writes (`stdout` or
`stderr`). It also contains the size of the associated frame encoded in
the last four bytes (`uint32`).

It is encoded on the first eight bytes like this:

```go
header := [8]byte{STREAM_TYPE, 0, 0, 0, SIZE1, SIZE2, SIZE3, SIZE4}
```

`STREAM_TYPE` can be:

- 0: `stdin` (is written on `stdout`)
- 1: `stdout`
- 2: `stderr`

`SIZE1, SIZE2, SIZE3, SIZE4` are the four bytes of the `uint32` size
encoded as big endian.

Following the header is the payload, which is the specified number of
bytes of `STREAM_TYPE`.

The simplest way to implement this protocol is the following:

1. Read 8 bytes.
2. Choose `stdout` or `stderr` depending on the first byte.
3. Extract the frame size from the last four bytes.
4. Read the extracted size and output it on the correct output.
5. Goto 1.

### Stream format when using a TTY

When the TTY setting is enabled in [`POST /containers/create`](#operation/ContainerCreate),
the stream is not multiplexed. The data exchanged over the hijacked
connection is simply the raw data from the process PTY and client\'s
`stdin`.
''',
      summary: 'Attach to a container',
      operationId: 'ContainerAttach',
      consumes: [],
      produces: [
        "application/vnd.docker.raw-stream",
        "application/vnd.docker.multiplexed-stream",
      ],
      security: [],
      tags: ["Container"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/containers/${id}/attach');
    final Map<String, dynamic> $params = <String, dynamic>{
      'detachKeys': detachKeys,
      'logs': logs,
      'stream': stream,
      'stdin': stdin,
      'stdout': stdout,
      'stderr': stderr,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _containersIdAttachWsGet({
    required String? id,
    String? detachKeys,
    bool? logs,
    bool? stream,
    bool? stdin,
    bool? stdout,
    bool? stderr,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Attach to a container via a websocket',
      operationId: 'ContainerAttachWebsocket',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Container"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/containers/${id}/attach/ws');
    final Map<String, dynamic> $params = <String, dynamic>{
      'detachKeys': detachKeys,
      'logs': logs,
      'stream': stream,
      'stdin': stdin,
      'stdout': stdout,
      'stderr': stderr,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<ContainerWaitResponse>> _containersIdWaitPost({
    required String? id,
    String? condition,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: 'Block until a container stops, then returns the exit code.',
      summary: 'Wait for a container',
      operationId: 'ContainerWait',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Container"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/containers/${id}/wait');
    final Map<String, dynamic> $params = <String, dynamic>{
      'condition': condition,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<ContainerWaitResponse, ContainerWaitResponse>($request);
  }

  @override
  Future<Response<dynamic>> _containersIdDelete({
    required String? id,
    bool? v,
    bool? force,
    bool? link,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Remove a container',
      operationId: 'ContainerDelete',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Container"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/containers/${id}');
    final Map<String, dynamic> $params = <String, dynamic>{
      'v': v,
      'force': force,
      'link': link,
    };
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _containersIdArchiveHead({
    required String? id,
    required String? path,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '''A response header `X-Docker-Container-Path-Stat` is returned, containing
a base64 - encoded JSON object with some filesystem header information
about the path.
''',
      summary: 'Get information about files in a container',
      operationId: 'ContainerArchiveInfo',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Container"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/containers/${id}/archive');
    final Map<String, dynamic> $params = <String, dynamic>{'path': path};
    final Request $request = Request(
      'HEAD',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _containersIdArchiveGet({
    required String? id,
    required String? path,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description:
          'Get a tar archive of a resource in the filesystem of container id.',
      summary: 'Get an archive of a filesystem resource in a container',
      operationId: 'ContainerArchive',
      consumes: [],
      produces: ["application/x-tar"],
      security: [],
      tags: ["Container"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/containers/${id}/archive');
    final Map<String, dynamic> $params = <String, dynamic>{'path': path};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _containersIdArchivePut({
    required String? id,
    required String? path,
    String? noOverwriteDirNonDir,
    String? copyUIDGID,
    required String? inputStream,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '''Upload a tar archive to be extracted to a path in the filesystem of container id.
`path` parameter is asserted to be a directory. If it exists as a file, 400 error
will be returned with message "not a directory".
''',
      summary: 'Extract an archive of files or folders to a directory in a container',
      operationId: 'PutContainerArchive',
      consumes: ["application/x-tar", "application/octet-stream"],
      produces: [],
      security: [],
      tags: ["Container"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/containers/${id}/archive');
    final Map<String, dynamic> $params = <String, dynamic>{
      'path': path,
      'noOverwriteDirNonDir': noOverwriteDirNonDir,
      'copyUIDGID': copyUIDGID,
    };
    final $body = inputStream;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<ContainersPrunePost$Response>> _containersPrunePost({
    String? filters,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Delete stopped containers',
      operationId: 'ContainerPrune',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Container"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/containers/prune');
    final Map<String, dynamic> $params = <String, dynamic>{'filters': filters};
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client
        .send<ContainersPrunePost$Response, ContainersPrunePost$Response>(
          $request,
        );
  }

  @override
  Future<Response<List<ImageSummary>>> _imagesJsonGet({
    bool? all,
    String? filters,
    bool? sharedSize,
    bool? digests,
    bool? manifests,
    bool? identity,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: 'Returns a list of images on the server. Note that it uses a different, smaller representation of an image than inspecting a single image.',
      summary: 'List Images',
      operationId: 'ImageList',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Image"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/images/json');
    final Map<String, dynamic> $params = <String, dynamic>{
      'all': all,
      'filters': filters,
      'shared-size': sharedSize,
      'digests': digests,
      'manifests': manifests,
      'identity': identity,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<List<ImageSummary>, ImageSummary>($request);
  }

  @override
  Future<Response<dynamic>> _buildPost({
    String? inputStream,
    String? dockerfile,
    String? t,
    String? extrahosts,
    String? remote,
    bool? q,
    bool? nocache,
    String? cachefrom,
    String? pull,
    bool? rm,
    bool? forcerm,
    int? memory,
    int? memswap,
    int? cpushares,
    String? cpusetcpus,
    int? cpuperiod,
    int? cpuquota,
    String? buildargs,
    int? shmsize,
    bool? squash,
    String? labels,
    String? networkmode,
    String? contentType,
    String? xRegistryConfig,
    String? platform,
    String? target,
    String? outputs,
    String? version,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description:
          '''Build an image from a tar archive with a `Dockerfile` in it.

The `Dockerfile` specifies how the image is built from the tar archive. It is typically in the archive\'s root, but can be at a different path or have a different name by specifying the `dockerfile` parameter. [See the `Dockerfile` reference for more information](https://docs.docker.com/engine/reference/builder/).

The Docker daemon performs a preliminary validation of the `Dockerfile` before starting the build, and returns an error if the syntax is incorrect. After that, each instruction is run one-by-one until the ID of the new image is output.

The build is canceled if the client drops the connection by quitting or being killed.
''',
      summary: 'Build an image',
      operationId: 'ImageBuild',
      consumes: ["application/octet-stream"],
      produces: ["application/json"],
      security: [],
      tags: ["Image"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/build');
    final Map<String, dynamic> $params = <String, dynamic>{
      'dockerfile': dockerfile,
      't': t,
      'extrahosts': extrahosts,
      'remote': remote,
      'q': q,
      'nocache': nocache,
      'cachefrom': cachefrom,
      'pull': pull,
      'rm': rm,
      'forcerm': forcerm,
      'memory': memory,
      'memswap': memswap,
      'cpushares': cpushares,
      'cpusetcpus': cpusetcpus,
      'cpuperiod': cpuperiod,
      'cpuquota': cpuquota,
      'buildargs': buildargs,
      'shmsize': shmsize,
      'squash': squash,
      'labels': labels,
      'networkmode': networkmode,
      'platform': platform,
      'target': target,
      'outputs': outputs,
      'version': version,
    };
    final Map<String, String> $headers = {
      if (contentType != null) 'Content-type': contentType,
      if (xRegistryConfig != null) 'X-Registry-Config': xRegistryConfig,
    };
    final $body = inputStream;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      parameters: $params,
      headers: $headers,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<BuildPrunePost$Response>> _buildPrunePost({
    int? reservedSpace,
    int? maxUsedSpace,
    int? minFreeSpace,
    bool? all,
    String? filters,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Delete builder cache',
      operationId: 'BuildPrune',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Image"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/build/prune');
    final Map<String, dynamic> $params = <String, dynamic>{
      'reserved-space': reservedSpace,
      'max-used-space': maxUsedSpace,
      'min-free-space': minFreeSpace,
      'all': all,
      'filters': filters,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<BuildPrunePost$Response, BuildPrunePost$Response>(
      $request,
    );
  }

  @override
  Future<Response<dynamic>> _imagesCreatePost({
    String? fromImage,
    String? fromSrc,
    String? repo,
    String? tag,
    String? message,
    String? inputImage,
    String? xRegistryAuth,
    List<String>? changes,
    String? platform,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: 'Pull or import an image.',
      summary: 'Create an image',
      operationId: 'ImageCreate',
      consumes: ["text/plain", "application/octet-stream"],
      produces: ["application/json"],
      security: [],
      tags: ["Image"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/images/create');
    final Map<String, dynamic> $params = <String, dynamic>{
      'fromImage': fromImage,
      'fromSrc': fromSrc,
      'repo': repo,
      'tag': tag,
      'message': message,
      'changes': changes,
      'platform': platform,
    };
    final Map<String, String> $headers = {
      if (xRegistryAuth != null) 'X-Registry-Auth': xRegistryAuth,
    };
    final $body = inputImage;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      parameters: $params,
      headers: $headers,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<ImageInspect>> _imagesNameJsonGet({
    required String? name,
    bool? manifests,
    String? platform,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: 'Return low-level information about an image.',
      summary: 'Inspect an image',
      operationId: 'ImageInspect',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Image"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/images/${name}/json');
    final Map<String, dynamic> $params = <String, dynamic>{
      'manifests': manifests,
      'platform': platform,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<ImageInspect, ImageInspect>($request);
  }

  @override
  Future<Response<List<AttestationStatement>>> _imagesNameAttestationsGet({
    required String? name,
    List<String>? platform,
    List<String>? type,
    bool? statement,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '''Return the in-toto attestation statements attached to the image for the
given platform. The daemon locates the attestation manifest(s) that
reference the matching platform image manifest, reads their statement
layers, and returns the verbatim statement JSON together with layer
metadata.

If the image has no attestations an empty array is returned.
''',
      summary: 'Get attestation statements for an image',
      operationId: 'ImageAttestations',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Image"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/images/${name}/attestations');
    final Map<String, dynamic> $params = <String, dynamic>{
      'platform': platform,
      'type': type,
      'statement': statement,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<List<AttestationStatement>, AttestationStatement>(
      $request,
    );
  }

  @override
  Future<Response<List<ImageHistoryResponseItem>>> _imagesNameHistoryGet({
    required String? name,
    String? platform,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: 'Return parent layers of an image.',
      summary: 'Get the history of an image',
      operationId: 'ImageHistory',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Image"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/images/${name}/history');
    final Map<String, dynamic> $params = <String, dynamic>{
      'platform': platform,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client
        .send<List<ImageHistoryResponseItem>, ImageHistoryResponseItem>(
          $request,
        );
  }

  @override
  Future<Response<dynamic>> _imagesNamePushPost({
    required String? name,
    String? tag,
    String? platform,
    String? xRegistryAuth,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '''Push an image to a registry.

If you wish to push an image on to a private registry, that image must
already have a tag which references the registry. For example,
`registry.example.com/myimage:latest`.

The push is cancelled if the HTTP connection is closed.
''',
      summary: 'Push an image',
      operationId: 'ImagePush',
      consumes: ["application/octet-stream"],
      produces: [],
      security: [],
      tags: ["Image"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/images/${name}/push');
    final Map<String, dynamic> $params = <String, dynamic>{
      'tag': tag,
      'platform': platform,
    };
    final Map<String, String> $headers = {
      if (xRegistryAuth != null) 'X-Registry-Auth': xRegistryAuth,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
      headers: $headers,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _imagesNameTagPost({
    required String? name,
    String? repo,
    String? tag,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '''Create a tag that refers to a source image.

This creates an additional reference (tag) to the source image. The tag
can include a different repository name and/or tag. If the repository
or tag already exists, it will be overwritten.
''',
      summary: 'Tag an image',
      operationId: 'ImageTag',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Image"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/images/${name}/tag');
    final Map<String, dynamic> $params = <String, dynamic>{
      'repo': repo,
      'tag': tag,
    };
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<ImageDeleteResponseItem>>> _imagesNameDelete({
    required String? name,
    bool? force,
    bool? noprune,
    List<String>? platforms,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description:
          '''Remove an image, along with any untagged parent images that were
referenced by that image.

Images can\'t be removed if they have descendant images, are being
used by a running container or are being used by a build.
''',
      summary: 'Remove an image',
      operationId: 'ImageDelete',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Image"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/images/${name}');
    final Map<String, dynamic> $params = <String, dynamic>{
      'force': force,
      'noprune': noprune,
      'platforms': platforms,
    };
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<List<ImageDeleteResponseItem>, ImageDeleteResponseItem>(
      $request,
    );
  }

  @override
  Future<Response<List<dynamic>>> _imagesSearchGet({
    required String? term,
    int? limit,
    String? filters,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: 'Search for an image on Docker Hub.',
      summary: 'Search images',
      operationId: 'ImageSearch',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Image"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/images/search');
    final Map<String, dynamic> $params = <String, dynamic>{
      'term': term,
      'limit': limit,
      'filters': filters,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<List<dynamic>, List<dynamic>>($request);
  }

  @override
  Future<Response<ImagesPrunePost$Response>> _imagesPrunePost({
    String? filters,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Delete unused images',
      operationId: 'ImagePrune',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Image"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/images/prune');
    final Map<String, dynamic> $params = <String, dynamic>{'filters': filters};
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<ImagesPrunePost$Response, ImagesPrunePost$Response>(
      $request,
    );
  }

  @override
  Future<Response<AuthResponse>> _authPost({
    AuthConfig? authConfig,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '''Validate credentials for a registry and, if available, get an identity
token for accessing the registry without password.
''',
      summary: 'Check auth configuration',
      operationId: 'SystemAuth',
      consumes: ["application/json"],
      produces: ["application/json"],
      security: [],
      tags: ["System"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/auth');
    final $body = authConfig;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<AuthResponse, AuthResponse>($request);
  }

  @override
  Future<Response<SystemInfo>> _infoGet({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Get system information',
      operationId: 'SystemInfo',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["System"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/info');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<SystemInfo, SystemInfo>($request);
  }

  @override
  Future<Response<SystemVersion>> _versionGet({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: 'Returns the version of Docker that is running and various information about the system that Docker is running on.',
      summary: 'Get version',
      operationId: 'SystemVersion',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["System"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/version');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<SystemVersion, SystemVersion>($request);
  }

  @override
  Future<Response<String>> _pingGet({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: 'This is a dummy endpoint you can use to test if the server is accessible.',
      summary: 'Ping',
      operationId: 'SystemPing',
      consumes: [],
      produces: ["text/plain"],
      security: [],
      tags: ["System"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/_ping');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<String, String>($request);
  }

  @override
  Future<Response<String>> _pingHead({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: 'This is a dummy endpoint you can use to test if the server is accessible.',
      summary: 'Ping',
      operationId: 'SystemPingHead',
      consumes: [],
      produces: ["text/plain"],
      security: [],
      tags: ["System"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/_ping');
    final Request $request = Request(
      'HEAD',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<String, String>($request);
  }

  @override
  Future<Response<IDResponse>> _commitPost({
    ContainerConfig? containerConfig,
    String? container,
    String? repo,
    String? tag,
    String? comment,
    String? author,
    bool? pause,
    String? changes,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Create a new image from a container',
      operationId: 'ImageCommit',
      consumes: ["application/json"],
      produces: ["application/json"],
      security: [],
      tags: ["Image"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/commit');
    final Map<String, dynamic> $params = <String, dynamic>{
      'container': container,
      'repo': repo,
      'tag': tag,
      'comment': comment,
      'author': author,
      'pause': pause,
      'changes': changes,
    };
    final $body = containerConfig;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<IDResponse, IDResponse>($request);
  }

  @override
  Future<Response<EventMessage>> _eventsGet({
    String? since,
    String? until,
    String? filters,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '''Stream real-time events from the server.

Various objects within Docker report events when something happens to them.

Containers report these events: `attach`, `commit`, `copy`, `create`, `destroy`, `detach`, `die`, `exec_create`, `exec_detach`, `exec_start`, `exec_die`, `export`, `health_status`, `kill`, `oom`, `pause`, `rename`, `resize`, `restart`, `start`, `stop`, `top`, `unpause`, `update`, and `prune`

Images report these events: `create`, `delete`, `import`, `load`, `pull`, `push`, `save`, `tag`, `untag`, and `prune`

Volumes report these events: `create`, `mount`, `unmount`, `destroy`, and `prune`

Networks report these events: `create`, `connect`, `disconnect`, `destroy`, `update`, `remove`, and `prune`

The Docker daemon reports these events: `reload`

Services report these events: `create`, `update`, and `remove`

Nodes report these events: `create`, `update`, and `remove`

Secrets report these events: `create`, `update`, and `remove`

Configs report these events: `create`, `update`, and `remove`

The Builder reports `prune` events
''',
      summary: 'Monitor events',
      operationId: 'SystemEvents',
      consumes: [],
      produces: [
        "application/jsonl",
        "application/x-ndjson",
        "application/json-seq",
      ],
      security: [],
      tags: ["System"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/events');
    final Map<String, dynamic> $params = <String, dynamic>{
      'since': since,
      'until': until,
      'filters': filters,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<EventMessage, EventMessage>($request);
  }

  @override
  Future<Response<SystemDfGet$Response>> _systemDfGet({
    List<Object?>? type,
    bool? verbose,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Get data usage information',
      operationId: 'SystemDataUsage',
      consumes: [],
      produces: [],
      security: [],
      tags: ["System"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/system/df');
    final Map<String, dynamic> $params = <String, dynamic>{
      'type': type,
      'verbose': verbose,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<SystemDfGet$Response, SystemDfGet$Response>($request);
  }

  @override
  Future<Response<String>> _imagesNameGetGet({
    required String? name,
    List<String>? platform,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description:
          '''Get a tarball containing all images and metadata for a repository.

If `name` is a specific name and tag (e.g. `ubuntu:latest`), then only that image (and its parents) are returned. If `name` is an image ID, similarly only that image (and its parents) are returned, but with the exclusion of the `repositories` file in the tarball, as there were no image names referenced.

### Image tarball format

An image tarball contains [Content as defined in the OCI Image Layout Specification](https://github.com/opencontainers/image-spec/blob/v1.1.1/image-layout.md#content).

Additionally, includes the manifest.json file associated with a backwards compatible docker save format.

If the tarball defines a repository, the tarball should also include a `repositories` file at the root that contains a list of repository and tag names mapped to layer IDs.

```json
{
  "hello-world": {
    "latest": "565a9d68a73f6706862bfe8409a7f659776d4d60a8d096eb4a3cbce6999cc2a1"
  }
}
```
''',
      summary: 'Export an image',
      operationId: 'ImageGet',
      consumes: [],
      produces: ["application/x-tar"],
      security: [],
      tags: ["Image"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/images/${name}/get');
    final Map<String, dynamic> $params = <String, dynamic>{
      'platform': platform,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<String, String>($request);
  }

  @override
  Future<Response<String>> _imagesGetGet({
    List<String>? names,
    List<String>? platform,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description:
          '''Get a tarball containing all images and metadata for several image
repositories.

For each value of the `names` parameter: if it is a specific name and
tag (e.g. `ubuntu:latest`), then only that image (and its parents) are
returned; if it is an image ID, similarly only that image (and its parents)
are returned and there would be no names referenced in the \'repositories\'
file for this image ID.

For details on the format, see the [export image endpoint](#operation/ImageGet).
''',
      summary: 'Export several images',
      operationId: 'ImageGetAll',
      consumes: [],
      produces: ["application/x-tar"],
      security: [],
      tags: ["Image"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/images/get');
    final Map<String, dynamic> $params = <String, dynamic>{
      'names': names,
      'platform': platform,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<String, String>($request);
  }

  @override
  Future<Response<dynamic>> _imagesLoadPost({
    String? imagesTarball,
    bool? quiet,
    List<String>? platform,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '''Load a set of images and tags into a repository.

For details on the format, see the [export image endpoint](#operation/ImageGet).
''',
      summary: 'Import images',
      operationId: 'ImageLoad',
      consumes: ["application/x-tar"],
      produces: ["application/json"],
      security: [],
      tags: ["Image"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/images/load');
    final Map<String, dynamic> $params = <String, dynamic>{
      'quiet': quiet,
      'platform': platform,
    };
    final $body = imagesTarball;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<IDResponse>> _containersIdExecPost({
    required Object? execConfig,
    required String? id,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: 'Run a command inside a running container.',
      summary: 'Create an exec instance',
      operationId: 'ContainerExec',
      consumes: ["application/json"],
      produces: ["application/json"],
      security: [],
      tags: ["Exec"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/containers/${id}/exec');
    final $body = execConfig;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<IDResponse, IDResponse>($request);
  }

  @override
  Future<Response<dynamic>> _execIdStartPost({
    Object? execStartConfig,
    required String? id,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '''Starts a previously set up exec instance. If detach is true, this endpoint
returns immediately after starting the command. Otherwise, it sets up an
interactive session with the command.
''',
      summary: 'Start an exec instance',
      operationId: 'ExecStart',
      consumes: ["application/json"],
      produces: [
        "application/vnd.docker.raw-stream",
        "application/vnd.docker.multiplexed-stream",
      ],
      security: [],
      tags: ["Exec"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/exec/${id}/start');
    final $body = execStartConfig;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _execIdResizePost({
    required String? id,
    required int? h,
    required int? w,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '''Resize the TTY session used by an exec instance. This endpoint only works
if `tty` was specified as part of creating and starting the exec instance.
''',
      summary: 'Resize an exec instance',
      operationId: 'ExecResize',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Exec"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/exec/${id}/resize');
    final Map<String, dynamic> $params = <String, dynamic>{'h': h, 'w': w};
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<ExecIdJsonGet$Response>> _execIdJsonGet({
    required String? id,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: 'Return low-level information about an exec instance.',
      summary: 'Inspect an exec instance',
      operationId: 'ExecInspect',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Exec"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/exec/${id}/json');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<ExecIdJsonGet$Response, ExecIdJsonGet$Response>(
      $request,
    );
  }

  @override
  Future<Response<VolumeListResponse>> _volumesGet({
    String? filters,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'List volumes',
      operationId: 'VolumeList',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Volume"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/volumes');
    final Map<String, dynamic> $params = <String, dynamic>{'filters': filters};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<VolumeListResponse, VolumeListResponse>($request);
  }

  @override
  Future<Response<Volume>> _volumesCreatePost({
    required VolumeCreateRequest? volumeConfig,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Create a volume',
      operationId: 'VolumeCreate',
      consumes: ["application/json"],
      produces: ["application/json"],
      security: [],
      tags: ["Volume"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/volumes/create');
    final $body = volumeConfig;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<Volume, Volume>($request);
  }

  @override
  Future<Response<Volume>> _volumesNameGet({
    required String? name,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Inspect a volume',
      operationId: 'VolumeInspect',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Volume"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/volumes/${name}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<Volume, Volume>($request);
  }

  @override
  Future<Response<dynamic>> _volumesNamePut({
    required String? name,
    Object? body,
    required int? version,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: '''"Update a volume. Valid only for Swarm cluster volumes"
''',
      operationId: 'VolumeUpdate',
      consumes: ["application/json"],
      produces: ["application/json"],
      security: [],
      tags: ["Volume"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/volumes/${name}');
    final Map<String, dynamic> $params = <String, dynamic>{'version': version};
    final $body = body;
    final Request $request = Request(
      'PUT',
      $url,
      client.baseUrl,
      body: $body,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _volumesNameDelete({
    required String? name,
    bool? force,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: 'Instruct the driver to remove the volume.',
      summary: 'Remove a volume',
      operationId: 'VolumeDelete',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Volume"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/volumes/${name}');
    final Map<String, dynamic> $params = <String, dynamic>{'force': force};
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<VolumesPrunePost$Response>> _volumesPrunePost({
    String? filters,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Delete unused volumes',
      operationId: 'VolumePrune',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Volume"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/volumes/prune');
    final Map<String, dynamic> $params = <String, dynamic>{'filters': filters};
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<VolumesPrunePost$Response, VolumesPrunePost$Response>(
      $request,
    );
  }

  @override
  Future<Response<List<NetworkSummary>>> _networksGet({
    String? filters,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description:
          '''Returns a list of networks. For details on the format, see the
[network inspect endpoint](#operation/NetworkInspect).

Note that it uses a different, smaller representation of a network than
inspecting a single network. For example, the list of containers attached
to the network is not propagated in API versions 1.28 and up.
''',
      summary: 'List networks',
      operationId: 'NetworkList',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Network"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/networks');
    final Map<String, dynamic> $params = <String, dynamic>{'filters': filters};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<List<NetworkSummary>, NetworkSummary>($request);
  }

  @override
  Future<Response<NetworkInspect>> _networksIdGet({
    required String? id,
    bool? verbose,
    String? scope,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Inspect a network',
      operationId: 'NetworkInspect',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Network"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/networks/${id}');
    final Map<String, dynamic> $params = <String, dynamic>{
      'verbose': verbose,
      'scope': scope,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<NetworkInspect, NetworkInspect>($request);
  }

  @override
  Future<Response<dynamic>> _networksIdDelete({
    required String? id,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Remove a network',
      operationId: 'NetworkDelete',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Network"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/networks/${id}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<NetworkCreateResponse>> _networksCreatePost({
    required Object? networkConfig,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Create a network',
      operationId: 'NetworkCreate',
      consumes: ["application/json"],
      produces: ["application/json"],
      security: [],
      tags: ["Network"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/networks/create');
    final $body = networkConfig;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<NetworkCreateResponse, NetworkCreateResponse>($request);
  }

  @override
  Future<Response<dynamic>> _networksIdConnectPost({
    required String? id,
    required NetworkConnectRequest? container,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: 'The network must be either a local-scoped network or a swarm-scoped network with the `attachable` option set. A network cannot be re-attached to a running container',
      summary: 'Connect a container to a network',
      operationId: 'NetworkConnect',
      consumes: ["application/json"],
      produces: [],
      security: [],
      tags: ["Network"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/networks/${id}/connect');
    final $body = container;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _networksIdDisconnectPost({
    required String? id,
    required NetworkDisconnectRequest? container,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Disconnect a container from a network',
      operationId: 'NetworkDisconnect',
      consumes: ["application/json"],
      produces: [],
      security: [],
      tags: ["Network"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/networks/${id}/disconnect');
    final $body = container;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<NetworksPrunePost$Response>> _networksPrunePost({
    String? filters,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Delete unused networks',
      operationId: 'NetworkPrune',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Network"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/networks/prune');
    final Map<String, dynamic> $params = <String, dynamic>{'filters': filters};
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<NetworksPrunePost$Response, NetworksPrunePost$Response>(
      $request,
    );
  }

  @override
  Future<Response<List<Plugin>>> _pluginsGet({
    String? filters,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: 'Returns information about installed plugins.',
      summary: 'List plugins',
      operationId: 'PluginList',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Plugin"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/plugins');
    final Map<String, dynamic> $params = <String, dynamic>{'filters': filters};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<List<Plugin>, Plugin>($request);
  }

  @override
  Future<Response<List<PluginPrivilege>>> _pluginsPrivilegesGet({
    required String? remote,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Get plugin privileges',
      operationId: 'GetPluginPrivileges',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Plugin"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/plugins/privileges');
    final Map<String, dynamic> $params = <String, dynamic>{'remote': remote};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<List<PluginPrivilege>, PluginPrivilege>($request);
  }

  @override
  Future<Response<dynamic>> _pluginsPullPost({
    required String? remote,
    String? name,
    String? xRegistryAuth,
    List<PluginPrivilege>? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '''Pulls and installs a plugin. After the plugin is installed, it can be
enabled using the [`POST /plugins/{name}/enable` endpoint](#operation/PostPluginsEnable).
''',
      summary: 'Install a plugin',
      operationId: 'PluginPull',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Plugin"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/plugins/pull');
    final Map<String, dynamic> $params = <String, dynamic>{
      'remote': remote,
      'name': name,
    };
    final Map<String, String> $headers = {
      if (xRegistryAuth != null) 'X-Registry-Auth': xRegistryAuth,
    };
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      parameters: $params,
      headers: $headers,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<Plugin>> _pluginsNameJsonGet({
    required String? name,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Inspect a plugin',
      operationId: 'PluginInspect',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Plugin"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/plugins/${name}/json');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<Plugin, Plugin>($request);
  }

  @override
  Future<Response<Plugin>> _pluginsNameDelete({
    required String? name,
    bool? force,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Remove a plugin',
      operationId: 'PluginDelete',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Plugin"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/plugins/${name}');
    final Map<String, dynamic> $params = <String, dynamic>{'force': force};
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<Plugin, Plugin>($request);
  }

  @override
  Future<Response<dynamic>> _pluginsNameEnablePost({
    required String? name,
    int? timeout,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Enable a plugin',
      operationId: 'PluginEnable',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Plugin"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/plugins/${name}/enable');
    final Map<String, dynamic> $params = <String, dynamic>{'timeout': timeout};
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _pluginsNameDisablePost({
    required String? name,
    bool? force,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Disable a plugin',
      operationId: 'PluginDisable',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Plugin"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/plugins/${name}/disable');
    final Map<String, dynamic> $params = <String, dynamic>{'force': force};
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _pluginsNameUpgradePost({
    required String? name,
    required String? remote,
    String? xRegistryAuth,
    List<PluginPrivilege>? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Upgrade a plugin',
      operationId: 'PluginUpgrade',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Plugin"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/plugins/${name}/upgrade');
    final Map<String, dynamic> $params = <String, dynamic>{'remote': remote};
    final Map<String, String> $headers = {
      if (xRegistryAuth != null) 'X-Registry-Auth': xRegistryAuth,
    };
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      parameters: $params,
      headers: $headers,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _pluginsCreatePost({
    required String? name,
    String? tarContext,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Create a plugin',
      operationId: 'PluginCreate',
      consumes: ["application/x-tar"],
      produces: ["application/json"],
      security: [],
      tags: ["Plugin"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/plugins/create');
    final Map<String, dynamic> $params = <String, dynamic>{'name': name};
    final $body = tarContext;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _pluginsNamePushPost({
    required String? name,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '''Push a plugin to the registry.
''',
      summary: 'Push a plugin',
      operationId: 'PluginPush',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Plugin"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/plugins/${name}/push');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _pluginsNameSetPost({
    required String? name,
    List<String>? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Configure a plugin',
      operationId: 'PluginSet',
      consumes: ["application/json"],
      produces: ["application/json"],
      security: [],
      tags: ["Plugin"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/plugins/${name}/set');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<Node>>> _nodesGet({
    String? filters,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'List nodes',
      operationId: 'NodeList',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Node"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/nodes');
    final Map<String, dynamic> $params = <String, dynamic>{'filters': filters};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<List<Node>, Node>($request);
  }

  @override
  Future<Response<Node>> _nodesIdGet({
    required String? id,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Inspect a node',
      operationId: 'NodeInspect',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Node"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/nodes/${id}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<Node, Node>($request);
  }

  @override
  Future<Response<dynamic>> _nodesIdDelete({
    required String? id,
    bool? force,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Delete a node',
      operationId: 'NodeDelete',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Node"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/nodes/${id}');
    final Map<String, dynamic> $params = <String, dynamic>{'force': force};
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _nodesIdUpdatePost({
    required String? id,
    NodeSpec? body,
    required int? version,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Update a node',
      operationId: 'NodeUpdate',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Node"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/nodes/${id}/update');
    final Map<String, dynamic> $params = <String, dynamic>{'version': version};
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<Swarm>> _swarmGet({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Inspect swarm',
      operationId: 'SwarmInspect',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Swarm"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/swarm');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<Swarm, Swarm>($request);
  }

  @override
  Future<Response<String>> _swarmInitPost({
    required Object? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Initialize a new swarm',
      operationId: 'SwarmInit',
      consumes: [],
      produces: ["application/json", "text/plain"],
      security: [],
      tags: ["Swarm"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/swarm/init');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<String, String>($request);
  }

  @override
  Future<Response<dynamic>> _swarmJoinPost({
    required Object? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Join an existing swarm',
      operationId: 'SwarmJoin',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Swarm"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/swarm/join');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _swarmLeavePost({
    bool? force,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Leave a swarm',
      operationId: 'SwarmLeave',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Swarm"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/swarm/leave');
    final Map<String, dynamic> $params = <String, dynamic>{'force': force};
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _swarmUpdatePost({
    required SwarmSpec? body,
    required int? version,
    bool? rotateWorkerToken,
    bool? rotateManagerToken,
    bool? rotateManagerUnlockKey,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Update a swarm',
      operationId: 'SwarmUpdate',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Swarm"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/swarm/update');
    final Map<String, dynamic> $params = <String, dynamic>{
      'version': version,
      'rotateWorkerToken': rotateWorkerToken,
      'rotateManagerToken': rotateManagerToken,
      'rotateManagerUnlockKey': rotateManagerUnlockKey,
    };
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<SwarmUnlockkeyGet$Response>> _swarmUnlockkeyGet({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Get the unlock key',
      operationId: 'SwarmUnlockkey',
      consumes: ["application/json"],
      produces: [],
      security: [],
      tags: ["Swarm"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/swarm/unlockkey');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<SwarmUnlockkeyGet$Response, SwarmUnlockkeyGet$Response>(
      $request,
    );
  }

  @override
  Future<Response<dynamic>> _swarmUnlockPost({
    required Object? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Unlock a locked manager',
      operationId: 'SwarmUnlock',
      consumes: ["application/json"],
      produces: ["application/json"],
      security: [],
      tags: ["Swarm"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/swarm/unlock');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<Service>>> _servicesGet({
    String? filters,
    bool? status,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'List services',
      operationId: 'ServiceList',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Service"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/services');
    final Map<String, dynamic> $params = <String, dynamic>{
      'filters': filters,
      'status': status,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<List<Service>, Service>($request);
  }

  @override
  Future<Response<ServiceCreateResponse>> _servicesCreatePost({
    required Object? body,
    String? xRegistryAuth,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Create a service',
      operationId: 'ServiceCreate',
      consumes: ["application/json"],
      produces: ["application/json"],
      security: [],
      tags: ["Service"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/services/create');
    final Map<String, String> $headers = {
      if (xRegistryAuth != null) 'X-Registry-Auth': xRegistryAuth,
    };
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      headers: $headers,
      tag: swaggerMetaData,
    );
    return client.send<ServiceCreateResponse, ServiceCreateResponse>($request);
  }

  @override
  Future<Response<Service>> _servicesIdGet({
    required String? id,
    bool? insertDefaults,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Inspect a service',
      operationId: 'ServiceInspect',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Service"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/services/${id}');
    final Map<String, dynamic> $params = <String, dynamic>{
      'insertDefaults': insertDefaults,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<Service, Service>($request);
  }

  @override
  Future<Response<dynamic>> _servicesIdDelete({
    required String? id,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Delete a service',
      operationId: 'ServiceDelete',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Service"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/services/${id}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<ServiceUpdateResponse>> _servicesIdUpdatePost({
    required String? id,
    required Object? body,
    required int? version,
    String? registryAuthFrom,
    String? rollback,
    String? xRegistryAuth,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Update a service',
      operationId: 'ServiceUpdate',
      consumes: ["application/json"],
      produces: ["application/json"],
      security: [],
      tags: ["Service"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/services/${id}/update');
    final Map<String, dynamic> $params = <String, dynamic>{
      'version': version,
      'registryAuthFrom': registryAuthFrom,
      'rollback': rollback,
    };
    final Map<String, String> $headers = {
      if (xRegistryAuth != null) 'X-Registry-Auth': xRegistryAuth,
    };
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      parameters: $params,
      headers: $headers,
      tag: swaggerMetaData,
    );
    return client.send<ServiceUpdateResponse, ServiceUpdateResponse>($request);
  }

  @override
  Future<Response<String>> _servicesIdLogsGet({
    required String? id,
    bool? details,
    bool? follow,
    bool? stdout,
    bool? stderr,
    int? since,
    bool? timestamps,
    String? tail,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '''Get `stdout` and `stderr` logs from a service. See also
[`/containers/{id}/logs`](#operation/ContainerLogs).

**Note**: This endpoint works only for services with the `local`,
`json-file` or `journald` logging drivers.
''',
      summary: 'Get service logs',
      operationId: 'ServiceLogs',
      consumes: [],
      produces: [
        "application/vnd.docker.raw-stream",
        "application/vnd.docker.multiplexed-stream",
      ],
      security: [],
      tags: ["Service"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/services/${id}/logs');
    final Map<String, dynamic> $params = <String, dynamic>{
      'details': details,
      'follow': follow,
      'stdout': stdout,
      'stderr': stderr,
      'since': since,
      'timestamps': timestamps,
      'tail': tail,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<String, String>($request);
  }

  @override
  Future<Response<List<Task>>> _tasksGet({
    String? filters,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'List tasks',
      operationId: 'TaskList',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Task"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/tasks');
    final Map<String, dynamic> $params = <String, dynamic>{'filters': filters};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<List<Task>, Task>($request);
  }

  @override
  Future<Response<Task>> _tasksIdGet({
    required String? id,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Inspect a task',
      operationId: 'TaskInspect',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Task"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/tasks/${id}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<Task, Task>($request);
  }

  @override
  Future<Response<String>> _tasksIdLogsGet({
    required String? id,
    bool? details,
    bool? follow,
    bool? stdout,
    bool? stderr,
    int? since,
    bool? timestamps,
    String? tail,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '''Get `stdout` and `stderr` logs from a task.
See also [`/containers/{id}/logs`](#operation/ContainerLogs).

**Note**: This endpoint works only for services with the `local`,
`json-file` or `journald` logging drivers.
''',
      summary: 'Get task logs',
      operationId: 'TaskLogs',
      consumes: [],
      produces: [
        "application/vnd.docker.raw-stream",
        "application/vnd.docker.multiplexed-stream",
      ],
      security: [],
      tags: ["Task"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/tasks/${id}/logs');
    final Map<String, dynamic> $params = <String, dynamic>{
      'details': details,
      'follow': follow,
      'stdout': stdout,
      'stderr': stderr,
      'since': since,
      'timestamps': timestamps,
      'tail': tail,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<String, String>($request);
  }

  @override
  Future<Response<List<Secret>>> _secretsGet({
    String? filters,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'List secrets',
      operationId: 'SecretList',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Secret"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/secrets');
    final Map<String, dynamic> $params = <String, dynamic>{'filters': filters};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<List<Secret>, Secret>($request);
  }

  @override
  Future<Response<IDResponse>> _secretsCreatePost({
    Object? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Create a secret',
      operationId: 'SecretCreate',
      consumes: ["application/json"],
      produces: ["application/json"],
      security: [],
      tags: ["Secret"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/secrets/create');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<IDResponse, IDResponse>($request);
  }

  @override
  Future<Response<Secret>> _secretsIdGet({
    required String? id,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Inspect a secret',
      operationId: 'SecretInspect',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Secret"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/secrets/${id}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<Secret, Secret>($request);
  }

  @override
  Future<Response<dynamic>> _secretsIdDelete({
    required String? id,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Delete a secret',
      operationId: 'SecretDelete',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Secret"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/secrets/${id}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _secretsIdUpdatePost({
    required String? id,
    SecretSpec? body,
    required int? version,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Update a Secret',
      operationId: 'SecretUpdate',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Secret"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/secrets/${id}/update');
    final Map<String, dynamic> $params = <String, dynamic>{'version': version};
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<Config>>> _configsGet({
    String? filters,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'List configs',
      operationId: 'ConfigList',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Config"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/configs');
    final Map<String, dynamic> $params = <String, dynamic>{'filters': filters};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<List<Config>, Config>($request);
  }

  @override
  Future<Response<IDResponse>> _configsCreatePost({
    Object? body,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Create a config',
      operationId: 'ConfigCreate',
      consumes: ["application/json"],
      produces: ["application/json"],
      security: [],
      tags: ["Config"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/configs/create');
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      tag: swaggerMetaData,
    );
    return client.send<IDResponse, IDResponse>($request);
  }

  @override
  Future<Response<Config>> _configsIdGet({
    required String? id,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Inspect a config',
      operationId: 'ConfigInspect',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Config"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/configs/${id}');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<Config, Config>($request);
  }

  @override
  Future<Response<dynamic>> _configsIdDelete({
    required String? id,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Delete a config',
      operationId: 'ConfigDelete',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Config"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/configs/${id}');
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _configsIdUpdatePost({
    required String? id,
    ConfigSpec? body,
    required int? version,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '',
      summary: 'Update a Config',
      operationId: 'ConfigUpdate',
      consumes: [],
      produces: [],
      security: [],
      tags: ["Config"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/configs/${id}/update');
    final Map<String, dynamic> $params = <String, dynamic>{'version': version};
    final $body = body;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      parameters: $params,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<DistributionInspect>> _distributionNameJsonGet({
    required String? name,
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '''Return image digest and platform information by contacting the registry.
''',
      summary: 'Get image information from the registry',
      operationId: 'DistributionInspect',
      consumes: [],
      produces: ["application/json"],
      security: [],
      tags: ["Distribution"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/distribution/${name}/json');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<DistributionInspect, DistributionInspect>($request);
  }

  @override
  Future<Response<dynamic>> _sessionPost({
    SwaggerMetaData swaggerMetaData = const SwaggerMetaData(
      description: '''Start a new interactive session with a server. Session allows server to
call back to the client for advanced capabilities.

> **Deprecated**: This endpoint is deprecated and will be removed in a future version.
> Server should support gRPC directly on the listening socket.

### Hijacking

This endpoint hijacks the HTTP connection to HTTP2 transport that allows
the client to expose gPRC services on that connection.

For example, the client sends this request to upgrade the connection:

```
POST /session HTTP/1.1
Upgrade: h2c
Connection: Upgrade
```

The Docker daemon responds with a `101 UPGRADED` response follow with
the raw stream:

```
HTTP/1.1 101 UPGRADED
Connection: Upgrade
Upgrade: h2c
```
''',
      summary: 'Initialize interactive session',
      operationId: 'Session',
      consumes: [],
      produces: ["application/vnd.docker.raw-stream"],
      security: [],
      tags: ["Session"],
      deprecated: false,
    ),
  }) {
    final Uri $url = Uri.parse('/session');
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      tag: swaggerMetaData,
    );
    return client.send<dynamic, dynamic>($request);
  }
}
