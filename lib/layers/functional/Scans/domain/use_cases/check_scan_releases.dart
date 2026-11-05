import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Scans/domain/gateways/chapter_alerts.dart';
import 'package:akashic/layers/functional/Scans/domain/use_cases/scan_releases.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';

class CheckScanReleases {
  CheckScanReleases(this._refresh, this._collection, this._notifier, this._preferredLanguages);

  final RefreshScanReleases _refresh;
  final CollectionGateway _collection;
  final ChapterNotifier _notifier;
  final Future<PreferredLanguages> Function() _preferredLanguages;

  Future<ReleaseRefresh> call({String? onlySeriesId}) async {
    final outcome = await _refresh(onlySeriesId: onlySeriesId, onlyWithAlerts: onlySeriesId == null);
    if (outcome.announcements.isEmpty) {
      await _refresh.acknowledge(outcome.unannouncedReleases);
      return outcome;
    }
    final languages = await _preferredLanguages();
    final titles = {for (final series in await _collection.watchAllSeries().first) series.id: resolveDisplayTitle(series.titles, languages) ?? ''};
    await _notifier.announce([
      for (final announcement in outcome.announcements)
        ChapterNotice(seriesId: announcement.seriesId, seriesTitle: titles[announcement.seriesId] ?? '', chapters: announcement.chapters),
    ]);
    await _refresh.acknowledge(outcome.unannouncedReleases);
    return outcome;
  }
}
