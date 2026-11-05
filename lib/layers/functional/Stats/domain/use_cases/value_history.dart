import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Stats/domain/entities/collection_value.dart';
import 'package:akashic/layers/functional/Stats/domain/entities/value_history.dart';
import 'package:akashic/layers/functional/Stats/domain/gateways/value_history_store.dart';

DateTime monthOf(DateTime date) => DateTime(date.year, date.month);

class RecordMonthlyValue {
  RecordMonthlyValue(this._computeValue, this._collection, this._store, {DateTime Function()? now}) : _now = now ?? DateTime.now;

  final Future<CollectionValue> Function() _computeValue;
  final CollectionGateway _collection;
  final ValueHistoryStore _store;
  final DateTime Function() _now;

  Future<bool> call() async {
    final month = monthOf(_now());
    if (await _store.hasSnapshot(month)) {
      return false;
    }
    final value = await _computeValue();
    await _store.save(ValueSnapshot(month: month, totals: value.totalByCurrency), {
      for (final item in await _collection.allItems())
        if (item.marketValue case final marketValue?) item.id: (marketValue.cents, marketValue.currency),
    });
    return true;
  }
}

class ComputeValueTrend {
  ComputeValueTrend(this._collection, this._store, {DateTime Function()? now}) : _now = now ?? DateTime.now;

  static const String mainCurrency = 'EUR';
  static const int moversShown = 3;

  final CollectionGateway _collection;
  final ValueHistoryStore _store;
  final DateTime Function() _now;

  Future<ValueTrend> call({int? months}) async {
    final current = monthOf(_now());
    final since = months == null ? null : DateTime(current.year, current.month - months + 1);
    final points = [for (final snapshot in await _store.snapshots()) if (since == null || !snapshot.month.isBefore(since)) snapshot]
      ..sort((first, second) => first.month.compareTo(second.month));
    final changes = <ItemValueChange>[];
    if (points.isNotEmpty) {
      final before = await _store.itemValuesAt(points.first.month);
      for (final item in await _collection.allItems()) {
        final now = item.marketValue;
        final then = before[item.id];
        if (now == null || then == null || then.$2 != now.currency || then.$1 == now.cents) {
          continue;
        }
        changes.add(ItemValueChange(item: item, fromCents: then.$1, toCents: now.cents, currency: now.currency));
      }
    }
    changes.sort((first, second) => second.deltaCents.compareTo(first.deltaCents));
    return ValueTrend(
      points: points,
      risers: [for (final change in changes) if (change.deltaCents > 0) change].take(moversShown).toList(),
      fallers: [for (final change in changes.reversed) if (change.deltaCents < 0) change].take(moversShown).toList(),
      currency: mainCurrency,
    );
  }
}
