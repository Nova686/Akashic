import 'dart:convert';

import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/jikan_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/musicbrainz_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/open_library_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/tvmaze_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/upcitemdb_source.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/catalog_source.dart';
import 'package:akashic/layers/functional/Lookup/domain/use_cases/source_registry.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'fixture_client.dart';

http.Response jsonResponse(Object body) => http.Response.bytes(utf8.encode(jsonEncode(body)), 200, headers: {'content-type': 'application/json; charset=utf-8'});

class FakeFilmSource implements CatalogSource {
  final List<String> queries = [];

  @override
  String get key => 'tmdb';

  @override
  Set<CategoryType> get types => const {CategoryType.films};

  @override
  bool get isConfigured => true;

  @override
  bool get supportsBarcode => false;

  @override
  Future<List<SourceMatch>> search(String query) async {
    queries.add(query);
    return const [SourceMatch(sourceKey: 'tmdb', externalWorkId: '603', titles: LocalizedTitles(byLanguage: {'fr': 'Matrix'}), suggestedType: CategoryType.films)];
  }

  @override
  Future<List<SourceMatch>> lookupBarcode(String barcode) async => const [];
}

void main() {
  test('musicbrainz finds a release by barcode with its group, label, format and cover', () async {
    final requests = <Uri>[];
    final source = MusicBrainzSource(MockClient((request) async {
      requests.add(request.url);
      return http.Response.bytes(utf8.encode(fixture('musicbrainz_barcode.json')), 200);
    }));
    final match = (await source.lookupBarcode('4547366033267')).single;
    expect(requests.single.queryParameters['query'], 'barcode:4547366033267');
    expect(match.titles.byLanguage['en'], 'Kind of Blue');
    expect(match.creator, 'Miles Davis');
    expect(match.year, 2007);
    expect(match.externalWorkId, '8e8a594f-2175-38c7-a871-abb68ec363e7');
    expect(match.externalEditionId, 'fa731de1-331d-4713-adcc-2c304817cb88');
    expect(match.publisher, 'Sony Records International');
    expect(match.imageUrl, 'https://coverartarchive.org/release-group/8e8a594f-2175-38c7-a871-abb68ec363e7/front-500');
  });

  test('open library gives a french comic with its authors and cover', () async {
    final match = (await OpenLibrarySource(clientReturning(fixture('openlibrary_search.json'))).search('asterix le gaulois')).single;
    expect(match.titles.byLanguage['fr'], 'Astérix le Gaulois');
    expect(match.creator, 'René Goscinny, Albert Uderzo');
    expect(match.year, 1961);
    expect(match.externalWorkId, 'OL267622W');
    expect(match.imageUrl, 'https://covers.openlibrary.org/b/id/962725-L.jpg');
  });

  test('tvmaze gives tv shows with their network and an https poster', () async {
    final match = (await TvmazeSource(clientReturning(fixture('tvmaze_search.json'))).search('friends')).first;
    expect(match.titles.byLanguage['en'], 'Friends');
    expect(match.publisher, 'NBC');
    expect(match.year, 1994);
    expect(match.imageUrl, startsWith('https://'));
    expect(match.suggestedType, CategoryType.films);
  });

  test('jikan gives romaji, english and japanese titles with authors in reading order', () async {
    final source = JikanSource(MockClient((request) async => jsonResponse({
          'data': [
            {
              'mal_id': 126287,
              'title': 'Sousou no Frieren',
              'title_english': "Frieren: Beyond Journey's End",
              'title_japanese': '葬送のフリーレン',
              'authors': [
                {'name': 'Yamada, Kanehito'},
                {'name': 'Abe, Tsukasa'},
              ],
              'published': {'from': '2020-04-28T00:00:00+00:00'},
              'images': {'jpg': {'large_image_url': 'https://cdn.myanimelist.net/images/manga/3/264213l.jpg'}},
              'volumes': null,
              'status': 'Publishing',
            },
          ],
        })));
    final match = (await source.search('frieren')).single;
    expect(match.titles.byLanguage, {'ja-Latn': 'Sousou no Frieren', 'en': "Frieren: Beyond Journey's End", 'ja': '葬送のフリーレン'});
    expect(match.creator, 'Kanehito Yamada, Tsukasa Abe');
    expect(match.year, 2020);
    expect(match.status, 'RELEASING');
  });

  test('a product barcode is turned into a film found by its cleaned name', () async {
    final films = FakeFilmSource();
    final source = UpcItemDbSource(
      MockClient((request) async => jsonResponse({
            'code': 'OK',
            'items': [
              {'title': 'The Matrix (Blu-ray) [Widescreen]', 'category': 'Media > DVDs & Videos', 'brand': 'Warner', 'images': ['http://images.example/matrix.jpg']},
            ],
          })),
      titleSources: {CategoryType.films: films},
    );
    final match = (await source.lookupBarcode('0883929264565')).single;
    expect(films.queries, ['The Matrix']);
    expect(match.sourceKey, 'tmdb');
    expect(match.barcode, '0883929264565');
  });

  test('a product unknown to the catalogues still gives its own name', () async {
    final source = UpcItemDbSource(
      MockClient((request) async => jsonResponse({
            'items': [
              {'title': 'Lego Star Wars Millennium Falcon', 'category': 'Toys & Games > Toys', 'images': ['http://images.example/falcon.jpg']},
            ],
          })),
      titleSources: const {},
    );
    final match = (await source.lookupBarcode('0673419281345')).single;
    expect(match.titles.byLanguage['en'], 'Lego Star Wars Millennium Falcon');
    expect(match.imageUrl, 'https://images.example/falcon.jpg');
    expect(match.suggestedType, CategoryType.lego);
  });

  test('the product barcode fallback is kept for when every other source failed, never for ISBNs', () {
    final fallback = UpcItemDbSource(MockClient((request) async => jsonResponse({})), titleSources: const {});
    final registry = SourceRegistry(const [], barcodeFallbacks: [fallback]);
    expect(registry.barcodeSources('0883929264565'), isEmpty);
    expect(registry.barcodeFallbacksFor('0883929264565'), [fallback]);
    expect(registry.barcodeFallbacksFor('9780547928227'), isEmpty);
  });
}
