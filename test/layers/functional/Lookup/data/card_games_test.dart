import 'dart:convert';

import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/lorcast_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/optcg_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/riftcodex_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/scryfall_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/tcgdex_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/ygoprodeck_source.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/card_game.dart';
import 'package:akashic/layers/functional/Lookup/domain/use_cases/source_registry.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

http.Response jsonResponse(Object body, [int status = 200]) =>
    http.Response.bytes(utf8.encode(jsonEncode(body)), status, headers: {'content-type': 'application/json; charset=utf-8'});

Category cardCategory(String name, {String? parentId}) =>
    Category(id: name, parentId: parentId, name: name, colorValue: 0, type: CategoryType.cards, conditionParts: const ['Objet'], position: 0);

void main() {
  test('a game is recognised from the name of its category', () {
    expect(cardGameNamed('Pokémon'), CardGame.pokemon);
    expect(cardGameNamed('Cartes Magic: The Gathering'), CardGame.magic);
    expect(cardGameNamed('Yu-Gi-Oh!'), CardGame.yugioh);
    expect(cardGameNamed('Disney Lorcana'), CardGame.lorcana);
    expect(cardGameNamed('Riftbound'), CardGame.riftbound);
    expect(cardGameNamed('One Piece'), CardGame.onePiece);
    expect(cardGameNamed('Cartes One Piece TCG'), CardGame.onePiece);
    expect(cardGameNamed('Digimon'), isNull);
    expect(cardGameNamed('Magicien'), isNull);
  });

  test('each game subcategory only asks its own catalogue, other games are entered by hand', () {
    final unused = MockClient((request) async => jsonResponse(const []));
    final registry = SourceRegistry([TcgdexSource(unused), ScryfallSource(unused), YgoprodeckSource(unused), LorcastSource(unused)]);
    expect(registry.forCategory(cardCategory('Yu-Gi-Oh!', parentId: 'tcg')).map((source) => source.key), ['ygoprodeck']);
    expect(registry.forCategory(cardCategory('Lorcana', parentId: 'tcg')).map((source) => source.key), ['lorcast']);
    expect(registry.forCategory(cardCategory('Digimon', parentId: 'tcg')), isEmpty);
    expect(registry.forCategory(cardCategory('TCG')), hasLength(4));
  });

  test('ygoprodeck merges french and english card names and treats a 400 as no card', () async {
    final requests = <Uri>[];
    final source = YgoprodeckSource(MockClient((request) async {
      requests.add(request.url);
      if (request.url.queryParameters['language'] == 'fr') {
        return jsonResponse({'error': 'No card matching your query was found in the database.'}, 400);
      }
      return jsonResponse({
        'data': [
          {
            'id': 46986414,
            'name': 'Dark Magician',
            'card_sets': [{'set_name': 'Legend of Blue Eyes White Dragon', 'set_code': 'LOB-005'}],
            'card_images': [{'image_url_small': 'https://images.ygoprodeck.com/images/cards_small/46986414.jpg'}],
          },
        ],
      });
    }));
    final cards = await source.searchCards('Dark Magician');
    expect(cards.single.name, 'Dark Magician');
    expect(cards.single.externalCardId, '46986414');
    expect(cards.single.setName, 'Legend of Blue Eyes White Dragon');
    expect(requests.map((uri) => uri.queryParameters['fname']).toSet(), {'Dark Magician'});
  });

  test('ygoprodeck finds an extension by its name, newest first', () async {
    final source = YgoprodeckSource(MockClient((request) async => jsonResponse([
          {'set_name': 'Legend of Blue Eyes White Dragon', 'set_code': 'LOB', 'tcg_date': '2002-03-08', 'set_image': 'https://images.ygoprodeck.com/images/sets/LOB.jpg'},
          {'set_name': 'Blue-Eyes White Destiny', 'set_code': 'BEWD', 'tcg_date': '2023-01-19'},
        ])));
    final matches = await source.search('blue');
    expect(matches.map((match) => match.externalWorkId), ['BEWD', 'LOB']);
    expect(matches.last.year, 2002);
    expect(matches.last.imageUrl, 'https://images.ygoprodeck.com/images/sets/LOB.jpg');
  });

  test('lorcast names each card with its version and extension', () async {
    final source = LorcastSource(MockClient((request) async => jsonResponse({
          'results': [
            {
              'id': 'crd_1',
              'name': 'Elsa',
              'version': 'Concerned Sister',
              'set': {'code': '11', 'name': 'Winterspell'},
              'image_uris': {'digital': {'small': 'https://cards.lorcast.io/card/digital/small/crd_1.avif'}},
            },
          ],
        })));
    final card = (await source.searchCards('elsa')).single;
    expect(card.name, 'Elsa – Concerned Sister');
    expect(card.setName, 'Winterspell');
    expect(card.imageUrl, endsWith('.avif'));
  });

  test('riftcodex names each card with its extension and finds extensions by name', () async {
    final source = RiftcodexSource(MockClient((request) async {
      if (request.url.path == '/sets') {
        return jsonResponse({
          'items': [
            {'name': 'Origins', 'set_id': 'OGN', 'published_on': '2025-10-31T00:00:00'},
            {'name': 'Unleashed', 'set_id': 'UNL', 'published_on': '2026-02-13T00:00:00'},
          ],
        });
      }
      expect(request.url.queryParameters['fuzzy'], 'jinx');
      return jsonResponse({
        'items': [
          {'name': 'Jinx - Rebel', 'riftbound_id': 'pr-202-298', 'set': {'label': 'Riftbound Promotional Cards'}, 'media': {'image_url': 'https://cmsassets.rgpub.io/jinx.png'}},
        ],
      });
    }));
    final card = (await source.searchCards('jinx')).single;
    expect(card.name, 'Jinx - Rebel');
    expect(card.externalCardId, 'pr-202-298');
    expect(card.setName, 'Riftbound Promotional Cards');
    final extension = (await source.search('origins')).single;
    expect(extension.externalWorkId, 'OGN');
    expect(extension.year, 2025);
  });

  test('optcg finds one piece cards, keeps each parallel apart and prices it in dollars', () async {
    final source = OptcgSource(MockClient((request) async {
      if (request.url.path == '/api/sets/filtered/') {
        expect(request.url.queryParameters['card_name'], 'zoro');
        return jsonResponse([
          {'card_image_id': 'OP01-001', 'card_set_id': 'OP01-001', 'card_name': 'Roronoa Zoro (001)', 'set_name': 'Romance Dawn', 'card_image': 'https://optcgapi.com/media/static/Card_Images/OP01-001.jpg'},
          {'card_image_id': 'OP01-001_p1', 'card_set_id': 'OP01-001', 'card_name': 'Roronoa Zoro (001) (Parallel)', 'set_name': 'Romance Dawn'},
        ]);
      }
      expect(request.url.path, '/api/sets/card/OP01-001/');
      return jsonResponse([
        {'card_image_id': 'OP01-001', 'market_price': 2.02},
        {'card_image_id': 'OP01-001_p1', 'market_price': 568.01},
      ]);
    }), now: () => DateTime(2026, 10, 28));
    final cards = await source.searchCards('zoro');
    expect(cards.map((card) => card.externalCardId), ['OP01-001', 'OP01-001_p1']);
    expect(cards.first.setName, 'Romance Dawn');
    expect(cards.first.sourceKey, 'optcg');
    final parallel = await source.priceOf('OP01-001_p1');
    expect(parallel?.cents, 56801);
    expect(parallel?.currency, 'USD');
  });

  test('the set list of a card catalogue is fetched once, and again after a failure', () async {
    var setRequests = 0;
    var fails = true;
    final source = OptcgSource(MockClient((request) async {
      setRequests++;
      if (fails) {
        fails = false;
        return jsonResponse({'error': 'down'}, 503);
      }
      return jsonResponse([
        {'set_id': 'OP-01', 'set_name': 'Romance Dawn'},
      ]);
    }));
    await expectLater(source.search('romance'), throwsA(anything));
    expect((await source.search('romance')).single.externalWorkId, 'OP-01');
    await source.search('dawn');
    expect(setRequests, 2);
  });
}
