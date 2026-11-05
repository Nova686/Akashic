import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Details/data/sources/igdb_details_source.dart';
import 'package:akashic/layers/functional/Details/data/sources/tmdb_details_source.dart';
import 'package:akashic/layers/functional/Details/domain/entities/item_details.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/igdb_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import '../Lookup/data/fixture_client.dart';

void main() {
  test('tmdb details give the synopsis, runtime and director', () async {
    const matrix = CollectionItem(id: 'm', categoryId: 'films', titles: LocalizedTitles(byLanguage: {'fr': 'Matrix'}), sourceKey: 'tmdb', externalWorkId: '603');
    final body = '{"id":603,"overview":"Thomas Anderson mène une double vie.","runtime":136,"credits":{"crew":[{"job":"Producer","name":"Joel Silver"},{"job":"Director","name":"Lana Wachowski"},{"job":"Director","name":"Lilly Wachowski"}]}}';
    final source = TmdbDetailsSource(clientReturning(body), apiKey: 'key');
    final sections = await source.fetch(matrix, languageCode: 'fr');
    expect(sections.whereType<TextSection>().single.text, 'Thomas Anderson mène une double vie.');
    expect(sections.whereType<FactsSection>().single.facts, [
      const DetailFact(kind: FactKind.director, value: 'Lana Wachowski, Lilly Wachowski'),
      const DetailFact(kind: FactKind.runtime, value: '2 h 16'),
    ]);
    expect(TmdbDetailsSource(clientReturning(body), apiKey: '').supports(matrix), isFalse);
  });

  test('igdb details give the summary and platforms', () async {
    const witcher = CollectionItem(id: 'w', categoryId: 'games', titles: LocalizedTitles(byLanguage: {'en': 'The Witcher 3'}), sourceKey: 'igdb', externalWorkId: '1942');
    final client = MockClient((request) async {
      if (request.url.host == 'id.twitch.tv') {
        return http.Response('{"access_token":"t","expires_in":3600}', 200);
      }
      return http.Response('[{"id":1942,"summary":"Geralt hunts monsters.","platforms":[{"name":"PC"},{"name":"PlayStation 4"}],"involved_companies":[{"company":{"name":"CD Projekt RED"}}]}]', 200);
    });
    final sections = await IgdbDetailsSource(IgdbSource(client, clientId: 'id', clientSecret: 'secret')).fetch(witcher, languageCode: 'fr');
    expect(sections.whereType<TextSection>().single.text, 'Geralt hunts monsters.');
    expect(sections.whereType<FactsSection>().single.facts, [
      const DetailFact(kind: FactKind.studio, value: 'CD Projekt RED'),
      const DetailFact(kind: FactKind.platforms, value: 'PC, PlayStation 4'),
    ]);
  });
}
