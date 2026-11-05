import 'dart:io';
import 'dart:typed_data';

import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/add_item.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/add_series_volumes.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/create_series.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_editor_cubit.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/catalog_source.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/image_search.dart';
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

class CardSource implements CatalogSource {
  CardSource(this.key, this.names, {this.isDown = false});

  @override
  final String key;
  final List<String> names;
  final bool isDown;

  @override
  Set<CategoryType> get types => const {CategoryType.cards};

  @override
  bool get isConfigured => true;

  @override
  bool get supportsBarcode => false;

  @override
  Future<List<SourceMatch>> search(String query) async {
    if (isDown) {
      throw SourceUnavailable(key);
    }
    return [
      for (final name in names) SourceMatch(sourceKey: key, externalWorkId: name, titles: LocalizedTitles(byLanguage: {'fr': name}), suggestedType: CategoryType.cards),
    ];
  }

  @override
  Future<List<SourceMatch>> lookupBarcode(String barcode) async => const [];
}

class CountingImageSearch implements ImageSearch {
  final List<String> queries = [];

  @override
  Future<List<String>> imagesFor(SourceMatch? match, String query) async {
    queries.add(query);
    return [?match?.imageUrl, 'https://upload.wikimedia.org/$query.jpg'];
  }
}

ItemEditorCubit cardsEditor(List<CatalogSource> sources, {ImageSearch? imageSearch}) => ItemEditorCubit(
      categoryId: 'tcg',
      categoryType: CategoryType.cards,
      preferredLanguages: PreferredLanguages.defaults,
      addItem: MockAddItem(),
      addSeriesVolumes: AddSeriesVolumes(NoCollection()),
      createSeries: CreateSeries(NoCollection()),
      imagePicker: NoPicker(),
      imageStore: LocalImageStore(Directory.systemTemp),
      extractColor: (_) async => 0,
      onlineSources: sources,
      imageSearch: imageSearch,
      searchDelay: Duration.zero,
    );

void main() {
  test('every source of the category type is asked and their answers are interleaved', () async {
    final cubit = cardsEditor([CardSource('tcgdex', ['Ange de Pokémon', 'Archange']), CardSource('scryfall', ['Serra Angel'])]);
    cubit.searchOnline('ange');
    await pumpEventQueue();
    expect(cubit.state.searchResults.map((match) => match.sourceKey), ['tcgdex', 'scryfall', 'tcgdex']);
    await cubit.close();
  });

  test('a source that is down does not hide the others', () async {
    final cubit = cardsEditor([CardSource('tcgdex', const [], isDown: true), CardSource('scryfall', ['Lightning Bolt'])]);
    cubit.searchOnline('bolt');
    await pumpEventQueue();
    expect(cubit.state.searchResults.single.externalWorkId, 'Lightning Bolt');
    expect(cubit.state.isSearching, isFalse);
    await cubit.close();
  });

  test('choosing a result shows its cover without searching images, which happens once when asked', () async {
    final images = CountingImageSearch();
    final cubit = cardsEditor([CardSource('scryfall', ['Lightning Bolt'])], imageSearch: images);
    await cubit.applyMatch(const SourceMatch(
      sourceKey: 'scryfall',
      externalWorkId: 'bolt',
      titles: LocalizedTitles(byLanguage: {'en': 'Lightning Bolt'}),
      imageUrl: 'https://cards.scryfall.io/bolt.jpg',
      suggestedType: CategoryType.cards,
    ));
    expect(images.queries, isEmpty);
    expect(cubit.state.webImages, ['https://cards.scryfall.io/bolt.jpg']);
    await cubit.searchWebImages();
    await cubit.searchWebImages();
    expect(images.queries, ['Lightning Bolt']);
    expect(cubit.state.webImages, ['https://cards.scryfall.io/bolt.jpg', 'https://upload.wikimedia.org/Lightning Bolt.jpg']);
    await cubit.close();
  });
}
