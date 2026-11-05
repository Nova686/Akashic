import 'package:akashic/layers/functional/SourceLimits/domain/entities/source_block.dart';
import 'package:akashic/layers/functional/SourceLimits/domain/gateways/source_block_gateway.dart';
import 'package:akashic/layers/technical/HttpAccess/rate_limits.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:drift/drift.dart';

class DriftSourceBlockGateway implements SourceBlockGateway, RateLimitRecorder {
  DriftSourceBlockGateway(this._database, {DateTime Function()? now}) : _now = now ?? DateTime.now;

  final AkashicDatabase _database;
  final DateTime Function() _now;
  final Map<String, DateTime> _retryAtByFamily = {};

  Future<void> load() async {
    await (_database.delete(_database.sourceBlocks)..where((table) => table.retryAt.isSmallerOrEqualValue(_now()))).go();
    for (final row in await _database.select(_database.sourceBlocks).get()) {
      _retryAtByFamily[row.apiFamily] = row.retryAt;
    }
  }

  @override
  DateTime? blockedUntil(String apiFamily) {
    final retryAt = _retryAtByFamily[apiFamily];
    return retryAt != null && retryAt.isAfter(_now()) ? retryAt : null;
  }

  @override
  Future<void> recordBlock(String apiFamily, {required DateTime blockedAt, required DateTime retryAt}) async {
    final known = _retryAtByFamily[apiFamily];
    if (known != null && !retryAt.isAfter(known)) {
      return;
    }
    _retryAtByFamily[apiFamily] = retryAt;
    await _database.into(_database.sourceBlocks).insertOnConflictUpdate(
          SourceBlocksCompanion.insert(apiFamily: apiFamily, blockedAt: blockedAt, retryAt: retryAt),
        );
  }

  @override
  Stream<List<SourceBlock>> watchBlocks() {
    return (_database.select(_database.sourceBlocks)..orderBy([(table) => OrderingTerm.asc(table.retryAt)]))
        .watch()
        .map((rows) => [for (final row in rows) SourceBlock(apiFamily: row.apiFamily, blockedAt: row.blockedAt, retryAt: row.retryAt)]);
  }
}
