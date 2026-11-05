import 'dart:convert';

import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Check/domain/entities/check_verdict.dart';
import 'package:akashic/layers/functional/Check/domain/gateways/cover_image_gateway.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/add_from_match.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/check_ownership.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/find_locally.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/add_item.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/anilist_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/google_books_source.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/functional/Lookup/domain/use_cases/isbn_with_series_source.dart';
import 'package:akashic/layers/functional/Lookup/domain/use_cases/source_registry.dart';
import 'package:akashic/layers/functional/Lookup/domain/use_cases/volume_title.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../Collection/collection_harness.dart';
import 'data/fixture_client.dart';

const String frierenFourIsbn = '9782505088227';

String googleBooksVolume({required String title, String? subtitle, String? publisher, List<String> categories = const []}) => jsonEncode({
      'totalItems': 1,
      'items': [
        {
          'id': 'gb-frieren-4',
          'volumeInfo': {
            'title': title,
            'subtitle': ?subtitle,
            'authors': ['Kanehito Yamada'],
            'publisher': ?publisher,
            'publishedDate': '2022-03-02',
            'language': 'fr',
            'categories': categories,
            'industryIdentifiers': [
              {'type': 'ISBN_13', 'identifier': frierenFourIsbn},
            ],
            'imageLinks': {'thumbnail': 'http://books.google.com/frieren4.jpg'},
          },
        },
      ],
    });

MockClient jsonClient(String body) => MockClient((request) async => http.Response.bytes(utf8.encode(body), 200, headers: {'content-type': 'application/json; charset=utf-8'}));

class NoCovers implements CoverImageGateway {
  @override
  Future<StoredCover?> storeCover(String url) async => null;
}

class OfflineAniList extends AniListSource {
  OfflineAniList() : super(MockClient((request) async => throw http.ClientException('offline')));

  @override
  Future<List<SourceMatch>> search(String query) => Future.error(const SourceUnavailable('anilist'));
}

