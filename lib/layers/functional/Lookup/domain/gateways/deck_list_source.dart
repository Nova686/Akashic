import 'package:akashic/layers/functional/Lookup/domain/entities/imported_deck_list.dart';

abstract interface class DeckListSource {
  bool recognizes(String link);
  Future<ImportedDeckList> deckAt(String link);
}
