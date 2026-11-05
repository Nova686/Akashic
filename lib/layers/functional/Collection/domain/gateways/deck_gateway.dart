import 'package:akashic/layers/functional/Collection/domain/entities/deck_card.dart';

abstract interface class DeckGateway {
  Stream<List<DeckCard>> watchCards(String itemId);
  Stream<List<DeckCard>> watchAllCards();
  Future<DeckCard?> findCard(String cardId);
  Future<void> saveCard(DeckCard card);
  Future<void> saveCards(List<DeckCard> cards);
  Future<void> removeCard(String cardId);
}
