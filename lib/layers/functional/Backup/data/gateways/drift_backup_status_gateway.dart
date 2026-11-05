import 'package:akashic/layers/functional/Backup/domain/gateways/backup_ports.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';

class DriftBackupStatusGateway implements BackupStatusGateway {
  DriftBackupStatusGateway(this._database);

  static const String _lastBackupKey = 'lastBackupAt';

  final AkashicDatabase _database;

  @override
  Stream<DateTime?> watchLastBackupAt() {
    return (_database.select(_database.preferences)..where((table) => table.key.equals(_lastBackupKey)))
        .watchSingleOrNull()
        .map((row) => row == null ? null : DateTime.tryParse(row.value)?.toLocal());
  }

  @override
  Future<void> saveLastBackupAt(DateTime at) {
    return _database.into(_database.preferences).insertOnConflictUpdate(PreferencesCompanion.insert(key: _lastBackupKey, value: at.toUtc().toIso8601String()));
  }
}
