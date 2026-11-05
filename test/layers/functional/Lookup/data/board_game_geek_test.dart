import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/board_game_geek_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

const searchAnswer = '''<?xml version="1.0" encoding="utf-8"?>
<items total="2">
  <item type="boardgame" id="13"><name type="primary" value="CATAN"/><yearpublished value="1995"/></item>
  <item type="boardgameexpansion" id="926"><name type="primary" value="CATAN: Seafarers"/><yearpublished value="1997"/></item>
</items>''';

const thingAnswer = '''<?xml version="1.0" encoding="utf-8"?>
<items>
  <item type="boardgame" id="13">
    <image>https://cf.geekdo-images.com/catan.jpg</image>
    <name type="primary" sortindex="1" value="CATAN"/>
    <name type="alternate" sortindex="1" value="Les Colons de Catane"/>
    <yearpublished value="1995"/>
    <link type="boardgamedesigner" id="11" value="Klaus Teuber"/>
    <link type="boardgamepublisher" id="37" value="KOSMOS"/>
  </item>
  <item type="boardgameexpansion" id="926">
    <name type="primary" sortindex="1" value="CATAN: Seafarers"/>
    <yearpublished value="1997"/>
  </item>
</items>''';

void main() {
  test('boardgamegeek is off without a token', () {
    expect(BoardGameGeekSource(MockClient((request) async => http.Response('', 500)), token: '').isConfigured, isFalse);
  });

  test('boardgamegeek searches then describes the games with the token', () async {
    final requests = <http.Request>[];
    final source = BoardGameGeekSource(
      MockClient((request) async {
        requests.add(request);
        return http.Response(request.url.path.endsWith('/search') ? searchAnswer : thingAnswer, 200, headers: {'content-type': 'text/xml; charset=utf-8'});
      }),
      token: 'secret-token',
    );
    final matches = await source.search('catan');
    expect(requests.map((request) => request.url.host).toSet(), {'boardgamegeek.com'});
    expect(requests.every((request) => request.headers['Authorization'] == 'Bearer secret-token'), isTrue);
    expect(requests.last.url.queryParameters['id'], '13,926');
    expect(matches.map((match) => match.titles.byLanguage['en']), ['CATAN', 'CATAN: Seafarers']);
    final catan = matches.first;
    expect(catan.creator, 'Klaus Teuber');
    expect(catan.publisher, 'KOSMOS');
    expect(catan.year, 1995);
    expect(catan.imageUrl, 'https://cf.geekdo-images.com/catan.jpg');
    expect(catan.suggestedType, CategoryType.boardGames);
  });
}
