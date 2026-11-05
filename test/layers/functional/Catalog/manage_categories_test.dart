import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Catalog/domain/use_cases/manage_categories.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:flutter_test/flutter_test.dart';

import '../Collection/collection_harness.dart';

void main() {
  late CollectionHarness harness;
  late List<String> deletedImages;
  late ManageCategories manageCategories;

  setUp(() {
    harness = CollectionHarness();
    deletedImages = [];
    manageCategories = ManageCategories(harness.categories, harness.collection, deleteImage: (path) async => deletedImages.add(path));
  });
  tearDown(() => harness.database.close());

  test('a category can be renamed and recoloured', () async {
    final vinyls = await harness.vinyls();
    await manageCategories.rename(vinyls, name: '  Disques  ', colorValue: 0xFF5ED1C3);
    final renamed = await harness.categories.findById(vinyls.id);
    expect(renamed?.name, 'Disques');
    expect(renamed?.colorValue, 0xFF5ED1C3);
    expect(renamed?.type, CategoryType.music);
  });

  test('categories are reordered among their siblings', () async {
    final vinyls = await harness.vinyls();
    final mangas = await harness.mangas();
    expect((await manageCategories.siblingsOf(vinyls)).map((category) => category.id), [vinyls.id, mangas.id]);
    await manageCategories.reorder([mangas, vinyls]);
    expect((await manageCategories.siblingsOf(vinyls)).map((category) => category.id), [mangas.id, vinyls.id]);
  });

  test('deleting a category removes its subcategories, items, series and covers', () async {
    final mangas = await harness.mangas();
    final shonen = await harness.createCategory(name: 'Shōnen', colorValue: 0, type: CategoryType.manga, parentId: mangas.id);
    final vinyls = await harness.vinyls();
    await harness.collection.saveSeries(Series(id: 'one-piece', categoryId: shonen.id, titles: const LocalizedTitles(byLanguage: {'fr': 'One Piece'})));
    await harness.collection.saveItem(CollectionItem(id: 'op-1', categoryId: shonen.id, seriesId: 'one-piece', volumeNumber: 1, titles: const LocalizedTitles(byLanguage: {'fr': 'One Piece 1'}), imagePath: '/covers/op-1.jpg'));
    await harness.collection.saveCopy(const ItemCopy(id: 'op-1-copy', itemId: 'op-1'));
    await harness.collection.saveItem(CollectionItem(id: 'op-2', categoryId: vinyls.id, seriesId: 'one-piece', titles: const LocalizedTitles(byLanguage: {'fr': 'One Piece OST'})));
    expect(await manageCategories.contentsOf(mangas), const CategoryContents(itemCount: 1, seriesCount: 1, subcategoryCount: 1));
    await manageCategories.delete(mangas);
    expect(await harness.categories.findById(mangas.id), isNull);
    expect(await harness.categories.findById(shonen.id), isNull);
    expect((await harness.collection.allItems()).map((item) => item.id), ['op-2']);
    expect((await harness.collection.allItems()).single.seriesId, isNull);
    expect(deletedImages, ['/covers/op-1.jpg']);
  });
}
