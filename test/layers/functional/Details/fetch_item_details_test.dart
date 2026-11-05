import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Details/data/gateways/drift_details_store.dart';
import 'package:akashic/layers/functional/Details/domain/entities/item_details.dart';
import 'package:akashic/layers/functional/Details/domain/gateways/details_source.dart';
import 'package:akashic/layers/functional/Details/domain/use_cases/fetch_item_details.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:flutter_test/flutter_test.dart';

import '../Collection/collection_harness.dart';

class FakeDetailsSource implements DetailsSource {
  FakeDetailsSource(this.sections, {this.isDown = false});

  List<DetailSection> sections;
  bool isDown;

  @override
  bool supports(CollectionItem item) => true;

  @override
  Future<List<DetailSection>> fetch(CollectionItem item, {required String languageCode, String? editionId}) async {
    if (isDown) {
      throw const SourceUnavailable('fake');
    }
    return sections;
  }
}

void main() {
  late CollectionHarness harness;
  late CollectionItem item;

  setUp(() async {
    harness = CollectionHarness();
    final vinyls = await harness.vinyls();
    item = CollectionItem(id: 'kob', categoryId: vinyls.id, titles: const LocalizedTitles(byLanguage: {'en': 'Kind of Blue'}));
    await harness.collection.saveItem(item);
  });
  tearDown(() => harness.database.close());

  test('partial details only keep non-empty sections', () async {
    final fetch = FetchItemDetails([
      FakeDetailsSource([const TextSection(kind: TextKind.summary, text: '  ', sourceLabel: 'Wikipedia'), const TagSection(tags: [])]),
      FakeDetailsSource([const TagSection(tags: ['jazz'])]),
    ], DriftDetailsStore(harness.database), now: () => DateTime(2026, 10, 26));
    final details = await fetch.refresh(item, languageCode: 'fr');
    expect(details.sections, [const TagSection(tags: ['jazz'])]);
    expect((await fetch.cached('kob'))?.fetchedAt, DateTime(2026, 10, 26));
  });

  test('a failed refresh keeps the previous details', () async {
    final source = FakeDetailsSource([const TagSection(tags: ['jazz'])]);
    final fetch = FetchItemDetails([source], DriftDetailsStore(harness.database));
    await fetch.refresh(item, languageCode: 'fr');
    source.isDown = true;
    await expectLater(fetch.refresh(item, languageCode: 'fr'), throwsA(isA<DetailsUnavailable>()));
    expect((await fetch.cached('kob'))?.sections, [const TagSection(tags: ['jazz'])]);
  });
}
