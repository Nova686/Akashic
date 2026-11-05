import 'package:akashic/layers/functional/Lookup/data/sources/json_fields.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/source_http.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/card_game.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/card_search_result.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/precon_deck.dart';
import 'package:akashic/layers/functional/Lookup/domain/gateways/precon_deck_catalogue.dart';
import 'package:http/http.dart' as http;

class MtgjsonPreconCatalogue implements PreconDeckCatalogue {
  MtgjsonPreconCatalogue(this._client);

  static const String sourceKey = 'mtgjson';
  static const Set<String> leftOutTypes = {'Secret Lair Drop', 'Secret Lair Bundle', 'Jumpstart', 'Bundle Land Pack', 'Box Set'};
  static const List<String> deckBoards = ['commander', 'mainBoard'];

  final http.Client _client;
  Future<List<PreconDeck>>? _decks;

  @override
  CardGame get game => CardGame.magic;

  @override
  Future<List<PreconDeck>> decks() => _decks ??= _loadDecks().catchError((Object failure) {
        _decks = null;
        throw failure;
      });

  Future<List<PreconDeck>> _loadDecks() async {
    final json = mapOf(await sourceGetJson(_client, Uri.https('mtgjson.com', '/api/v5/DeckList.json'), sourceKey: sourceKey));
    final decks = [
      for (final deck in listOf(json['data']).map(mapOf))
        if ((textOf(deck['fileName']), textOf(deck['name']), textOf(deck['type'])) case (final fileName?, final name?, final type?) when !leftOutTypes.contains(type))
          PreconDeck(id: fileName, name: name, type: type, setCode: textOf(deck['code']), releaseDate: DateTime.tryParse(textOf(deck['releaseDate']) ?? '')),
    ];
    return decks
      ..sort((first, second) {
        final byKind = (first.isCommander ? 0 : 1).compareTo(second.isCommander ? 0 : 1);
        return byKind != 0 ? byKind : (second.releaseDate ?? DateTime(0)).compareTo(first.releaseDate ?? DateTime(0));
      });
  }

  @override
  Future<List<PreconCard>> cardsOf(PreconDeck deck) async {
    final data = mapOf(mapOf(await sourceGetJson(_client, Uri.https('mtgjson.com', '/api/v5/decks/${deck.id}.json'), sourceKey: sourceKey))['data']);
    return [
      for (final board in deckBoards)
        for (final card in listOf(data[board]).map(mapOf))
          if (textOf(card['name']) case final name?)
            PreconCard(
              card: CardSearchResult(
                name: name,
                externalCardId: textOf(mapOf(card['identifiers'])['scryfallId']),
                setName: textOf(card['setCode']),
                imageUrl: _imageOf(textOf(mapOf(card['identifiers'])['scryfallId'])),
                sourceKey: 'scryfall',
              ),
              quantity: card['count'] is int ? card['count']! as int : 1,
              isCommander: board == 'commander',
            ),
    ];
  }

  String? _imageOf(String? scryfallId) =>
      scryfallId == null || scryfallId.length < 2 ? null : 'https://cards.scryfall.io/normal/front/${scryfallId[0]}/${scryfallId[1]}/$scryfallId.jpg';
}
