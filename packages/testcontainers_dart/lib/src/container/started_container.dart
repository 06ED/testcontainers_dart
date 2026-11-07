import 'dart:convert';

import 'package:docker_engine/docker_engine.dart';
import 'package:http/http.dart' as http;

import 'container_config.dart';

class StartedContainer {
  StartedContainer({
    required Docker api,
    required this.id,
    required this.image,
    required this.host,
    void Function()? onTerminate,
  }) : _api = api,
       _onTerminate = onTerminate;

  final Docker _api;
  final void Function()? _onTerminate;
  final String id;
  final String image;
  final String host;

  Future<void>? _termination;

  Future<Map<String, dynamic>> inspect() async {
    final response = await _api.containersIdJsonGet(id: id);
    checkResponse(response);
    final base = response.base;
    return base is http.Response && base.bodyBytes.isNotEmpty
        ? jsonDecode(responseText(response)) as Map<String, dynamic>
        : response.body!.toJson();
  }

  Future<int> mappedPort(int port, {String protocol = 'tcp'}) async {
    Port.tcp(port).validate();

    if (protocol != 'tcp' && protocol != 'udp') {
      throw ArgumentError.value(protocol, 'protocol');
    }

    final info = await inspect();
    final bindings =
        info['NetworkSettings']?['Ports']?['$port/$protocol'] as List<dynamic>?;
    if (bindings == null || bindings.isEmpty) {
      throw StateError('No host binding for $port/$protocol in $id');
    }

    final result = int.tryParse('${bindings.first['HostPort']}');
    if (result == null || result < 1 || result > 65535) {
      throw StateError('Invalid host port for $port/$protocol in $id');
    }

    return result;
  }

  Future<String> logs({int tail = 1000}) async {
    if (tail < 0) throw ArgumentError.value(tail, 'tail');

    final response = await _api.containersIdLogsGet(
      id: id,
      stdout: true,
      stderr: true,
      tail: '$tail',
    );
    checkResponse(response);

    final base = response.base;
    final bytes = base is http.Response && base.bodyBytes.isNotEmpty
        ? base.bodyBytes
        : utf8.encode(responseText(response));

    return decodeDockerOutput(bytes).combined;
  }

  Future<ExecResult> exec(List<String> command) async {
    if (command.isEmpty || command.any((arg) => arg.contains('\u0000'))) {
      throw ArgumentError.value(
        command,
        'command',
        'An argument array without NUL is required',
      );
    }
    final created = await _api.containersIdExecPost(
      id: id,
      execConfig: {
        'AttachStdout': true,
        'AttachStderr': true,
        'Tty': false,
        'Cmd': command,
      },
    );
    checkResponse(created);
    final execId = created.body?.id;
    if (execId == null || execId.isEmpty) {
      throw const FormatException('Docker exec response is missing Id');
    }
    final started = await _api.execIdStartPost(
      id: execId,
      execStartConfig: {'Detach': false, 'Tty': false},
    );
    checkResponse(started);
    final base = started.base;
    final output = decodeDockerOutput(
      base is http.Response
          ? base.bodyBytes
          : utf8.encode(responseText(started)),
    );
    final inspected = await _api.execIdJsonGet(id: execId);
    checkResponse(inspected);
    final info = inspected.body;
    if (info?.running != false || info?.exitCode == null) {
      throw StateError('Exec $execId has not completed');
    }
    return ExecResult(
      exitCode: info!.exitCode!,
      stdout: output.stdout,
      stderr: output.stderr,
    );
  }

  Future<void> stop({Duration timeout = const Duration(seconds: 10)}) async {
    if (timeout.isNegative) throw ArgumentError.value(timeout, 'timeout');
    checkResponse(
      await _api.containersIdStopPost(id: id, t: timeout.inSeconds),
      allowed: {304},
    );
  }

  Future<void> terminate() => _termination ??= _remove();

  Future<void> _remove() async {
    try {
      checkResponse(
        await _api.containersIdDelete(id: id, force: true, v: true),
        allowed: {404},
      );
      _onTerminate?.call();
    } catch (_) {
      _termination = null;
      rethrow;
    }
  }
}

class ExecResult {
  const ExecResult({
    required this.exitCode,
    required this.stdout,
    required this.stderr,
  });

  final int exitCode;
  final String stdout;
  final String stderr;
}
