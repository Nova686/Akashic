import 'dart:convert';

import 'package:akashic/layers/functional/Preorders/domain/gateways/preorder_alerts.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';

class DriftPreorderAlertMemory implements PreorderAlertMemory {
  DriftPreorderAlertMemory(this._database);

  static const String _key = 'preorderArrivalsAnnounced';

  final AkashicDatabase _database;

  @override
  Future<Set<String>> announced() async {
    final row = await (_database.select(_database.preferences)..where((table) => table.key.equals(_key))).getSingleOrNull();
    return row == null ? {} : {for (final key in jsonDecode(row.value) as List) key as String};
  }

  @override
  Future<void> saveAnnounced(Set<String> keys) => _database.into(_database.preferences).insertOnConflictUpdate(PreferencesCompanion.insert(key: _key, value: jsonEncode(keys.toList())));
}
