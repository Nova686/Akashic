import 'dart:convert';

import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/deezer_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/mangadex_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/wikidata_source.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/catalog_source.dart';
import 'package:akashic/layers/functional/Lookup/domain/use_cases/source_with_backup.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

http.Response jsonResponse(Object body, [int status = 200]) =>
    http.Response.bytes(utf8.encode(jsonEncode(body)), status, headers: {'content-type': 'application/json; charset=utf-8'});

class ScriptedSource implements CatalogSource {
  ScriptedSource(this.key, {this.isConfigured = true, this.failure});

  @override
  final String key;
  @override
  final bool isConfigured;
  final SourceUnavailable? failure;
  int calls = 0;

  @override
  Set<CategoryType> get types => const {CategoryType.music};

  @override
  bool get supportsBarcode => true;

  Future<List<SourceMatch>> _answer() async {
    calls++;
    if (failure case final failure?) {
      throw failure;
    }
    return [SourceMatch(sourceKey: key, externalWorkId: key, titles: LocalizedTitles(byLanguage: {'en': key}), suggestedType: CategoryType.music)];
  }

  @override
  Future<List<SourceMatch>> search(String query) => _answer();

  @override
  Future<List<SourceMatch>> lookupBarcode(String barcode) => _answer();
}

void main() {
  test('the backup answers only when the main source is over its quota', () async {
    final primary = ScriptedSource('discogs', failure: const SourceUnavailable('discogs', 'HTTP 429', true));
    final backup = ScriptedSource('deezer');
    final source = SourceWithBackup(primary, backup);
    expect((await source.search('kind of blue')).single.sourceKey, 'deezer');
    expect((await source.lookupBarcode('888880696069')).single.sourceKey, 'deezer');
    expect(source.key, 'discogs');
  });

  test('a working main source never wakes the backup', () async {
    final backup = ScriptedSource('deezer');
    final matches = await SourceWithBackup(ScriptedSource('discogs'), backup).search('kind of blue');
    expect(matches.single.sourceKey, 'discogs');
    expect(backup.calls, 0);
  });

  test('a main source without its key leaves the backup in charge, and a missing backup keeps the failure', () async {
    final unconfigured = SourceWithBackup(ScriptedSource('boardgamegeek', isConfigured: false), ScriptedSource('wikidata'));
    expect(unconfigured.isConfigured, isTrue);
    expect((await unconfigured.search('catan')).single.sourceKey, 'wikidata');
    final withoutBackup = SourceWithBackup(ScriptedSource('discogs', failure: const SourceUnavailable('discogs', 'HTTP 429', true)), ScriptedSource('deezer', isConfigured: false));
    expect(withoutBackup.search('x'), throwsA(isA<SourceUnavailable>()));
  });

  test('deezer finds albums by name and by barcode, an unknown barcode gives nothing', () async {
    final source = DeezerSource(MockClient((request) async {
      if (request.url.path == '/search/album') {
        return jsonResponse({
          'data': [
            {'id': 262078, 'title': 'Kind Of Blue (Legacy Edition)', 'artist': {'name': 'Miles Davis'}, 'cover_xl': 'https://cdn-images.dzcdn.net/kob.jpg'},
          ],
        });
      }
      if (request.url.path == '/album/upc:888880696069') {
        return jsonResponse({'id': 262078, 'title': 'Kind Of Blue (Legacy Edition)', 'artist': {'name': 'Miles Davis'}, 'label': 'Columbia/Legacy', 'release_date': '2009-01-19'});
      }
      return jsonResponse({'error': {'type': 'DataException', 'message': 'no data', 'code': 800}});
    }));
    final found = (await source.search('kind of blue')).single;
    expect(found.creator, 'Miles Davis');
    expect(found.imageUrl, 'https://cdn-images.dzcdn.net/kob.jpg');
    final scanned = (await source.lookupBarcode('888880696069')).single;
    expect(scanned.publisher, 'Columbia/Legacy');
    expect(scanned.year, 2009);
    expect(scanned.barcode, '888880696069');
    expect(await source.lookupBarcode('0000000000000'), isEmpty);
  });

  test('mangadex keeps the useful titles, the authors and the cover', () async {
    final source = MangaDexSource(MockClient((request) async {
      expect(request.url.queryParametersAll['includes[]'], ['author', 'cover_art']);
      return jsonResponse({
        'data': [
          {
            'id': 'b0b721ff',
            'attributes': {
              'title': {'ja-ro': 'Sousou no Frieren'},
              'altTitles': [{'en': "Frieren: Beyond Journey's End"}, {'ja': '葬送のフリーレン'}, {'ru': 'Фрирен'}],
              'year': 2020,
              'status': 'hiatus',
              'lastVolume': '',
            },
            'relationships': [
              {'type': 'author', 'attributes': {'name': 'Yamada Kanehito'}},
              {'type': 'cover_art', 'attributes': {'fileName': 'cover.jpg'}},
            ],
          },
        ],
      });
    }));
    final match = (await source.search('frieren')).single;
    expect(match.titles.byLanguage, {'ja-Latn': 'Sousou no Frieren', 'en': "Frieren: Beyond Journey's End", 'ja': '葬送のフリーレン'});
    expect(match.creator, 'Yamada Kanehito');
    expect(match.year, 2020);
    expect(match.imageUrl, 'https://uploads.mangadex.org/covers/b0b721ff/cover.jpg.512.jpg');
    expect(match.volumeCount, isNull);
  });

  test('wikidata keeps only entries described as the wanted kind, with the year of the description', () async {
    final source = WikidataSource.forType(MockClient((request) async => jsonResponse({
          'search': [
            {'id': 'Q4267401', 'label': 'The Witcher 3 : Wild Hunt', 'description': 'jeu vidéo de 2015'},
            {'id': 'Q105853242', 'label': 'The Witcher 3 game save', 'description': 'file format'},
            {'id': 'Q1', 'label': 'Sans description'},
          ],
        })), CategoryType.videoGames);
    final match = (await source.search('witcher 3')).single;
    expect(match.externalWorkId, 'Q4267401');
    expect(match.titles.byLanguage['fr'], 'The Witcher 3 : Wild Hunt');
    expect(match.year, 2015);
    expect(match.suggestedType, CategoryType.videoGames);
    expect(source.key, 'wikidata-videoGames');
  });
}
