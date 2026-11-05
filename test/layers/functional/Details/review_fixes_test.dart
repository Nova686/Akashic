import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/add_series_volumes.dart';
import 'package:akashic/layers/functional/Details/data/gateways/drift_details_store.dart';
import 'package:akashic/layers/functional/Details/data/sources/anilist_details_source.dart';
import 'package:akashic/layers/functional/Details/domain/entities/item_details.dart';
import 'package:akashic/layers/functional/Details/domain/gateways/details_source.dart';
import 'package:akashic/layers/functional/Details/domain/use_cases/fetch_item_details.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;

import '../Collection/collection_harness.dart';

class SwitchableDetailsSource implements DetailsSource {
  SwitchableDetailsSource(this.sections);

  final List<DetailSection> sections;
  bool isDown = false;

  @override
  bool supports(CollectionItem item) => true;

  @override
  Future<List<DetailSection>> fetch(CollectionItem item, {required String languageCode, String? editionId}) async {
    if (isDown) {
      throw const SourceUnavailable('switchable');
    }
    return sections;
  }
}

void main() {
  test('only items a catalogue knows can ask for online details', () async {
    final harness = CollectionHarness();
    final fetch = FetchItemDetails([AniListDetailsSource(MockClient((request) async => http.Response('{}', 200)))], DriftDetailsStore(harness.database));
    const fromAniList = CollectionItem(id: 'frieren', categoryId: 'mangas', titles: LocalizedTitles(byLanguage: {'fr': 'Frieren'}), sourceKey: 'anilist', externalWorkId: '118586');
    const typedByHand = CollectionItem(id: 'fanzine', categoryId: 'mangas', titles: LocalizedTitles(byLanguage: {'fr': 'Fanzine'}));
    const fromBnf = CollectionItem(id: 'bnf-book', categoryId: 'mangas', titles: LocalizedTitles(byLanguage: {'fr': 'Livre'}), sourceKey: 'bnf', externalWorkId: 'ark:/12148/cb1');
    expect(fetch.canDescribe(fromAniList), isTrue);
    expect(fetch.canDescribe(typedByHand), isFalse);
    expect(fetch.canDescribe(fromBnf), isFalse);
    await harness.database.close();
  });

  test('a partial refresh keeps the previous details instead of losing a section', () async {
    final harness = CollectionHarness();
    final vinyls = await harness.vinyls();
    final item = CollectionItem(id: 'kob', categoryId: vinyls.id, titles: const LocalizedTitles(byLanguage: {'en': 'Kind of Blue'}));
    await harness.collection.saveItem(item);
    final tracks = SwitchableDetailsSource([const TrackListSection(tracks: [DetailTrack(position: '1', title: 'So What')], sourceLabel: 'MusicBrainz')]);
    final summary = SwitchableDetailsSource([const TextSection(kind: TextKind.summary, text: 'A jazz album.', sourceLabel: 'Wikipedia')]);
    final fetch = FetchItemDetails([tracks, summary], DriftDetailsStore(harness.database));
    await fetch.refresh(item, languageCode: 'fr');
    summary.isDown = true;
    await expectLater(fetch.refresh(item, languageCode: 'fr'), throwsA(isA<DetailsUnavailable>()));
    expect((await fetch.cached('kob'))!.sections, hasLength(2));
    await harness.database.close();
  });

  test('manga volumes carry the series source so AniList details apply to them', () async {
    final harness = CollectionHarness();
    final mangas = await harness.mangas();
    final series = Series(id: 'frieren', categoryId: mangas.id, titles: const LocalizedTitles(byLanguage: {'en': 'Frieren'}), sourceKey: 'anilist', externalWorkId: '118586');
    await harness.collection.saveSeries(series);
    await AddSeriesVolumes(harness.collection, newId: harness.newId)(
      series: series,
      from: 1,
      to: 1,
      template: CollectionItem(id: 'template', categoryId: mangas.id, titles: series.titles, seriesId: series.id),
    );
    final volume = (await harness.collection.allItems()).single;
    expect(volume.sourceKey, 'anilist');
    expect(volume.externalWorkId, '118586');
    expect(AniListDetailsSource(MockClient((request) async => http.Response('{}', 200))).supports(volume), isTrue);
    await harness.database.close();
  });
}
