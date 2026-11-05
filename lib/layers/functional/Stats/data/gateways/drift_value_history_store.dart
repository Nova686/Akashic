import 'dart:convert';

import 'package:akashic/layers/functional/Stats/domain/entities/value_history.dart';
import 'package:akashic/layers/functional/Stats/domain/gateways/value_history_store.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';

class DriftValueHistoryStore implements ValueHistoryStore {
  DriftValueHistoryStore(this._database);

  final AkashicDatabase _database;

  String _keyOf(DateTime month) => '${month.year.toString().padLeft(4, '0')}-${month.month.toString().padLeft(2, '0')}';

  DateTime _monthOf(String key) => DateTime(int.parse(key.substring(0, 4)), int.parse(key.substring(5, 7)));

  @override
  Future<List<ValueSnapshot>> snapshots() async => [
        for (final row in await _database.select(_database.valueSnapshots).get())
          ValueSnapshot(month: _monthOf(row.month), totals: Map<String, int>.from(jsonDecode(row.totals) as Map)),
      ];

  @override
  Future<bool> hasSnapshot(DateTime month) async => await (_database.select(_database.valueSnapshots)..where((table) => table.month.equals(_keyOf(month)))).getSingleOrNull() != null;

  @override
  Future<void> save(ValueSnapshot snapshot, Map<String, (int, String)> valuesByItem) => _database.transaction(() async {
        final month = _keyOf(snapshot.month);
        await _database.into(_database.valueSnapshots).insertOnConflictUpdate(ValueSnapshotsCompanion.insert(month: month, totals: jsonEncode(snapshot.totals), takenAt: DateTime.now()));
        await _database.batch((batch) => batch.insertAllOnConflictUpdate(_database.itemValueSnapshots, [
              for (final MapEntry(key: itemId, value: (cents, currency)) in valuesByItem.entries)
                ItemValueSnapshotsCompanion.insert(itemId: itemId, month: month, cents: cents, currency: currency),
            ]));
      });

  @override
  Future<Map<String, (int, String)>> itemValuesAt(DateTime month) async => {
        for (final row in await (_database.select(_database.itemValueSnapshots)..where((table) => table.month.equals(_keyOf(month)))).get()) row.itemId: (row.cents, row.currency),
      };
}
