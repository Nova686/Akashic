import 'dart:convert';

import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/owned_work.dart';
import 'package:akashic/layers/functional/Discoveries/data/sources/anilist_recommendations.dart';
import 'package:akashic/layers/functional/Discoveries/data/sources/igdb_similar_games.dart';
import 'package:akashic/layers/functional/Discoveries/data/sources/discogs_recommendations.dart';
import 'package:akashic/layers/functional/Discoveries/data/sources/google_books_recommendations.dart';
import 'package:akashic/layers/functional/Discoveries/data/sources/tmdb_recommendations.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/igdb_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../Lookup/data/fixture_client.dart';

MockClient routedClient(String Function(http.Request request) fixtureFor, {List<http.Request>? requests}) {
  return MockClient((request) async {
    requests?.add(request);
    return http.Response.bytes(utf8.encode(fixture(fixtureFor(request))), 200, headers: {'content-type': 'application/json; charset=utf-8'});
  });
}

OwnedWork ownedWork({String? sourceKey, String? externalWorkId, String? creator}) =>
    OwnedWork(itemId: 'seed', categoryId: 'category', titles: const LocalizedTitles(byLanguage: {'en': 'Seed'}), sourceKey: sourceKey, externalWorkId: externalWorkId, creator: creator);

void main() {
  test('AniList recommendations decode manga suggestions with their author', () async {
    final source = AniListRecommendations(clientReturning(fixture('anilist_recommendations.json')));
    final seed = ownedWork(sourceKey: 'anilist', externalWorkId: '118586');
    expect(source.supports(seed, CategoryType.manga), isTrue);
    final suggestions = await source.recommendationsFor(seed, languageCode: 'fr');
    expect(suggestions.first.title, 'Witch Hat Atelier');
    expect(suggestions.first.externalWorkId, '98263');
    expect(suggestions.first.creator, 'Kamome Shirahama');
    expect(suggestions.first.imageUrl, startsWith('https://'));
  });

  test('TMDB recommendations are asked in the app language', () async {
    final requests = <http.Request>[];
    final source = TmdbRecommendations(clientReturning(fixture('tmdb_recommendations.json'), requests: requests), apiKey: 'key');
    final suggestions = await source.recommendationsFor(ownedWork(sourceKey: 'tmdb', externalWorkId: '550'), languageCode: 'en');
    expect(requests.single.url.path, '/3/movie/550/recommendations');
    expect(requests.single.url.queryParameters['language'], 'en');
    expect(suggestions.first.title, 'Matrix');
    expect(suggestions.first.year, 1999);
    expect(suggestions.first.imageUrl, 'https://image.tmdb.org/t/p/w342/matrix.jpg');
    expect(suggestions.last.imageUrl, isNull);
  });

  test('IGDB similar games carry their studio and cover', () async {
    final igdb = IgdbSource(
      routedClient((request) => request.url.host == 'id.twitch.tv' ? 'igdb_token.json' : 'igdb_similar_games.json'),
      clientId: 'id',
      clientSecret: 'secret',
    );
    final suggestions = await IgdbSimilarGames(igdb).recommendationsFor(ownedWork(sourceKey: 'igdb', externalWorkId: '1942'), languageCode: 'fr');
    expect(suggestions.first.title, 'Grand Theft Auto V');
    expect(suggestions.first.creator, 'Rockstar North');
    expect(suggestions.first.imageUrl, 'https://images.igdb.com/igdb/image/upload/t_cover_big/co2lbd.jpg');
    expect(suggestions.first.year, 2013);
    expect(suggestions.last.imageUrl, isNull);
  });

  test('discogs suggests other albums of the artist then the most owned of the same style', () async {
    final requests = <http.Request>[];
    final source = DiscogsRecommendations(routedClient((request) {
      if (request.url.path.startsWith('/masters/')) {
        return 'discogs_master.json';
      }
      return request.url.queryParameters.containsKey('style') ? 'discogs_search_style.json' : 'discogs_search_artist.json';
    }, requests: requests), token: 'secret');
    final seed = ownedWork(sourceKey: 'discogs', externalWorkId: 'master:5460', creator: 'Miles Davis');
    expect(DiscogsRecommendations(routedClient((_) => ''), token: '').isConfigured, isFalse);
    expect(source.supports(seed, CategoryType.music), isTrue);
    final suggestions = await source.recommendationsFor(seed, languageCode: 'fr');
    expect(suggestions.map((suggestion) => suggestion.title), ['Sketches Of Spain', 'Kind Of Blue', 'Bitches Brew', 'Blue Train']);
    expect(suggestions.first.externalWorkId, 'master:66299');
    expect(suggestions[2].creator, 'Miles Davis');
    expect(suggestions[2].imageUrl, isNull);
    expect(requests.last.url.queryParameters['style'], 'Modal');
    expect(requests.first.url.queryParameters['sort'], 'have');
    expect(requests.first.url.queryParameters['artist'], 'Miles Davis');
    expect(requests.every((request) => request.headers['Authorization'] == 'Discogs token=secret'), isTrue);
  });

  test('google books suggests the same author then the same category in the app language', () async {
    final requests = <http.Request>[];
    final source = GoogleBooksRecommendations(routedClient((request) {
      if (request.url.path.endsWith('/volumes')) {
        return request.url.queryParameters['q']!.startsWith('inauthor') ? 'googlebooks_search_author.json' : 'googlebooks_search_category.json';
      }
      return 'googlebooks_volume.json';
    }, requests: requests), apiKey: 'key');
    final seed = ownedWork(sourceKey: 'googlebooks', externalWorkId: 'zyTCAlFPjgYC');
    expect(source.supports(seed, CategoryType.books), isTrue);
    expect(source.supports(seed, CategoryType.manga), isFalse);
    final suggestions = await source.recommendationsFor(seed, languageCode: 'fr');
    expect(suggestions.map((suggestion) => suggestion.title), ['Le Silmarillion', 'Le Sorcier de Terremer']);
    expect(suggestions.first.imageUrl, 'https://books.google.com/silm.jpg');
    expect(requests[1].url.queryParameters['q'], 'inauthor:"J.R.R. Tolkien"');
    expect(requests[2].url.queryParameters['q'], 'subject:"Fiction"');
    expect(requests[1].url.queryParameters['langRestrict'], 'fr');
  });
}
