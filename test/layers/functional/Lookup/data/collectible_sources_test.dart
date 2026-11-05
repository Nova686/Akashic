import 'dart:convert';

import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/amiibo_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/igdb_platform_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/igdb_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/rebrickable_source.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/upcitemdb_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

http.Response jsonResponse(Object body, [int status = 200]) =>
    http.Response.bytes(utf8.encode(jsonEncode(body)), status, headers: {'content-type': 'application/json; charset=utf-8'});

void main() {
  test('rebrickable searches by the set number found in a product name and names the theme', () async {
    final requests = <Uri>[];
    final source = RebrickableSource(MockClient((request) async {
      requests.add(request.url);
      expect(request.headers['Authorization'], 'key secret');
      if (request.url.path.contains('/themes/')) {
        return jsonResponse({'id': 158, 'name': 'Star Wars'});
      }
      return jsonResponse({
        'results': [
          {'set_num': '75192-1', 'name': 'Millennium Falcon', 'year': 2017, 'theme_id': 158, 'num_parts': 7541, 'set_img_url': 'https://cdn.rebrickable.com/media/sets/75192-1.jpg'},
        ],
      });
    }), apiKey: 'secret');
    final match = (await source.search('LEGO Star Wars 75192 Millennium Falcon')).single;
    expect(requests.first.queryParameters['search'], '75192');
    expect(match.titles.byLanguage['en'], 'Millennium Falcon (75192)');
    expect(match.creator, 'Star Wars');
    expect(match.year, 2017);
    expect(match.format, '7541 pcs');
    expect(match.suggestedType, CategoryType.lego);
  });

  test('rebrickable without a key is not configured', () {
    expect(RebrickableSource(MockClient((request) async => jsonResponse({})), apiKey: '').isConfigured, isFalse);
  });

  test('amiiboapi gives the figure with its series and an unknown name gives nothing', () async {
    final source = AmiiboSource(MockClient((request) async {
      if (request.url.queryParameters['name'] == 'nobody') {
        return jsonResponse({'error': 'not found'}, 404);
      }
      return jsonResponse({
        'amiibo': [
          {'name': 'Link', 'head': '01000000', 'tail': '00040002', 'amiiboSeries': 'Super Smash Bros.', 'gameSeries': 'The Legend of Zelda', 'release': {'eu': '2014-11-28', 'na': '2014-11-21'}, 'image': 'https://raw.githubusercontent.com/N3evin/AmiiboAPI/master/images/icon_01000000-00040002.png'},
        ],
      });
    }));
    final match = (await source.search('link')).single;
    expect(match.externalWorkId, '0100000000040002');
    expect(match.creator, 'Super Smash Bros.');
    expect(match.seriesTitle, 'The Legend of Zelda');
    expect(match.year, 2014);
    expect(await source.search('nobody'), isEmpty);
  });

  test('igdb platforms give the console with its maker, first release and logo', () async {
    final source = IgdbPlatformSource(IgdbSource(MockClient((request) async {
      if (request.url.host == 'id.twitch.tv') {
        return jsonResponse({'access_token': 'token', 'expires_in': 3600});
      }
      expect(request.url.path, '/v4/platforms');
      return jsonResponse([
        {
          'id': 130,
          'name': 'Nintendo Switch',
          'platform_logo': {'image_id': 'pl6b'},
          'versions': [
            {
              'platform_version_release_dates': [{'date': 1488499200}],
              'companies': [{'company': {'name': 'Nintendo'}, 'manufacturer': true}],
            },
          ],
        },
      ]);
    }), clientId: 'id', clientSecret: 'secret'));
    final match = (await source.search('switch')).single;
    expect(match.titles.byLanguage['en'], 'Nintendo Switch');
    expect(match.creator, 'Nintendo');
    expect(match.year, 2017);
    expect(match.imageUrl, 'https://images.igdb.com/igdb/image/upload/t_logo_med/pl6b.png');
    expect(match.suggestedType, CategoryType.consoles);
  });

  test('a lego or amiibo product barcode is routed to its catalogue', () {
    expect(UpcItemDbSource.categoryTypeOfProduct('Toys & Games > Toys', productTitle: 'Millennium Falcon 75192', brand: 'LEGO'), CategoryType.lego);
    expect(UpcItemDbSource.categoryTypeOfProduct('Toys & Games', productTitle: 'Link amiibo Super Smash Bros'), CategoryType.amiibo);
  });
}
