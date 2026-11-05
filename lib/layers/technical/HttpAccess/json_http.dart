import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:http/http.dart' as http;

const Duration defaultRequestDeadline = Duration(seconds: 10);

class RemoteServiceUnavailable implements Exception {
  const RemoteServiceUnavailable(this.serviceKey, [this.reason, this.isRateLimited = false]);

  final String serviceKey;
  final String? reason;
  final bool isRateLimited;

  @override
  String toString() => 'RemoteServiceUnavailable($serviceKey${reason == null ? '' : ': $reason'})';
}

const int _backgroundJsonThreshold = 256 * 1024;

FutureOr<Object?> _decodeJson(String body) => body.length > _backgroundJsonThreshold ? Isolate.run(() => jsonDecode(body)) : jsonDecode(body);

Future<T?> _guarded<T>(String serviceKey, Duration deadline, Future<http.Response> Function() request, FutureOr<T> Function(String body) decode) async {
  try {
    final response = await request().timeout(deadline);
    if (response.statusCode == 404) {
      return null;
    }
    if (response.statusCode == 429) {
      throw RemoteServiceUnavailable(serviceKey, 'rate limited for ${response.headers['retry-after'] ?? '?'} s', true);
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw RemoteServiceUnavailable(serviceKey, 'HTTP ${response.statusCode}');
    }
    return await decode(utf8.decode(response.bodyBytes));
  } on TimeoutException {
    throw RemoteServiceUnavailable(serviceKey, 'timeout');
  } on IOException catch (error) {
    throw RemoteServiceUnavailable(serviceKey, '$error');
  } on http.ClientException catch (error) {
    throw RemoteServiceUnavailable(serviceKey, error.message);
  } on FormatException catch (error) {
    throw RemoteServiceUnavailable(serviceKey, 'unreadable answer: ${error.message}');
  }
}

Future<Object?> getJson(http.Client client, Uri uri, {required String sourceKey, Map<String, String>? headers, Duration deadline = defaultRequestDeadline}) {
  return _guarded<Object?>(sourceKey, deadline, () => client.get(uri, headers: headers), _decodeJson);
}

Future<String?> getText(http.Client client, Uri uri, {required String sourceKey, Map<String, String>? headers, Duration deadline = defaultRequestDeadline}) {
  return _guarded(sourceKey, deadline, () => client.get(uri, headers: headers), (body) => body);
}

Future<Object?> postJson(
  http.Client client,
  Uri uri, {
  required String sourceKey,
  required Object body,
  Map<String, String>? headers,
  Duration deadline = defaultRequestDeadline,
}) {
  return _guarded<Object?>(
    sourceKey,
    deadline,
    () => client.post(uri, headers: {'Content-Type': 'application/json', 'Accept': 'application/json', ...?headers}, body: jsonEncode(body)),
    _decodeJson,
  );
}

Future<Object?> postForm(
  http.Client client,
  Uri uri, {
  required String sourceKey,
  required String body,
  Map<String, String>? headers,
  Duration deadline = defaultRequestDeadline,
}) {
  return _guarded<Object?>(sourceKey, deadline, () => client.post(uri, headers: headers, body: body), _decodeJson);
}
