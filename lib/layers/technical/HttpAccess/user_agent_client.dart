import 'package:akashic/layers/technical/AppShell/app_version.dart';
import 'package:akashic/layers/technical/HttpAccess/api_keys.dart';
import 'package:http/http.dart' as http;

const String appName = 'Akashic';
const String appVersion = AppVersion.name;
const String appDescription = 'personal collection app';
const String projectUrl = 'https://github.com/Nova686/Akashic';

String userAgentFor({String version = appVersion, String? contact}) {
  final cleanContact = (contact ?? (ApiKeys.apiContact.isEmpty ? projectUrl : ApiKeys.apiContact)).replaceAll(RegExp(r'[()\\\x00-\x1F\x7F]'), '').trim();
  final comment = cleanContact.isEmpty ? appDescription : '$appDescription; $cleanContact';
  return '$appName/$version ($comment)';
}

class UserAgentClient extends http.BaseClient {
  UserAgentClient(this._inner, {String? userAgent}) : _userAgent = userAgent ?? userAgentFor();

  final http.Client _inner;
  final String _userAgent;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['User-Agent'] = _userAgent;
    return _inner.send(request);
  }

  @override
  void close() => _inner.close();
}
