import 'package:akashic/layers/functional/Collection/domain/entities/deck_card.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/deck_gateway.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:drift/drift.dart';

class DriftDeckGateway implements DeckGateway {
  DriftDeckGateway(this._database);

  final AkashicDatabase _database;

  @override
  Stream<List<DeckCard>> watchCards(String itemId) {
    final query = _database.select(_database.deckCards)
      ..where((table) => table.itemId.equals(itemId))
      ..orderBy([(table) => OrderingTerm.asc(table.createdAt), (table) => OrderingTerm.asc(table.name)]);
    return query.watch().map((rows) => [
          for (final row in rows)
            _toCard(row),
        ]);
  }

  @override
  Future<DeckCard?> findCard(String cardId) async {
    final row = await (_database.select(_database.deckCards)..where((table) => table.id.equals(cardId))).getSingleOrNull();
    return row == null ? null : _toCard(row);
  }

  DeckCard _toCard(DeckCardRow row) => DeckCard(
        id: row.id,
        itemId: row.itemId,
        name: row.name,
        quantity: row.quantity,
        externalCardId: row.externalCardId,
        imageUrl: row.imageUrl,
        sourceKey: row.sourceKey,
        price: switch ((row.priceCents, row.priceCurrency, row.pricedAt)) {
          (final cents?, final currency?, final pricedAt?) => CardPrice(cents: cents, currency: currency, pricedAt: pricedAt),
          _ => null,
        },
        traits: switch ((row.typeLine, row.colorIdentity)) {
          (final typeLine?, final colorIdentity?) => CardTraits(typeLine: typeLine, colorIdentity: colorIdentity, manaValue: row.manaValue),
          _ => null,
        },
        commanderRole: switch ((row.isCommander, row.isSecondaryCommander)) {
          (false, _) => CommanderRole.none,
          (true, true) => CommanderRole.secondary,
          (true, false) => CommanderRole.primary,
        },
      );

  @override
  Stream<List<DeckCard>> watchAllCards() => _database.select(_database.deckCards).watch().map((rows) => [for (final row in rows) _toCard(row)]);

  @override
  Future<void> saveCard(DeckCard card) => _database.into(_database.deckCards).insertOnConflictUpdate(_rowOf(card));

  @override
  Future<void> saveCards(List<DeckCard> cards) async {
    if (cards.isEmpty) {
      return;
    }
    await _database.batch((batch) => batch.insertAllOnConflictUpdate(_database.deckCards, [for (final card in cards) _rowOf(card)]));
  }

  DeckCardsCompanion _rowOf(DeckCard card) {
    return DeckCardsCompanion.insert(
      id: card.id,
      itemId: card.itemId,
      name: card.name,
      quantity: card.quantity,
      externalCardId: Value(card.externalCardId),
      imageUrl: Value(card.imageUrl),
      sourceKey: Value(card.sourceKey),
      priceCents: Value(card.price?.cents),
      priceCurrency: Value(card.price?.currency),
      pricedAt: Value(card.price?.pricedAt),
      typeLine: Value(card.traits?.typeLine),
      colorIdentity: Value(card.traits?.colorIdentity),
      manaValue: Value(card.traits?.manaValue),
      isCommander: Value(card.isCommander),
      isSecondaryCommander: Value(card.commanderRole == CommanderRole.secondary),
    );
  }

  @override
  Future<void> removeCard(String cardId) => (_database.delete(_database.deckCards)..where((table) => table.id.equals(cardId))).go();
}
