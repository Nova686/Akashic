import 'dart:async';
import 'dart:typed_data';

import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Catalog/domain/gateways/category_gateway.dart';
import 'package:akashic/layers/functional/Catalog/domain/use_cases/delete_category.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/add_item.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/add_series_volumes.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/create_series.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/watch_shelf.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_editor_cubit.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_editor_state.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/functional/Settings/domain/gateways/settings_gateway.dart';
import 'package:akashic/layers/technical/MediaStorage/local_image_store.dart';
import 'package:akashic/layers/technical/MediaStorage/phone_image_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../collection_harness.dart';

class ListenerCounter {
  int active = 0;

  Stream<T> stream<T>(T value) {
    late StreamController<T> controller;
    controller = StreamController<T>(
      onListen: () {
        active++;
        controller.add(value);
      },
      onCancel: () => active--,
    );
    return controller.stream;
  }
}

class CountingCollectionGateway extends Mock implements CollectionGateway {}

class SlowCategoryGateway extends Mock implements CategoryGateway {}

class CountingSettingsGateway extends Mock implements SettingsGateway {}

class MockAddItem extends Mock implements AddItem {}

class MockLocalImageStore extends Mock implements LocalImageStore {}

class SilentPhonePicker implements PhoneImagePicker {
  @override
  Future<Uint8List?> pickFromGallery() async => null;

  @override
  Future<Uint8List?> takePhoto() async => null;
}

void main() {
  test('cancelling a shelf before its category type loads leaves no watcher behind', () async {
    final counter = ListenerCounter();
    final collection = CountingCollectionGateway();
    final categories = SlowCategoryGateway();
    final settings = CountingSettingsGateway();
    final typeLookup = Completer<Category?>();
    when(() => categories.findById(any())).thenAnswer((_) => typeLookup.future);
    when(() => collection.watchItemsInCategoryTree(any())).thenAnswer((_) => counter.stream(const <CollectionItem>[]));
    when(() => collection.watchSeriesInCategoryTree(any())).thenAnswer((_) => counter.stream(const <Series>[]));
    when(() => settings.watchPreferredLanguages()).thenAnswer((_) => counter.stream(PreferredLanguages.defaults));

    final subscription = WatchShelf(collection, categories, settings)('mangas').listen((_) {});
    await Future<void>.delayed(Duration.zero);
    await subscription.cancel();
    typeLookup.complete(null);
    await Future<void>.delayed(Duration.zero);

    expect(counter.active, 0);
  });

  test('a category holding only an empty series is refused, not a raw SQL error', () async {
    final harness = CollectionHarness();
    final mangas = await harness.mangas();
    await harness.collection.saveSeries(Series(id: 'empty', categoryId: mangas.id, titles: const LocalizedTitles(byLanguage: {'fr': 'Vide'})));
    await expectLater(DeleteCategory(harness.categories)(mangas.id), throwsA(isA<CategoryNotEmpty>()));
    await harness.database.close();
  });

  test('a huge volume range is refused', () async {
    final harness = CollectionHarness();
    final mangas = await harness.mangas();
    final series = Series(id: 'one-piece', categoryId: mangas.id, titles: const LocalizedTitles(byLanguage: {'fr': 'One Piece'}));
    await harness.collection.saveSeries(series);
    final template = CollectionItem(id: 'template', categoryId: mangas.id, titles: series.titles, seriesId: series.id);
    await expectLater(
      AddSeriesVolumes(harness.collection)(series: series, from: 1, to: 5000, template: template),
      throwsA(isA<InvalidVolumeRange>()),
    );
    expect(await AddSeriesVolumes(harness.collection, newId: harness.newId)(series: series, from: 1, to: 2, template: template), [1, 2]);
    await harness.database.close();
  });

  group('item editor failures', () {
    late MockAddItem addItem;

    setUpAll(() => registerFallbackValue(const CollectionItem(id: 'fallback', categoryId: 'fallback', titles: LocalizedTitles(byLanguage: {}))));

    setUp(() => addItem = MockAddItem());

    ItemEditorCubit editor() => ItemEditorCubit(
          categoryId: 'vinyls',
          preferredLanguages: PreferredLanguages.defaults,
          addItem: addItem,
          addSeriesVolumes: AddSeriesVolumes(CountingCollectionGateway()),
          createSeries: CreateSeries(CountingCollectionGateway()),
          imagePicker: SilentPhonePicker(),
          imageStore: MockLocalImageStore(),
          extractColor: (_) async => 0,
        );

    test('a failed save is reported instead of staying in saving', () async {
      when(() => addItem(any())).thenThrow(const ItemNeedsLeafCategory('vinyls'));
      final cubit = editor()..setTitle('fr', 'Kind of Blue');
      await cubit.submit();
      expect(cubit.state.status, ItemEditorStatus.failure);
      await cubit.close();
    });

    test('closing the editor while saving does not throw', () async {
      final saving = Completer<CollectionItem>();
      when(() => addItem(any())).thenAnswer((_) => saving.future);
      final cubit = editor()..setTitle('fr', 'Kind of Blue');
      final submitted = cubit.submit();
      await cubit.close();
      saving.complete(const CollectionItem(id: 'x', categoryId: 'vinyls', titles: LocalizedTitles(byLanguage: {})));
      await expectLater(submitted, completes);
    });
  });

  test('copy fallback is reachable', () {
    expect(const ItemCopy(id: 'a', itemId: 'b').conditions, isEmpty);
    expect(CategoryType.manga.defaultConditionParts, isNotEmpty);
  });
}