void main() {
  test('volume titles give their series and number', () {
    expect(parseVolumeTitle('Frieren - Tome 4'), const VolumeTitle(seriesTitle: 'Frieren', volumeNumber: 4));
    expect(parseVolumeTitle('One Piece - Édition originale - Tome 104'), const VolumeTitle(seriesTitle: 'One Piece', volumeNumber: 104));
    expect(parseVolumeTitle('Dandadan T03'), const VolumeTitle(seriesTitle: 'Dandadan', volumeNumber: 3));
    expect(parseVolumeTitle('Blame! Vol. 2'), const VolumeTitle(seriesTitle: 'Blame!', volumeNumber: 2));
    expect(parseVolumeTitle('Frieren 12'), const VolumeTitle(seriesTitle: 'Frieren', volumeNumber: 12));
    expect(parseVolumeTitle('The Hobbit'), isNull);
  });

  test('google books recognises a manga by its publisher or category', () async {
    final byPublisher = (await GoogleBooksSource(jsonClient(googleBooksVolume(title: 'Frieren', subtitle: 'Tome 4', publisher: 'Kana')), apiKey: 'key').lookupBarcode(frierenFourIsbn)).single;
    expect(byPublisher.suggestedType, CategoryType.manga);
    expect(byPublisher.seriesTitle, 'Frieren');
    expect(byPublisher.volumeNumber, 4);
    final byCategory = (await GoogleBooksSource(jsonClient(googleBooksVolume(title: 'Frieren - Tome 4', categories: ['Comics & Graphic Novels / Manga / Fantasy'])), apiKey: 'key').lookupBarcode(frierenFourIsbn)).single;
    expect(byCategory.suggestedType, CategoryType.manga);
    final novel = (await GoogleBooksSource(jsonClient(googleBooksVolume(title: 'Le Seigneur des anneaux 2', publisher: 'Pocket')), apiKey: 'key').lookupBarcode(frierenFourIsbn)).single;
    expect(novel.suggestedType, CategoryType.books);
    expect(novel.volumeNumber, isNull);
  });

  test('a manga isbn is identified by google books and completed by anilist', () async {
    final source = IsbnWithSeriesSource(
      GoogleBooksSource(jsonClient(googleBooksVolume(title: 'Frieren - Tome 4', publisher: 'Kana')), apiKey: 'key'),
      AniListSource(clientReturning(fixture('anilist.json'))),
    );
    final match = (await source.lookupBarcode(frierenFourIsbn)).single;
    expect(match.sourceKey, 'anilist');
    expect(match.externalWorkId, '118586');
    expect(match.externalEditionId, 'gb-frieren-4');
    expect(match.volumeNumber, 4);
    expect(match.barcode, frierenFourIsbn);
    expect(match.imageUrl, 'https://books.google.com/frieren4.jpg');
    expect(match.suggestedType, CategoryType.manga);
    expect(match.titles.byLanguage.values, contains('Frieren: Beyond Journey’s End'));
  });

  test('without anilist the google books answer is kept', () async {
    final source = IsbnWithSeriesSource(GoogleBooksSource(jsonClient(googleBooksVolume(title: 'Frieren - Tome 4', publisher: 'Kana')), apiKey: 'key'), OfflineAniList());
    final match = (await source.lookupBarcode(frierenFourIsbn)).single;
    expect(match.sourceKey, 'googlebooks');
    expect(match.volumeNumber, 4);
  });

  group('owning manga volumes', () {
    late CollectionHarness harness;
    late CheckOwnership checkOwnership;
    late AddFromMatch addFromMatch;
    late String mangasId;

    setUp(() async {
      harness = CollectionHarness();
      mangasId = (await harness.mangas()).id;
      final source = IsbnWithSeriesSource(
        GoogleBooksSource(jsonClient(googleBooksVolume(title: 'Frieren - Tome 4', publisher: 'Kana')), apiKey: 'key'),
        AniListSource(clientReturning(fixture('anilist.json'))),
      );
      checkOwnership = CheckOwnership(FindLocally(harness.collection), SourceRegistry([source]), harness.collection, harness.categories);
      final addItem = AddItem(harness.collection, harness.categories, newId: harness.newId);
      addFromMatch = AddFromMatch(addItem, harness.collection, NoCovers(), newId: harness.newId);
    });

    tearDown(() => harness.database.close());

    SourceMatch volume(int number) => SourceMatch(
          sourceKey: 'anilist',
          externalWorkId: '118586',
          titles: const LocalizedTitles(byLanguage: {'en': 'Frieren: Beyond Journey\u2019s End', 'ja-Latn': 'Sousou no Frieren'}),
          seriesTitle: 'Frieren',
          volumeNumber: number,
          volumeCount: 13,
          status: 'RELEASING',
          suggestedType: CategoryType.manga,
        );

    test('owning volume 1 does not mean owning volume 4', () async {
      await addFromMatch(volume(1), categoryId: mangasId);
      final verdict = await checkOwnership.barcode(frierenFourIsbn);
      expect(verdict, isA<NotOwned>());
      expect((verdict as NotOwned).match?.volumeNumber, 4);
    });

    test('buying the scanned volume files it in its series and is then recognised', () async {
      await addFromMatch(volume(1), categoryId: mangasId);
      final verdict = await checkOwnership.barcode(frierenFourIsbn) as NotOwned;
      await addFromMatch(verdict.match!, categoryId: mangasId, barcode: frierenFourIsbn);
      final series = await harness.collection.watchSeriesInCategoryTree(mangasId).first;
      expect(series, hasLength(1));
      expect(series.single.publishedVolumes, 13);
      expect(await harness.collection.volumeNumbersOf(series.single.id), {1, 4});
      expect(await checkOwnership.barcode(frierenFourIsbn), isA<Owned>());
    });
  });

  test('comic albums found by isbn alone are grouped under their series title', () async {
    final harness = CollectionHarness();
    final comics = await harness.createCategory(name: 'BD', colorValue: 0, type: CategoryType.comics, conditionParts: const ['Album']);
    final addFromMatch = AddFromMatch(AddItem(harness.collection, harness.categories, newId: harness.newId), harness.collection, NoCovers(), newId: harness.newId);
    for (final number in [1, 3]) {
      await addFromMatch(
        SourceMatch(
          sourceKey: 'googlebooks',
          externalWorkId: 'asterix-$number',
          titles: LocalizedTitles(byLanguage: {'fr': 'Astérix - Tome $number'}),
          seriesTitle: 'Astérix',
          volumeNumber: number,
          suggestedType: CategoryType.comics,
        ),
        categoryId: comics.id,
      );
    }
    final series = await harness.collection.watchSeriesInCategoryTree(comics.id).first;
    expect(series.single.titles.byLanguage, {'fr': 'Astérix'});
    expect(series.single.externalWorkId, isNull);
    expect(await harness.collection.volumeNumbersOf(series.single.id), {1, 3});
    await harness.database.close();
  });
}
