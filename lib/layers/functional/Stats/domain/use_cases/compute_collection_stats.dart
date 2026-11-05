import 'package:akashic/layers/functional/Catalog/domain/entities/category.dart';
import 'package:akashic/layers/functional/Catalog/domain/gateways/category_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/series_completion.dart';
import 'package:akashic/layers/functional/Stats/domain/entities/collection_stats.dart';
import 'package:akashic/layers/functional/Stats/domain/gateways/stats_gateway.dart';

class ComputeCollectionStats {
  ComputeCollectionStats(this._stats, this._categories, {this._collection, DateTime Function()? now}) : _now = now ?? DateTime.now;

  static const int monthsShown = 12;

  final StatsGateway _stats;
  final CategoryGateway _categories;
  final CollectionGateway? _collection;
  final DateTime Function() _now;

  Stream<CollectionStats> call() => _stats.watchFacts().asyncMap((facts) async => statsOf(facts.$1, facts.$2, await _categories.watchTree().first, series: await _seriesShare()));

  Future<SeriesShare> _seriesShare() async {
    final collection = _collection;
    if (collection == null) {
      return SeriesShare.none;
    }
    final ownedBySeries = await collection.ownedVolumesBySeries();
    var complete = 0;
    var incomplete = 0;
    for (final series in await collection.watchAllSeries().first) {
      if (computeSeriesCompletion(series, ownedBySeries[series.id] ?? const {}).isComplete) {
        complete++;
      } else {
        incomplete++;
      }
    }
    return SeriesShare(complete: complete, incomplete: incomplete);
  }

  CollectionStats statsOf(List<CopyFact> copies, Map<String, String> categoryOfItem, List<CategoryNode> tree, {SeriesShare series = SeriesShare.none}) {
    final topLevelOf = <String, Category>{
      for (final node in tree) ...{
        node.category.id: node.category,
        for (final child in node.children) child.id: node.category,
      },
    };
    final today = _now();
    final firstMonth = DateTime(today.year, today.month - monthsShown + 1);
    final months = [for (var offset = 0; offset < monthsShown; offset++) DateTime(firstMonth.year, firstMonth.month + offset)];
    final copiesByMonth = {for (final month in months) month: <CopyFact>[]};
    for (final copy in copies) {
      copiesByMonth[DateTime(copy.addedAt.year, copy.addedAt.month)]?.add(copy);
    }
    final copiesByYear = <int, int>{};
    for (final copy in copies) {
      copiesByYear[copy.addedAt.year] = (copiesByYear[copy.addedAt.year] ?? 0) + 1;
    }
    final firstYear = copiesByYear.keys.fold(today.year, (earliest, year) => year < earliest ? year : earliest);
    int paidOf(Iterable<CopyFact> facts) => facts.fold(0, (total, copy) => total + (copy.pricePaidCents ?? 0));
    return CollectionStats(
      totalPaidCents: paidOf(copies),
      itemCount: categoryOfItem.length,
      copyCount: copies.length,
      categories: [
        for (final node in tree)
          CategoryStat(
            category: node.category,
            itemCount: categoryOfItem.values.where((categoryId) => topLevelOf[categoryId]?.id == node.category.id).length,
            copyCount: copies.where((copy) => topLevelOf[copy.categoryId]?.id == node.category.id).length,
            paidCents: paidOf(copies.where((copy) => topLevelOf[copy.categoryId]?.id == node.category.id)),
          ),
      ],
      months: [for (final month in months) MonthlyPurchases(month: month, copyCount: copiesByMonth[month]!.length, paidCents: paidOf(copiesByMonth[month]!))],
      years: [for (var year = firstYear; year <= today.year; year++) YearlyAdditions(year: year, copyCount: copiesByYear[year] ?? 0)],
      series: series,
    );
  }
}
