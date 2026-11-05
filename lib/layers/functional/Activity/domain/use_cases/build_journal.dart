import 'package:akashic/layers/functional/Activity/domain/entities/activity_event.dart';
import 'package:akashic/layers/functional/Activity/domain/gateways/activity_log.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/functional/Stats/domain/gateways/value_history_store.dart';
import 'package:akashic/layers/functional/Trades/domain/gateways/trade_gateway.dart';

class BuildJournal {
  BuildJournal(this._collection, this._activityLog, this._trades, this._valueHistory, {DateTime Function()? now}) : _now = now ?? DateTime.now;

  static const int monthsShown = 12;
  static const int entriesShown = 500;
  static const double notableValueChange = 0.15;
  static const int notableValueCents = 200;

  final CollectionGateway _collection;
  final ActivityLog _activityLog;
  final TradeGateway _trades;
  final ValueHistoryStore _valueHistory;
  final DateTime Function() _now;

  Future<List<ActivityEvent>> call() async {
    final now = _now();
    final since = DateTime(now.year, now.month - monthsShown + 1);
    final items = await _collection.allItems();
    final titles = {for (final item in items) item.id: resolveDisplayTitle(item.titles, PreferredLanguages.defaults) ?? ''};
    final events = <ActivityEvent>[
      for (final item in items)
        if (item.addedAt case final addedAt? when !addedAt.isBefore(since))
          ActivityEvent(kind: ActivityKind.added, title: titles[item.id]!, at: addedAt, itemId: item.id, categoryId: item.categoryId),
      for (final sale in (await _trades.watchHistory().first).sales)
        if (!sale.soldOn.isBefore(since))
          ActivityEvent(
            kind: ActivityKind.sold,
            title: resolveDisplayTitle(sale.titles, PreferredLanguages.defaults) ?? '',
            at: sale.soldOn,
            itemId: sale.itemId,
            categoryId: sale.categoryId,
            amountCents: sale.salePriceCents,
            currency: 'EUR',
          ),
      ...await _activityLog.between(since, now.add(const Duration(days: 1))),
      ...await _valueChanges(since, titles),
    ]..sort((first, second) => second.at.compareTo(first.at));
    return events.take(entriesShown).toList();
  }

  Future<List<ActivityEvent>> _valueChanges(DateTime since, Map<String, String> titles) async {
    final months = [for (final snapshot in await _valueHistory.snapshots()) snapshot.month]..sort();
    final changes = <ActivityEvent>[];
    for (var index = 1; index < months.length; index++) {
      if (months[index].isBefore(since)) {
        continue;
      }
      final before = await _valueHistory.itemValuesAt(months[index - 1]);
      final after = await _valueHistory.itemValuesAt(months[index]);
      for (final MapEntry(key: itemId, value: (cents, currency)) in after.entries) {
        final previous = before[itemId];
        final title = titles[itemId];
        if (previous == null || title == null || previous.$2 != currency || previous.$1 == 0) {
          continue;
        }
        final delta = cents - previous.$1;
        if (delta.abs() >= notableValueCents && delta.abs() / previous.$1 >= notableValueChange) {
          changes.add(ActivityEvent(kind: delta > 0 ? ActivityKind.valueRose : ActivityKind.valueFell, title: title, at: months[index], itemId: itemId, amountCents: delta, currency: currency));
        }
      }
    }
    return changes;
  }
}
