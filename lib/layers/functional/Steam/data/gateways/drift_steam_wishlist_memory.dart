import 'dart:convert';

import 'package:akashic/layers/functional/Steam/domain/gateways/steam_wishlist_memory.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';

class DriftSteamWishlistMemory implements SteamWishlistMemory {
  DriftSteamWishlistMemory(this._database);

  static const String _key = 'steamWishlistImported';

  final AkashicDatabase _database;

  @override
  Future<Set<String>> importedAppIds() async {
    final row = await (_database.select(_database.preferences)..where((table) => table.key.equals(_key))).getSingleOrNull();
    return row == null ? <String>{} : {for (final appId in jsonDecode(row.value) as List) '$appId'};
  }

  @override
  Future<void> rememberImported(Set<String> appIds) =>
      _database.into(_database.preferences).insertOnConflictUpdate(PreferencesCompanion.insert(key: _key, value: jsonEncode(appIds.toList()..sort())));
}
