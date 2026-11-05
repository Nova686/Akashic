import 'package:akashic/layers/functional/Collection/domain/entities/deck_card.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/scryfall_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/card_search_result.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/imported_deck_list.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/deck_list_source.dart';
import 'package:http/http.dart' as http;

class ArchidektDeckSource implements DeckListSource {
  ArchidektDeckSource(this._client);

  static const String sourceKey = 'archidekt';
  static const String commanderCategory = 'Commander';
  static const Map<String, String> _colorLetters = {'White': 'W', 'Blue': 'U', 'Black': 'B', 'Red': 'R', 'Green': 'G'};
  static final RegExp _deckLink = RegExp(r'archidekt\.com/(?:api/)?decks/(\d+)');
  static final RegExp _deckNumber = RegExp(r'^\d+$');

  final http.Client _client;

  String? _deckIdOf(String link) => _deckLink.firstMatch(link)?.group(1) ?? (_deckNumber.hasMatch(link.trim()) ? link.trim() : null);

  @override
  bool recognizes(String link) => _deckIdOf(link) != null;

  @override
  Future<ImportedDeckList> deckAt(String link) async {
    final deckId = _deckIdOf(link) ?? (throw const DeckListNotFound());
    final json = await sourceGetJson(_client, Uri.https('archidekt.com', '/api/decks/$deckId/'), sourceKey: sourceKey);
    if (json == null) {
      throw const DeckListNotFound();
    }
    final deck = mapOf(json);
    final leftOutCategories = {
      for (final category in listOf(deck['categories']).map(mapOf))
        if (category['includedInDeck'] == false) ?textOf(category['name']),
    };
    final cards = <ImportedDeckCard>[];
    for (final entry in listOf(deck['cards']).map(mapOf)) {
      final categories = listOf(entry['categories']).whereType<String>().toSet();
      final card = mapOf(entry['card']);
      final oracle = mapOf(card['oracleCard']);
      final name = textOf(oracle['name']) ?? textOf(card['displayName']);
      final quantity = entry['quantity'] is int ? entry['quantity']! as int : 1;
      if (name == null || quantity < 1 || categories.any(leftOutCategories.contains)) {
        continue;
      }
      final scryfallId = textOf(card['uid']);
      cards.add(ImportedDeckCard(
        card: CardSearchResult(
          name: name,
          externalCardId: scryfallId,
          setName: textOf(mapOf(card['edition'])['editionname']),
          imageUrl: scryfallId == null || scryfallId.length < 2 ? null : 'https://cards.scryfall.io/normal/front/${scryfallId[0]}/${scryfallId[1]}/$scryfallId.jpg',
          sourceKey: ScryfallSource.sourceKey,
        ),
        quantity: quantity,
        isCommander: categories.contains(commanderCategory),
        traits: _traitsOf(oracle),
      ));
    }
    return ImportedDeckList(name: textOf(deck['name']) ?? deckId, cards: cards);
  }

  CardTraits? _traitsOf(Map<String, Object?> oracle) {
    final types = listOf(oracle['types']).whereType<String>().toList();
    if (types.isEmpty) {
      return null;
    }
    final subtypes = listOf(oracle['subTypes']).whereType<String>().toList();
    final mainLine = [...listOf(oracle['superTypes']).whereType<String>(), ...types].join(' ');
    return CardTraits(
      typeLine: subtypes.isEmpty ? mainLine : '$mainLine — ${subtypes.join(' ')}',
      colorIdentity: [for (final color in const ['White', 'Blue', 'Black', 'Red', 'Green']) if (listOf(oracle['colorIdentity']).contains(color)) _colorLetters[color]!].join(),
      manaValue: (oracle['cmc'] as num?)?.toDouble(),
    );
  }
}
