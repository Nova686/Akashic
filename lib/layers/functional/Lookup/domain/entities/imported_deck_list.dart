import 'package:akashic/layers/functional/Collection/domain/entities/deck_card.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/card_search_result.dart';
import 'package:equatable/equatable.dart';

class ImportedDeckCard extends Equatable {
  const ImportedDeckCard({required this.card, required this.quantity, this.isCommander = false, this.traits});

  final CardSearchResult card;
  final int quantity;
  final bool isCommander;
  final CardTraits? traits;

  @override
  List<Object?> get props => [card, quantity, isCommander, traits];
}

class ImportedDeckList extends Equatable {
  const ImportedDeckList({required this.name, required this.cards});

  final String name;
  final List<ImportedDeckCard> cards;

  @override
  List<Object?> get props => [name, cards];
}

class DeckListNotFound implements Exception {
  const DeckListNotFound();
}
