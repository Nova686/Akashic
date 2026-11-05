import 'dart:async';
import 'dart:io';

import 'package:akashic/layers/technical/HttpAccess/json_http.dart';
import 'package:akashic/layers/technical/HttpAccess/throttled_http_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test('a TLS handshake failure from a captive portal is a service failure', () async {
    final client = ThrottledHttpClient(
      MockClient((request) async => throw const HandshakeException('captive portal')),
      sourceKey: 'musicbrainz',
      minimumInterval: Duration.zero,
    );
    await expectLater(getJson(client, Uri.parse('https://musicbrainz.org'), sourceKey: 'musicbrainz'), throwsA(isA<RemoteServiceUnavailable>()));
  });

  test('an html page answered with 200 is a service failure, not a crash', () async {
    final client = MockClient((request) async => http.Response('<html>Wi-Fi login</html>', 200));
    await expectLater(getJson(client, Uri.parse('https://openlibrary.org'), sourceKey: 'openlibrary'), throwsA(isA<RemoteServiceUnavailable>()));
  });

  test('a response whose body never ends is cut by the overall deadline', () async {
    final client = MockClient.streaming((request, body) async {
      final endless = StreamController<List<int>>();
      return http.StreamedResponse(endless.stream, 200);
    });
    await expectLater(
      getJson(client, Uri.parse('https://anilist.co'), sourceKey: 'anilist', deadline: const Duration(milliseconds: 50)),
      throwsA(isA<RemoteServiceUnavailable>()),
    );
  });
}
