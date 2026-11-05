import 'dart:io';
import 'dart:typed_data';

import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/add_item.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/add_series_volumes.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/create_series.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_editor_cubit.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/technical/MediaStorage/local_image_store.dart';
import 'package:akashic/layers/technical/MediaStorage/phone_image_picker.dart';
import 'package:flutter_test/flutter_test.dart';

import '../collection_harness.dart';

class NoPicker implements PhoneImagePicker {
  @override
  Future<Uint8List?> pickFromGallery() async => null;

  @override
  Future<Uint8List?> takePhoto() async => null;
}

void main() {
  test('a series created from an anilist match keeps its id, volume count and status', () async {
    final harness = CollectionHarness();
    final mangas = await harness.mangas();
    final editor = ItemEditorCubit(
      categoryId: mangas.id,
      categoryType: CategoryType.manga,
      preferredLanguages: PreferredLanguages.defaults,
      addItem: AddItem(harness.collection, harness.categories),
      addSeriesVolumes: AddSeriesVolumes(harness.collection),
      createSeries: CreateSeries(harness.collection),
      imagePicker: NoPicker(),
      imageStore: LocalImageStore(Directory.systemTemp),
      extractColor: (_) async => 0,
    );
    await editor.applyMatch(const SourceMatch(
      sourceKey: 'anilist',
      externalWorkId: '118586',
      titles: LocalizedTitles(byLanguage: {'en': 'Frieren'}),
      volumeCount: 13,
      status: 'FINISHED',
      suggestedType: CategoryType.manga,
    ));
    editor
      ..startNewSeries()
      ..setVolumeRange(from: '1', to: '3');
    await editor.submit();
    final series = (await harness.collection.watchSeriesInCategoryTree(mangas.id).first).single;
    expect(series.externalWorkId, '118586');
    expect(series.sourceKey, 'anilist');
    expect(series.publishedVolumes, 13);
    expect(series.status, 'FINISHED');
    await editor.close();
    await harness.database.close();
  });
}
