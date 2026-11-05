import 'package:akashic/layers/functional/Collection/domain/entities/deck_card.dart';

abstract interface class CardTraitsCatalogue {
  String get key;
  Future<Map<String, CardTraits>> traitsOf(List<String> externalCardIds);
}
