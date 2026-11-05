import 'dart:async';
import 'dart:io';

import 'package:akashic/layers/technical/HttpAccess/json_http.dart';
import 'package:akashic/layers/technical/HttpAccess/throttled_http_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('two requests are spaced by the minimum interval and carry default headers', () async {
    final waits = <Duration>[];
    final userAgents = <String?>[];
    final inner = MockClient((request) async {
      userAgents.add(request.headers['User-Agent']);
      return http.Response('{}', 200);
    });
    var clock = DateTime(2026);
    final client = ThrottledHttpClient(
      inner,
      sourceKey: 'musicbrainz',
      minimumInterval: const Duration(seconds: 1),
      defaultHeaders: const {'User-Agent': 'Akashic/0.1'},
      now: () => clock,
      wait: (duration) async {
        waits.add(duration);
        clock = clock.add(duration);
      },
    );
    await client.get(Uri.parse('https://example.org/a'));
    await client.get(Uri.parse('https://example.org/b'));
    expect(waits, [const Duration(seconds: 1)]);
    expect(userAgents, ['Akashic/0.1', 'Akashic/0.1']);
  });

  test('a timeout becomes SourceUnavailable', () async {
    final inner = MockClient((request) => Completer<http.Response>().future);
    final client = ThrottledHttpClient(inner, sourceKey: 'anilist', minimumInterval: Duration.zero, timeout: const Duration(milliseconds: 20));
    await expectLater(client.get(Uri.parse('https://example.org')), throwsA(isA<RemoteServiceUnavailable>()));
  });

  test('a socket failure becomes SourceUnavailable', () async {
    final inner = MockClient((request) async => throw const SocketException('offline'));
    final client = ThrottledHttpClient(inner, sourceKey: 'anilist', minimumInterval: Duration.zero);
    await expectLater(client.get(Uri.parse('https://example.org')), throwsA(isA<RemoteServiceUnavailable>()));
  });

  test('404 gives null and 503 or 429 throw SourceUnavailable', () async {
    final inner = MockClient((request) async => switch (request.url.path) {
          '/missing' => http.Response('', 404),
          '/busy' => http.Response('', 429),
          '/ok' => http.Response('{"title":"Kind of Blue"}', 200),
          _ => http.Response('', 503),
        });
    expect(await getJson(inner, Uri.parse('https://example.org/missing'), sourceKey: 'mb'), isNull);
    expect(await getJson(inner, Uri.parse('https://example.org/ok'), sourceKey: 'mb'), {'title': 'Kind of Blue'});
    await expectLater(getJson(inner, Uri.parse('https://example.org/busy'), sourceKey: 'mb'), throwsA(isA<RemoteServiceUnavailable>()));
    await expectLater(getJson(inner, Uri.parse('https://example.org/down'), sourceKey: 'mb'), throwsA(isA<RemoteServiceUnavailable>()));
  });
}
