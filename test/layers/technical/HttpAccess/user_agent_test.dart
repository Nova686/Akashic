import 'dart:io';

import 'package:akashic/layers/technical/AppShell/app_version.dart';
import 'package:akashic/layers/technical/AppShell/dependency_scope.dart';
import 'package:akashic/layers/technical/HttpAccess/user_agent_client.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const String _token = r"[!#$%&'*+\-.^_`|~0-9A-Za-z]+";
final RegExp rfc1945UserAgent = RegExp('^$_token(/$_token)?( \\([^()\\x00-\\x1F\\x7F]*\\))*\$');

void main() {
  test('the user agent names the app and its version as RFC 1945 asks', () {
    expect(userAgentFor(contact: ''), 'Akashic/${AppVersion.name} (personal collection app)');
    expect(userAgentFor(contact: ''), matches(rfc1945UserAgent));
    expect(userAgentFor(contact: 'collection@example.org'), 'Akashic/${AppVersion.name} (personal collection app; collection@example.org)');
    expect(userAgentFor(contact: 'me (home)\n'), matches(rfc1945UserAgent));
    expect(userAgentFor(), 'Akashic/${AppVersion.name} (personal collection app; https://github.com/Nova686/Akashic)');
    expect(userAgentFor(), matches(rfc1945UserAgent));
  });

  test('the announced version follows the app version', () {
    final pubspecVersion = RegExp(r'^version:\s*([^+\s]+)', multiLine: true).firstMatch(File('pubspec.yaml').readAsStringSync())!.group(1);
    expect(appVersion, pubspecVersion);
  });

  test('every request of the app carries the user agent, even when a source sets its own', () async {
    final userAgents = <String?>[];
    final dependencies = AkashicDependencies(
      database: AkashicDatabase.forTesting(),
      imageRoot: Directory.systemTemp,
      httpClient: MockClient((request) async {
        userAgents.add(request.headers['User-Agent']);
        return http.Response('[]', 200);
      }),
    );
    final tcgdex = dependencies.sourceRegistry.byKey('tcgdex')!;
    await tcgdex.search('151').catchError((Object _) => const <Never>[]);
    final scryfall = dependencies.sourceRegistry.byKey('scryfall')!;
    await scryfall.search('bolt').catchError((Object _) => const <Never>[]);
    await dependencies.imageDownloader.download('https://example.org/cover.jpg');
    expect(userAgents, isNotEmpty);
    expect(userAgents.toSet(), {userAgentFor()});
    await dependencies.database.close();
  });
}
