import 'dart:convert';
import 'dart:io';

class DockerServer(final HttpServer server) {
  this {
    server.listen((request) async {
      paths.add(request.uri.path);
      bodies.add(await utf8.decoder.bind(request).join());

      if (handler != null && await handler!(request)) return;
      final path = request.uri.path;

      if (path == '/version') {
        await respond(request, {
          'ApiVersion': apiVersion,
          'MinAPIVersion': '1.41',
        });
      } else if (path.endsWith('/images/create')) {
        await respond(
          request,
          '{"status":"Downloaded"}\n',
          contentType: 'application/json',
        );
      } else if (path.endsWith('/containers/create')) {
        await respond(request, {
          'Id': 'container-1',
          'Warnings': [],
        }, status: 201);
      } else if (path.endsWith('/containers/container-1/start') ||
          request.method == 'DELETE' ||
          path.endsWith('/stop')) {
        await respond(request, '', status: 204);
      } else if (path.endsWith('/containers/container-1/json')) {
        await respond(request, {
          'State': {'Running': true},
          'NetworkSettings': {
            'Ports': {
              '6379/tcp': [
                {'HostIp': '127.0.0.1', 'HostPort': '32768'},
              ],
            },
          },
        });
      } else {
        await respond(request, {
          'message': 'Unexpected request: $path',
        }, status: 404);
      }
    });
  }

  final paths = <String>[];
  final bodies = <String>[];
  String apiVersion = '1.56';
  Future<bool> Function(HttpRequest request)? handler;

  static Future<DockerServer> start() async =>
      DockerServer(await HttpServer.bind(InternetAddress.loopbackIPv4, 0));

  Uri get endpoint => Uri.parse('http://127.0.0.1:${server.port}');

  Future<void> close() => server.close(force: true);

  static Future<void> respond(
    HttpRequest request,
    Object body, {
    int status = 200,
    String contentType = 'application/json',
  }) async {
    request.response.statusCode = status;
    request.response.headers.set(HttpHeaders.contentTypeHeader, contentType);
    if (body is List<int>) {
      request.response.add(body);
    } else {
      request.response.write(body is String ? body : jsonEncode(body));
    }
    await request.response.close();
  }
}

List<int> frame(int stream, List<int> bytes) => [
  stream,
  0,
  0,
  0,
  (bytes.length >> 24) & 255,
  (bytes.length >> 16) & 255,
  (bytes.length >> 8) & 255,
  bytes.length & 255,
  ...bytes,
];
