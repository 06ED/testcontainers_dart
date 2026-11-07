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

    setUp(() async {
      apiVersion = '1.56';
      server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      serve(server, () => apiVersion, graphDriver: () => graphDriver);
    });
    tearDown(() => server.close(force: true));

    Future<DockerConnection> connect() => DockerConnection.connect(
      DockerConfig(endpoint: Uri.parse('http://127.0.0.1:${server.port}')),
    );

    test('negotiates API and exposes generated methods and models', () async {
      final connection = await connect();
      addTearDown(connection.close);
      expect(connection.api.client.baseUrl.path, '/v1.53');
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
    serve(server, () => '1.53');
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
  }, skip: Platform.isWindows);
}

void serve(
  HttpServer server,
  String Function() apiVersion, {
  Map<String, dynamic> Function()? graphDriver,
}) {
  server.listen((request) async {
    await request.drain<void>();
    request.response.headers.contentType = ContentType.json;
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
