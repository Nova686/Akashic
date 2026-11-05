import 'dart:io';
import 'dart:typed_data';

import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/data/gateways/drift_deck_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/card_kind.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/add_item.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/add_series_volumes.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/create_series.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/manage_deck.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/deck_editor_cubit.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_editor_cubit.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/card_search_result.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/card_search.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/technical/MediaStorage/local_image_store.dart';
import 'package:akashic/layers/technical/MediaStorage/phone_image_picker.dart';
import 'package:flutter_test/flutter_test.dart';

import '../collection_harness.dart';

class FakeCardSearch implements CardSearch {
  @override
  String get key => 'pokemontcg';

  @override
  Future<List<CardSearchResult>> searchCards(String query) async => const [CardSearchResult(name: 'Pikachu', externalCardId: 'sv3pt5-25', setName: '151')];
}

class NoPicker implements PhoneImagePicker {
  @override
  Future<Uint8List?> pickFromGallery() async => null;

  @override
  Future<Uint8List?> takePhoto() async => null;
}

void main() {
  late CollectionHarness harness;
  late String tcgId;

  setUp(() async {
    harness = CollectionHarness();
    tcgId = (await harness.createCategory(name: 'TCG', colorValue: 0, type: CategoryType.cards, conditionParts: const ['Objet'])).id;
  });
  tearDown(() => harness.database.close());

  test('choosing deck stores the card kind', () async {
    final editor = ItemEditorCubit(
      categoryId: tcgId,
      categoryType: CategoryType.cards,
      preferredLanguages: PreferredLanguages.defaults,
      addItem: AddItem(harness.collection, harness.categories),
      addSeriesVolumes: AddSeriesVolumes(harness.collection),
      createSeries: CreateSeries(harness.collection),
      imagePicker: NoPicker(),
      imageStore: LocalImageStore(Directory.systemTemp),
      extractColor: (_) async => 0,
    );
    expect(editor.state.cardKind, CardKind.extension);
    editor
      ..setCardKind(CardKind.deck)
      ..setTitle('fr', 'Deck électrique');
    await editor.submit();
    expect((await harness.collection.allItems()).single.cardKind, CardKind.deck);
    await editor.close();
  });

  test('a deck editor adds a searched card and shows the total', () async {
    await harness.collection.saveItem(CollectionItem(id: 'deck', categoryId: tcgId, titles: const LocalizedTitles(byLanguage: {'fr': 'Deck'}), cardKind: CardKind.deck));
    final cubit = DeckEditorCubit(itemId: 'deck', manageDeck: ManageDeck(DriftDeckGateway(harness.database)), cardSearches: [FakeCardSearch()], searchDelay: Duration.zero)..start();
    cubit.search('pika');
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(cubit.state.searchResults.single.name, 'Pikachu');
    await cubit.add(cubit.state.searchResults.single);
    await cubit.add(cubit.state.searchResults.single);
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(cubit.state.cards.single.quantity, 2);
    expect(cubit.state.totalCards, 2);
    await cubit.close();
  });

  test('a deck of a game without catalogue takes cards typed by hand', () async {
    await harness.collection.saveItem(CollectionItem(id: 'deck', categoryId: tcgId, titles: const LocalizedTitles(byLanguage: {'fr': 'Deck'}), cardKind: CardKind.deck));
    final cubit = DeckEditorCubit(itemId: 'deck', manageDeck: ManageDeck(DriftDeckGateway(harness.database)), cardSearches: const [], searchDelay: Duration.zero)..start();
    expect(cubit.state.canSearchCards, isFalse);
    cubit.search('  Agumon  ');
    await cubit.addTypedCard();
    await Future<void>.delayed(const Duration(milliseconds: 20));
    expect(cubit.state.cards.single.name, 'Agumon');
    expect(cubit.state.searchResults, isEmpty);
    await cubit.close();
  });
}
