part of 'docker_connection.dart';

/// Binary archive requests bypass Chopper's String upload and buffered transport.
extension DockerArchives on Docker {
  Stream<List<int>> getArchive({required String id, required String path}) =>
      _archiveRequest(this, 'GET', id, path);

  Future<void> putArchive({
    required String id,
    required String path,
    required Stream<List<int>> archive,
  }) => _archiveRequest(this, 'PUT', id, path, body: archive).drain<void>();
}

Stream<List<int>> _archiveRequest(
  Docker api,
  String method,
  String id,
  String path, {
  Stream<List<int>> body = const Stream.empty(),
}) {
  if (id.isEmpty || id.contains('\u0000')) {
    throw ArgumentError('A container ID is required');
  }
  if (!path.startsWith('/') || path.contains('\u0000')) {
    throw ArgumentError('An absolute container path without NUL is required');
  }
  final transport = api.client.httpClient;
  final managed = transport is _TimeoutClient ? transport : null;
  final raw = managed?.inner ?? transport;
  final timeout = managed?.timeout ?? const Duration(minutes: 2);
  final url = api.client.baseUrl.replace(
    pathSegments: [
      ...api.client.baseUrl.pathSegments.where((segment) => segment.isNotEmpty),
      'containers',
      id,
      'archive',
    ],
    queryParameters: {
      'path': path,
      if (method == 'PUT') 'noOverwriteDirNonDir': 'true',
      if (method == 'PUT') 'copyUIDGID': 'true',
    },
  );
  final abort = Completer<void>();
  StreamSubscription<List<int>>? subscription;
  Timer? timer;
  var finished = false;
  var timedOut = false;
  late final StreamController<List<int>> controller;

  void finish([Object? error, StackTrace? stack]) {
    if (finished) return;
    finished = true;
    timer?.cancel();
    managed?._streamRequests.remove(abort);
    if (error != null) controller.addError(error, stack);
    unawaited(controller.close());
  }

  Future<void> open() async {
    try {
      if (managed?._closed ?? false) {
        throw StateError('Docker connection is closed');
      }
      managed?._streamRequests.add(abort);
      timer = Timer(timeout, () {
        timedOut = true;
        if (!abort.isCompleted) abort.complete();
      });
      unawaited(
        abort.future.then((_) {
          finish(
            timedOut
                ? TimeoutException('Docker archive request timed out', timeout)
                : http.RequestAbortedException(url),
          );
          unawaited(subscription?.cancel());
        }),
      );
      final request = _ArchiveRequest(method, url, body, abort.future)
        ..followRedirects = false;
      if (method == 'PUT') {
        request.headers['content-type'] = 'application/x-tar';
      } else {
        request.contentLength = 0;
      }
      final response = await raw.send(request);
      if (finished) {
        await response.stream.listen(null).cancel();
        return;
      }
      if (response.statusCode < 200 || response.statusCode >= 300) {
        await response.stream.listen(null).cancel();
        throw DockerException(
          'Docker archive request failed',
          statusCode: response.statusCode,
        );
      }
      subscription = response.stream.listen(
        controller.add,
        onError: (Object error, StackTrace stack) => finish(error, stack),
        onDone: finish,
        cancelOnError: true,
      );
      if (controller.isPaused) subscription!.pause();
    } catch (error, stack) {
      finish(error, stack);
    }
  }

  controller = StreamController<List<int>>(
    onListen: () => unawaited(open()),
    onPause: () => subscription?.pause(),
    onResume: () => subscription?.resume(),
    onCancel: () async {
      finish();
      if (!abort.isCompleted) abort.complete();
      await subscription?.cancel();
    },
  );
  return controller.stream;
}

class _ArchiveRequest(
  super.method,
  super.url,
  final Stream<List<int>> _body,
  @override final Future<void> abortTrigger,
) extends http.BaseRequest with http.Abortable {
  @override
  http.ByteStream finalize() {
    super.finalize();
    return http.ByteStream(_body);
  }
}
