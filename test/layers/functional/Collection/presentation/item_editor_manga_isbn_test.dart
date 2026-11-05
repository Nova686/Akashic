import 'dart:io';
import 'dart:typed_data';

import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/add_item.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/add_series_volumes.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/create_series.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_editor_cubit.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_editor_state.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/technical/MediaStorage/local_image_store.dart';
import 'package:akashic/layers/technical/MediaStorage/phone_image_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class NoPicker implements PhoneImagePicker {
  @override
  Future<Uint8List?> pickFromGallery() async => null;

  @override
  Future<Uint8List?> takePhoto() async => null;
}

class MockAddItem extends Mock implements AddItem {}

class NoCollection extends Mock implements CollectionGateway {}

const frierenTitles = LocalizedTitles(byLanguage: {'en': 'Frieren: Beyond Journey’s End', 'ja-Latn': 'Sousou no Frieren'});

const frierenFour = SourceMatch(
  sourceKey: 'anilist',
  externalWorkId: '118586',
  titles: frierenTitles,
  seriesTitle: 'Frieren',
  volumeNumber: 4,
  barcode: '9782505088227',
  suggestedType: CategoryType.manga,
);

ItemEditorCubit mangaEditor({List<Series> existingSeries = const []}) => ItemEditorCubit(
      categoryId: 'mangas',
      categoryType: CategoryType.manga,
      preferredLanguages: PreferredLanguages.defaults,
      addItem: MockAddItem(),
      addSeriesVolumes: AddSeriesVolumes(NoCollection()),
      createSeries: CreateSeries(NoCollection()),
      imagePicker: NoPicker(),
      imageStore: LocalImageStore(Directory.systemTemp),
      extractColor: (_) async => 0,
      existingSeries: existingSeries,
      barcodeLookup: (barcode) async => const [frierenFour],
      searchDelay: Duration.zero,
    );

void main() {
  test('a scanned manga volume goes into its existing series with its number', () async {
    const owned = Series(id: 'frieren', categoryId: 'mangas', titles: frierenTitles, sourceKey: 'anilist', externalWorkId: '118586');
    final cubit = mangaEditor(existingSeries: const [owned]);
    await cubit.useBarcode('9782505088227');
    await cubit.applyMatch(cubit.state.searchResults.single);
    expect(cubit.state.seriesChoice, SeriesChoice.existing);
    expect(cubit.state.selectedSeries, owned);
    expect(cubit.state.volumeFromText, '4');
    expect(cubit.state.volumeToText, '4');
    await cubit.close();
  });

  test('a scanned volume of an unknown series prepares a new series', () async {
    final cubit = mangaEditor();
    await cubit.useBarcode('9782505088227');
    await cubit.applyMatch(cubit.state.searchResults.single);
    expect(cubit.state.seriesChoice, SeriesChoice.created);
    expect(cubit.state.sourceKey, 'anilist');
    expect(cubit.state.volumeFromText, '4');
    expect(cubit.state.titles, frierenTitles.byLanguage);
    await cubit.close();
  });
}
