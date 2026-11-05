import 'package:akashic/layers/functional/Collection/domain/entities/deck_card.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/deck_gateway.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/card_search_result.dart';
import 'package:uuid/uuid.dart';

class ManageDeck {
  ManageDeck(this._deck, {String Function()? newId}) : _newId = newId ?? const Uuid().v4;

  final DeckGateway _deck;
  final String Function() _newId;

  Stream<List<DeckCard>> watch(String itemId) => _deck.watchCards(itemId);

  Future<void> add(String itemId, CardSearchResult card) async {
    final cards = await _deck.watchCards(itemId).first;
    final existing = cards.where((candidate) => card.externalCardId != null ? candidate.externalCardId == card.externalCardId : candidate.name == card.name).firstOrNull;
    if (existing != null) {
      await _deck.saveCard(_withQuantity(existing, existing.quantity + 1));
      return;
    }
    await _deck.saveCard(DeckCard(id: _newId(), itemId: itemId, name: card.name, quantity: 1, externalCardId: card.externalCardId, imageUrl: card.imageUrl, sourceKey: card.sourceKey));
  }

  Future<int> addAll(String itemId, List<(CardSearchResult, int)> cards, {List<String> commanderNames = const [], Map<String, CardTraits> traitsByCardId = const {}}) async {
    final existing = [...await _deck.watchCards(itemId).first];
    final savedById = <String, DeckCard>{};
    var added = 0;
    for (final (card, quantity) in cards) {
      if (quantity < 1) {
        continue;
      }
      final index = existing.indexWhere((candidate) => card.externalCardId != null ? candidate.externalCardId == card.externalCardId : candidate.name == card.name);
      final saved = index >= 0
          ? _withQuantity(existing[index], existing[index].quantity + quantity)
          : DeckCard(
              id: _newId(),
              itemId: itemId,
              name: card.name,
              quantity: quantity,
              externalCardId: card.externalCardId,
              imageUrl: card.imageUrl,
              sourceKey: card.sourceKey,
              traits: traitsByCardId[card.externalCardId],
              commanderRole: switch (commanderNames.indexOf(card.name)) {
                0 => CommanderRole.primary,
                1 => CommanderRole.secondary,
                _ => CommanderRole.none,
              },
            );
      savedById[saved.id] = saved;
      if (index >= 0) {
        existing[index] = saved;
      } else {
        existing.add(saved);
      }
      added += quantity;
    }
    await _deck.saveCards(savedById.values.toList());
    return added;
  }

  Future<void> setQuantity(String cardId, int quantity) async {
    final card = await _deck.findCard(cardId);
    if (card != null) {
      await _deck.saveCard(_withQuantity(card, quantity < 1 ? 1 : quantity));
    }
  }

  Future<void> remove(String cardId) => _deck.removeCard(cardId);

  Future<void> setCommanderRole(String cardId, CommanderRole role) async {
    final card = await _deck.findCard(cardId);
    if (card == null || card.commanderRole == role) {
      return;
    }
    final cards = await _deck.watchCards(card.itemId).first;
    final roles = {for (final deckCard in cards) deckCard.id: deckCard.commanderRole, card.id: role};
    if (role != CommanderRole.none) {
      final holder = cards.where((deckCard) => deckCard.id != card.id && deckCard.commanderRole == role).firstOrNull;
      if (holder != null) {
        final hasSecondary = cards.any((deckCard) => deckCard.id != card.id && deckCard.commanderRole == CommanderRole.secondary);
        roles[holder.id] = card.isCommander
            ? card.commanderRole
            : role == CommanderRole.primary && !hasSecondary
                ? CommanderRole.secondary
                : CommanderRole.none;
      }
    }
    if (!roles.containsValue(CommanderRole.primary)) {
      final secondaryId = roles.entries.where((entry) => entry.value == CommanderRole.secondary).firstOrNull?.key;
      if (secondaryId != null) {
        roles[secondaryId] = CommanderRole.primary;
      }
    }
    for (final deckCard in cards) {
      if (roles[deckCard.id] case final newRole? when newRole != deckCard.commanderRole) {
        await _deck.saveCard(deckCard.copyWith(commanderRole: newRole));
      }
    }
  }

  Future<void> swapCommanders(String itemId) async {
    final cards = await _deck.watchCards(itemId).first;
    final primary = cards.where((card) => card.commanderRole == CommanderRole.primary).firstOrNull;
    final secondary = cards.where((card) => card.commanderRole == CommanderRole.secondary).firstOrNull;
    if (primary == null || secondary == null) {
      return;
    }
    await _deck.saveCard(primary.copyWith(commanderRole: CommanderRole.secondary));
    await _deck.saveCard(secondary.copyWith(commanderRole: CommanderRole.primary));
  }

  Future<int> totalCards(String itemId) async => (await _deck.watchCards(itemId).first).fold<int>(0, (total, card) => total + card.quantity);

  DeckCard _withQuantity(DeckCard card, int quantity) => card.copyWith(quantity: quantity);
}
