import 'dart:convert';

import 'package:akashic/layers/functional/Import/domain/entities/linked_account.dart';
import 'package:akashic/layers/functional/Import/domain/gateways/linked_account_gateway.dart';
import 'package:akashic/layers/functional/Import/domain/use_cases/import_account_library.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';

class DriftLinkedAccountGateway implements LinkedAccountGateway {
  DriftLinkedAccountGateway(this._database);

  static const String _key = 'linkedAccounts';

  final AkashicDatabase _database;

  @override
  Stream<List<LinkedAccount>> watchAll() {
    final query = _database.select(_database.preferences)..where((table) => table.key.equals(_key));
    return query.watchSingleOrNull().map((row) => row == null ? const [] : _decode(row.value));
  }

  Future<List<LinkedAccount>> _all() async {
    final row = await (_database.select(_database.preferences)..where((table) => table.key.equals(_key))).getSingleOrNull();
    return row == null ? const [] : _decode(row.value);
  }

  @override
  Future<void> save(LinkedAccount account) => _database.transaction(() async {
        final others = [for (final linked in await _all()) if (linked.service != account.service) linked];
        await _write([...others, account]);
      });

  @override
  Future<void> remove(LibraryService service) => _database.transaction(() async => _write([for (final linked in await _all()) if (linked.service != service) linked]));

  Future<void> _write(List<LinkedAccount> accounts) => _database.into(_database.preferences).insertOnConflictUpdate(PreferencesCompanion.insert(
        key: _key,
        value: jsonEncode([
          for (final account in accounts)
            {
              'service': account.service.name,
              'accountName': account.accountName,
              'categoryId': account.categoryId,
              'seenKeys': account.seenKeys.toList(),
              'lastSyncedAt': account.lastSyncedAt?.toIso8601String(),
              'lastAdded': account.lastAdded,
            },
        ]),
      ));

  List<LinkedAccount> _decode(String value) {
    final decoded = jsonDecode(value);
    if (decoded is! List) {
      return const [];
    }
    return [
      for (final entry in decoded.whereType<Map<String, dynamic>>())
        if ((LibraryService.values.asNameMap()[entry['service']], entry['accountName'], entry['categoryId']) case (final service?, final String accountName, final String categoryId))
          LinkedAccount(
            service: service,
            accountName: accountName,
            categoryId: categoryId,
            seenKeys: {...(entry['seenKeys'] as List? ?? const []).whereType<String>()},
            lastSyncedAt: DateTime.tryParse(entry['lastSyncedAt'] as String? ?? ''),
            lastAdded: entry['lastAdded'] is int ? entry['lastAdded'] as int : 0,
          ),
    ];
  }
}
