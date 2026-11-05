import 'dart:typed_data';

import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/add_item.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/add_series_volumes.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/create_series.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_editor_cubit.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_editor_state.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/technical/MediaStorage/local_image_store.dart';
import 'package:akashic/layers/technical/MediaStorage/phone_image_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAddItem extends Mock implements AddItem {}

class MockAddSeriesVolumes extends Mock implements AddSeriesVolumes {}

class MockCreateSeries extends Mock implements CreateSeries {}

class MockLocalImageStore extends Mock implements LocalImageStore {}

class FakePhoneImagePicker implements PhoneImagePicker {
  @override
  Future<Uint8List?> pickFromGallery() async => Uint8List.fromList([9, 9]);

  @override
  Future<Uint8List?> takePhoto() async => Uint8List.fromList([1, 2, 3]);
}

void main() {
  late MockAddItem addItem;
  late MockAddSeriesVolumes addSeriesVolumes;
  late MockCreateSeries createSeries;
  late MockLocalImageStore imageStore;

  setUpAll(() {
    registerFallbackValue(Uint8List(0));
    registerFallbackValue(const LocalizedTitles(byLanguage: {}));
    registerFallbackValue(const CollectionItem(id: 'fallback', categoryId: 'fallback', titles: LocalizedTitles(byLanguage: {})));
    registerFallbackValue(const Series(id: 'fallback', categoryId: 'fallback', titles: LocalizedTitles(byLanguage: {})));
  });

  setUp(() {
    addItem = MockAddItem();
    addSeriesVolumes = MockAddSeriesVolumes();
    createSeries = MockCreateSeries();
    imageStore = MockLocalImageStore();
    when(() => imageStore.delete(any())).thenAnswer((_) async {});
    when(() => imageStore.save(any())).thenAnswer((_) async => '/images/photo.jpg');
    when(() => addItem(any())).thenAnswer((invocation) async => invocation.positionalArguments.first as CollectionItem);
  });

  ItemEditorCubit buildEditor({Future<int> Function(Uint8List bytes)? extractColor}) {
    var sequence = 0;
    return ItemEditorCubit(
      categoryId: 'mangas',
      preferredLanguages: PreferredLanguages.defaults,
      addItem: addItem,
      addSeriesVolumes: addSeriesVolumes,
      createSeries: createSeries,
      imagePicker: FakePhoneImagePicker(),
      imageStore: imageStore,
      extractColor: extractColor ?? (_) async => 0xFFC2412D,
      newId: () => 'new-${sequence++}',
    );
  }

  test('picking a photo stores it and sets the spine color', () async {
    final editor = buildEditor();
    await editor.takePhoto();
    expect(editor.state.imagePath, '/images/photo.jpg');
    expect(editor.state.spineColorValue, 0xFFC2412D);
    await editor.close();
  });

  test('a manual spine color wins over the extracted one, even after picking a new photo', () async {
    final editor = buildEditor();
    editor.overrideSpineColor(0xFF22344F);
    await editor.pickFromGallery();
    expect(editor.state.spineColorValue, 0xFF22344F);
    await editor.close();
  });

  test('a volume range calls AddSeriesVolumes with from and to', () async {
    when(() => createSeries(categoryId: any(named: 'categoryId'), titles: any(named: 'titles'), creator: any(named: 'creator')))
        .thenAnswer((invocation) async => Series(id: 'frieren', categoryId: 'mangas', titles: invocation.namedArguments[#titles]));
    when(() => addSeriesVolumes(series: any(named: 'series'), from: any(named: 'from'), to: any(named: 'to'), template: any(named: 'template')))
        .thenAnswer((_) async => [1, 2, 3]);
    final editor = buildEditor();
    editor.setTitle('fr', 'Frieren');
    editor.startNewSeries();
    editor.setVolumeRange(from: '1', to: '9');
    await editor.submit();
    verify(() => addSeriesVolumes(series: any(named: 'series'), from: 1, to: 9, template: any(named: 'template'))).called(1);
    verifyNever(() => addItem(any()));
    expect(editor.state.status, ItemEditorStatus.saved);
    await editor.close();
  });

  test('an item without any title is refused', () async {
    final editor = buildEditor();
    await editor.submit();
    expect(editor.state.status, ItemEditorStatus.invalid);
    verifyNever(() => addItem(any()));
    await editor.close();
  });

  test('a single item keeps its titles and original language', () async {
    final editor = buildEditor();
    editor.setTitle('fr', 'Le Hobbit');
    editor.setTitle('en', 'The Hobbit');
    editor.setOriginalLanguage('en');
    editor.setCreator('J. R. R. Tolkien');
    await editor.submit();
    final saved = verify(() => addItem(captureAny())).captured.single as CollectionItem;
    expect(saved.titles.byLanguage, {'fr': 'Le Hobbit', 'en': 'The Hobbit'});
    expect(saved.titles.originalLanguage, 'en');
    expect(saved.creator, 'J. R. R. Tolkien');
    await editor.close();
  });
}
