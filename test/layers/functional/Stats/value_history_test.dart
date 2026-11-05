import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/market_value.dart';
import 'package:akashic/layers/functional/Stats/data/gateways/drift_value_history_store.dart';
import 'package:akashic/layers/functional/Stats/domain/entities/collection_value.dart';
import 'package:akashic/layers/functional/Stats/domain/entities/value_history.dart';
import 'package:akashic/layers/functional/Stats/domain/use_cases/value_history.dart';
import 'package:akashic/layers/functional/Stats/presentation/widgets/value_trend_section.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../Collection/collection_harness.dart';

void main() {
  late CollectionHarness harness;
  late DriftValueHistoryStore store;
  late String categoryId;
  var now = DateTime(2026, 9, 14);
  var total = 10000;

  Future<void> saveValued(String id, String title, int cents) async {
    await harness.collection.saveItem(CollectionItem(id: id, categoryId: categoryId, titles: LocalizedTitles(byLanguage: {'fr': title})));
    await harness.collection.saveMarketValue(id, MarketValue(cents: cents, currency: 'EUR', valuedAt: now));
  }

  RecordMonthlyValue recorder() => RecordMonthlyValue(
        () async => CollectionValue(totalByCurrency: {'EUR': total}, categories: const [], marketValuedItems: 0, purchaseValuedItems: 0, unvaluedItems: 0),
        harness.collection,
        store,
        now: () => now,
      );

  setUp(() async {
    harness = CollectionHarness();
    store = DriftValueHistoryStore(harness.database);
    categoryId = (await harness.vinyls()).id;
    now = DateTime(2026, 9, 14);
    total = 10000;
  });
  tearDown(() => harness.database.close());

  test('the collection value is recorded once per month', () async {
    await saveValued('kob', 'Kind of Blue', 3000);
    expect(await recorder()(), isTrue);
    total = 12000;
    expect(await recorder()(), isFalse);
    now = DateTime(2026, 10, 2);
    expect(await recorder()(), isTrue);
    final snapshots = await store.snapshots();
    expect(snapshots.map((snapshot) => snapshot.month), [DateTime(2026, 9), DateTime(2026, 10)]);
    expect(snapshots.map((snapshot) => snapshot.totals['EUR']), [10000, 12000]);
    expect(await store.itemValuesAt(DateTime(2026, 9)), {'kob': (3000, 'EUR')});
  });

  test('the trend keeps the chosen period and ranks what moved since its start', () async {
    await saveValued('kob', 'Kind of Blue', 3000);
    await saveValued('train', 'Blue Train', 5000);
    await saveValued('moanin', 'Moanin', 2000);
    now = DateTime(2025, 6, 1);
    await recorder()();
    now = DateTime(2026, 9, 1);
    await recorder()();
    await harness.collection.saveMarketValue('kob', MarketValue(cents: 4500, currency: 'EUR', valuedAt: now));
    await harness.collection.saveMarketValue('train', MarketValue(cents: 4000, currency: 'EUR', valuedAt: now));
    now = DateTime(2026, 10, 1);
    final trend = ComputeValueTrend(harness.collection, store, now: () => now);
    final lastSixMonths = await trend(months: 6);
    expect(lastSixMonths.points.map((point) => point.month), [DateTime(2026, 9)]);
    final everything = await trend();
    expect(everything.points, hasLength(2));
    expect(everything.risers.map((change) => (change.item.id, change.deltaCents)), [('kob', 1500)]);
    expect(everything.fallers.map((change) => (change.item.id, change.deltaCents)), [('train', -1000)]);
    expect(everything.risers.single.ratio, closeTo(0.5, 0.001));
  });

  testWidgets('the section waits for a second month before drawing the curve', (tester) async {
    Future<Widget> section(List<ValueSnapshot> points) async => MaterialApp(
          locale: const Locale('fr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: SingleChildScrollView(child: ValueTrendSection(key: ValueKey(points.length), loadTrend: ({int? months}) async => ValueTrend(points: points, risers: const [], fallers: const [], currency: 'EUR')))),
        );
    await tester.pumpWidget(await section([ValueSnapshot(month: DateTime(2026, 10), totals: const {'EUR': 10000})]));
    await tester.pumpAndSettle();
    expect(find.textContaining('La courbe se remplit'), findsOneWidget);
    await tester.pumpWidget(await section([
      ValueSnapshot(month: DateTime(2026, 9), totals: const {'EUR': 10000}),
      ValueSnapshot(month: DateTime(2026, 10), totals: const {'EUR': 12000}),
    ]));
    await tester.pumpAndSettle();
    expect(find.textContaining('La courbe se remplit'), findsNothing);
    expect(find.textContaining('Octobre 2026'), findsOneWidget);
  });
}
