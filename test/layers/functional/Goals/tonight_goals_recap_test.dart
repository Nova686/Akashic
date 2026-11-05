import 'dart:math';

import 'package:akashic/layers/functional/Activity/data/gateways/drift_activity_log.dart';
import 'package:akashic/layers/functional/Activity/domain/entities/activity_event.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_progress.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/market_value.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/pick_tonight.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/set_item_progress.dart';
import 'package:akashic/layers/functional/Goals/data/gateways/drift_goal_store.dart';
import 'package:akashic/layers/functional/Goals/domain/entities/goal.dart';
import 'package:akashic/layers/functional/Goals/domain/use_cases/compute_goal_progress.dart';
import 'package:akashic/layers/functional/Goals/presentation/widgets/goal_rings.dart';
import 'package:akashic/layers/functional/Stats/data/gateways/drift_value_history_store.dart';
import 'package:akashic/layers/functional/Stats/domain/entities/recap.dart';
import 'package:akashic/layers/functional/Stats/domain/use_cases/compute_recap.dart';
import 'package:akashic/layers/functional/Stats/presentation/views/recap_view.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../Collection/collection_harness.dart';

Widget localized(Widget child) => MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );

void main() {
  late CollectionHarness harness;
  late DriftActivityLog log;
  late Category mangas;
  late Category vinyls;

  CollectionItem item(String id, Category category, String title, {String? seriesId, int? volume}) =>
      CollectionItem(id: id, categoryId: category.id, seriesId: seriesId, volumeNumber: volume, titles: LocalizedTitles(byLanguage: {'fr': title}));

  setUp(() async {
    harness = CollectionHarness();
    log = DriftActivityLog(harness.database);
    mangas = await harness.mangas();
    vinyls = await harness.vinyls();
  });
  tearDown(() => harness.database.close());

  test('only what waits to be started is drawn, by activity and length, without repeating at once', () {
    final candidates = [
      for (final (index, activity) in [TonightActivity.read, TonightActivity.read, TonightActivity.listen].indexed)
        TonightCandidate(item: CollectionItem(id: 'c$index', categoryId: 'x', titles: const LocalizedTitles(byLanguage: {})), category: mangas, activity: activity, length: TonightLength.short),
    ];
    final pick = PickTonight(random: Random(1));
    final first = pick(candidates, activity: TonightActivity.read)!;
    final second = pick(candidates, activity: TonightActivity.read)!;
    expect({first.item.id, second.item.id}, {'c0', 'c1'});
    expect(pick(candidates, activity: TonightActivity.listen)!.item.id, 'c2');
    expect(pick(candidates, activity: TonightActivity.play), isNull);
    expect(pick(candidates, length: TonightLength.long), isNull);
    expect(isWaitingToStart(const CollectionItem(id: 'a', categoryId: 'x', titles: LocalizedTitles(byLanguage: {}), progress: ItemProgress(status: ProgressStatus.inProgress))), isFalse);
    expect(lengthOf(const CollectionItem(id: 'a', categoryId: 'x', titles: LocalizedTitles(byLanguage: {})), CategoryType.manga, null), TonightLength.short);
  });

  test('starting and finishing are written to the journal once, and count toward a goal of the right category', () async {
    await harness.collection.saveItem(item('f1', mangas, 'Frieren'));
    await harness.collection.saveItem(item('kob', vinyls, 'Kind of Blue'));
    final setProgress = SetItemProgress(harness.collection, activityLog: log);
    await setProgress('f1', const ItemProgress(status: ProgressStatus.inProgress));
    await setProgress('f1', const ItemProgress(status: ProgressStatus.inProgress, chapter: '3'));
    await setProgress('f1', const ItemProgress(status: ProgressStatus.finished));
    await setProgress('kob', const ItemProgress(status: ProgressStatus.finished));
    final year = DateTime.now().year;
    final events = await log.between(DateTime(year), DateTime(year + 1));
    expect(events.map((event) => (event.kind, event.title)), [
      (ActivityKind.started, 'Frieren'),
      (ActivityKind.finished, 'Frieren'),
      (ActivityKind.finished, 'Kind of Blue'),
    ]);
    final compute = ComputeGoalProgress(harness.collection, harness.categories, log, now: () => DateTime(year, 7, 2));
    final progress = await compute([
      Goal(id: 'g1', year: year, measure: GoalMeasure.finished, target: 4, categoryId: mangas.id),
      Goal(id: 'g2', year: year, measure: GoalMeasure.added, target: 2),
    ]);
    expect(progress.map((goal) => (goal.done, goal.categoryName)), [(1, 'Mangas'), (2, null)]);
    expect(progress.first.expectedToday, 2);
    expect(progress.first.gap, -1);
    expect(progress.last.isReached, isTrue);
  });

  test('goals are stored per year', () async {
    final store = DriftGoalStore(harness.database);
    await store.save(const Goal(id: 'g', year: 2026, measure: GoalMeasure.finished, target: 30));
    await store.save(const Goal(id: 'h', year: 2027, measure: GoalMeasure.added, target: 10));
    expect((await store.watchYear(2026).first).map((goal) => goal.id), ['g']);
    await store.delete('g');
    expect(await store.watchYear(2026).first, isEmpty);
  });

  test('the monthly recap counts additions, spending, finished items and completed series', () async {
    final now = DateTime.now();
    await harness.collection.saveSeries(Series(id: 'dan', categoryId: mangas.id, titles: const LocalizedTitles(byLanguage: {'fr': 'Dandadan'}), publishedVolumes: 2));
    await harness.collection.saveItem(item('d1', mangas, 'Dandadan', seriesId: 'dan', volume: 1));
    await harness.collection.saveItem(item('d2', mangas, 'Dandadan', seriesId: 'dan', volume: 2));
    await harness.collection.saveCopy(ItemCopy(id: 'c1', itemId: 'd1', pricePaidCents: 720, purchasedOn: now));
    await harness.collection.saveMarketValue('d2', MarketValue(cents: 1500, currency: 'EUR', valuedAt: now));
    await SetItemProgress(harness.collection, activityLog: log)('d1', const ItemProgress(status: ProgressStatus.finished));
    final recap = await ComputeRecap(harness.collection, log, DriftValueHistoryStore(harness.database)).month(now);
    expect((recap.addedCount, recap.spentCents, recap.finishedCount), (2, 720, 1));
    expect(recap.completedSeries, ['Dandadan']);
    expect(recap.mostValued.single.id, 'd2');
  });

  testWidgets('a goal ring says its progress and its pace', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(localized(GoalRing(
      progress: const GoalProgress(goal: Goal(id: 'g', year: 2026, measure: GoalMeasure.finished, target: 30), done: 22, yearElapsed: 0.84),
      onTap: () {},
    )));
    expect(find.bySemanticsLabel('Finir 30 · toute la collection, 22 / 30, 3 de retard'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('the year poster shows its tiles and its most valued items', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final recap = Recap(
      from: DateTime(2026),
      to: DateTime(2027),
      addedCount: 128,
      spentCents: 184000,
      finishedCount: 31,
      completedSeries: const ['Dandadan'],
      mostValued: [CollectionItem(id: 'kob', categoryId: 'v', titles: const LocalizedTitles(byLanguage: {'fr': 'Kind of Blue'}), marketValue: MarketValue(cents: 6500, currency: 'EUR', valuedAt: DateTime(2026)))],
      valueChangeCents: 21000,
      busiestMonth: DateTime(2026, 3),
    );
    await tester.pumpWidget(localized(YearPoster(year: 2026, recap: recap)));
    expect(find.text('2026'), findsOneWidget);
    expect(find.text('128'), findsOneWidget);
    expect(find.text('Mars'), findsOneWidget);
    expect(find.textContaining('Kind of Blue'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
