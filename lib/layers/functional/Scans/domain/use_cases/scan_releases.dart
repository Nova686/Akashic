import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/functional/Scans/domain/entities/scan_follow.dart';
import 'package:akashic/layers/functional/Scans/domain/entities/scan_progress.dart';
import 'package:akashic/layers/functional/Scans/domain/entities/scan_release.dart';
import 'package:akashic/layers/functional/Scans/domain/gateways/chapter_release_source.dart';
import 'package:akashic/layers/functional/Scans/domain/gateways/scan_gateway.dart';
import 'package:equatable/equatable.dart';

class SearchReleaseSeries {
  SearchReleaseSeries(this._source);

  final ChapterReleaseSource _source;

  Future<List<ReleaseSeriesCandidate>> call(String query) => query.trim().isEmpty ? Future.value(const []) : _source.searchSeries(query.trim());
}

class LinkReleaseSeries {
  LinkReleaseSeries(this._scans);

  final ScanGateway _scans;

  Future<void> call(ScanFollow follow, String? releaseSeriesId) async {
    await _scans.clearReleases(follow.seriesId);
    await _scans.saveFollow(follow.copyWith(mangaUpdatesSeriesId: () => releaseSeriesId, lastCheckedAt: () => null));
  }
}

class ChapterAnnouncement extends Equatable {
  const ChapterAnnouncement({required this.seriesId, required this.chapters});

  final String seriesId;
  final List<double> chapters;

  @override
  List<Object?> get props => [seriesId, chapters];
}

class ReleaseRefresh extends Equatable {
  const ReleaseRefresh({required this.announcements, required this.unannouncedReleases, required this.failedSeries});

  final List<ChapterAnnouncement> announcements;
  final List<ScanRelease> unannouncedReleases;
  final int failedSeries;

  @override
  List<Object?> get props => [announcements, unannouncedReleases, failedSeries];
}

class RefreshScanReleases {
  RefreshScanReleases(this._scans, this._source, {DateTime Function()? now}) : _now = now ?? DateTime.now;

  final ScanGateway _scans;
  final ChapterReleaseSource _source;
  final DateTime Function() _now;

  Future<void> acknowledge(List<ScanRelease> releases) => _scans.markNotified(releases);

  Future<ReleaseRefresh> call({String? onlySeriesId, bool onlyWithAlerts = false}) async {
    final announcements = <ChapterAnnouncement>[];
    final unannouncedReleases = <ScanRelease>[];
    var failedSeries = 0;
    for (final follow in await _scans.follows()) {
      final releaseSeriesId = follow.mangaUpdatesSeriesId;
      if (releaseSeriesId == null || (onlySeriesId != null && follow.seriesId != onlySeriesId) || (onlyWithAlerts && !follow.alertsEnabled)) {
        continue;
      }
      final List<PublishedChapters> published;
      try {
        published = await _source.releasesOf(releaseSeriesId);
      } on SourceUnavailable {
        failedSeries++;
        continue;
      }
      if (published.isEmpty) {
        continue;
      }
      final isFirstCheck = follow.lastCheckedAt == null;
      await _scans.addReleases([
        for (final release in published)
          for (final chapter in release.chapters) ScanRelease(seriesId: follow.seriesId, chapter: chapter, teamName: release.teamName, notified: isFirstCheck),
      ]);
      final current = await _scans.followOf(follow.seriesId);
      if (current != null) {
        await _scans.saveFollow(current.copyWith(lastCheckedAt: () => _now()));
      }
      final unannounced = (await _scans.releasesOf(follow.seriesId)).where((release) => !release.notified).toList();
      if (unannounced.isEmpty) {
        continue;
      }
      unannouncedReleases.addAll(unannounced);
      final progress = ScanProgress(
        follow: current ?? follow,
        readChapters: (await _scans.watchSeries(follow.seriesId).first)?.readChapters ?? const [],
        releases: unannounced,
      );
      final newChapters = progress.newChapters;
      if ((current ?? follow).alertsEnabled && newChapters.isNotEmpty) {
        announcements.add(ChapterAnnouncement(seriesId: follow.seriesId, chapters: newChapters));
      }
    }
    return ReleaseRefresh(announcements: announcements, unannouncedReleases: unannouncedReleases, failedSeries: failedSeries);
  }
}
