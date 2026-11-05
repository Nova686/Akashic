import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';

import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/data/gateways/drift_deck_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/card_kind.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/deck_card.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/manage_deck.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/deck_editor_cubit.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/mtgjson_precon_catalogue.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/card_search_result.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/add_item.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/add_series_volumes.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/create_series.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/precon_deck_library.dart';
import 'package:akashic/layers/functional/Collection/presentation/cubit/item_editor_cubit.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/technical/MediaStorage/local_image_store.dart';
import 'package:akashic/layers/technical/MediaStorage/phone_image_picker.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/group_precon_decks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../collection_harness.dart';

http.Response jsonResponse(Object body) => http.Response.bytes(utf8.encode(jsonEncode(body)), 200, headers: {'content-type': 'application/json; charset=utf-8'});

MtgjsonPreconCatalogue fakeMtgjson() => MtgjsonPreconCatalogue(MockClient((request) async {
      if (request.url.path == '/api/v5/DeckList.json') {
        return jsonResponse({
          'data': [
            {'code': '10E', 'fileName': 'ArcanisSGuile_10E', 'name': "Arcanis's Guile", 'releaseDate': '2007-07-13', 'type': 'Theme Deck'},
            {'code': 'SLD', 'fileName': 'Drop_SLD', 'name': 'Some Drop', 'releaseDate': '2024-01-01', 'type': 'Secret Lair Drop'},
            {'code': 'MOC', 'fileName': 'Growing_MOC', 'name': 'Growing Threat', 'releaseDate': '2023-04-21', 'type': 'Commander Deck'},
          ],
        });
      }
      expect(request.url.path, '/api/v5/decks/Growing_MOC.json');
      return jsonResponse({
        'data': {
          'commander': [
            {'name': 'Brimaz, Blight of Oreskos', 'count': 1, 'setCode': 'MOC', 'identifiers': {'scryfallId': 'ab12cd34-0000-0000-0000-000000000000'}},
          ],
          'mainBoard': [
            {'name': 'Plains', 'count': 12, 'setCode': 'MOC', 'identifiers': {'scryfallId': 'ef56ab78-0000-0000-0000-000000000000'}},
            {'name': 'Sol Ring', 'count': 1, 'setCode': 'MOC', 'identifiers': {'scryfallId': '9a8b7c6d-0000-0000-0000-000000000000'}},
          ],
          'tokens': [
            {'name': 'Cat Token', 'count': 1},
          ],
        },
      });
    }));

class NoPicker implements PhoneImagePicker {
  @override
  Future<Uint8List?> pickFromGallery() async => null;

  @override
  Future<Uint8List?> takePhoto() async => null;
}

