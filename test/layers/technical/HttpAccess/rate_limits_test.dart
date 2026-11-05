import 'dart:io';

import 'package:akashic/layers/technical/HttpAccess/json_http.dart';
import 'package:akashic/layers/technical/HttpAccess/rate_limits.dart';
import 'package:akashic/layers/technical/HttpAccess/throttled_http_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

class MemoryRateLimits implements RateLimitRecorder {
  final Map<String, (DateTime, DateTime)> blocks = {};

  @override
  DateTime? blockedUntil(String apiFamily) => blocks[apiFamily]?.$2;

  @override
  Future<void> recordBlock(String apiFamily, {required DateTime blockedAt, required DateTime retryAt}) async => blocks[apiFamily] = (blockedAt, retryAt);
}

void main() {
  final now = DateTime.utc(2026, 10, 28, 14, 30);

  test('the next connection follows Retry-After, then a daily quota, then the default pause of the api', () {
    expect(retryAtFor(apiFamily: 'discogs', headers: const {'retry-after': '42'}, body: '', now: now), now.add(const Duration(seconds: 42)));
    expect(retryAtFor(apiFamily: 'discogs', headers: const {'retry-after': '1'}, body: '', now: now), now.add(const Duration(seconds: 5)));
    expect(
      retryAtFor(apiFamily: 'anilist', headers: {'retry-after': HttpDate.format(DateTime.utc(2026, 10, 28, 14, 35))}, body: '', now: now).toUtc(),
      DateTime.utc(2026, 10, 28, 14, 35),
    );
    expect(retryAtFor(apiFamily: 'googlebooks', headers: const {}, body: "Quota exceeded for quota metric 'Queries' and limit 'Queries per day'", now: now).toUtc(), DateTime.utc(2026, 10, 29, 8));
    expect(retryAtFor(apiFamily: 'tmdb', headers: const {}, body: '', now: now), now.add(const Duration(seconds: 10)));
    expect(nextPacificMidnight(DateTime.utc(2026, 10, 28, 7, 59)).toUtc(), DateTime.utc(2026, 10, 28, 8));
    expect(apiFamilyOf('googlebooks-details'), 'googlebooks');
  });

  test('a limit reached is recorded, then the api is not called until the next connection', () async {
    var clock = now;
    var calls = 0;
    final rateLimits = MemoryRateLimits();
    final client = ThrottledHttpClient(
      MockClient((request) async {
        calls++;
        return calls == 1 ? http.Response('{"message":"You are making requests too quickly."}', 429, headers: {'retry-after': '60'}) : http.Response('{"ok":true}', 200);
      }),
      sourceKey: 'discogs-details',
      minimumInterval: Duration.zero,
      rateLimits: rateLimits,
      now: () => clock,
      wait: (_) async {},
    );
    await expectLater(getJson(client, Uri.https('api.discogs.com', '/masters/1'), sourceKey: 'discogs'), throwsA(isA<RemoteServiceUnavailable>()));
    expect(rateLimits.blocks['discogs'], (now, now.add(const Duration(seconds: 60))));
    clock = now.add(const Duration(seconds: 30));
    await expectLater(getJson(client, Uri.https('api.discogs.com', '/masters/1'), sourceKey: 'discogs'), throwsA(isA<RemoteServiceUnavailable>()));
    expect(calls, 1);
    clock = now.add(const Duration(seconds: 61));
    expect(await getJson(client, Uri.https('api.discogs.com', '/masters/1'), sourceKey: 'discogs'), {'ok': true});
    expect(calls, 2);
  });
}
