import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:docker_engine/docker_engine.dart';
import 'package:http/http.dart' as http;
import 'package:test/test.dart';

void main() {
  test('accepts successful and explicitly allowed response statuses', () {
    checkResponse(Response<dynamic>(http.Response('', 204), null));
    checkResponse(
      Response<dynamic>(http.Response('', 404), null),
      allowed: {404},
    );
  });

  for (final body in [
    'proxy unavailable',
    '{"message":"denied"}',
    '["unexpected"]',
    '{"message":42}',
  ]) {
    test('preserves useful diagnostics for error response $body', () {
      final response = Response<dynamic>(http.Response(body, 502), null);
      final message = body == '{"message":"denied"}' ? 'denied' : body;
      expect(
        () => checkResponse(response),
        throwsA(
          isA<DockerException>()
              .having((e) => e.statusCode, 'status', 502)
              .having((e) => e.message, 'message', message)
              .having(
                (e) => e.toString(),
                'description',
                allOf(contains('502'), contains(message)),
              ),
        ),
      );
    });
  }

  test('prefers raw UTF-8 bytes and tolerates malformed UTF-8', () {
    expect(
      responseText(
        Response<String>(
          http.Response.bytes(utf8.encode('ошибка'), 500),
          'ignored',
        ),
      ),
      'ошибка',
    );
    expect(
      responseText(Response<dynamic>(http.Response.bytes([255], 500), null)),
      '\uFFFD',
    );
  });

  test('falls back to the typed body, error or empty text', () {
    expect(
      responseText(Response<String>(http.Response('', 200), 'body')),
      'body',
    );
    expect(
      responseText(
        Response<dynamic>(http.Response('', 500), null, error: 'error'),
      ),
      'error',
    );
    expect(responseText(Response<dynamic>(http.Response('', 204), null)), '');
  });
}
