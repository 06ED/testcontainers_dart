// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

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
    );
    return client.send<List<ContainerSummary>, ContainerSummary>($request);
  }

  @override
  Future<Response<ContainerCreateResponse>> _containersCreatePost({
    String? name,
    String? platform,
    required Object? body,
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
    );
    return client.send<ContainerCreateResponse, ContainerCreateResponse>(
      $request,
    );
  }

  @override
  Future<Response<ContainerInspectResponse>> _containersIdJsonGet({
    required String? id,
    bool? size,
  }) {
    final Uri $url = Uri.parse('/containers/${id}/json');
    final Map<String, dynamic> $params = <String, dynamic>{'size': size};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<ContainerInspectResponse, ContainerInspectResponse>(
      $request,
    );
  }

  @override
  Future<Response<ContainerTopResponse>> _containersIdTopGet({
    required String? id,
    String? psArgs,
  }) {
    final Uri $url = Uri.parse('/containers/${id}/top');
    final Map<String, dynamic> $params = <String, dynamic>{'ps_args': psArgs};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
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
    );
    return client.send<String, String>($request);
  }

  @override
  Future<Response<List<FilesystemChange>>> _containersIdChangesGet({
    required String? id,
  }) {
    final Uri $url = Uri.parse('/containers/${id}/changes');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<List<FilesystemChange>, FilesystemChange>($request);
  }

  @override
  Future<Response<dynamic>> _containersIdExportGet({required String? id}) {
    final Uri $url = Uri.parse('/containers/${id}/export');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<ContainerStatsResponse>> _containersIdStatsGet({
    required String? id,
    bool? stream,
    bool? oneShot,
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
  }) {
    final Uri $url = Uri.parse('/containers/${id}/resize');
    final Map<String, dynamic> $params = <String, dynamic>{'h': h, 'w': w};
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _containersIdStartPost({
    required String? id,
    String? detachKeys,
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
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _containersIdStopPost({
    required String? id,
    String? signal,
    int? t,
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
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _containersIdRestartPost({
    required String? id,
    String? signal,
    int? t,
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
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _containersIdKillPost({
    required String? id,
    String? signal,
  }) {
    final Uri $url = Uri.parse('/containers/${id}/kill');
    final Map<String, dynamic> $params = <String, dynamic>{'signal': signal};
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<ContainerUpdateResponse>> _containersIdUpdatePost({
    required String? id,
    required Object? update,
  }) {
    final Uri $url = Uri.parse('/containers/${id}/update');
    final $body = update;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<ContainerUpdateResponse, ContainerUpdateResponse>(
      $request,
    );
  }

  @override
  Future<Response<dynamic>> _containersIdRenamePost({
    required String? id,
    required String? name,
  }) {
    final Uri $url = Uri.parse('/containers/${id}/rename');
    final Map<String, dynamic> $params = <String, dynamic>{'name': name};
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _containersIdPausePost({required String? id}) {
    final Uri $url = Uri.parse('/containers/${id}/pause');
    final Request $request = Request('POST', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _containersIdUnpausePost({required String? id}) {
    final Uri $url = Uri.parse('/containers/${id}/unpause');
    final Request $request = Request('POST', $url, client.baseUrl);
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
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<ContainerWaitResponse>> _containersIdWaitPost({
    required String? id,
    String? condition,
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
    );
    return client.send<ContainerWaitResponse, ContainerWaitResponse>($request);
  }

  @override
  Future<Response<dynamic>> _containersIdDelete({
    required String? id,
    bool? v,
    bool? force,
    bool? link,
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
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _containersIdArchiveHead({
    required String? id,
    required String? path,
  }) {
    final Uri $url = Uri.parse('/containers/${id}/archive');
    final Map<String, dynamic> $params = <String, dynamic>{'path': path};
    final Request $request = Request(
      'HEAD',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _containersIdArchiveGet({
    required String? id,
    required String? path,
  }) {
    final Uri $url = Uri.parse('/containers/${id}/archive');
    final Map<String, dynamic> $params = <String, dynamic>{'path': path};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
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
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<ContainersPrunePost$Response>> _containersPrunePost({
    String? filters,
  }) {
    final Uri $url = Uri.parse('/containers/prune');
    final Map<String, dynamic> $params = <String, dynamic>{'filters': filters};
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
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
  }) {
    final Uri $url = Uri.parse('/images/json');
    final Map<String, dynamic> $params = <String, dynamic>{
      'all': all,
      'filters': filters,
      'shared-size': sharedSize,
      'digests': digests,
      'manifests': manifests,
    };
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
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
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<ImageInspect>> _imagesNameJsonGet({
    required String? name,
    bool? manifests,
    String? platform,
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
    );
    return client.send<ImageInspect, ImageInspect>($request);
  }

  @override
  Future<Response<List<ImageHistoryResponseItem>>> _imagesNameHistoryGet({
    required String? name,
    String? platform,
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
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _imagesNameTagPost({
    required String? name,
    String? repo,
    String? tag,
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
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<ImageDeleteResponseItem>>> _imagesNameDelete({
    required String? name,
    bool? force,
    bool? noprune,
    List<String>? platforms,
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
    );
    return client.send<List<dynamic>, List<dynamic>>($request);
  }

  @override
  Future<Response<ImagesPrunePost$Response>> _imagesPrunePost({
    String? filters,
  }) {
    final Uri $url = Uri.parse('/images/prune');
    final Map<String, dynamic> $params = <String, dynamic>{'filters': filters};
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<ImagesPrunePost$Response, ImagesPrunePost$Response>(
      $request,
    );
  }

  @override
  Future<Response<AuthResponse>> _authPost({AuthConfig? authConfig}) {
    final Uri $url = Uri.parse('/auth');
    final $body = authConfig;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<AuthResponse, AuthResponse>($request);
  }

  @override
  Future<Response<SystemInfo>> _infoGet() {
    final Uri $url = Uri.parse('/info');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<SystemInfo, SystemInfo>($request);
  }

  @override
  Future<Response<SystemVersion>> _versionGet() {
    final Uri $url = Uri.parse('/version');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<SystemVersion, SystemVersion>($request);
  }

  @override
  Future<Response<String>> _pingGet() {
    final Uri $url = Uri.parse('/_ping');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<String, String>($request);
  }

  @override
  Future<Response<String>> _pingHead() {
    final Uri $url = Uri.parse('/_ping');
    final Request $request = Request('HEAD', $url, client.baseUrl);
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
    );
    return client.send<IDResponse, IDResponse>($request);
  }

  @override
  Future<Response<EventMessage>> _eventsGet({
    String? since,
    String? until,
    String? filters,
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
    );
    return client.send<EventMessage, EventMessage>($request);
  }

  @override
  Future<Response<SystemDfGet$Response>> _systemDfGet({
    List<Object?>? type,
    bool? verbose,
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
    );
    return client.send<SystemDfGet$Response, SystemDfGet$Response>($request);
  }

  @override
  Future<Response<String>> _imagesNameGetGet({
    required String? name,
    List<String>? platform,
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
    );
    return client.send<String, String>($request);
  }

  @override
  Future<Response<String>> _imagesGetGet({
    List<String>? names,
    List<String>? platform,
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
    );
    return client.send<String, String>($request);
  }

  @override
  Future<Response<dynamic>> _imagesLoadPost({
    String? imagesTarball,
    bool? quiet,
    List<String>? platform,
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
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<IDResponse>> _containersIdExecPost({
    required Object? execConfig,
    required String? id,
  }) {
    final Uri $url = Uri.parse('/containers/${id}/exec');
    final $body = execConfig;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<IDResponse, IDResponse>($request);
  }

  @override
  Future<Response<dynamic>> _execIdStartPost({
    Object? execStartConfig,
    required String? id,
  }) {
    final Uri $url = Uri.parse('/exec/${id}/start');
    final $body = execStartConfig;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _execIdResizePost({
    required String? id,
    required int? h,
    required int? w,
  }) {
    final Uri $url = Uri.parse('/exec/${id}/resize');
    final Map<String, dynamic> $params = <String, dynamic>{'h': h, 'w': w};
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<ExecIdJsonGet$Response>> _execIdJsonGet({
    required String? id,
  }) {
    final Uri $url = Uri.parse('/exec/${id}/json');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<ExecIdJsonGet$Response, ExecIdJsonGet$Response>(
      $request,
    );
  }

  @override
  Future<Response<VolumeListResponse>> _volumesGet({String? filters}) {
    final Uri $url = Uri.parse('/volumes');
    final Map<String, dynamic> $params = <String, dynamic>{'filters': filters};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<VolumeListResponse, VolumeListResponse>($request);
  }

  @override
  Future<Response<Volume>> _volumesCreatePost({
    required VolumeCreateRequest? volumeConfig,
  }) {
    final Uri $url = Uri.parse('/volumes/create');
    final $body = volumeConfig;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<Volume, Volume>($request);
  }

  @override
  Future<Response<Volume>> _volumesNameGet({required String? name}) {
    final Uri $url = Uri.parse('/volumes/${name}');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<Volume, Volume>($request);
  }

  @override
  Future<Response<dynamic>> _volumesNamePut({
    required String? name,
    Object? body,
    required int? version,
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
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _volumesNameDelete({
    required String? name,
    bool? force,
  }) {
    final Uri $url = Uri.parse('/volumes/${name}');
    final Map<String, dynamic> $params = <String, dynamic>{'force': force};
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<VolumesPrunePost$Response>> _volumesPrunePost({
    String? filters,
  }) {
    final Uri $url = Uri.parse('/volumes/prune');
    final Map<String, dynamic> $params = <String, dynamic>{'filters': filters};
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<VolumesPrunePost$Response, VolumesPrunePost$Response>(
      $request,
    );
  }

  @override
  Future<Response<List<NetworkSummary>>> _networksGet({String? filters}) {
    final Uri $url = Uri.parse('/networks');
    final Map<String, dynamic> $params = <String, dynamic>{'filters': filters};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<NetworkSummary>, NetworkSummary>($request);
  }

  @override
  Future<Response<NetworkInspect>> _networksIdGet({
    required String? id,
    bool? verbose,
    String? scope,
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
    );
    return client.send<NetworkInspect, NetworkInspect>($request);
  }

  @override
  Future<Response<dynamic>> _networksIdDelete({required String? id}) {
    final Uri $url = Uri.parse('/networks/${id}');
    final Request $request = Request('DELETE', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<NetworkCreateResponse>> _networksCreatePost({
    required Object? networkConfig,
  }) {
    final Uri $url = Uri.parse('/networks/create');
    final $body = networkConfig;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<NetworkCreateResponse, NetworkCreateResponse>($request);
  }

  @override
  Future<Response<dynamic>> _networksIdConnectPost({
    required String? id,
    required NetworkConnectRequest? container,
  }) {
    final Uri $url = Uri.parse('/networks/${id}/connect');
    final $body = container;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _networksIdDisconnectPost({
    required String? id,
    required NetworkDisconnectRequest? container,
  }) {
    final Uri $url = Uri.parse('/networks/${id}/disconnect');
    final $body = container;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<NetworksPrunePost$Response>> _networksPrunePost({
    String? filters,
  }) {
    final Uri $url = Uri.parse('/networks/prune');
    final Map<String, dynamic> $params = <String, dynamic>{'filters': filters};
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<NetworksPrunePost$Response, NetworksPrunePost$Response>(
      $request,
    );
  }

  @override
  Future<Response<List<Plugin>>> _pluginsGet({String? filters}) {
    final Uri $url = Uri.parse('/plugins');
    final Map<String, dynamic> $params = <String, dynamic>{'filters': filters};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<Plugin>, Plugin>($request);
  }

  @override
  Future<Response<List<PluginPrivilege>>> _pluginsPrivilegesGet({
    required String? remote,
  }) {
    final Uri $url = Uri.parse('/plugins/privileges');
    final Map<String, dynamic> $params = <String, dynamic>{'remote': remote};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<PluginPrivilege>, PluginPrivilege>($request);
  }

  @override
  Future<Response<dynamic>> _pluginsPullPost({
    required String? remote,
    String? name,
    String? xRegistryAuth,
    List<PluginPrivilege>? body,
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
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<Plugin>> _pluginsNameJsonGet({required String? name}) {
    final Uri $url = Uri.parse('/plugins/${name}/json');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<Plugin, Plugin>($request);
  }

  @override
  Future<Response<Plugin>> _pluginsNameDelete({
    required String? name,
    bool? force,
  }) {
    final Uri $url = Uri.parse('/plugins/${name}');
    final Map<String, dynamic> $params = <String, dynamic>{'force': force};
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<Plugin, Plugin>($request);
  }

  @override
  Future<Response<dynamic>> _pluginsNameEnablePost({
    required String? name,
    int? timeout,
  }) {
    final Uri $url = Uri.parse('/plugins/${name}/enable');
    final Map<String, dynamic> $params = <String, dynamic>{'timeout': timeout};
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _pluginsNameDisablePost({
    required String? name,
    bool? force,
  }) {
    final Uri $url = Uri.parse('/plugins/${name}/disable');
    final Map<String, dynamic> $params = <String, dynamic>{'force': force};
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _pluginsNameUpgradePost({
    required String? name,
    required String? remote,
    String? xRegistryAuth,
    List<PluginPrivilege>? body,
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
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _pluginsCreatePost({
    required String? name,
    String? tarContext,
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
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _pluginsNamePushPost({required String? name}) {
    final Uri $url = Uri.parse('/plugins/${name}/push');
    final Request $request = Request('POST', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _pluginsNameSetPost({
    required String? name,
    List<String>? body,
  }) {
    final Uri $url = Uri.parse('/plugins/${name}/set');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<Node>>> _nodesGet({String? filters}) {
    final Uri $url = Uri.parse('/nodes');
    final Map<String, dynamic> $params = <String, dynamic>{'filters': filters};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<Node>, Node>($request);
  }

  @override
  Future<Response<Node>> _nodesIdGet({required String? id}) {
    final Uri $url = Uri.parse('/nodes/${id}');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<Node, Node>($request);
  }

  @override
  Future<Response<dynamic>> _nodesIdDelete({required String? id, bool? force}) {
    final Uri $url = Uri.parse('/nodes/${id}');
    final Map<String, dynamic> $params = <String, dynamic>{'force': force};
    final Request $request = Request(
      'DELETE',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _nodesIdUpdatePost({
    required String? id,
    NodeSpec? body,
    required int? version,
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
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<Swarm>> _swarmGet() {
    final Uri $url = Uri.parse('/swarm');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<Swarm, Swarm>($request);
  }

  @override
  Future<Response<String>> _swarmInitPost({required Object? body}) {
    final Uri $url = Uri.parse('/swarm/init');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<String, String>($request);
  }

  @override
  Future<Response<dynamic>> _swarmJoinPost({required Object? body}) {
    final Uri $url = Uri.parse('/swarm/join');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _swarmLeavePost({bool? force}) {
    final Uri $url = Uri.parse('/swarm/leave');
    final Map<String, dynamic> $params = <String, dynamic>{'force': force};
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      parameters: $params,
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
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<SwarmUnlockkeyGet$Response>> _swarmUnlockkeyGet() {
    final Uri $url = Uri.parse('/swarm/unlockkey');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<SwarmUnlockkeyGet$Response, SwarmUnlockkeyGet$Response>(
      $request,
    );
  }

  @override
  Future<Response<dynamic>> _swarmUnlockPost({required Object? body}) {
    final Uri $url = Uri.parse('/swarm/unlock');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<Service>>> _servicesGet({
    String? filters,
    bool? status,
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
    );
    return client.send<List<Service>, Service>($request);
  }

  @override
  Future<Response<ServiceCreateResponse>> _servicesCreatePost({
    required Object? body,
    String? xRegistryAuth,
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
    );
    return client.send<ServiceCreateResponse, ServiceCreateResponse>($request);
  }

  @override
  Future<Response<Service>> _servicesIdGet({
    required String? id,
    bool? insertDefaults,
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
    );
    return client.send<Service, Service>($request);
  }

  @override
  Future<Response<dynamic>> _servicesIdDelete({required String? id}) {
    final Uri $url = Uri.parse('/services/${id}');
    final Request $request = Request('DELETE', $url, client.baseUrl);
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
    );
    return client.send<String, String>($request);
  }

  @override
  Future<Response<List<Task>>> _tasksGet({String? filters}) {
    final Uri $url = Uri.parse('/tasks');
    final Map<String, dynamic> $params = <String, dynamic>{'filters': filters};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<Task>, Task>($request);
  }

  @override
  Future<Response<Task>> _tasksIdGet({required String? id}) {
    final Uri $url = Uri.parse('/tasks/${id}');
    final Request $request = Request('GET', $url, client.baseUrl);
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
    );
    return client.send<String, String>($request);
  }

  @override
  Future<Response<List<Secret>>> _secretsGet({String? filters}) {
    final Uri $url = Uri.parse('/secrets');
    final Map<String, dynamic> $params = <String, dynamic>{'filters': filters};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<Secret>, Secret>($request);
  }

  @override
  Future<Response<IDResponse>> _secretsCreatePost({Object? body}) {
    final Uri $url = Uri.parse('/secrets/create');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<IDResponse, IDResponse>($request);
  }

  @override
  Future<Response<Secret>> _secretsIdGet({required String? id}) {
    final Uri $url = Uri.parse('/secrets/${id}');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<Secret, Secret>($request);
  }

  @override
  Future<Response<dynamic>> _secretsIdDelete({required String? id}) {
    final Uri $url = Uri.parse('/secrets/${id}');
    final Request $request = Request('DELETE', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _secretsIdUpdatePost({
    required String? id,
    SecretSpec? body,
    required int? version,
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
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<List<Config>>> _configsGet({String? filters}) {
    final Uri $url = Uri.parse('/configs');
    final Map<String, dynamic> $params = <String, dynamic>{'filters': filters};
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<List<Config>, Config>($request);
  }

  @override
  Future<Response<IDResponse>> _configsCreatePost({Object? body}) {
    final Uri $url = Uri.parse('/configs/create');
    final $body = body;
    final Request $request = Request('POST', $url, client.baseUrl, body: $body);
    return client.send<IDResponse, IDResponse>($request);
  }

  @override
  Future<Response<Config>> _configsIdGet({required String? id}) {
    final Uri $url = Uri.parse('/configs/${id}');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<Config, Config>($request);
  }

  @override
  Future<Response<dynamic>> _configsIdDelete({required String? id}) {
    final Uri $url = Uri.parse('/configs/${id}');
    final Request $request = Request('DELETE', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<dynamic>> _configsIdUpdatePost({
    required String? id,
    ConfigSpec? body,
    required int? version,
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
    );
    return client.send<dynamic, dynamic>($request);
  }

  @override
  Future<Response<DistributionInspect>> _distributionNameJsonGet({
    required String? name,
  }) {
    final Uri $url = Uri.parse('/distribution/${name}/json');
    final Request $request = Request('GET', $url, client.baseUrl);
    return client.send<DistributionInspect, DistributionInspect>($request);
  }

  @override
  Future<Response<dynamic>> _sessionPost() {
    final Uri $url = Uri.parse('/session');
    final Request $request = Request('POST', $url, client.baseUrl);
    return client.send<dynamic, dynamic>($request);
  }
}
