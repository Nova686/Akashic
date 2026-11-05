import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/card_kind.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/market_value.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/add_another_item.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/delete_copy.dart';
import 'package:akashic/layers/functional/Collection/data/gateways/drift_deck_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/deck_card.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:flutter_test/flutter_test.dart';

import 'collection_harness.dart';

void main() {
  test('every extra copy becomes its own item with its titles, deck, photos and loan', () async {
    final harness = CollectionHarness();
    addTearDown(harness.database.close);
    final vinyls = await harness.vinyls();
    final database = harness.database;
    await harness.collection.saveItem(CollectionItem(id: 'kob', categoryId: vinyls.id, titles: const LocalizedTitles(byLanguage: {'en': 'Kind of Blue', 'fr': 'Kind of Blue'}), creator: 'Miles Davis', cardKind: CardKind.deck));
    await database.into(database.copies).insert(CopiesCompanion.insert(id: 'first', itemId: 'kob', pricePaidCents: const Value(2500), createdAt: Value(DateTime(2020))));
    await database.into(database.copies).insert(CopiesCompanion.insert(id: 'second', itemId: 'kob', pricePaidCents: const Value(3000), loanedTo: const Value('Camille'), createdAt: Value(DateTime(2021))));
    await database.into(database.itemPhotos).insert(ItemPhotosCompanion.insert(id: 'photo-second', itemId: 'kob', copyId: const Value('second'), path: '/second.jpg', position: 0));
    await database.into(database.itemPhotos).insert(ItemPhotosCompanion.insert(id: 'photo-first', itemId: 'kob', copyId: const Value('first'), path: '/first.jpg', position: 0));
    await database.into(database.deckCards).insert(DeckCardsCompanion.insert(id: 'sol-ring', itemId: 'kob', name: 'Sol Ring', quantity: 1));
    await database.splitCopiesIntoItems();
    final split = await harness.collection.watchItem('split-second').first;
    expect(split?.titles.byLanguage, {'en': 'Kind of Blue', 'fr': 'Kind of Blue'});
    expect((split?.creator, split?.categoryId, split?.cardKind), ('Miles Davis', vinyls.id, CardKind.deck));
    expect((await harness.collection.watchCopies('kob').first).map((copy) => copy.id), ['first']);
    final moved = (await harness.collection.watchCopies('split-second').first).single;
    expect((moved.id, moved.pricePaidCents, moved.loanedTo), ('second', 3000, 'Camille'));
    expect({for (final photo in await database.select(database.itemPhotos).get()) photo.id: photo.itemId}, {'photo-second': 'split-second', 'photo-first': 'kob'});
    expect({for (final card in await database.select(database.deckCards).get()) card.id: card.itemId}, {'sol-ring': 'kob', 'split-second:sol-ring': 'split-second'});
    await database.splitCopiesIntoItems();
    expect(await database.select(database.items).get(), hasLength(2));
  });

  test('owning another one adds a new item with blank purchase details', () async {
    final harness = CollectionHarness();
    addTearDown(harness.database.close);
    final vinyls = await harness.vinyls();
    await harness.collection.saveItem(CollectionItem(id: 'kob', categoryId: vinyls.id, titles: const LocalizedTitles(byLanguage: {'en': 'Kind of Blue'}), sourceKey: 'discogs', externalWorkId: '42'));
    await harness.collection.saveCopy(const ItemCopy(id: 'kob-copy', itemId: 'kob', edition: 'Columbia 1959', pricePaidCents: 2500, location: 'Salon', barcode: '111'));
    await harness.collection.saveMarketValue('kob', MarketValue(cents: 4000, currency: 'EUR', valuedAt: DateTime(2026)));
    var sequence = 0;
    final anotherId = await AddAnotherItem(harness.collection, newId: () => 'new-${sequence++}')('kob', barcode: '222');
    expect(anotherId, 'new-0');
    final another = await harness.collection.watchItem('new-0').first;
    expect((another?.titles.byLanguage['en'], another?.sourceKey, another?.externalWorkId, another?.marketValue?.cents), ('Kind of Blue', 'discogs', '42', 4000));
    final copy = (await harness.collection.watchCopies('new-0').first).single;
    expect((copy.edition, copy.barcode, copy.pricePaidCents, copy.location), (null, '222', null, null));
    final sameEdition = await AddAnotherItem(harness.collection, newId: () => 'same-${sequence++}')('kob');
    expect((await harness.collection.watchCopies(sameEdition!).first).single.edition, 'Columbia 1959');
    expect(await AddAnotherItem(harness.collection)('missing'), isNull);
  });

  test('owning another deck copies its whole card list, commanders included', () async {
    final harness = CollectionHarness();
    addTearDown(harness.database.close);
    final magic = await harness.createCategory(name: 'Magic', colorValue: 0, type: CategoryType.cards, conditionParts: const ['Objet']);
    final decks = DriftDeckGateway(harness.database);
    await harness.collection.saveItem(CollectionItem(id: 'precon', categoryId: magic.id, titles: const LocalizedTitles(byLanguage: {'en': 'Growing Threat'}), cardKind: CardKind.deck));
    await decks.saveCards(const [
      DeckCard(id: 'brimaz', itemId: 'precon', name: 'Brimaz, Blight of Oreskos', quantity: 1, commanderRole: CommanderRole.primary),
      DeckCard(id: 'plains', itemId: 'precon', name: 'Plains', quantity: 12),
    ]);
    var sequence = 0;
    final anotherId = await AddAnotherItem(harness.collection, decks: decks, newId: () => 'new-${sequence++}')('precon');
    final copied = await decks.watchCards(anotherId!).first;
    expect({for (final card in copied) card.name: (card.quantity, card.commanderRole)}, {'Brimaz, Blight of Oreskos': (1, CommanderRole.primary), 'Plains': (12, CommanderRole.none)});
    expect(copied.every((card) => card.id != 'brimaz' && card.id != 'plains'), isTrue);
    expect(await decks.watchCards('precon').first, hasLength(2));
    expect((await harness.collection.watchItem(anotherId).first)?.cardKind, CardKind.deck);
  });

  test('deleting a clone keeps the cover the original still uses, deleting the last one removes it', () async {
    final harness = CollectionHarness();
    addTearDown(harness.database.close);
    final vinyls = await harness.vinyls();
    await harness.collection.saveItem(CollectionItem(id: 'kob', categoryId: vinyls.id, titles: const LocalizedTitles(byLanguage: {'en': 'Kind of Blue'}), imagePath: '/covers/kob.jpg'));
    await harness.collection.saveCopy(const ItemCopy(id: 'kob-copy', itemId: 'kob'));
    final anotherId = await AddAnotherItem(harness.collection)('kob');
    final deleted = <String>[];
    final deleteCopy = DeleteCopy(harness.collection, deleteImage: (path) async => deleted.add(path));
    await deleteCopy((await harness.collection.watchCopies(anotherId!).first).single);
    expect(deleted, isEmpty);
    await deleteCopy((await harness.collection.watchCopies('kob').first).single);
    expect(deleted, ['/covers/kob.jpg']);
  });
}
