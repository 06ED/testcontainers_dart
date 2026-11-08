import 'dart:async';
import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:docker_engine/docker_engine.dart'
    show
        ContainerCreateResponse,
        ContainerInspectResponse,
        ContainerState,
        ContainerSummary,
        Docker,
        ImageInspect;
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:testcontainers_dart/testcontainers_dart.dart';

class MockDockerApi() extends Mock implements Docker;

void main() {
  late MockDockerApi api;

  setUp(() {
    api = MockDockerApi();

    when(() => api.imagesNameJsonGet(name: any(named: 'name')))
        .thenAnswer((_) async => response<ImageInspect>(404, null));

    when(() => api.imagesCreatePost(fromImage: any(named: 'fromImage')))
        .thenAnswer((_) async => response<dynamic>(200, null));

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

    when(() => api.containersIdStartPost(id: any(named: 'id')))
        .thenAnswer((_) async => response<dynamic>(204, null));

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

  group('StartedContainer', () {
    late StartedContainer container;
    setUp(() {
      container = StartedContainer(
        api: api,
        id: 'container-1',
        image: 'redis',
        host: 'localhost',
      );
    });

    test(
      'inspect falls back to a typed response when there are no raw bytes',
      () async {
        const info = ContainerInspectResponse(
          id: 'container-1',
          state: ContainerState(running: true),
        );
        when(() => api.containersIdJsonGet(id: 'container-1'))
            .thenAnswer((_) async => response(200, info));
        expect(await container.inspect(), info.toJson());
      },
    );

    test(
      'inspect preserves raw fields unknown to the generated model',
      () async {
        when(() => api.containersIdJsonGet(id: 'container-1')).thenAnswer(
          (_) async => response(
            200,
            const ContainerInspectResponse(id: 'container-1'),
            rawBody: '{"Id":"container-1","FutureField":42}',
          ),
        );
        expect(await container.inspect(), {
          'Id': 'container-1',
          'FutureField': 42,
        });
      },
    );

    test(
      'mapped ports reject invalid protocols and invalid host bindings',
      () async {
        await expectLater(
          container.mappedPort(6379, protocol: 'sctp'),
          throwsArgumentError,
        );
        for (final port in ['invalid', '0', '65536']) {
          when(() => api.containersIdJsonGet(id: 'container-1')).thenAnswer(
            (_) async => response(
              200,
              const ContainerInspectResponse(),
              rawBody: jsonEncode({
                'NetworkSettings': {
                  'Ports': {
                    '6379/tcp': [
                      {'HostPort': port},
                    ],
                  },
                },
              }),
            ),
          );
          await expectLater(
            container.mappedPort(6379),
            throwsA(
              isA<StateError>().having(
                (e) => e.message,
                'message',
                contains('Invalid host port'),
              ),
            ),
          );
        }
      },
    );

    test(
      'exec rejects empty commands and NUL arguments before calling Docker',
      () async {
        await expectLater(container.exec([]), throwsArgumentError);
        await expectLater(
          container.exec(['echo', '\u0000']),
          throwsArgumentError,
        );
        verifyNever(
          () => api.containersIdExecPost(
            id: any(named: 'id'),
            execConfig: any(named: 'execConfig'),
          ),
        );
      },
    );
  });

  test('exceptions describe the container, logs and cleanup failures', () {
    expect(
      const ContainerExitedException('container-1', 42).toString(),
      allOf(contains('container-1'), contains('42')),
    );
    final cause = StateError('startup failed');
    final cleanup = StateError('removal failed');
    expect(
      ContainerStartException(cause, containerId: 'container-1').toString(),
      allOf(contains('container-1'), contains('startup failed')),
    );
    expect(
      ContainerStartException(
        cause,
        containerId: 'container-1',
        logs: 'recent logs',
        cleanupError: cleanup,
      ).toString(),
      allOf(
        contains('container-1'),
        contains('startup failed'),
        contains('recent logs'),
        contains('removal failed'),
      ),
    );
  });

  group('DockerProvider', () {
    test(
      'untagged images pull latest, not every tag in the repository',
      () async {
        final provider = DockerProvider(
          dockerApi: api,
          ryuk: const RyukConfig(enabled: false),
        );
        for (final image in ['redis', 'registry.example:5000/team/redis']) {
          await provider.start(ContainerConfig(image: image));
          verify(() => api.imagesCreatePost(fromImage: '$image:latest'))
              .called(1);
        }
      },
    );

    test(
      'request values are snapshotted before the first Docker call',
      () async {
        final pull = Completer<Response<dynamic>>();
        when(() => api.imagesCreatePost(fromImage: any(named: 'fromImage')))
            .thenAnswer((_) => pull.future);
        final environment = {'MODE': 'test'};
        final command = ['original'];
        final labels = {'owner': 'test'};
        final started =
            DockerProvider(
              dockerApi: api,
              ryuk: const RyukConfig(enabled: false),
            ).start(
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

    test('concurrent termination performs one delete, and failed deletion can retry', () async {
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
        ryuk: const RyukConfig(enabled: false),
      ).start(const ContainerConfig(image: 'redis'));
      await expectLater(container.terminate(), throwsA(isA<DockerException>()));
      await Future.wait([container.terminate(), container.terminate()]);
      expect(calls, 2);
    });

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
            ryuk: const RyukConfig(enabled: false),
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
        final provider = DockerProvider(
          dockerApi: api,
          ryuk: const RyukConfig(enabled: false),
        );
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
      final provider = DockerProvider(
        dockerApi: api,
        ryuk: const RyukConfig(enabled: false),
      );
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
      when(() => api.imagesCreatePost(fromImage: any(named: 'fromImage')))
          .thenAnswer(
            (_) async => response<dynamic>(
              500,
              null,
              rawBody: '{"message":"registry unavailable"}',
            ),
          );
      await expectLater(
        DockerProvider(
          dockerApi: api,
          ryuk: const RyukConfig(enabled: false),
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
      when(() => api.imagesCreatePost(fromImage: any(named: 'fromImage')))
          .thenAnswer(
            (_) async => response<dynamic>(
              200,
              null,
              rawBody: '{"status":"Pulling"}\n{"error":"denied"}\n',
            ),
          );
      await expectLater(
        DockerProvider(
          dockerApi: api,
          ryuk: const RyukConfig(enabled: false),
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
        when(() => api.containersIdStartPost(id: any(named: 'id')))
            .thenAnswer((_) async => response<dynamic>(500, null));
        await expectLater(
          DockerProvider(
            dockerApi: api,
            ryuk: const RyukConfig(enabled: false),
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
            ryuk: const RyukConfig(enabled: false),
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
          ryuk: const RyukConfig(enabled: false),
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
        ryuk: const RyukConfig(enabled: false),
      ).start(const ContainerConfig(image: 'redis'));
      await expectLater(container.mappedPort(6379), throwsA(isA<StateError>()));
    });

    test('starts container using pull -> create -> start flow', () async {
      final provider = DockerProvider(
        dockerApi: api,
        ryuk: const RyukConfig(enabled: false),
      );

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
        () => api.imagesNameJsonGet(name: 'redis:7-alpine'),
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
          rawBody: '{"State":{"Running":true},"NetworkSettings":{"Ports":{"6379/tcp":[{"HostIp":"127.0.0.1","HostPort":"32768"}]}}}',
        ),
      );

      final provider = DockerProvider(
        dockerApi: api,
        ryuk: const RyukConfig(enabled: false),
      );
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
      final provider = DockerProvider(
        dockerApi: api,
        ryuk: const RyukConfig(enabled: false),
      );
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

class FailingWait() implements Wait {
  @override
  Future<void> waitUntilReady(StartedContainer container) async {
    throw StateError('not ready');
  }
}
