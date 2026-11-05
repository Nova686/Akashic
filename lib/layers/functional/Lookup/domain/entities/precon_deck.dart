import 'package:akashic/layers/functional/Lookup/domain/entities/card_search_result.dart';
import 'package:equatable/equatable.dart';

class PreconDeck extends Equatable {
  const PreconDeck({required this.id, required this.name, required this.type, this.setCode, this.releaseDate});

  final String id;
  final String name;
  final String type;
  final String? setCode;
  final DateTime? releaseDate;

  bool get isCommander => type.toLowerCase().contains('commander');

  @override
  List<Object?> get props => [id, name, type, setCode, releaseDate];
}

class PreconCard extends Equatable {
  const PreconCard({required this.card, required this.quantity, this.isCommander = false});

  final CardSearchResult card;
  final int quantity;
  final bool isCommander;

  @override
  List<Object?> get props => [card, quantity, isCommander];
}
