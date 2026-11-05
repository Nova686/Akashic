import 'package:akashic/layers/functional/Lookup/domain/entities/card_game.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/precon_deck.dart';

abstract interface class PreconDeckCatalogue {
  CardGame get game;
  Future<List<PreconDeck>> decks();
  Future<List<PreconCard>> cardsOf(PreconDeck deck);
}
