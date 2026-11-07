import 'dart:async';
import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:testcontainers/testcontainers.dart';

class MockContainer extends Mock implements StartedContainer {}

void main() {
  late MockContainer container;
  const timeout = Duration(milliseconds: 200);
  const interval = Duration(milliseconds: 2);

  setUp(() {
    container = MockContainer();
    when(() => container.id).thenReturn('container-1');
    when(() => container.host).thenReturn('127.0.0.1');
    when(container.inspect).thenAnswer(
      (_) async => {
        'State': {'Running': true},
      },
    );
  });

  test('no wait makes no calls', () async {
    await Wait.forNothing().waitUntilReady(container);
    verifyNever(container.inspect);
  });

  test('log wait retries until the required occurrence count', () async {
    var calls = 0;
    when(
      () => container.logs(),
    ).thenAnswer((_) async => ++calls == 1 ? 'ready' : 'ready\nready');
    await Wait.forLogMessage(
      'ready',
      times: 2,
      timeout: timeout,
      pollInterval: interval,
    ).waitUntilReady(container);
    expect(calls, 2);
  });

  test('log wait accepts a regular expression', () async {
    when(
      () => container.logs(),
    ).thenAnswer((_) async => 'Listening on port 8080');
    await Wait.forLogMessage(RegExp(r'port \d+')).waitUntilReady(container);
  });

  test('timeout includes the strategy description', () async {
    when(() => container.logs()).thenAnswer((_) async => 'starting');
    await expectLater(
      Wait.forLogMessage(
        'ready',
        timeout: const Duration(milliseconds: 20),
        pollInterval: interval,
      ).waitUntilReady(container),
      throwsA(
        isA<WaitTimeoutException>().having(
          (e) => e.message,
          'message',
          contains('ready'),
        ),
      ),
    );
  });

  test('timeout also bounds a hung inspect request', () async {
    when(
      container.inspect,
    ).thenAnswer((_) => Completer<Map<String, dynamic>>().future);
    await expectLater(
      Wait.forHealthcheck(
        timeout: const Duration(milliseconds: 20),
      ).waitUntilReady(container),
      throwsA(isA<WaitTimeoutException>()),
    );
  });

  test('exited containers fail immediately with their exit code', () async {
    when(container.inspect).thenAnswer(
      (_) async => {
        'State': {'Running': false, 'ExitCode': 42},
      },
    );
    await expectLater(
      Wait.forLogMessage('ready').waitUntilReady(container),
      throwsA(
        isA<ContainerExitedException>().having(
          (e) => e.exitCode,
          'exit code',
          42,
        ),
      ),
    );
    verifyNever(() => container.logs());
  });

  test('healthcheck wait retries starting state', () async {
    var calls = 0;
    when(container.inspect).thenAnswer(
      (_) async => {
        'State': {
          'Running': true,
          'Health': {'Status': ++calls == 1 ? 'starting' : 'healthy'},
        },
      },
    );
    await Wait.forHealthcheck(
      timeout: timeout,
      pollInterval: interval,
    ).waitUntilReady(container);
    expect(calls, 2);
  });

  test('healthcheck wait rejects missing healthcheck', () async {
    await expectLater(
      Wait.forHealthcheck().waitUntilReady(container),
      throwsStateError,
    );
  });

  test(
    'malformed inspect cannot be mistaken for a running container',
    () async {
      when(container.inspect).thenAnswer((_) async => {});
      await expectLater(
        Wait.forHealthcheck().waitUntilReady(container),
        throwsFormatException,
      );
    },
  );

  test('TCP wait connects using the mapped port', () async {
    final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
    final subscription = server.listen((socket) => socket.destroy());
    addTearDown(() async {
      await subscription.cancel();
      await server.close();
    });
    when(() => container.mappedPort(6379)).thenAnswer((_) async => server.port);
    await Wait.forListeningPort(
      port: 6379,
      timeout: timeout,
      pollInterval: interval,
    ).waitUntilReady(container);
  });

  test('TCP wait retries connection refusal then times out', () async {
    final server = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
    final unused = server.port;
    await server.close();
    when(() => container.mappedPort(6379)).thenAnswer((_) async => unused);
    await expectLater(
      Wait.forListeningPort(
        port: 6379,
        timeout: const Duration(milliseconds: 30),
        pollInterval: interval,
      ).waitUntilReady(container),
      throwsA(isA<WaitTimeoutException>()),
    );
  });

  test(
    'HTTP wait checks path and status, retrying non-ready responses',
    () async {
      final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
      addTearDown(() => server.close(force: true));
      var calls = 0;
      server.listen((request) async {
        expect(request.uri.path, '/health');
        request.response.statusCode = ++calls == 1 ? 503 : 204;
        await request.response.close();
      });
      when(
        () => container.mappedPort(8080),
      ).thenAnswer((_) async => server.port);
      await Wait.forHttp(
        port: 8080,
        path: '/health',
        statusCode: 204,
        timeout: timeout,
        pollInterval: interval,
      ).waitUntilReady(container);
      expect(calls, 2);
    },
  );

  test('exec wait retries non-zero exit codes', () async {
    var calls = 0;
    when(() => container.exec(['redis-cli', 'ping'])).thenAnswer(
      (_) async =>
          ExecResult(exitCode: ++calls == 1 ? 1 : 0, stdout: '', stderr: ''),
    );
    await Wait.forSuccessfulCommand(
      ['redis-cli', 'ping'],
      timeout: timeout,
      pollInterval: interval,
    ).waitUntilReady(container);
    expect(calls, 2);
  });

  test('wait-all runs strategies in order', () async {
    when(() => container.logs()).thenAnswer((_) async => 'ready');
    await Wait.forAll([
      Wait.forLogMessage('ready'),
      Wait.forLogMessage('ready'),
    ]).waitUntilReady(container);
    verify(() => container.logs()).called(2);
  });

  test('wait configuration is validated', () {
    expect(() => Wait.forLogMessage(''), throwsArgumentError);
    expect(() => Wait.forLogMessage('ready', times: 0), throwsArgumentError);
    expect(
      () => Wait.forLogMessage('ready', timeout: Duration.zero),
      throwsArgumentError,
    );
    expect(
      () => Wait.forLogMessage('ready', pollInterval: Duration.zero),
      throwsArgumentError,
    );
    expect(() => Wait.forListeningPort(port: 65536), throwsArgumentError);
    expect(() => Wait.forHttp(port: 80, path: 'health'), throwsArgumentError);
    expect(
      () => Wait.forHttp(port: 80, path: '//other-host/health'),
      throwsArgumentError,
    );
    expect(() => Wait.forSuccessfulCommand([]), throwsArgumentError);
  });
}
