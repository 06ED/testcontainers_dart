import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import '../errors/exceptions.dart';
import '../generated/docker.swagger.dart';
import 'docker_config.dart';

class DockerConnection {
  DockerConnection._(this.api, this.transport, this.host);

  final Docker api;
  final http.Client transport;
  final String host;

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
      const maximum = 1053;
      final selected = version < maximum ? version : maximum;
      if (selected < minimum || selected < 1041) {
        throw UnsupportedError(
          'Docker API must overlap supported versions 1.41–1.53',
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

class _DockerConverter extends $JsonSerializableConverter {
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

class _TimeoutClient extends http.BaseClient {
  _TimeoutClient(this.inner, this.timeout);

  final http.Client inner;
  final Duration timeout;

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
  void close() => inner.close();
}
