import 'package:akashic/layers/functional/Activity/domain/entities/activity_event.dart';
import 'package:akashic/layers/functional/Activity/domain/gateways/activity_log.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:drift/drift.dart';

class DriftActivityLog implements ActivityLog {
  DriftActivityLog(this._database);

  final AkashicDatabase _database;

  ActivityEvent _eventOf(ActivityEventRow row) => ActivityEvent(
        kind: ActivityKind.values.asNameMap()[row.kind] ?? ActivityKind.added,
        title: row.title,
        at: row.at,
        itemId: row.itemId,
        categoryId: row.categoryId,
        amountCents: row.amountCents,
        currency: row.currency,
        detail: row.detail,
      );

  @override
  Future<void> record(ActivityEvent event) => _database.into(_database.activityEvents).insert(ActivityEventsCompanion.insert(
        kind: event.kind.name,
        title: event.title,
        at: event.at,
        itemId: Value(event.itemId),
        categoryId: Value(event.categoryId),
        amountCents: Value(event.amountCents),
        currency: Value(event.currency),
        detail: Value(event.detail),
      ));

  @override
  Future<List<ActivityEvent>> between(DateTime from, DateTime to) async => [
        for (final row in await (_database.select(_database.activityEvents)
              ..where((table) => table.at.isBiggerOrEqualValue(from) & table.at.isSmallerThanValue(to))
              ..orderBy([(table) => OrderingTerm.asc(table.at)]))
            .get())
          _eventOf(row),
      ];

  @override
  Stream<List<ActivityEvent>> watchRecent({int limit = 300}) => (_database.select(_database.activityEvents)
        ..orderBy([(table) => OrderingTerm.desc(table.at), (table) => OrderingTerm.desc(table.id)])
        ..limit(limit))
      .watch()
      .map((rows) => [for (final row in rows) _eventOf(row)]);
}
