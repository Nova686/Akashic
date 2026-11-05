import 'dart:convert';

import 'package:akashic/layers/functional/Lookup/data/sources/scryfall_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/ygoprodeck_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

http.Response jsonResponse(Object body) => http.Response.bytes(utf8.encode(jsonEncode(body)), 200, headers: {'content-type': 'application/json; charset=utf-8'});

void main() {
  test('scryfall prices many cards per collection call, euros first then dollars', () async {
    final batchSizes = <int>[];
    final source = ScryfallSource(MockClient((request) async {
      expect(request.url.path, '/cards/collection');
      final identifiers = (jsonDecode(request.body) as Map<String, dynamic>)['identifiers'] as List;
      batchSizes.add(identifiers.length);
      return jsonResponse({
        'data': [
          for (final identifier in identifiers)
            {
              'id': (identifier as Map)['id'],
              'prices': identifier['id'] == 'card-1' ? {'eur': null, 'usd': '2.50'} : {'eur': '1.20', 'usd': '1.40'},
            },
        ],
      });
    }));
    final prices = await source.pricesOf([for (var index = 0; index < 80; index++) 'card-$index']);
    expect(batchSizes, [75, 5]);
    expect((prices['card-0']!.cents, prices['card-0']!.currency), (120, 'EUR'));
    expect((prices['card-1']!.cents, prices['card-1']!.currency), (250, 'USD'));
  });

  test('ygoprodeck prices several cards in one cardinfo call', () async {
    final asked = <String>[];
    final source = YgoprodeckSource(MockClient((request) async {
      asked.add(request.url.queryParameters['id']!);
      return jsonResponse({
        'data': [
          {
            'id': 46986414,
            'card_prices': [
              {'cardmarket_price': '0.35', 'tcgplayer_price': '0.40'},
            ],
          },
          {
            'id': 89631139,
            'card_prices': [
              {'cardmarket_price': '0.00', 'tcgplayer_price': '1.10'},
            ],
          },
        ],
      });
    }));
    final prices = await source.pricesOf(['46986414', '89631139']);
    expect(asked, ['46986414,89631139']);
    expect((prices['46986414']!.cents, prices['46986414']!.currency), (35, 'EUR'));
    expect(prices['89631139']!.currency, isNotNull);
  });
}
