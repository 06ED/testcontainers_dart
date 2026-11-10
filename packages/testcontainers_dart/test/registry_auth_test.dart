import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';
import 'package:testcontainers_dart/src/auth/registry_auth.dart';
import 'package:testcontainers_dart/testcontainers_dart.dart';

void main() {
  late Directory directory;
  late Map<String, String> environment;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('registry-auth-');
    environment = {'HOME': directory.path};
  });
  tearDown(() => directory.delete(recursive: true));

  String auth(String password) => base64Encode(utf8.encode('user:$password'));
  Future<void> config(Map<String, Object?> value) async {
    final file = File('${directory.path}/.docker/config.json');
    await file.parent.create(recursive: true);
    await file.writeAsString(jsonEncode(value));
  }

  Future<Map<String, dynamic>?> resolve(
    String image, {
    Map<String, RegistryCredentials> credentials = const {},
  }) async {
    final header = await RegistryAuth(
      credentials: credentials,
      environment: environment,
    ).resolve(image);
    return header == null
        ? null
        : jsonDecode(utf8.decode(base64Url.decode(header)))
              as Map<String, dynamic>;
  }

  test(
    'explicit credentials bypass even malformed environment and file',
    () async {
      environment['DOCKER_AUTH_CONFIG'] = 'secret-invalid-json';
      await config({'auths': 'invalid'});
      expect(
        await resolve(
          'registry.test:5000/team/app:1',
          credentials: {
            'registry.test:5000': RegistryCredentials(
              username: 'explicit',
              password: 'secret',
            ),
          },
        ),
        {
          'username': 'explicit',
          'password': 'secret',
          'serveraddress': 'registry.test:5000',
        },
      );
    },
  );

  test(
    'environment overrides file per registry, without merging fields',
    () async {
      await config({
        'auths': {
          'registry.test': {'auth': auth('file')},
          'other.test': {'auth': auth('other')},
        },
      });
      environment['DOCKER_AUTH_CONFIG'] = jsonEncode({
        'auths': {
          'registry.test': {'auth': auth('env:with:colons')},
        },
      });
      expect(
        (await resolve('registry.test/app'))!['password'],
        'env:with:colons',
      );
      expect((await resolve('other.test/app'))!['password'], 'other');
      expect(await resolve('unrelated.test/app'), isNull);
    },
  );

  test('DOCKER_CONFIG replaces the default directory', () async {
    await config({
      'auths': {
        'registry.test': {'auth': auth('home')},
      },
    });
    environment['DOCKER_CONFIG'] = '${directory.path}/custom';
    final file = File('${environment['DOCKER_CONFIG']}/config.json');
    await file.parent.create();
    await file.writeAsString(
      jsonEncode({
        'auths': {
          'registry.test': {'auth': auth('custom')},
        },
      }),
    );
    expect((await resolve('registry.test/app'))!['password'], 'custom');
  });

  test(
    'Docker Hub aliases, tags and digests resolve to the same registry',
    () async {
      await config({
        'auths': {
          'https://index.docker.io/v1/': {'auth': auth('hub')},
        },
      });
      for (final image in [
        'redis:7',
        'team/app',
        'docker.io/team/app',
        'index.docker.io/team/app@sha256:${'a' * 64}',
        'registry-1.docker.io/library/redis',
      ]) {
        expect((await resolve(image))!['password'], 'hub', reason: image);
      }
      expect(await resolve('docker.io.evil.test/app'), isNull);
    },
  );

  test(
    'identity tokens are supported and credentials never stringify secrets',
    () async {
      final token = RegistryCredentials.identityToken('secret-token');
      expect(token.toString(), isNot(contains('secret-token')));
      expect(
        (await resolve(
          'registry.test/app',
          credentials: {'registry.test': token},
        ))!['identitytoken'],
        'secret-token',
      );
      await config({
        'auths': {
          'registry.test': {'identitytoken': 'file-token'},
        },
      });
      expect(
        (await resolve('registry.test/app'))!['identitytoken'],
        'file-token',
      );
    },
  );

  test('malformed config and auth errors do not contain their input', () async {
    for (final value in [
      'secret-invalid-json',
      jsonEncode({
        'auths': {
          'registry.test': {'auth': 'secret-invalid-base64'},
        },
      }),
      jsonEncode({
        'auths': {
          'registry.test': {
            'auth': base64Encode(utf8.encode('secret-no-colon')),
          },
        },
      }),
    ]) {
      environment['DOCKER_AUTH_CONFIG'] = value;
      await expectLater(
        resolve('registry.test/app'),
        throwsA(
          isA<RegistryAuthException>().having(
            (e) => e.toString(),
            'safe message',
            isNot(contains('secret')),
          ),
        ),
      );
    }
  });

  test('username/password entries and empty auth placeholders', () async {
    await config({
      'auths': {
        'registry.test': {'username': 'plain', 'password': 'plain-password'},
        'empty.test': {'auth': ''},
      },
    });
    expect((await resolve('registry.test/app'))!['password'], 'plain-password');
    expect(await resolve('empty.test/app'), isNull);
    expect(await resolve('missing.test/app'), isNull);
    expect(await RegistryAuth(environment: {}).resolve('redis'), isNull);
  });

  test(
    'invalid explicit credentials and registry names never expose values',
    () {
      for (final create in <Object Function()>[
        () => RegistryCredentials(username: 'secret:user', password: 'secret'),
        () => RegistryCredentials(username: '', password: 'secret'),
        () => RegistryCredentials.identityToken(''),
        () => RegistryAuth(
          credentials: {
            'https://secret:secret@registry.test':
                RegistryCredentials.identityToken('secret'),
          },
        ),
        () => RegistryAuth(
          credentials: {
            'registry.test/secret': RegistryCredentials.identityToken('secret'),
          },
        ),
      ]) {
        expect(
          create,
          throwsA(
            predicate<Object>((error) => !error.toString().contains('secret')),
          ),
        );
      }
    },
  );

  test(
    'unreadable and malformed files do not allow anonymous fallback',
    () async {
      final file = File('${directory.path}/.docker/config.json');
      await file.parent.create();
      await file.writeAsString('secret-invalid-json');
      await expectLater(
        resolve('registry.test/app'),
        throwsA(isA<RegistryAuthException>()),
      );
      await file.delete();
      await Directory(file.path).create();
      await expectLater(
        resolve('registry.test/app'),
        throwsA(
          isA<RegistryAuthException>().having(
            (e) => e.message,
            'safe error',
            'Cannot read Docker credential config',
          ),
        ),
      );
    },
  );

  test('registry matching never uses prefixes or ignores ports', () async {
    await config({
      'auths': {
        'https://registry.test:5000/': {'auth': auth('port')},
      },
    });
    expect((await resolve('registry.test:5000/app'))!['password'], 'port');
    expect(await resolve('registry.test/app'), isNull);
    expect(await resolve('registry.test:5001/app'), isNull);
    expect(await resolve('registry.test.evil/app'), isNull);
    await config({
      'auths': {
        'http://registry.test:80': {'auth': auth('http-port')},
      },
    });
    expect(await resolve('registry.test/app'), isNull);
    expect((await resolve('registry.test:80/app'))!['password'], 'http-port');
  });

  test(
    'uppercase single-label registry does not receive Docker Hub credentials',
    () async {
      await config({
        'auths': {
          'docker.io': {'auth': auth('hub')},
        },
      });
      expect(await resolve('PRIVATE/team/app'), isNull);
      await config({
        'auths': {
          'private': {'auth': auth('private')},
        },
      });
      expect((await resolve('PRIVATE/team/app'))!['password'], 'private');
    },
  );

  group('credential helpers', () {
    Future<void> helper(String name, String script) async {
      final file = File('${directory.path}/docker-credential-$name');
      await file.writeAsString('#!/bin/sh\n$script\n');
      expect((await Process.run('chmod', ['+x', file.path])).exitCode, 0);
      environment['PATH'] = '${directory.path}:/usr/bin:/bin';
    }

    test('registry helper overrides store and inline auth, using stdin not arguments', () async {
      await helper('specific', '''
test "\$#" = 1 && test "\$1" = get || exit 9
read registry
test "\$registry" = registry.test:5000 || exit 8
printf '%s' '{"Username":"helper","Secret":"specific"}'
''');
      await helper(
        'global',
        "printf '%s' '{\"Username\":\"helper\",\"Secret\":\"global\"}'",
      );
      await config({
        'credHelpers': {'registry.test:5000': 'specific'},
        'credsStore': 'global',
        'auths': {
          'registry.test:5000': {'auth': auth('stale')},
        },
      });
      expect(
        (await resolve('registry.test:5000/team/app'))!['password'],
        'specific',
      );
      expect((await resolve('other.test/app'))!['password'], 'global');
    });

    test('environment credentials bypass the configured helper', () async {
      await config({'credsStore': 'nonexistent-helper'});
      environment['DOCKER_AUTH_CONFIG'] = jsonEncode({
        'auths': {
          'registry.test': {'auth': auth('env')},
        },
      });
      expect((await resolve('registry.test/app'))!['password'], 'env');
    });

    test('helper token and Docker Hub server address', () async {
      await helper('token', '''
read registry
test "\$registry" = https://index.docker.io/v1/ || exit 9
printf '%s' '{"Username":"<token>","Secret":"helper-token"}'
''');
      await config({'credsStore': 'token'});
      expect((await resolve('redis:7'))!['identitytoken'], 'helper-token');
    });

    test(
      'not found permits anonymous pull without using stale inline auth',
      () async {
        await helper(
          'absent',
          "echo 'credentials not found in native keychain'; exit 1",
        );
        await config({
          'credsStore': 'absent',
          'auths': {
            'registry.test': {'auth': auth('stale')},
          },
        });
        expect(await resolve('registry.test/app'), isNull);
      },
    );

    test(
      'helper failures never expose stdout, stderr or malformed JSON',
      () async {
        for (final script in [
          'echo secret-stdout; echo secret-stderr >&2; exit 1',
          'echo secret-invalid-json',
          '''echo '{"Username":"secret-user","Secret":3}' ''',
        ]) {
          await helper('broken', script);
          await config({'credsStore': 'broken'});
          await expectLater(
            resolve('registry.test/app'),
            throwsA(
              isA<RegistryAuthException>().having(
                (e) => e.toString(),
                'safe error',
                isNot(contains('secret')),
              ),
            ),
          );
        }
      },
    );

    test('missing and unsafe helper names fail without falling back', () async {
      for (final name in [
        'nonexistent-testcontainers-helper',
        '../secret',
        'secret; echo bad',
      ]) {
        await config({
          'credsStore': name,
          'auths': {
            'registry.test': {'auth': auth('stale')},
          },
        });
        await expectLater(
          resolve('registry.test/app'),
          throwsA(
            isA<RegistryAuthException>().having(
              (e) => e.toString(),
              'safe error',
              isNot(contains('secret')),
            ),
          ),
        );
      }
    });

    test(
      'timeout kills the helper instead of leaving a pending pull',
      () async {
        await helper('slow', 'exec sleep 60');
        await config({'credsStore': 'slow'});
        final resolver = RegistryAuth(
          environment: environment,
          helperTimeout: const Duration(milliseconds: 200),
        );
        await expectLater(
          resolver.resolve('registry.test/app'),
          throwsA(
            isA<RegistryAuthException>().having(
              (e) => e.message,
              'message',
              contains('timed out'),
            ),
          ),
        );
      },
    );

    test('oversized output is bounded and never included in errors', () async {
      await helper('large', 'head -c 1048577 /dev/zero');
      await config({'credsStore': 'large'});
      await expectLater(
        resolve('registry.test/app'),
        throwsA(
          isA<RegistryAuthException>().having(
            (e) => e.message,
            'message',
            contains('exceeds limit'),
          ),
        ),
      );
    });
    test('stderr is bounded too, and a timed-out helper is reaped', () async {
      await helper('large-stderr', 'head -c 1048577 /dev/zero >&2');
      await config({'credsStore': 'large-stderr'});
      await expectLater(
        resolve('registry.test/app'),
        throwsA(
          isA<RegistryAuthException>().having(
            (e) => e.message,
            'message',
            contains('exceeds limit'),
          ),
        ),
      );
      final pidFile = File('${directory.path}/pid');
      await helper('slow', 'echo \$\$ > "${pidFile.path}"; exec sleep 60');
      await config({'credsStore': 'slow'});
      await expectLater(
        RegistryAuth(
          environment: environment,
          helperTimeout: const Duration(seconds: 2),
        ).resolve('registry.test/app'),
        throwsA(
          isA<RegistryAuthException>().having(
            (e) => e.message,
            'message',
            contains('timed out'),
          ),
        ),
      );
      final pid = (await pidFile.readAsString()).trim();
      final result = await Process.run('kill', ['-0', pid]);
      expect(
        result.exitCode,
        isNot(0),
        reason: 'Timed-out helper must have exited',
      );
    });
  }, skip: Platform.isWindows ? 'POSIX helper fixtures' : false);
}
