import 'package:equatable/equatable.dart';

class CardPrice extends Equatable {
  const CardPrice({required this.cents, required this.currency, required this.pricedAt});

  final int cents;
  final String currency;
  final DateTime pricedAt;

  @override
  List<Object?> get props => [cents, currency, pricedAt];
}

class CardTraits extends Equatable {
  const CardTraits({required this.typeLine, required this.colorIdentity, this.manaValue});

  final String typeLine;
  final String colorIdentity;
  final double? manaValue;

  @override
  List<Object?> get props => [typeLine, colorIdentity, manaValue];
}

enum CommanderRole { none, primary, secondary }

class DeckCard extends Equatable {
  const DeckCard({
    required this.id,
    required this.itemId,
    required this.name,
    required this.quantity,
    this.externalCardId,
    this.imageUrl,
    this.sourceKey,
    this.price,
    this.traits,
    this.commanderRole = CommanderRole.none,
  });

  final String id;
  final String itemId;
  final String name;
  final String? externalCardId;
  final int quantity;
  final String? imageUrl;
  final String? sourceKey;
  final CardPrice? price;
  final CardTraits? traits;
  final CommanderRole commanderRole;

  bool get isCommander => commanderRole != CommanderRole.none;

  DeckCard copyWith({int? quantity, CardPrice? price, CardTraits? traits, CommanderRole? commanderRole}) => DeckCard(
        id: id,
        itemId: itemId,
        name: name,
        quantity: quantity ?? this.quantity,
        externalCardId: externalCardId,
        imageUrl: imageUrl,
        sourceKey: sourceKey,
        price: price ?? this.price,
        traits: traits ?? this.traits,
        commanderRole: commanderRole ?? this.commanderRole,
      );

  @override
  List<Object?> get props => [id, itemId, name, externalCardId, quantity, imageUrl, sourceKey, price, traits, commanderRole];
}
