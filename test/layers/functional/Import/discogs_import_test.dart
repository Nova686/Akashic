import 'dart:convert';

import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Check/domain/use_cases/add_from_match.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Import/domain/use_cases/import_discogs_collection.dart';
import 'package:akashic/layers/functional/Lookup/data/sources/discogs_collection_source.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_match.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mocktail/mocktail.dart';

import '../Collection/collection_harness.dart';

http.Response jsonResponse(Object body) => http.Response.bytes(utf8.encode(jsonEncode(body)), 200, headers: {'content-type': 'application/json; charset=utf-8'});

Map<String, Object?> releaseOf(int releaseId, String title, {int masterId = 0}) => {
      'id': releaseId,
      'basic_information': {
        'id': releaseId,
        'master_id': masterId,
        'title': title,
        'year': 1959,
        'artists': [
          {'name': 'Miles Davis (2)'},
        ],
        'formats': [
          {'name': 'Vinyl', 'descriptions': ['LP', 'Album']},
        ],
        'labels': [
          {'name': 'Columbia'},
        ],
        'cover_image': 'https://i.discogs.com/$releaseId.jpg',
      },
    };

class MockAddFromMatch extends Mock implements AddFromMatch {}

class FixedCatalogue implements OwnedReleaseCatalogue {
  FixedCatalogue(this.releases);

  final List<SourceMatch> releases;

  @override
  bool get isConfigured => true;

  @override
  Future<List<SourceMatch>> ownedReleases({void Function(int loaded, int total)? onProgress}) async => releases;
}

SourceMatch record(String workId) => SourceMatch(sourceKey: 'discogs', externalWorkId: workId, titles: LocalizedTitles(byLanguage: {'en': workId}), suggestedType: CategoryType.music);

void main() {
  test('the discogs collection is read page after page as matches', () async {
    final requests = <Uri>[];
    final source = DiscogsCollectionSource(
      MockClient((request) async {
        requests.add(request.url);
        if (request.url.path == '/oauth/identity') {
          return jsonResponse({'username': 'nova686'});
        }
        final page = request.url.queryParameters['page'];
        return jsonResponse({
          'pagination': {'page': int.parse(page!), 'pages': 2, 'items': 2},
          'releases': [page == '1' ? releaseOf(1, 'Kind of Blue', masterId: 5460) : releaseOf(2, 'Bitches Brew')],
        });
      }),
      token: 'token',
    );
    final releases = await source.ownedReleases();
    expect(requests.skip(1).map((uri) => uri.path).toSet(), {'/users/nova686/collection/folders/0/releases'});
    expect(releases.map((release) => release.externalWorkId), ['master:5460', 'release:2']);
    final kindOfBlue = releases.first;
    expect(kindOfBlue.creator, 'Miles Davis');
    expect(kindOfBlue.format, 'Vinyl, LP, Album');
    expect(kindOfBlue.publisher, 'Columbia');
    expect(kindOfBlue.year, 1959);
  });

  test('importing skips owned records and counts additions and failures', () async {
    final harness = CollectionHarness();
    final vinyls = await harness.vinyls();
    await harness.collection.saveItem(CollectionItem(id: 'owned', categoryId: vinyls.id, titles: const LocalizedTitles(byLanguage: {'en': 'Owned'}), sourceKey: 'discogs', externalWorkId: 'master:1'));
    final addFromMatch = MockAddFromMatch();
    registerFallbackValue(record('fallback'));
    when(() => addFromMatch(any(), categoryId: any(named: 'categoryId'))).thenAnswer((invocation) async {
      final match = invocation.positionalArguments.first as SourceMatch;
      if (match.externalWorkId == 'master:3') {
        throw const FormatException('cover');
      }
      return CollectionItem(id: match.externalWorkId, categoryId: vinyls.id, titles: match.titles);
    });
    final progress = <int>[];
    final outcome = await ImportDiscogsCollection(FixedCatalogue([record('master:1'), record('master:2'), record('master:3')]), harness.collection, addFromMatch)(
      categoryId: vinyls.id,
      onProgress: (done, total) => progress.add(done),
    );
    expect(outcome, const DiscogsImportOutcome(added: 1, alreadyOwned: 1, failed: 1));
    expect(progress, [1, 2, 3]);
    await harness.database.close();
  });
}
