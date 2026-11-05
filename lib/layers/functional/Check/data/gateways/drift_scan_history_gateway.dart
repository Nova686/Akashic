import 'package:akashic/layers/functional/Check/domain/entities/scan_session.dart';
import 'package:akashic/layers/functional/Check/domain/gateways/scan_history_gateway.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:drift/drift.dart';

class DriftScanHistoryGateway implements ScanHistoryGateway {
  DriftScanHistoryGateway(this._database);

  final AkashicDatabase _database;

  @override
  Future<void> save(ScanSession session) => _database.transaction(() async {
        await _database.into(_database.scanSessions).insertOnConflictUpdate(ScanSessionsCompanion.insert(id: session.id, startedAt: session.startedAt, mode: session.mode.name));
        await (_database.delete(_database.scanSessionEntries)..where((table) => table.sessionId.equals(session.id))).go();
        await _database.batch((batch) => batch.insertAll(_database.scanSessionEntries, [
              for (final (position, entry) in session.entries.indexed)
                ScanSessionEntriesCompanion.insert(
                  sessionId: session.id,
                  position: position,
                  title: entry.title,
                  outcome: entry.outcome.name,
                  source: entry.source.name,
                  itemId: Value(entry.itemId),
                ),
            ]));
      });

  @override
  Stream<List<ScanSession>> watchAll() {
    final query = _database.select(_database.scanSessions).join([
      leftOuterJoin(_database.scanSessionEntries, _database.scanSessionEntries.sessionId.equalsExp(_database.scanSessions.id)),
    ])
      ..orderBy([OrderingTerm.desc(_database.scanSessions.startedAt), OrderingTerm.asc(_database.scanSessionEntries.position)]);
    return query.watch().map((rows) {
      final sessions = <String, ScanSessionRow>{};
      final entries = <String, List<ScanSessionEntry>>{};
      for (final row in rows) {
        final session = row.readTable(_database.scanSessions);
        sessions[session.id] = session;
        final sessionEntries = entries.putIfAbsent(session.id, () => []);
        if (row.readTableOrNull(_database.scanSessionEntries) case final entry?) {
          sessionEntries.add(ScanSessionEntry(
            title: entry.title,
            outcome: ScanOutcome.values.asNameMap()[entry.outcome] ?? ScanOutcome.missed,
            source: ScanSource.values.asNameMap()[entry.source] ?? ScanSource.barcode,
            itemId: entry.itemId,
          ));
        }
      }
      return [
        for (final session in sessions.values)
          ScanSession(
            id: session.id,
            startedAt: session.startedAt,
            mode: ScanSource.values.asNameMap()[session.mode] ?? ScanSource.barcode,
            entries: entries[session.id] ?? const [],
          ),
      ];
    });
  }
}
