import 'dart:convert';

import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Lookup/data/image_search/combined_image_search.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/anilist_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/discogs_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/google_books_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/igdb_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/tmdb_source.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/use_cases/source_registry.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'fixture_client.dart';

final failingClient = MockClient((request) async => fail('an unconfigured source must not call ${request.url}'));

void main() {
  test('sources without keys are not configured and never called', () async {
    final sources = [
      DiscogsSource(failingClient, token: ''),
      TmdbSource(failingClient, apiKey: ''),
      IgdbSource(failingClient, clientId: '', clientSecret: ''),
    ];
    for (final source in sources) {
      expect(source.isConfigured, isFalse);
      expect(await source.search('anything'), isEmpty);
      expect(await source.lookupBarcode('0074646093822'), isEmpty);
    }
  });

  test('discogs splits artist and title and keeps the master as the work', () async {
    final requests = <http.Request>[];
    final body = '{"results":[{"id":2510301,"master_id":5460,"type":"release","title":"Miles Davis - Kind Of Blue","year":"1959","label":["Columbia"],"format":["Vinyl","LP"],"barcode":["074646093822"],"cover_image":"https://i.discogs.com/kob.jpg"}]}';
    final source = DiscogsSource(clientReturning(body, requests: requests), token: 'secret');
    final match = (await source.lookupBarcode('0074646093822')).single;
    expect(requests.single.headers['Authorization'], 'Discogs token=secret');
    expect(match.creator, 'Miles Davis');
    expect(match.titles.byLanguage['en'], 'Kind Of Blue');
    expect(match.externalWorkId, 'master:5460');
    expect(match.externalEditionId, '2510301');
    expect(match.format, 'Vinyl');
    expect(match.year, 1959);
  });

  test('tmdb keeps the french title and the original one', () async {
    final body = '{"results":[{"id":603,"title":"Matrix","original_title":"The Matrix","original_language":"en","release_date":"1999-03-30","poster_path":"/poster.jpg"}]}';
    final match = (await TmdbSource(clientReturning(body), apiKey: 'key').search('matrix')).single;
    expect(match.titles.byLanguage, {'fr': 'Matrix', 'en': 'The Matrix'});
    expect(match.titles.originalLanguage, 'en');
    expect(match.imageUrl, 'https://image.tmdb.org/t/p/w342/poster.jpg');
    expect(match.suggestedType, CategoryType.films);
  });

  test('igdb reuses its token until it expires and keeps the platform', () async {
    var tokenRequests = 0;
    var clock = DateTime(2026);
    final client = MockClient((request) async {
      if (request.url.host == 'id.twitch.tv') {
        tokenRequests++;
        return http.Response(jsonEncode({'access_token': 'token-$tokenRequests', 'expires_in': 3600}), 200);
      }
      expect(request.headers['Authorization'], 'Bearer token-$tokenRequests');
      return http.Response(
        '[{"id":1942,"name":"The Witcher 3","first_release_date":1431993600,"involved_companies":[{"company":{"name":"CD Projekt RED"}}],"platforms":[{"name":"PlayStation 4"}],"cover":{"image_id":"co1wyy"}}]',
        200,
      );
    });
    final source = IgdbSource(client, clientId: 'id', clientSecret: 'secret', now: () => clock);
    final match = (await source.search('witcher')).single;
    await source.search('witcher');
    expect(tokenRequests, 1);
    clock = clock.add(const Duration(hours: 2));
    await source.search('witcher');
    expect(tokenRequests, 2);
    expect(match.platform, 'PlayStation 4');
    expect(match.creator, 'CD Projekt RED');
    expect(match.year, 2015);
    expect(match.imageUrl, 'https://images.igdb.com/igdb/image/upload/t_cover_big/co1wyy.jpg');
  });

  test('igdb asks for a single token when several searches start together', () async {
    var tokenRequests = 0;
    final client = MockClient((request) async {
      if (request.url.host == 'id.twitch.tv') {
        tokenRequests++;
        await Future<void>.delayed(const Duration(milliseconds: 20));
        return http.Response(jsonEncode({'access_token': 'token', 'expires_in': 3600}), 200);
      }
      return http.Response('[]', 200);
    });
    final source = IgdbSource(client, clientId: 'id', clientSecret: 'secret');
    await Future.wait([source.search('zelda'), source.search('mario'), source.search('metroid')]);
    expect(tokenRequests, 1);
  });

  test('each barcode goes to the single source of its family', () {
    final registry = SourceRegistry([
      DiscogsSource(failingClient, token: 'token'),
      AniListSource(failingClient),
      GoogleBooksSource(failingClient, apiKey: 'key'),
    ]);
    expect(registry.barcodeSources('9780547928227').map((source) => source.key), ['googlebooks']);
    expect(registry.barcodeSources('0074646093822').map((source) => source.key), ['discogs']);
    expect(registry.configuredFor(CategoryType.manga).map((source) => source.key), ['anilist']);
    expect(registry.configuredFor(CategoryType.comics).map((source) => source.key), ['googlebooks']);
  });

  test('image search puts the match image first and removes duplicates', () async {
    final body = '{"query":{"pages":{"1":{"index":2,"imageinfo":[{"thumburl":"https://upload.wikimedia.org/b.jpg"}]},"2":{"index":1,"imageinfo":[{"thumburl":"https://coverartarchive.org/front.jpg"}]}}}}';
    final search = CombinedImageSearch(clientReturning(body));
    const match = SourceMatch(
      sourceKey: 'musicbrainz',
      externalWorkId: 'x',
      titles: LocalizedTitles(byLanguage: {'en': 'Kind of Blue'}),
      imageUrl: 'https://coverartarchive.org/front.jpg',
      suggestedType: CategoryType.music,
    );
    expect(await search.imagesFor(match, 'Kind of Blue Miles Davis'), ['https://coverartarchive.org/front.jpg', 'https://upload.wikimedia.org/b.jpg']);
  });
}
