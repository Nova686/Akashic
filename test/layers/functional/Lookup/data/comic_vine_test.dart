import 'dart:convert';

import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/comic_vine_source.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

http.Response jsonResponse(Object body, [int status = 200]) => http.Response.bytes(utf8.encode(jsonEncode(body)), status, headers: {'content-type': 'application/json; charset=utf-8'});

void main() {
  test('comic vine is off without a key', () {
    expect(ComicVineSource(MockClient((request) async => jsonResponse({})), apiKey: '').isConfigured, isFalse);
  });

  test('comic vine gives series and issues with publisher, issue number and cover', () async {
    final requests = <Uri>[];
    final source = ComicVineSource(
      MockClient((request) async {
        requests.add(request.url);
        return jsonResponse({
          'error': 'OK',
          'status_code': 1,
          'results': [
            {
              'resource_type': 'volume',
              'id': 796,
              'name': 'Batman',
              'start_year': '1940',
              'publisher': {'name': 'DC Comics'},
              'count_of_issues': 716,
              'image': {'super_url': 'https://comicvine.gamespot.com/a/uploads/scale_large/batman.jpg'},
            },
            {
              'resource_type': 'issue',
              'id': 105468,
              'name': 'The Court of Owls',
              'issue_number': '1',
              'volume': {'name': 'Batman'},
              'cover_date': '2011-11-01',
              'image': {'original_url': 'https://comicvine.gamespot.com/a/uploads/original/owls.jpg'},
            },
          ],
        });
      }),
      apiKey: 'secret',
    );
    final matches = await source.search('batman');
    expect(requests.single.queryParameters['api_key'], 'secret');
    expect(requests.single.queryParameters['resources'], 'volume,issue');
    final series = matches.first;
    expect(series.titles.byLanguage['en'], 'Batman');
    expect(series.publisher, 'DC Comics');
    expect(series.year, 1940);
    expect(series.volumeCount, 716);
    expect(series.suggestedType, CategoryType.comics);
    final issue = matches.last;
    expect(issue.titles.byLanguage['en'], 'Batman #1 – The Court of Owls');
    expect(issue.seriesTitle, 'Batman');
    expect(issue.volumeNumber, 1);
    expect(issue.year, 2011);
  });

  test('a comic vine refusal for too many calls is reported as rate limited', () async {
    final slowedDown = ComicVineSource(MockClient((request) async => jsonResponse({'error': 'Slow down cowboy', 'status_code': 107})), apiKey: 'secret');
    await expectLater(slowedDown.search('batman'), throwsA(isA<SourceUnavailable>().having((failure) => failure.isRateLimited, 'rate limited', isTrue)));
    final velocity = ComicVineSource(MockClient((request) async => jsonResponse({'error': 'Velocity'}, 420)), apiKey: 'secret');
    await expectLater(velocity.search('batman'), throwsA(isA<SourceUnavailable>().having((failure) => failure.isRateLimited, 'rate limited', isTrue)));
    final badKey = ComicVineSource(MockClient((request) async => jsonResponse({'error': 'Invalid API Key', 'status_code': 100})), apiKey: 'wrong');
    await expectLater(badKey.search('batman'), throwsA(isA<SourceUnavailable>().having((failure) => failure.isRateLimited, 'rate limited', isFalse)));
  });
}
