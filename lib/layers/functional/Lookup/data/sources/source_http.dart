import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/technical/HttpAccess/json_http.dart';
import 'package:http/http.dart' as http;

Future<Object?> _asSourceCall(String sourceKey, Future<Object?> Function() call) async {
  try {
    return await call();
  } on RemoteServiceUnavailable catch (failure) {
    throw SourceUnavailable(sourceKey, failure.reason, failure.isRateLimited);
  }
}

Future<Object?> sourceGetJson(http.Client client, Uri uri, {required String sourceKey, Map<String, String>? headers}) =>
    _asSourceCall(sourceKey, () => getJson(client, uri, sourceKey: sourceKey, headers: headers));

Future<String?> sourceGetText(http.Client client, Uri uri, {required String sourceKey, Map<String, String>? headers}) async =>
    await _asSourceCall(sourceKey, () => getText(client, uri, sourceKey: sourceKey, headers: headers)) as String?;

Future<Object?> sourcePostJson(http.Client client, Uri uri, {required String sourceKey, required Object body, Map<String, String>? headers}) =>
    _asSourceCall(sourceKey, () => postJson(client, uri, sourceKey: sourceKey, body: body, headers: headers));

Future<Object?> sourcePostForm(http.Client client, Uri uri, {required String sourceKey, required String body, Map<String, String>? headers}) =>
    _asSourceCall(sourceKey, () => postForm(client, uri, sourceKey: sourceKey, body: body, headers: headers));
