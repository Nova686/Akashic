import 'package:akashic/layers/functional/Scans/domain/entities/scan_follow.dart';
import 'package:akashic/layers/functional/Scans/domain/entities/scan_progress.dart';
import 'package:akashic/layers/functional/Scans/domain/entities/scan_release.dart';
import 'package:akashic/layers/functional/Scans/domain/gateways/scan_gateway.dart';
import 'package:akashic/layers/technical/LocalDatabase/akashic_database.dart';
import 'package:drift/drift.dart';

class DriftScanGateway implements ScanGateway {
  DriftScanGateway(this._database);

  final AkashicDatabase _database;

  Stream<T> _watchScanTables<T>(Future<T> Function() load) {
    return _database
        .customSelect('SELECT 1', readsFrom: {_database.scanFollows, _database.readChapters, _database.scanReleases})
        .watch()
        .asyncMap((_) => load());
  }

  @override
  Stream<List<ScanProgress>> watchAll() => _watchScanTables(() async => _progressOf(await _database.select(_database.scanFollows).get()));

  @override
  Stream<ScanProgress?> watchSeries(String seriesId) => _watchScanTables(() async {
        final rows = await (_database.select(_database.scanFollows)..where((table) => table.seriesId.equals(seriesId))).get();
        return (await _progressOf(rows)).firstOrNull;
      });

  Future<List<ScanProgress>> _progressOf(List<ScanFollowRow> followRows) async {
    final seriesIds = followRows.map((row) => row.seriesId).toList();
    final readRows = await (_database.select(_database.readChapters)..where((table) => table.seriesId.isIn(seriesIds))).get();
    final releaseRows = await (_database.select(_database.scanReleases)..where((table) => table.seriesId.isIn(seriesIds))).get();
    return [
      for (final row in followRows)
        ScanProgress(
          follow: _followFromRow(row),
          readChapters: [for (final read in readRows) if (read.seriesId == row.seriesId) read.chapter]..sort(),
          releases: [for (final release in releaseRows) if (release.seriesId == row.seriesId) _releaseFromRow(release)],
        ),
    ];
  }

  @override
  Future<ScanFollow?> followOf(String seriesId) async {
    final row = await (_database.select(_database.scanFollows)..where((table) => table.seriesId.equals(seriesId))).getSingleOrNull();
    return row == null ? null : _followFromRow(row);
  }

  @override
  Future<List<ScanFollow>> follows() async => (await _database.select(_database.scanFollows).get()).map(_followFromRow).toList();

  @override
  Future<void> saveFollow(ScanFollow follow) {
    return _database.into(_database.scanFollows).insertOnConflictUpdate(ScanFollowsCompanion.insert(
          seriesId: follow.seriesId,
          siteUrl: Value(follow.siteUrl),
          teamName: Value(follow.teamName),
          mangaUpdatesSeriesId: Value(follow.mangaUpdatesSeriesId),
          alertsEnabled: Value(follow.alertsEnabled),
          onlyFollowedTeam: Value(follow.onlyFollowedTeam),
          lastCheckedAt: Value(follow.lastCheckedAt),
        ));
  }

  @override
  Future<void> unfollow(String seriesId) {
    return _database.transaction(() async {
      await (_database.delete(_database.scanReleases)..where((table) => table.seriesId.equals(seriesId))).go();
      await (_database.delete(_database.scanFollows)..where((table) => table.seriesId.equals(seriesId))).go();
    });
  }

  @override
  Future<void> markRead(String seriesId, Iterable<double> chapters) {
    return _database.batch((batch) {
      for (final chapter in chapters) {
        batch.insert(_database.readChapters, ReadChaptersCompanion.insert(seriesId: seriesId, chapter: chapter), mode: InsertMode.insertOrIgnore);
      }
    });
  }

  @override
  Future<void> unmarkRead(String seriesId, double chapter) {
    return (_database.delete(_database.readChapters)..where((table) => table.seriesId.equals(seriesId) & table.chapter.equals(chapter))).go();
  }

  @override
  Future<List<ScanRelease>> releasesOf(String seriesId) async {
    final rows = await (_database.select(_database.scanReleases)..where((table) => table.seriesId.equals(seriesId))).get();
    return rows.map(_releaseFromRow).toList();
  }

  @override
  Future<List<ScanRelease>> addReleases(List<ScanRelease> releases) {
    return _database.transaction(() async {
      final added = <ScanRelease>[];
      for (final release in releases) {
        final existing = await (_database.select(_database.scanReleases)
              ..where((table) => table.seriesId.equals(release.seriesId) & table.chapter.equals(release.chapter) & table.teamName.equals(release.teamName)))
            .getSingleOrNull();
        if (existing != null) {
          continue;
        }
        await _database.into(_database.scanReleases).insert(ScanReleasesCompanion.insert(
              seriesId: release.seriesId,
              chapter: release.chapter,
              teamName: release.teamName,
              releasedOn: Value(release.releasedOn),
              notified: Value(release.notified),
            ));
        added.add(release);
      }
      return added;
    });
  }

  @override
  Future<void> markNotified(List<ScanRelease> releases) {
    return _database.batch((batch) {
      for (final release in releases) {
        batch.update(
          _database.scanReleases,
          const ScanReleasesCompanion(notified: Value(true)),
          where: (table) => table.seriesId.equals(release.seriesId) & table.chapter.equals(release.chapter) & table.teamName.equals(release.teamName),
        );
      }
    });
  }

  @override
  Future<void> clearReleases(String seriesId) => (_database.delete(_database.scanReleases)..where((table) => table.seriesId.equals(seriesId))).go();

  ScanFollow _followFromRow(ScanFollowRow row) => ScanFollow(
        seriesId: row.seriesId,
        siteUrl: row.siteUrl,
        teamName: row.teamName,
        mangaUpdatesSeriesId: row.mangaUpdatesSeriesId,
        alertsEnabled: row.alertsEnabled,
        onlyFollowedTeam: row.onlyFollowedTeam,
        lastCheckedAt: row.lastCheckedAt,
      );

  ScanRelease _releaseFromRow(ScanReleaseRow row) =>
      ScanRelease(seriesId: row.seriesId, chapter: row.chapter, teamName: row.teamName, releasedOn: row.releasedOn, notified: row.notified);
}
