import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/suggest_category.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:flutter_test/flutter_test.dart';

import '../Collection/collection_harness.dart';

SourceMatch mangaVolume({String? creator, String? publisher}) => SourceMatch(
      sourceKey: 'google_books',
      externalWorkId: 'one-piece-105',
      titles: const LocalizedTitles(byLanguage: {'fr': 'One Piece Tome 105'}),
      seriesTitle: 'One Piece',
      volumeNumber: 105,
      creator: creator,
      publisher: publisher,
      suggestedType: CategoryType.manga,
    );

void main() {
  late CollectionHarness harness;
  late SuggestCategory suggestCategory;

  setUp(() {
    harness = CollectionHarness();
    suggestCategory = SuggestCategory(harness.categories, collection: harness.collection);
  });
  tearDown(() => harness.database.close());

  Future<(String, String)> shonenAndSeinen() async {
    final mangas = await harness.mangas();
    final shonen = await harness.createCategory(name: 'Shōnen', colorValue: 0, type: CategoryType.manga, parentId: mangas.id);
    final seinen = await harness.createCategory(name: 'Seinen', colorValue: 0, type: CategoryType.manga, parentId: mangas.id);
    return (shonen.id, seinen.id);
  }

  test('a volume goes where its series already lives', () async {
    final (_, seinenId) = await shonenAndSeinen();
    await harness.collection.saveSeries(Series(id: 'series', categoryId: seinenId, titles: const LocalizedTitles(byLanguage: {'fr': 'One Piece'})));
    expect((await suggestCategory.forMatch(mangaVolume()))?.id, seinenId);
  });

  test('a subcategory named in the match wins over the others', () async {
    final mangas = await harness.mangas();
    await harness.createCategory(name: 'Kana', colorValue: 0, type: CategoryType.manga, parentId: mangas.id);
    final glenat = await harness.createCategory(name: 'Glénat', colorValue: 0, type: CategoryType.manga, parentId: mangas.id);
    expect((await suggestCategory.forMatch(mangaVolume(publisher: 'Glenat')))?.id, glenat.id);
  });

  test('the same creator pulls the item next to their other works', () async {
    final (_, seinenId) = await shonenAndSeinen();
    await harness.collection.saveItem(CollectionItem(id: 'film-z', categoryId: seinenId, titles: const LocalizedTitles(byLanguage: {'fr': 'Film Z'}), creator: 'Eiichirō Oda'));
    expect((await suggestCategory.forMatch(mangaVolume(creator: 'Eiichiro Oda')))?.id, seinenId);
  });

  test('without any clue the fullest subcategory is chosen', () async {
    final (_, seinenId) = await shonenAndSeinen();
    await harness.collection.saveItem(CollectionItem(id: 'berserk', categoryId: seinenId, titles: const LocalizedTitles(byLanguage: {'fr': 'Berserk'})));
    expect((await suggestCategory.forMatch(mangaVolume()))?.id, seinenId);
  });

  test('no category of that type means no suggestion', () async {
    await harness.vinyls();
    expect(await suggestCategory.forMatch(mangaVolume()), isNull);
  });
}
