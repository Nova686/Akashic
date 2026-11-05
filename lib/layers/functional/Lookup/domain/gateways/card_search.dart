import 'package:akashic/layers/functional/Lookup/domain/entities/card_search_result.dart';

abstract interface class CardSearch {
  String get key;
  Future<List<CardSearchResult>> searchCards(String query);
}
