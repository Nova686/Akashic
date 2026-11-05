import 'package:akashic/layers/functional/Activity/domain/entities/activity_event.dart';
import 'package:akashic/layers/functional/Activity/domain/gateways/activity_log.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/series_completion.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/functional/Stats/domain/entities/recap.dart';
import 'package:akashic/layers/functional/Stats/domain/gateways/value_history_store.dart';

class ComputeRecap {
  ComputeRecap(this._collection, this._activityLog, this._valueHistory);

  static const String mainCurrency = 'EUR';
  static const int mostValuedShown = 3;

  final CollectionGateway _collection;
  final ActivityLog _activityLog;
  final ValueHistoryStore _valueHistory;

  Future<Recap> month(DateTime month) => _between(DateTime(month.year, month.month), DateTime(month.year, month.month + 1), withValue: false);

  Future<Recap> year(int year) => _between(DateTime(year), DateTime(year + 1), withValue: true);

  bool _within(DateTime? moment, DateTime from, DateTime to) => moment != null && !moment.isBefore(from) && moment.isBefore(to);

  Future<Recap> _between(DateTime from, DateTime to, {required bool withValue}) async {
    final items = await _collection.allItems();
    final copies = await _collection.firstCopiesByItem();
    final added = [for (final item in items) if (_within(item.addedAt, from, to)) item];
    var spent = 0;
    for (final item in items) {
      final copy = copies[item.id];
      final paid = copy?.pricePaidCents;
      if (paid == null) {
        continue;
      }
      if (_within(copy?.purchasedOn ?? item.addedAt, from, to)) {
        spent += paid;
      }
    }
    final finished = {
      for (final event in await _activityLog.between(from, to))
        if (event.kind == ActivityKind.finished) event.itemId ?? event.title,
    };
    final owned = await _collection.ownedVolumesBySeries();
    final latestVolumeAt = <String, DateTime>{};
    for (final item in items) {
      if ((item.seriesId, item.addedAt) case (final seriesId?, final addedAt?)) {
        if (latestVolumeAt[seriesId] == null || addedAt.isAfter(latestVolumeAt[seriesId]!)) {
          latestVolumeAt[seriesId] = addedAt;
        }
      }
    }
    final completed = [
      for (final series in await _collection.watchAllSeries().first)
        if (series.publishedVolumes != null && _within(latestVolumeAt[series.id], from, to))
          if (computeSeriesCompletion(series, owned[series.id] ?? const {}) case final completion when completion.missing.isEmpty && completion.owned.isNotEmpty)
            resolveDisplayTitle(series.titles, PreferredLanguages.defaults) ?? '',
    ];
    final valued = [
      for (final item in added)
        if (item.marketValue?.currency == mainCurrency) item,
    ]..sort((first, second) => second.marketValue!.cents.compareTo(first.marketValue!.cents));
    int? valueChange;
    DateTime? busiest;
    if (withValue) {
      final snapshots = [for (final snapshot in await _valueHistory.snapshots()) if (_within(snapshot.month, from, to)) snapshot]..sort((first, second) => first.month.compareTo(second.month));
      if (snapshots.length >= 2) {
        valueChange = (snapshots.last.totals[mainCurrency] ?? 0) - (snapshots.first.totals[mainCurrency] ?? 0);
      }
      final perMonth = <DateTime, int>{};
      for (final item in added) {
        final month = DateTime(item.addedAt!.year, item.addedAt!.month);
        perMonth[month] = (perMonth[month] ?? 0) + 1;
      }
      busiest = perMonth.entries.fold<MapEntry<DateTime, int>?>(null, (best, entry) => best == null || entry.value > best.value ? entry : best)?.key;
    }
    return Recap(
      from: from,
      to: to,
      addedCount: added.length,
      spentCents: spent,
      finishedCount: finished.length,
      completedSeries: completed,
      mostValued: valued.take(withValue ? mostValuedShown : 1).toList(),
      valueChangeCents: valueChange,
      busiestMonth: busiest,
    );
  }
}

