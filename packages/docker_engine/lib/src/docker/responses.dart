import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:http/http.dart' as http;

import '../errors/exceptions.dart';

void checkResponse(Response<dynamic> response, {Set<int> allowed = const {}}) {
  if (response.isSuccessful || allowed.contains(response.statusCode)) return;
  final body = responseText(response);
  String message = body;
  try {
    final json = jsonDecode(body);
    if (json is Map && json['message'] is String) {
      message = json['message'] as String;
    }
  } on FormatException {
    // Docker proxies can return plain-text errors.
  }
  throw DockerException(message, statusCode: response.statusCode);
}

String responseText(Response<dynamic> response) {
  final base = response.base;
  if (base is http.Response && base.bodyBytes.isNotEmpty) {
    return utf8.decode(base.bodyBytes, allowMalformed: true);
  }
  return response.body?.toString() ?? response.error?.toString() ?? '';
}
