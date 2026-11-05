import 'dart:convert';

import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/anilist_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/google_books_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/scryfall_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/tcgdex_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'fixture_client.dart';

MockClient tcgdexClient({List<http.Request>? requests}) => MockClient((request) async {
      requests?.add(request);
      final body = request.url.path.endsWith('/sets') ? fixture('tcgdex_sets.json') : fixture('tcgdex_cards.json');
      return http.Response.bytes(utf8.encode(body), 200, headers: {'content-type': 'application/json; charset=utf-8'});
    });

void main() {
  test('anilist search gives Frieren with english and native titles and both authors', () async {
    final match = (await AniListSource(clientReturning(fixture('anilist.json'))).search('Frieren')).first;
    expect(match.titles.byLanguage['en'], 'Frieren: Beyond Journey’s End');
    expect(match.titles.byLanguage['ja'], '葬送のフリーレン');
    expect(match.titles.byLanguage['ja-Latn'], 'Sousou no Frieren');
    expect(match.titles.originalLanguage, 'ja');
    expect(match.creator, 'Kanehito Yamada, Tsukasa Abe');
    expect(match.year, 2020);
    expect(match.externalWorkId, '118586');
    expect(match.suggestedType, CategoryType.manga);
  });

  test('google books isbn lookup gives the edition with an https cover', () async {
    final match = (await GoogleBooksSource(clientReturning(fixture('googlebooks_isbn.json')), apiKey: 'key').lookupBarcode('9780547928227')).single;
    expect(match.titles.byLanguage['en'], 'The Hobbit');
    expect(match.year, 2012);
    expect(match.barcode, '9780547928227');
    expect(match.imageUrl, startsWith('https://'));
  });

  test('scryfall gives card entries', () async {
    final card = (await ScryfallSource(clientReturning(fixture('scryfall_search.json'))).search('lightning')).single;
    expect(card.titles.byLanguage['en'], 'Lightning Bolt');
    expect(card.publisher, 'Magic 2011');
  });

  test('tcgdex gives french pokemon extensions with their logo', () async {
    final set = (await TcgdexSource(tcgdexClient()).search('151')).single;
    expect(set.titles.byLanguage, {'fr': '151'});
    expect(set.externalWorkId, 'sv03.5');
    expect(set.imageUrl, 'https://assets.tcgdex.net/fr/sv/sv03.5/logo.png');
    expect(set.suggestedType, CategoryType.cards);
  });

  test('tcgdex card search names the extension of each card and loads the extensions once', () async {
    final requests = <http.Request>[];
    final source = TcgdexSource(tcgdexClient(requests: requests));
    final cards = await source.searchCards('pikachu');
    expect(cards.first.name, 'Pikachu');
    expect(cards.first.externalCardId, '2024sv-2');
    expect(cards.first.setName, isNotNull);
    expect(cards.firstWhere((card) => card.externalCardId == 'tk-hs-r-2').setName, isNull);
    await source.search('151');
    expect(requests.where((request) => request.url.path.endsWith('/sets')), hasLength(1));
    expect(requests.firstWhere((request) => request.url.path.endsWith('/cards')).url.queryParameters['name'], 'pikachu');
  });

  test('a result with missing fields is still a usable match and empty titles are skipped', () async {
    final anilist = AniListSource(clientReturning('{"data":{"Page":{"media":[{"id":1,"title":{"romaji":"Only Romaji"}}]}}}'));
    expect((await anilist.search('x')).single.titles.byLanguage, {'ja-Latn': 'Only Romaji'});
    final books = GoogleBooksSource(clientReturning('{"totalItems":0}'), apiKey: 'key');
    expect(await books.search('nothing'), isEmpty);
  });
}