void main() {
  test('mtgjson lists the boxed decks newest first and leaves out drops', () async {
    final decks = await fakeMtgjson().decks();
    expect(decks.map((deck) => deck.name), ['Growing Threat', "Arcanis's Guile"]);
    expect(decks.first.type, 'Commander Deck');
  });

  test('a deck gives its commander and main board with counts, images and scryfall ids', () async {
    final catalogue = fakeMtgjson();
    final cards = await catalogue.cardsOf((await catalogue.decks()).first);
    expect(cards.map((card) => (card.card.name, card.quantity)), [('Brimaz, Blight of Oreskos', 1), ('Plains', 12), ('Sol Ring', 1)]);
    expect(cards.first.card.sourceKey, 'scryfall');
    expect(cards.first.card.imageUrl, 'https://cards.scryfall.io/normal/front/a/b/ab12cd34-0000-0000-0000-000000000000.jpg');
  });

  test('the commander of a precon deck is marked as such once in the deck', () async {
    final catalogue = fakeMtgjson();
    final cards = await catalogue.cardsOf((await catalogue.decks()).first);
    expect([for (final card in cards) if (card.isCommander) card.card.name], ['Brimaz, Blight of Oreskos']);
    final harness = CollectionHarness();
    final vinyls = await harness.vinyls();
    await harness.collection.saveItem(CollectionItem(id: 'deck', categoryId: vinyls.id, titles: const LocalizedTitles(byLanguage: {'fr': 'Deck'}), cardKind: CardKind.deck));
    final deck = DriftDeckGateway(harness.database);
    await ManageDeck(deck).addAll('deck', [for (final card in cards) (card.card, card.quantity)], commanderNames: [for (final card in cards) if (card.isCommander) card.card.name]);
    expect([for (final card in await deck.watchCards('deck').first) if (card.isCommander) (card.name, card.commanderRole)], [('Brimaz, Blight of Oreskos', CommanderRole.primary)]);
    await harness.database.close();
  });

  test('adding a whole deck merges with the cards already there', () async {
    final harness = CollectionHarness();
    addTearDown(harness.database.close);
    final tcg = await harness.createCategory(name: 'Magic', colorValue: 0, type: CategoryType.cards, conditionParts: const ['Objet']);
    await harness.collection.saveItem(CollectionItem(id: 'deck', categoryId: tcg.id, titles: const LocalizedTitles(byLanguage: {'fr': 'Deck'}), cardKind: CardKind.deck));
    final manageDeck = ManageDeck(DriftDeckGateway(harness.database));
    await manageDeck.add('deck', const CardSearchResult(name: 'Sol Ring', externalCardId: '9a8b7c6d-0000-0000-0000-000000000000', sourceKey: 'scryfall'));
    final cubit = DeckEditorCubit(itemId: 'deck', manageDeck: manageDeck, cardSearches: const [], preconDecks: fakeMtgjson());
    expect(cubit.state.canAddPrecon, isTrue);
    final added = await cubit.addPrecon((await cubit.precons()).first);
    expect(added, 14);
    final cards = await DriftDeckGateway(harness.database).watchCards('deck').first;
    expect({for (final card in cards) card.name: card.quantity}, {'Sol Ring': 2, 'Brimaz, Blight of Oreskos': 1, 'Plains': 12});
    await cubit.close();
  });

  test('the precon search puts commander decks first and matches names, sets and types', () async {
    final harness = CollectionHarness();
    addTearDown(harness.database.close);
    final library = PreconDeckLibrary(fakeMtgjson(), ManageDeck(DriftDeckGateway(harness.database)));
    expect((await library.search('')).map((match) => match.titles.byLanguage['en']), ['Growing Threat', "Arcanis's Guile"]);
    expect((await library.search('moc')).single.format, 'Commander Deck');
    expect(await library.coverOf('Growing_MOC'), 'https://cards.scryfall.io/normal/front/a/b/ab12cd34-0000-0000-0000-000000000000.jpg');
  });

  test('choosing deck in the add form searches precon decks and saving fills the new deck', () async {
    final harness = CollectionHarness();
    addTearDown(harness.database.close);
    final magic = await harness.createCategory(name: 'Magic', colorValue: 0, type: CategoryType.cards, conditionParts: const ['Objet']);
    final editor = ItemEditorCubit(
      categoryId: magic.id,
      categoryType: CategoryType.cards,
      preferredLanguages: PreferredLanguages.defaults,
      addItem: AddItem(harness.collection, harness.categories),
      addSeriesVolumes: AddSeriesVolumes(harness.collection),
      createSeries: CreateSeries(harness.collection),
      imagePicker: NoPicker(),
      imageStore: LocalImageStore(Directory.systemTemp),
      extractColor: (_) async => 0,
      searchDelay: Duration.zero,
      preconDecks: PreconDeckLibrary(fakeMtgjson(), ManageDeck(DriftDeckGateway(harness.database))),
    );
    editor.searchOnline('growing');
    editor.setCardKind(CardKind.deck);
    expect(editor.state.searchesPreconDecks, isTrue);
    await Future<void>.delayed(const Duration(milliseconds: 30));
    final deck = editor.state.searchResults.single;
    expect(deck.titles.byLanguage['en'], 'Growing Threat');
    await editor.applyMatch(deck);
    expect(editor.state.webImages.first, 'https://cards.scryfall.io/normal/front/a/b/ab12cd34-0000-0000-0000-000000000000.jpg');
    await editor.submit();
    final item = (await harness.collection.allItems()).single;
    expect(item.cardKind, CardKind.deck);
    final cards = await DriftDeckGateway(harness.database).watchCards(item.id).first;
    expect(cards.fold<int>(0, (total, card) => total + card.quantity), 14);
    await editor.close();
  });

  test('precon decks are offered in magic categories and in card categories tied to no game', () {
    Category cards(String name) => Category(id: name, name: name, colorValue: 0, type: CategoryType.cards, conditionParts: const ['Objet'], position: 0);
    final catalogue = fakeMtgjson();
    expect(offersPreconDecks(cards('Magic'), catalogue), isTrue);
    expect(offersPreconDecks(cards('TCG'), catalogue), isTrue);
    expect(offersPreconDecks(cards('Pokémon'), catalogue), isFalse);
    expect(offersPreconDecks(null, catalogue), isFalse);
  });

  test('a precon deck is shelved as a commander deck, and decks added before get their shelf back', () async {
    final harness = CollectionHarness();
    addTearDown(harness.database.close);
    final library = PreconDeckLibrary(fakeMtgjson(), ManageDeck(DriftDeckGateway(harness.database)), groupOf: (deck) => deck.isCommander ? 'Deck commander' : 'Deck préconstruit');
    expect((await library.search('growing')).single.platform, 'Deck commander');
    final magic = await harness.createCategory(name: 'Magic', colorValue: 0, type: CategoryType.cards, conditionParts: const ['Objet']);
    await harness.collection.saveItem(CollectionItem(
      id: 'growing',
      categoryId: magic.id,
      titles: const LocalizedTitles(byLanguage: {'en': 'Growing Threat'}),
      cardKind: CardKind.deck,
      sourceKey: PreconDeckLibrary.sourceKey,
      externalWorkId: 'Growing_MOC',
    ));
    final regrouped = await GroupPreconDecks(harness.collection, fakeMtgjson(), (deck) => deck.isCommander ? 'Deck commander' : 'Deck préconstruit')();
    expect(regrouped, 1);
    expect((await harness.collection.allItems()).single.groupKey, 'Deck commander');
    expect(await GroupPreconDecks(harness.collection, fakeMtgjson(), (deck) => 'x')(), 0);
  });

  test('a precon missing from the catalogue does not download the deck list again before a week', () async {
    final harness = CollectionHarness();
    addTearDown(harness.database.close);
    var downloads = 0;
    final catalogue = MtgjsonPreconCatalogue(MockClient((request) async {
      downloads++;
      return jsonResponse({'data': <Object>[]});
    }));
    final magic = await harness.createCategory(name: 'Magic', colorValue: 0, type: CategoryType.cards, conditionParts: const ['Objet']);
    await harness.collection.saveItem(CollectionItem(
      id: 'drop',
      categoryId: magic.id,
      titles: const LocalizedTitles(byLanguage: {'en': 'Some Drop'}),
      cardKind: CardKind.deck,
      sourceKey: PreconDeckLibrary.sourceKey,
      externalWorkId: 'Drop_SLD',
    ));
    var clock = DateTime(2026, 10, 30);
    GroupPreconDecks grouping() => GroupPreconDecks(harness.collection, catalogue, (deck) => 'x', settings: harness.settings, now: () => clock);
    expect(await grouping()(), 0);
    expect(downloads, 1);
    clock = clock.add(const Duration(days: 2));
    expect(await GroupPreconDecks(harness.collection, MtgjsonPreconCatalogue(MockClient((request) async => fail('no download within the week'))), (deck) => 'x', settings: harness.settings, now: () => clock)(), 0);
    clock = clock.add(const Duration(days: 6));
    await GroupPreconDecks(harness.collection, MtgjsonPreconCatalogue(MockClient((request) async {
      downloads++;
      return jsonResponse({'data': <Object>[]});
    })), (deck) => 'x', settings: harness.settings, now: () => clock)();
    expect(downloads, 2);
  });
}

