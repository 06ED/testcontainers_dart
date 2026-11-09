import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import '../errors/exceptions.dart';
import '../generated/docker.swagger.dart';
import 'docker_config.dart';
import 'docker_output.dart';
import 'responses.dart';

class DockerConnection._(
  final Docker api,
  final http.Client transport,
  final String host,
) {
  static Future<DockerConnection> connect(DockerConfig config) async {
    final io = HttpClient()..connectionTimeout = config.requestTimeout;
    io.findProxy = (_) => 'DIRECT';

    final unix = config.endpoint.scheme == 'unix';
    if (unix) {
      io.connectionFactory = (uri, proxyHost, proxyPort) => Socket.startConnect(
        InternetAddress(config.endpoint.path, type: InternetAddressType.unix),
        0,
      );
    }

    final client = _TimeoutClient(IOClient(io), config.requestTimeout);
    final base = unix ? Uri.parse('http://localhost') : config.endpoint;

    try {
      final response = await client.get(base.replace(path: '/version'));
      if (response.statusCode != 200) {
        throw DockerException(response.body, statusCode: response.statusCode);
      }

      final info = jsonDecode(response.body) as Map<String, dynamic>;
      final version = _version(info['ApiVersion']);
      final minimum = _version(info['MinAPIVersion'] ?? '1.0');
      const maximum = 1055;
      final selected = version < maximum ? version : maximum;

      if (selected < minimum || selected < 1041) {
        throw UnsupportedError(
          'Docker API must overlap supported versions 1.41–1.55',
        );
      }

      return DockerConnection._(
        Docker.create(
          httpClient: client,
          baseUrl: base.replace(
            path: '/v${selected ~/ 1000}.${selected % 1000}',
          ),
          converter: _DockerConverter(),
        ),
        client,
        config.host,
      );
    } catch (_) {
      client.close();
      rethrow;
    }
  }

  static int _version(Object? value) {
    final match = RegExp(r'^(\d+)\.(\d{1,3})$').firstMatch('$value');

    if (match == null) {
      throw FormatException('Invalid Docker API version: $value');
    }

    return int.parse(match[1]!) * 1000 + int.parse(match[2]!);
  }

  void close() {
    api.client.dispose();
    transport.close();
  }
}

class _DockerConverter() extends $JsonSerializableConverter {
  @override
  FutureOr<Response> decodeJson<BodyType, InnerType>(Response response) async {
    final decoded = await super.decodeJson<BodyType, InnerType>(response);
    final body = decoded.body;
    final driver = body is Map<String, dynamic> ? body['GraphDriver'] : null;

    // Docker may return null driver metadata despite the schema requiring a map.
    if (driver is Map<String, dynamic> && driver['Data'] == null) {
      driver['Data'] = <String, dynamic>{};
    }

    return decoded;
  }

  @override
  FutureOr<Response<ResultType>> convertResponse<ResultType, Item>(
    Response response,
  ) {
    // Pull is NDJSON and exec is binary, not a single JSON document.
    if (ResultType == dynamic || ResultType == String) {
      return response.copyWith<ResultType>();
    }

    return super.convertResponse<ResultType, Item>(response);
  }
}

extension DockerLogStreaming on Docker {
  /// Follows container output. Set [tty] from the container's Config.Tty value.
  Stream<DockerLogChunk> logsStream({
    required String id,
    required bool tty,
    int tail = 100,
  }) {
    if (id.isEmpty) throw ArgumentError.value(id, 'id');
    if (tail < 0) throw ArgumentError.value(tail, 'tail');

    final transport = client.httpClient;
    final managed = transport is _TimeoutClient ? transport : null;
    final raw = managed?.inner ?? transport;
    final timeout = managed?.timeout ?? const Duration(minutes: 2);

    final url = client.baseUrl.replace(
      pathSegments: [
        ...client.baseUrl.pathSegments.where((s) => s.isNotEmpty),
        'containers',
        id,
        'logs',
      ],
      queryParameters: {
        'follow': 'true',
        'stdout': 'true',
        'stderr': 'true',
        'tail': '$tail',
      },
    );

    final abort = Completer<void>();
    StreamSubscription<List<int>>? subscription;
    var cancelled = false;
    var finished = false;
    late final StreamController<List<int>> controller;

    void finish() {
      finished = true;
      managed?._logRequests.remove(abort);
      unawaited(controller.close());
    }

    Never timedOut() {
      if (!abort.isCompleted) abort.complete();
      throw TimeoutException('Docker log request timed out: $url', timeout);
    }

    Future<void> open() async {
      try {
        if (managed?._closed ?? false) {
          throw StateError('Docker connection is closed');
        }

        managed?._logRequests.add(abort);
        final request = http.AbortableRequest(
          'GET',
          url,
          abortTrigger: abort.future,
        )..followRedirects = false;

        final response = await raw
            .send(request)
            .timeout(timeout, onTimeout: timedOut);

        if (cancelled) {
          await response.stream.listen(null).cancel();
          return;
        }
        if (response.statusCode < 200 || response.statusCode >= 300) {
          final error = await http.Response.fromStream(response)
              .timeout(timeout, onTimeout: timedOut);
          checkResponse(Response<dynamic>(error, null));
        }

        subscription = response.stream.listen(
          controller.add,
          onError: (Object error, StackTrace stack) {
            controller.addError(error, stack);
            finish();
          },
          onDone: finish,
          cancelOnError: true,
        );

        if (controller.isPaused) subscription!.pause();
      } catch (error, stack) {
        if (!cancelled) {
          controller.addError(error, stack);
          finish();
        }
      }
    }

    controller = StreamController<List<int>>(
      onListen: () => unawaited(open()),
      onPause: () => subscription?.pause(),
      onResume: () => subscription?.resume(),
      onCancel: () async {
        cancelled = true;
        managed?._logRequests.remove(abort);
        if (!finished && !abort.isCompleted) abort.complete();
        await subscription?.cancel();
      },
    );

    return decodeDockerLogStream(controller.stream, tty: tty);
  }
}

class _TimeoutClient(final http.Client inner, final Duration timeout)
    extends http.BaseClient {
  final _logRequests = <Completer<void>>{};
  bool _closed = false;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final abort = Completer<void>();
    final outgoing =
        http.AbortableRequest(
            request.method,
            request.url,
            abortTrigger: abort.future,
          )
          ..headers.addAll(request.headers)
          ..followRedirects = false
          ..bodyBytes = await request.finalize().toBytes();

    final timer = Timer(timeout, abort.complete);
    try {
      final response = await inner.send(outgoing);
      // shortcut: buffers replies, use a streaming transport for unbounded exec output.
      final bytes = await response.stream.toBytes();
      return http.StreamedResponse(
        Stream.value(bytes),
        response.statusCode,
        headers: response.headers,
        contentLength: bytes.length,
        reasonPhrase: response.reasonPhrase,
        request: request,
      );
    } on http.RequestAbortedException {
      throw TimeoutException(
        'Docker request timed out: ${request.method} ${request.url}',
        timeout,
      );
    } finally {
      timer.cancel();
    }
  }

  @override
  void close() {
    _closed = true;

    for (final request in _logRequests) {
      if (!request.isCompleted) request.complete();
    }

    _logRequests.clear();
    inner.close();
  }
}
