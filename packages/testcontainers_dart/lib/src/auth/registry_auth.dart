import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'registry_credentials.dart';

/// Shared by application and Ryuk pulls. Resolves only the requested registry.
class RegistryAuth({
  Map<String, RegistryCredentials> credentials = const {},
  Map<String, String>? environment,
  final Duration helperTimeout = const Duration(seconds: 10),
}) {
  final Map<String, RegistryCredentials> _credentials = {
    for (final entry in credentials.entries)
      _registryKey(entry.key): entry.value,
  };
  final Map<String, String> _environment = Map.of(
    environment ?? Platform.environment,
  );

  Future<String?> resolve(String image) async {
    final first = image.split('/').first;
    final registry =
        image.contains('/') &&
            (first.contains('.') ||
                first.contains(':') ||
                first == 'localhost' ||
                first.toLowerCase() != first)
        ? _registryKey(first)
        : _hub;

    var credentials = _credentials[registry];
    if (credentials == null) {
      final inline = _environment['DOCKER_AUTH_CONFIG'];
      if (inline != null && inline.isNotEmpty) {
        credentials = await _fromConfig(
          _parse(inline, 'DOCKER_AUTH_CONFIG'),
          registry,
        );
      }
    }

    if (credentials == null) {
      final directory = _environment['DOCKER_CONFIG'];
      final home = _environment[Platform.isWindows ? 'USERPROFILE' : 'HOME'];
      final path = directory != null && directory.isNotEmpty
          ? '$directory/config.json'
          : home != null && home.isNotEmpty
          ? '$home/.docker/config.json'
          : null;

      if (path != null) {
        String? text;

        try {
          text = await File(path).readAsString();
        } on FileSystemException catch (error) {
          // Missing config is normal, but permission and other I/O errors aren't.
          if (error.osError?.errorCode != 2 && error.osError?.errorCode != 3) {
            throw RegistryAuthException('Cannot read Docker credential config');
          }
        }

        if (text != null) {
          credentials = await _fromConfig(
            _parse(text, 'Docker config'),
            registry,
          );
        }
      }
    }

    return credentials == null
        ? null
        : base64Url.encode(
            utf8.encode(jsonEncode(credentials.toJson(registry))),
          );
  }

  Map<String, dynamic> _parse(String text, String source) {
    try {
      return jsonDecode(text) as Map<String, dynamic>;
    } catch (_) {
      throw RegistryAuthException('Invalid $source JSON');
    }
  }

  Future<RegistryCredentials?> _fromConfig(
    Map<String, dynamic> config,
    String registry,
  ) async {
    try {
      final helpers = config['credHelpers'] as Map<String, dynamic>?;
      final helper = _entry(helpers, registry) ?? config['credsStore'];
      if (helper != null && helper != '') {
        return await _fromHelper(helper as String, registry);
      }

      final entry = _entry(config['auths'] as Map<String, dynamic>?, registry);
      if (entry == null) return null;

      final value = entry as Map<String, dynamic>;
      if (value['identitytoken'] case final String token
          when token.isNotEmpty) {
        return RegistryCredentials.identityToken(token);
      }

      if (value['auth'] case final String auth when auth.isNotEmpty) {
        final decoded = utf8.decode(base64.decode(auth));
        final colon = decoded.indexOf(':');
        if (colon < 1) throw const FormatException();
        return RegistryCredentials(
          username: decoded.substring(0, colon),
          password: decoded.substring(colon + 1),
        );
      }

      if (value['username'] != null || value['password'] != null) {
        return RegistryCredentials(
          username: value['username'] as String,
          password: value['password'] as String,
        );
      }

      if (value.isEmpty || value['auth'] == '') return null;
      throw const FormatException();
    } on RegistryAuthException {
      rethrow;
    } catch (_) {
      throw RegistryAuthException('Invalid Docker registry credentials');
    }
  }

  Object? _entry(Map<String, dynamic>? entries, String registry) {
    if (entries == null) return null;
    if (entries.containsKey(registry)) return entries[registry];

    for (final entry in entries.entries) {
      if (_registryKey(entry.key) == registry) return entry.value;
    }

    return null;
  }

  Future<RegistryCredentials?> _fromHelper(
    String helper,
    String registry,
  ) async {
    if (!RegExp(r'^[a-zA-Z0-9][a-zA-Z0-9_.-]*$').hasMatch(helper)) {
      throw RegistryAuthException('Invalid Docker credential helper name');
    }
    Process? process;
    final subscriptions = <StreamSubscription<List<int>>>[];
    try {
      process = await Process.start(
        'docker-credential-$helper',
        ['get'],
        environment: _environment,
        includeParentEnvironment: false,
        runInShell: false,
      );
      final running = process;
      Future<List<int>> read(Stream<List<int>> stream) {
        final bytes = <int>[];
        final result = Completer<List<int>>();
        subscriptions.add(
          stream.listen(
            (chunk) {
              if (result.isCompleted) return;
              if (bytes.length + chunk.length > 1024 * 1024) {
                running.kill(ProcessSignal.sigkill);
                result.completeError(
                  RegistryAuthException(
                    'Docker credential helper output exceeds limit',
                  ),
                );
              } else {
                bytes.addAll(chunk);
              }
            },
            onError: (Object error, StackTrace stack) {
              if (!result.isCompleted) result.completeError(error, stack);
            },
            onDone: () {
              if (!result.isCompleted) result.complete(bytes);
            },
          ),
        );
        return result.future;
      }

      // Drain both pipes while writing stdin, so a broken helper cannot deadlock.
      final outputBytes = Future.wait([
        read(running.stdout),
        read(running.stderr),
      ], eagerError: true);
      final result = await Future.wait<Object>([
        outputBytes,
        running.exitCode,
        (() async {
          running.stdin.writeln(registry);
          await running.stdin.close();
          return true;
        })(),
      ], eagerError: true).timeout(helperTimeout);

      final output = result[0] as List<List<int>>;
      final stdout = utf8.decode(output[0]);
      final stderr = utf8.decode(output[1], allowMalformed: true);

      if (result[1] != 0) {
        if (stdout.trim() == 'credentials not found in native keychain' ||
            stderr.trim() == 'credentials not found in native keychain') {
          return null;
        }
        throw RegistryAuthException(
          'Docker credential helper failed (exit ${result[1]})',
        );
      }

      final value = jsonDecode(stdout) as Map<String, dynamic>;
      final username = value['Username'] as String;
      final secret = value['Secret'] as String;

      return username == '<token>'
          ? RegistryCredentials.identityToken(secret)
          : RegistryCredentials(username: username, password: secret);
    } on RegistryAuthException {
      rethrow;
    } on TimeoutException {
      throw RegistryAuthException('Docker credential helper timed out');
    } on ProcessException {
      throw RegistryAuthException('Cannot start Docker credential helper');
    } catch (_) {
      throw RegistryAuthException('Invalid Docker credential helper response');
    } finally {
      process?.kill(ProcessSignal.sigkill);
      // Descendants may inherit the pipes; don't keep Dart alive waiting for them.
      await Future.wait(
        subscriptions.map((subscription) => subscription.cancel()),
      );
      await process?.exitCode;
    }
  }
}

const _hub = 'https://index.docker.io/v1/';

String _registryKey(String value) {
  try {
    final address = value.contains('://') ? value : 'https://$value';
    final uri = Uri.parse(address);
    if (!{'http', 'https'}.contains(uri.scheme) ||
        uri.host.isEmpty ||
        uri.userInfo.isNotEmpty ||
        uri.hasQuery ||
        uri.hasFragment ||
        (uri.hasPort && (uri.port < 1 || uri.port > 65535)) ||
        (uri.path != '' &&
            uri.path != '/' &&
            !(uri.host == 'index.docker.io' &&
                {'/v1', '/v1/'}.contains(uri.path)))) {
      throw const FormatException();
    }

    // Preserve explicit ports even when Uri would elide a scheme's default port.
    final authority = address
        .substring(address.indexOf('://') + 3)
        .split('/')
        .first
        .toLowerCase();
    if ({
      'docker.io',
      'index.docker.io',
      'registry-1.docker.io',
    }.contains(authority)) {
      return _hub;
    }

    return authority;
  } catch (_) {
    throw RegistryAuthException('Invalid registry address');
  }
}
