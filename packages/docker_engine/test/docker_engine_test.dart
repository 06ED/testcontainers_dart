import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:docker_engine/docker_engine.dart' hide Platform;
import 'package:test/test.dart';

void main() {
  test('configuration is available without Testcontainers', () {
    final config = DockerConfig.fromEnvironment({
      'DOCKER_HOST': 'tcp://docker:2375',
    });
    expect(config.endpoint, Uri.parse('http://docker:2375'));
    expect(config.host, 'docker');
  });

  test('decodes stdout and stderr without Testcontainers', () {
    final output = decodeDockerOutput([
      1,
      0,
      0,
      0,
      0,
      0,
      0,
      2,
      111,
      107,
      2,
      0,
      0,
      0,
      0,
      0,
      0,
      1,
      33,
    ]);
    expect(output.stdout, 'ok');
    expect(output.stderr, '!');
    expect(output.combined, 'ok!');
  });

  group('standalone Docker connection', () {
    late HttpServer server;
    var apiVersion = '1.56';
    var graphDriver = <String, dynamic>{};
    Future<bool> Function(HttpRequest)? handler;

    setUp(() async {
      apiVersion = '1.56';
      handler = null;
      server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      serve(
        server,
        () => apiVersion,
        graphDriver: () => graphDriver,
        handler: (request) async =>
            handler == null ? false : await handler!(request),
      );
    });
    tearDown(() => server.close(force: true));

    Future<DockerConnection> connect() => DockerConnection.connect(
      DockerConfig(endpoint: Uri.parse('http://127.0.0.1:${server.port}')),
    );

    test('negotiates API and exposes generated methods and models', () async {
      final connection = await connect();
      addTearDown(connection.close);

      expect(connection.api.client.baseUrl.path, '/v1.55');
      final response = await connection.api.containersCreatePost(
        body: {'Image': 'busybox:1.37'},
      );

      checkResponse(response);
      expect(response.body, isA<ContainerCreateResponse>());
      expect(response.body!.id, 'standalone-1');
    });

    test('uses an older daemon API', () async {
      apiVersion = '1.45';
      final connection = await connect();
      addTearDown(connection.close);

      expect(connection.api.client.baseUrl.path, '/v1.45');
    });

    for (final version in ['1.40', 'invalid']) {
      test('rejects unsupported or malformed daemon API $version', () async {
        apiVersion = version;
        await expectLater(
          connect(),
          version == 'invalid' ? throwsFormatException : throwsUnsupportedError,
        );
      });
    }

    test('rejects a minimum API newer than the supported maximum', () async {
      handler = (request) async {
        request.response.write('{"ApiVersion":"1.60","MinAPIVersion":"1.56"}');
        await request.response.close();
        return true;
      };
      await expectLater(connect(), throwsUnsupportedError);
    });

    test(
      'reports daemon discovery HTTP errors without following redirects',
      () async {
        handler = (request) async {
          request.response.statusCode = 302;
          request.response.headers.set(
            HttpHeaders.locationHeader,
            '/redirected',
          );
          request.response.write('unexpected redirect');
          await request.response.close();
          return true;
        };
        await expectLater(
          connect(),
          throwsA(
            isA<DockerException>()
                .having((e) => e.statusCode, 'status', 302)
                .having((e) => e.message, 'message', 'unexpected redirect'),
          ),
        );
      },
    );

    test('accepts a daemon requiring API 1.55', () async {
      handler = (request) async {
        request.response.write('{"ApiVersion":"1.55","MinAPIVersion":"1.55"}');
        await request.response.close();
        return true;
      };
      final connection = await connect();
      addTearDown(connection.close);
      expect(connection.api.client.baseUrl.path, '/v1.55');
    });

    test('preserves a pull response as NDJSON instead of decoding a single JSON value', () async {
      handler = (request) async {
        if (!request.uri.path.endsWith('/images/create')) return false;
        request.response.write('{"status":"Pulling"}\n{"status":"Done"}\n');
        await request.response.close();
        return true;
      };
      final connection = await connect();
      addTearDown(connection.close);
      final response = await connection.api.imagesCreatePost(
        fromImage: 'redis',
      );
      checkResponse(response);
      expect(
        responseText(response),
        '{"status":"Pulling"}\n{"status":"Done"}\n',
      );
    });

    for (final partialBody in [false, true]) {
      test(
        'times out a stalled ${partialBody ? 'body' : 'response'}',
        () async {
          handler = (request) async {
            if (partialBody) {
              request.response.write('{');
              await request.response.flush();
            }
            return true;
          };
          const timeout = Duration(milliseconds: 200);
          await expectLater(
            DockerConnection.connect(
              DockerConfig(
                endpoint: Uri.parse('http://127.0.0.1:${server.port}'),
                requestTimeout: timeout,
              ),
            ),
            throwsA(
              isA<TimeoutException>()
                  .having((e) => e.duration, 'timeout', timeout)
                  .having((e) => e.message, 'request', contains('/version')),
            ),
          );
        },
      );
    }

    for (final data in [
      null,
      <String, dynamic>{'UpperDir': '/var/lib/docker/upper'},
    ]) {
      test('inspect accepts storage driver Data=$data', () async {
        graphDriver = {'Name': 'overlay2', 'Data': data};
        final connection = await connect();
        addTearDown(connection.close);
        final response = await connection.api.containersIdJsonGet(
          id: 'existing',
        );
        checkResponse(response);
        expect(response.body!.graphDriver!.data, data ?? <String, dynamic>{});
        expect(jsonDecode(responseText(response))['GraphDriver']['Data'], data);
      });
    }

    test('inspect accepts missing storage driver Data', () async {
      graphDriver = {'Name': 'overlay2'};
      final connection = await connect();
      addTearDown(connection.close);
      final response = await connection.api.containersIdJsonGet(id: 'existing');
      checkResponse(response);
      expect(response.body!.graphDriver!.data, isEmpty);
    });

    test('Docker errors belong to the standalone package', () async {
      final connection = await connect();
      addTearDown(connection.close);
      final response = await connection.api.containersIdJsonGet(id: 'missing');
      expect(
        () => checkResponse(response),
        throwsA(
          isA<DockerException>()
              .having((error) => error.statusCode, 'status', 404)
              .having((error) => error.message, 'message', 'not found'),
        ),
      );
    });
  });

  test('standalone connection works over a Unix socket', () async {
    final directory = await Directory.systemTemp.createTemp('de-');
    final path = '${directory.path}/docker.sock';
    final server = await HttpServer.bind(
      InternetAddress(path, type: InternetAddressType.unix),
      0,
    );
    serve(
      server,
      () => '1.53',
      handler: (request) async {
        if (!request.uri.path.endsWith('/logs')) return false;
        request.response.write('unix logs');
        await request.response.close();
        return true;
      },
    );
    addTearDown(() async {
      await server.close(force: true);
      await directory.delete(recursive: true);
    });
    final connection = await DockerConnection.connect(
      DockerConfig(
        endpoint: Uri(scheme: 'unix', path: path),
      ),
    );
    addTearDown(connection.close);
    final response = await connection.api.containersCreatePost(
      body: {'Image': 'busybox:1.37'},
    );
    expect(response.body!.id, 'standalone-1');
    final chunks = await connection.api
        .logsStream(id: 'standalone-1', tty: true)
        .toList();
    expect(chunks.single.text, 'unix logs');
  }, skip: Platform.isWindows);
}

void serve(
  HttpServer server,
  String Function() apiVersion, {
  Map<String, dynamic> Function()? graphDriver,
  Future<bool> Function(HttpRequest)? handler,
}) {
  server.listen((request) async {
    await request.drain<void>();
    request.response.headers.contentType = ContentType.json;
    if (handler != null && await handler(request)) return;
    if (request.uri.path == '/version') {
      request.response.write(
        jsonEncode({'ApiVersion': apiVersion(), 'MinAPIVersion': '1.41'}),
      );
    } else if (request.uri.path.endsWith('/containers/create')) {
      request.response.statusCode = 201;
      request.response.write(
        jsonEncode({'Id': 'standalone-1', 'Warnings': []}),
      );
    } else if (request.uri.path.endsWith('/containers/existing/json')) {
      request.response.write(
        jsonEncode({'Id': 'existing', 'GraphDriver': graphDriver!()}),
      );
    } else {
      request.response.statusCode = 404;
      request.response.write(jsonEncode({'message': 'not found'}));
    }
    await request.response.close();
  });
}
