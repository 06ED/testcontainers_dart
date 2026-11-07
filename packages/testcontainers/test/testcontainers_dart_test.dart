import 'dart:async';

import 'package:chopper/chopper.dart';
import 'package:docker_engine/docker_engine.dart'
    show
        ContainerCreateResponse,
        ContainerInspectResponse,
        ContainerState,
        ContainerSummary;
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:testcontainers/testcontainers.dart';

class MockDockerApi extends Mock implements DockerApi {}

void main() {
  late MockDockerApi api;

  setUp(() {
    api = MockDockerApi();

    when(
      () => api.imagesCreatePost(fromImage: any(named: 'fromImage')),
    ).thenAnswer((_) async => response<dynamic>(200, null));

    when(
      () => api.containersCreatePost(
        name: any(named: 'name'),
        body: any(named: 'body'),
      ),
    ).thenAnswer(
      (_) async => response<ContainerCreateResponse>(
        201,
        const ContainerCreateResponse(id: 'container-1', warnings: <String>[]),
      ),
    );

    when(
      () => api.containersIdStartPost(id: any(named: 'id')),
    ).thenAnswer((_) async => response<dynamic>(204, null));

    when(
      () => api.containersIdStopPost(
        id: any(named: 'id'),
        t: any(named: 't'),
      ),
    ).thenAnswer((_) async => response<dynamic>(204, null));

    when(
      () => api.containersIdDelete(
        id: any(named: 'id'),
        force: any(named: 'force'),
        v: any(named: 'v'),
      ),
    ).thenAnswer((_) async => response<dynamic>(204, null));

    when(() => api.containersIdJsonGet(id: any(named: 'id'))).thenAnswer(
      (_) async => response<ContainerInspectResponse>(
        200,
        const ContainerInspectResponse(state: ContainerState(running: true)),
        rawBody: '{"State":{"Running":true}}',
      ),
    );

    when(
      () => api.containersIdLogsGet(
        id: any(named: 'id'),
        stdout: any(named: 'stdout'),
        stderr: any(named: 'stderr'),
        tail: any(named: 'tail'),
      ),
    ).thenAnswer((_) async => response<String>(200, 'ok'));

    when(() => api.containersJsonGet(all: any(named: 'all'))).thenAnswer(
      (_) async =>
          response<List<ContainerSummary>>(200, const <ContainerSummary>[]),
    );
  });

  group('DockerProvider', () {
    test(
      'untagged images pull latest, not every tag in the repository',
      () async {
        final provider = DockerProvider(dockerApi: api);
        for (final image in ['redis', 'registry.example:5000/team/redis']) {
          await provider.start(ContainerConfig(image: image));
          verify(
            () => api.imagesCreatePost(fromImage: '$image:latest'),
          ).called(1);
        }
      },
    );

    test(
      'request values are snapshotted before the first Docker call',
      () async {
        final pull = Completer<Response<dynamic>>();
        when(
          () => api.imagesCreatePost(fromImage: any(named: 'fromImage')),
        ).thenAnswer((_) => pull.future);
        final environment = {'MODE': 'test'};
        final command = ['original'];
        final labels = {'owner': 'test'};
        final started = DockerProvider(dockerApi: api).start(
          ContainerConfig(
            image: 'redis',
            environment: environment,
            command: command,
            labels: labels,
          ),
        );
        environment['MODE'] = 'changed';
        command[0] = 'changed';
        labels['owner'] = 'changed';
        pull.complete(response<dynamic>(200, null));
        await started;
        final body =
            verify(
                  () => api.containersCreatePost(
                    name: null,
                    body: captureAny(named: 'body'),
                  ),
                ).captured.single
                as Map<String, dynamic>;
        expect(body['Env'], ['MODE=test']);
        expect(body['Cmd'], ['original']);
        expect(body['Labels'], {'owner': 'test'});
      },
    );

    test(
      'concurrent termination performs one delete, and failed deletion can retry',
      () async {
        var calls = 0;
        when(
          () => api.containersIdDelete(
            id: any(named: 'id'),
            force: any(named: 'force'),
            v: any(named: 'v'),
          ),
        ).thenAnswer(
          (_) async => response<dynamic>(++calls == 1 ? 500 : 204, null),
        );
        final container = await DockerProvider(
          dockerApi: api,
        ).start(const ContainerConfig(image: 'redis'));
        await expectLater(
          container.terminate(),
          throwsA(isA<DockerException>()),
        );
        await Future.wait([container.terminate(), container.terminate()]);
        expect(calls, 2);
      },
    );

    test(
      'creation errors never attempt cleanup of an unknown container',
      () async {
        when(
          () => api.containersCreatePost(
            name: any(named: 'name'),
            body: any(named: 'body'),
          ),
        ).thenAnswer((_) async => response<ContainerCreateResponse>(409, null));
        await expectLater(
          DockerProvider(
            dockerApi: api,
          ).start(const ContainerConfig(image: 'redis')),
          throwsA(isA<DockerException>()),
        );
        verifyNever(
          () => api.containersIdDelete(
            id: any(named: 'id'),
            force: any(named: 'force'),
            v: any(named: 'v'),
          ),
        );
      },
    );

    test(
      'passes environment, command, ports and read-only bind mounts',
      () async {
        final provider = DockerProvider(dockerApi: api);
        await provider.start(
          const ContainerConfig(
            image: 'redis:7-alpine',
            name: 'cache',
            environment: {'MODE': 'test'},
            command: ['redis-server'],
            exposedPorts: [Port.tcp(6379), Port.udp(5353)],
            mounts: [BindMount(source: '/host/data', target: '/data')],
          ),
        );
        final body =
            verify(
                  () => api.containersCreatePost(
                    name: 'cache',
                    body: captureAny(named: 'body'),
                  ),
                ).captured.single
                as Map<String, dynamic>;
        expect(body['Env'], ['MODE=test']);
        expect(body['Cmd'], ['redis-server']);
        expect(body['ExposedPorts'], {'6379/tcp': {}, '5353/udp': {}});
        expect(body['HostConfig'], {
          'PortBindings': {
            '6379/tcp': [
              {'HostIp': '127.0.0.1', 'HostPort': ''},
            ],
            '5353/udp': [
              {'HostIp': '127.0.0.1', 'HostPort': ''},
            ],
          },
          'Mounts': [
            {
              'Type': 'bind',
              'Source': '/host/data',
              'Target': '/data',
              'ReadOnly': true,
            },
          ],
        });
      },
    );

    test('validates requests before contacting Docker', () async {
      final provider = DockerProvider(dockerApi: api);
      for (final request in [
        const ContainerConfig(image: ''),
        const ContainerConfig(image: 'redis', exposedPorts: [Port.tcp(0)]),
        const ContainerConfig(image: 'redis', environment: {'A=B': 'value'}),
        const ContainerConfig(
          image: 'redis',
          mounts: [BindMount(source: 'relative', target: '/data')],
        ),
      ]) {
        await expectLater(provider.start(request), throwsArgumentError);
      }
      verifyNever(
        () => api.imagesCreatePost(fromImage: any(named: 'fromImage')),
      );
    });

    test('does not create a container when pull fails', () async {
      when(
        () => api.imagesCreatePost(fromImage: any(named: 'fromImage')),
      ).thenAnswer(
        (_) async => response<dynamic>(
          500,
          null,
          rawBody: '{"message":"registry unavailable"}',
        ),
      );
      await expectLater(
        DockerProvider(
          dockerApi: api,
        ).start(const ContainerConfig(image: 'redis')),
        throwsA(
          isA<DockerException>().having((e) => e.statusCode, 'status', 500),
        ),
      );
      verifyNever(
        () => api.containersCreatePost(
          name: any(named: 'name'),
          body: any(named: 'body'),
        ),
      );
    });

    test('detects errors inside successful pull HTTP responses', () async {
      when(
        () => api.imagesCreatePost(fromImage: any(named: 'fromImage')),
      ).thenAnswer(
        (_) async => response<dynamic>(
          200,
          null,
          rawBody: '{"status":"Pulling"}\n{"error":"denied"}\n',
        ),
      );
      await expectLater(
        DockerProvider(
          dockerApi: api,
        ).start(const ContainerConfig(image: 'redis')),
        throwsA(
          isA<DockerException>().having(
            (e) => e.message,
            'message',
            contains('denied'),
          ),
        ),
      );
      verifyNever(
        () => api.containersCreatePost(
          name: any(named: 'name'),
          body: any(named: 'body'),
        ),
      );
    });

    test(
      'removes created container when start fails and includes logs',
      () async {
        when(
          () => api.containersIdStartPost(id: any(named: 'id')),
        ).thenAnswer((_) async => response<dynamic>(500, null));
        await expectLater(
          DockerProvider(
            dockerApi: api,
          ).start(const ContainerConfig(image: 'redis')),
          throwsA(
            isA<ContainerStartException>().having(
              (e) => e.logs,
              'logs',
              contains('ok'),
            ),
          ),
        );
        verify(
          () => api.containersIdDelete(id: 'container-1', force: true, v: true),
        ).called(1);
      },
    );

    test(
      'cleans up when readiness fails and retains cleanup failure',
      () async {
        when(
          () => api.containersIdDelete(
            id: any(named: 'id'),
            force: any(named: 'force'),
            v: any(named: 'v'),
          ),
        ).thenAnswer((_) async => response<dynamic>(500, null));
        await expectLater(
          DockerProvider(
            dockerApi: api,
          ).start(ContainerConfig(image: 'redis', waitStrategy: FailingWait())),
          throwsA(
            isA<ContainerStartException>()
                .having((e) => e.cause, 'cause', isA<StateError>())
                .having(
                  (e) => e.cleanupError,
                  'cleanup error',
                  isA<DockerException>(),
                ),
          ),
        );
      },
    );

    test(
      'termination is idempotent and treats a missing container as removed',
      () async {
        when(
          () => api.containersIdDelete(
            id: any(named: 'id'),
            force: any(named: 'force'),
            v: any(named: 'v'),
          ),
        ).thenAnswer((_) async => response<dynamic>(404, null));
        final container = await DockerProvider(
          dockerApi: api,
        ).start(const ContainerConfig(image: 'redis'));
        await container.terminate();
        await container.terminate();
        verify(
          () => api.containersIdDelete(id: 'container-1', force: true, v: true),
        ).called(1);
      },
    );

    test('fails clearly when a port has no binding', () async {
      final container = await DockerProvider(
        dockerApi: api,
      ).start(const ContainerConfig(image: 'redis'));
      await expectLater(container.mappedPort(6379), throwsA(isA<StateError>()));
    });

    test('starts container using pull -> create -> start flow', () async {
      final provider = DockerProvider(dockerApi: api);

      final container = await provider.start(
        const ContainerConfig(
          image: 'redis:7-alpine',
          exposedPorts: [Port.tcp(6379)],
          waitStrategy: NoWaitStrategy(),
        ),
      );

      expect(container.id, 'container-1');
      expect(container.image, 'redis:7-alpine');

      verifyInOrder(<void Function()>[
        () => api.imagesCreatePost(fromImage: 'redis:7-alpine'),
        () => api.containersCreatePost(name: null, body: any(named: 'body')),
        () => api.containersIdStartPost(id: 'container-1'),
      ]);
    });

    test('resolves mapped port from inspect response', () async {
      when(() => api.containersIdJsonGet(id: 'container-1')).thenAnswer(
        (_) async => response<ContainerInspectResponse>(
          200,
          const ContainerInspectResponse(state: ContainerState(running: true)),
          rawBody:
              '{"State":{"Running":true},"NetworkSettings":{"Ports":{"6379/tcp":[{"HostIp":"127.0.0.1","HostPort":"32768"}]}}}',
        ),
      );

      final provider = DockerProvider(dockerApi: api);
      final container = await provider.start(
        const ContainerConfig(
          image: 'redis:7-alpine',
          exposedPorts: [Port.tcp(6379)],
          waitStrategy: NoWaitStrategy(),
        ),
      );

      final hostPort = await container.mappedPort(6379);

      expect(hostPort, 32768);
      verify(() => api.containersIdJsonGet(id: 'container-1')).called(1);
    });

    test('uses stop timeout when stopping container', () async {
      final provider = DockerProvider(dockerApi: api);
      final container = await provider.start(
        const ContainerConfig(
          image: 'redis:7-alpine',
          waitStrategy: NoWaitStrategy(),
        ),
      );

      await container.stop(timeout: const Duration(seconds: 5));

      verify(() => api.containersIdStopPost(id: 'container-1', t: 5)).called(1);
    });
  });
}

Response<T> response<T>(int statusCode, T? body, {String rawBody = ''}) {
  return Response<T>(http.Response(rawBody, statusCode), body);
}

class FailingWait implements WaitStrategy {
  @override
  Future<void> waitUntilReady(StartedContainer container) async {
    throw StateError('not ready');
  }
}
