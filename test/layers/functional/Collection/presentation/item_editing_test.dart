import 'dart:typed_data';

import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/add_item.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/add_series_volumes.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/create_series.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/update_item.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_editor_cubit.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_editor_state.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/technical/MediaStorage/local_image_store.dart';
import 'package:akashic/layers/technical/MediaStorage/phone_image_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../collection_harness.dart';

class MockLocalImageStore extends Mock implements LocalImageStore {}

class NoPicker implements PhoneImagePicker {
  @override
  Future<Uint8List?> pickFromGallery() async => null;

  @override
  Future<Uint8List?> takePhoto() async => null;
}

void main() {
  late CollectionHarness harness;

  setUp(() => harness = CollectionHarness());
  tearDown(() => harness.database.close());

  Future<CollectionItem> seedHobbit() async {
    final books = await harness.createCategory(name: 'Livres', colorValue: 0, type: CategoryType.books, conditionParts: const ['Objet']);
    final hobbit = CollectionItem(
      id: 'hobbit',
      categoryId: books.id,
      titles: const LocalizedTitles(byLanguage: {'en': 'The Hobbit'}, originalLanguage: 'en'),
      creator: 'Tolkien',
      year: 1937,
      rating: 4,
      spineColorValue: 0xFF6FD6B0,
    );
    await harness.collection.saveItem(hobbit);
    await harness.collection.saveCopy(const ItemCopy(id: 'pocket', itemId: 'hobbit', edition: 'Poche'));
    return hobbit;
  }

  ItemEditorCubit editorFor(CollectionItem item) => ItemEditorCubit.edit(
        item: item,
        categoryType: CategoryType.books,
        preferredLanguages: PreferredLanguages.defaults,
        updateItem: UpdateItem(harness.collection),
        addItem: AddItem(harness.collection, harness.categories),
        addSeriesVolumes: AddSeriesVolumes(harness.collection),
        createSeries: CreateSeries(harness.collection),
        imagePicker: NoPicker(),
        imageStore: MockLocalImageStore(),
        extractColor: (_) async => 0,
      );

  test('the editor is prefilled with the item', () async {
    final editor = editorFor(await seedHobbit());
    expect(editor.state.isEditing, isTrue);
    expect(editor.state.titles, {'en': 'The Hobbit'});
    expect(editor.state.originalLanguage, 'en');
    expect(editor.state.creator, 'Tolkien');
    expect(editor.state.yearText, '1937');
    expect(editor.state.rating, 4);
    expect(editor.state.spineColorValue, 0xFF6FD6B0);
    await editor.close();
  });

  test('editing an item keeps its id and copies and saves the new titles', () async {
    final editor = editorFor(await seedHobbit());
    editor
      ..setTitle('fr', 'Le Hobbit')
      ..setCreator('J. R. R. Tolkien');
    await editor.submit();
    expect(editor.state.status, ItemEditorStatus.saved);
    final stored = (await harness.collection.watchItem('hobbit').first)!;
    expect(stored.titles.byLanguage, {'en': 'The Hobbit', 'fr': 'Le Hobbit'});
    expect(stored.creator, 'J. R. R. Tolkien');
    expect(stored.rating, 4);
    expect((await harness.collection.watchCopies('hobbit').first).single.edition, 'Poche');
    expect(await harness.collection.allItems(), hasLength(1));
    await editor.close();
  });

  test('updating an unknown item is refused', () async {
    await expectLater(
      UpdateItem(harness.collection)(const CollectionItem(id: 'ghost', categoryId: 'none', titles: LocalizedTitles(byLanguage: {'en': 'Ghost'}))),
      throwsA(isA<ItemNotFound>()),
    );
  });
}
