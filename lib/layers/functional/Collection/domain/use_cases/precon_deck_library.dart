import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/manage_deck.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/search_text_normalizer.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/card_game.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/precon_deck.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/precon_deck_catalogue.dart';

bool offersPreconDecks(Category? category, PreconDeckCatalogue catalogue) {
  if (category == null || category.type != CategoryType.cards) {
    return false;
  }
  final game = cardGameNamed(category.name);
  return game == null || game == catalogue.game;
}

class PreconDeckLibrary {
  PreconDeckLibrary(this._catalogue, this._manageDeck, {this._groupOf});

  static const String sourceKey = 'precon';
  static const int maximumResults = 30;

  final PreconDeckCatalogue _catalogue;
  final ManageDeck _manageDeck;
  final String Function(PreconDeck deck)? _groupOf;
  final Map<String, Future<List<PreconCard>>> _cardsByDeck = {};

  static bool isPrecon(String? sourceKey) => sourceKey == PreconDeckLibrary.sourceKey;

  Future<List<SourceMatch>> search(String query) async {
    final wanted = normalizeForSearch(query);
    final decks = [
      for (final deck in await _catalogue.decks())
        if (normalizeForSearch('${deck.name} ${deck.setCode ?? ''} ${deck.type}').contains(wanted)) deck,
    ]..sort((first, second) {
        final byKind = (first.isCommander ? 0 : 1).compareTo(second.isCommander ? 0 : 1);
        return byKind != 0 ? byKind : (second.releaseDate ?? DateTime(0)).compareTo(first.releaseDate ?? DateTime(0));
      });
    return [
      for (final deck in decks.take(maximumResults))
        SourceMatch(
          sourceKey: sourceKey,
          externalWorkId: deck.id,
          titles: LocalizedTitles(byLanguage: {'en': deck.name}),
          year: deck.releaseDate?.year,
          publisher: deck.setCode,
          format: deck.type,
          platform: _groupOf?.call(deck),
          suggestedType: CategoryType.cards,
        ),
    ];
  }

  Future<List<PreconCard>> _cardsOf(String deckId) => _cardsByDeck[deckId] ??= _catalogue.cardsOf(PreconDeck(id: deckId, name: deckId, type: '')).catchError((Object failure) {
        _cardsByDeck.remove(deckId);
        throw failure;
      });

  Future<String?> coverOf(String deckId) async => (await _cardsOf(deckId)).map((card) => card.card.imageUrl).nonNulls.firstOrNull;

  Future<int> fill(String itemId, String deckId) async {
    final cards = await _cardsOf(deckId);
    return _manageDeck.addAll(itemId, [for (final card in cards) (card.card, card.quantity)], commanderNames: [for (final card in cards) if (card.isCommander) card.card.name]);
  }
}
