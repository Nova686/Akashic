import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_copy.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/localized_titles.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/series.dart';
import 'package:akashic/layers/functional/Stats/data/gateways/drift_stats_gateway.dart';
import 'package:akashic/layers/functional/Stats/domain/entities/collection_stats.dart';
import 'package:akashic/layers/functional/Stats/domain/use_cases/compute_collection_stats.dart';
import 'package:akashic/layers/functional/Stats/presentation/cubit/stats_cubit.dart';
import 'package:akashic/layers/functional/Stats/presentation/cubit/collection_value_cubit.dart';
import 'package:akashic/layers/functional/Stats/presentation/cubit/collection_value_state.dart';
import 'package:akashic/layers/functional/Stats/domain/entities/collection_value.dart';
import 'package:akashic/layers/functional/Stats/presentation/views/stats_view.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:drift/drift.dart' show Value;
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../Collection/collection_harness.dart';

class MockStatsCubit extends MockCubit<CollectionStats?> implements StatsCubit {}

class MockCollectionValueCubit extends MockCubit<CollectionValueState> implements CollectionValueCubit {}

void main() {
  late CollectionHarness harness;
  late ComputeCollectionStats computeStats;

  setUp(() async {
    harness = CollectionHarness();
    computeStats = ComputeCollectionStats(DriftStatsGateway(harness.database), harness.categories, now: () => DateTime(2026, 10, 27));
    final vinyls = await harness.vinyls();
    final jazz = await harness.createCategory(name: 'Jazz', colorValue: 0xFF7FA8FF, type: CategoryType.music, conditionParts: const ['Disque'], parentId: vinyls.id);
    await harness.mangas();
    await harness.collection.saveItem(CollectionItem(id: 'kob', categoryId: jazz.id, titles: const LocalizedTitles(byLanguage: {'en': 'Kind of Blue'})));
    await harness.collection.saveCopy(const ItemCopy(id: 'first', itemId: 'kob', pricePaidCents: 2500));
    await harness.collection.saveCopy(const ItemCopy(id: 'second', itemId: 'kob', pricePaidCents: 1250));
    await harness.collection.saveCopy(const ItemCopy(id: 'free', itemId: 'kob'));
    await (harness.database.update(harness.database.copies)..where((table) => table.id.equals('first'))).write(CopiesCompanion(createdAt: Value(DateTime(2026, 9, 3))));
    await (harness.database.update(harness.database.copies)..where((table) => table.id.equals('second'))).write(CopiesCompanion(createdAt: Value(DateTime(2026, 10, 2))));
    await (harness.database.update(harness.database.copies)..where((table) => table.id.equals('free'))).write(CopiesCompanion(createdAt: Value(DateTime(2024, 1, 1))));
  });

  tearDown(() => harness.database.close());

  test('the total paid sums every copy and subcategories count for their parent', () async {
    final stats = await computeStats().first;
    expect(stats.totalPaidCents, 3750);
    expect(stats.itemCount, 1);
    expect(stats.copyCount, 3);
    final vinyls = stats.categories.firstWhere((category) => category.category.name == 'Vinyles');
    expect(vinyls.itemCount, 1);
    expect(vinyls.copyCount, 3);
    expect(stats.categories.firstWhere((category) => category.category.name == 'Mangas').itemCount, 0);
  });

  test('purchases are counted by copy month over the last twelve months', () async {
    final stats = await computeStats().first;
    expect(stats.months, hasLength(12));
    expect(stats.months.first.month, DateTime(2025, 11));
    expect(stats.months.last, MonthlyPurchases(month: DateTime(2026, 10), copyCount: 1, paidCents: 1250));
    expect(stats.months[10], MonthlyPurchases(month: DateTime(2026, 9), copyCount: 1, paidCents: 2500));
    expect(stats.months.fold(0, (total, month) => total + month.copyCount), 2);
  });

  test('additions are counted per year since the oldest copy and series are split by completeness', () async {
    final mangas = (await harness.categories.watchTree().first).firstWhere((node) => node.category.name == 'Mangas').category;
    await harness.collection.saveSeries(Series(id: 'frieren', categoryId: mangas.id, titles: const LocalizedTitles(byLanguage: {'fr': 'Frieren'}), publishedVolumes: 2));
    await harness.collection.saveSeries(Series(id: 'dandadan', categoryId: mangas.id, titles: const LocalizedTitles(byLanguage: {'fr': 'Dandadan'}), publishedVolumes: 3));
    for (final (id, seriesId, volume) in [('f1', 'frieren', 1), ('f2', 'frieren', 2), ('d1', 'dandadan', 1)]) {
      await harness.collection.saveItem(CollectionItem(id: id, categoryId: mangas.id, seriesId: seriesId, volumeNumber: volume, titles: const LocalizedTitles(byLanguage: {'fr': 'Tome'})));
    }
    final stats = await ComputeCollectionStats(DriftStatsGateway(harness.database), harness.categories, collection: harness.collection, now: () => DateTime(2026, 10, 27)).call().first;
    expect(stats.years, const [YearlyAdditions(year: 2024, copyCount: 1), YearlyAdditions(year: 2025, copyCount: 0), YearlyAdditions(year: 2026, copyCount: 2)]);
    expect(stats.series, const SeriesShare(complete: 1, incomplete: 1));
  });

  testWidgets('the statistics screen shows the total in euros and the estimated value', (tester) async {
    final cubit = MockStatsCubit();
    final valueCubit = MockCollectionValueCubit();
    const vinyls = Category(id: 'v', name: 'Vinyles', colorValue: 0xFF7FA8FF, type: CategoryType.music, conditionParts: [], position: 0);
    when(() => valueCubit.state).thenReturn(CollectionValueState(
      value: const CollectionValue(
        totalByCurrency: {'EUR': 4200},
        categories: [CategoryValue(category: vinyls, byCurrency: {'EUR': 4200})],
        marketValuedItems: 1,
        purchaseValuedItems: 0,
        unvaluedItems: 0,
      ),
      duplicates: const Duplicates(sameWork: [[CollectionItem(id: 'kob', categoryId: 'v', titles: LocalizedTitles(byLanguage: {'en': 'Kind of Blue'})), CollectionItem(id: 'kob-again', categoryId: 'v', titles: LocalizedTitles(byLanguage: {'en': 'Kind of Blue'}))]]),
    ));
    when(() => cubit.state).thenReturn(CollectionStats(
      totalPaidCents: 3750,
      itemCount: 1,
      copyCount: 3,
      categories: const [CategoryStat(category: Category(id: 'v', name: 'Vinyles', colorValue: 0xFF7FA8FF, type: CategoryType.music, conditionParts: [], position: 0), itemCount: 1, copyCount: 3, paidCents: 3750)],
      months: [for (var month = 1; month <= 12; month++) MonthlyPurchases(month: DateTime(2026, month), copyCount: month == 10 ? 2 : 0, paidCents: 0)],
      years: const [YearlyAdditions(year: 2025, copyCount: 1), YearlyAdditions(year: 2026, copyCount: 2)],
      series: const SeriesShare(complete: 1, incomplete: 2),
    ));
    await tester.pumpWidget(MaterialApp(
      locale: const Locale('fr'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MultiBlocProvider(
        providers: [BlocProvider<StatsCubit>.value(value: cubit), BlocProvider<CollectionValueCubit>.value(value: valueCubit)],
        child: const StatsView(),
      ),
    ));
    expect(find.textContaining('37,50'), findsWidgets);
    expect(find.text('1 objet'), findsOneWidget);
    expect(find.text('Vinyles'), findsWidgets);
    expect(find.text('Valeur estimée'), findsOneWidget);
    expect(find.textContaining('42,00'), findsWidgets);
    expect(find.text('Doublons (1)'), findsOneWidget);
    expect(find.text('Mettre à jour les cotes'), findsOneWidget);
    await tester.scrollUntilVisible(find.bySemanticsLabel('Vinyles 100 %'), 300);
    await tester.scrollUntilVisible(find.bySemanticsLabel('1 sur 3 séries complètes'), 300);
    expect(find.bySemanticsLabel('2025 : 1 ajouts, 2026 : 2 ajouts'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  test('chart colours differ from one category to the next', () {
    expect({for (var index = 0; index < 7; index++) AkashicColors.chartColor(index)}, hasLength(7));
    expect(AkashicColors.chartColor(7), AkashicColors.chartColor(0));
  });
}

