import 'package:akashic/layers/functional/Scans/domain/entities/scan_follow.dart';
import 'package:akashic/layers/functional/Scans/domain/gateways/scan_gateway.dart';

class FollowSeriesInScans {
  FollowSeriesInScans(this._scans);

  final ScanGateway _scans;

  Future<ScanFollow> call(String seriesId) async {
    final existing = await _scans.followOf(seriesId);
    if (existing != null) {
      return existing;
    }
    final follow = ScanFollow(seriesId: seriesId);
    await _scans.saveFollow(follow);
    return follow;
  }
}

class UpdateScanFollow {
  UpdateScanFollow(this._scans);

  final ScanGateway _scans;

  Future<void> call(ScanFollow follow) => _scans.saveFollow(follow);
}

class MarkChapterRead {
  MarkChapterRead(this._scans);

  final ScanGateway _scans;

  Future<void> call(String seriesId, double chapter) => _scans.markRead(seriesId, [chapter]);
}

class UnmarkChapter {
  UnmarkChapter(this._scans);

  final ScanGateway _scans;

  Future<void> call(String seriesId, double chapter) => _scans.unmarkRead(seriesId, chapter);
}

class MarkReadUpTo {
  MarkReadUpTo(this._scans);

  static const int maximumChapters = 5000;

  final ScanGateway _scans;

  Future<void> call(String seriesId, double lastChapter) async {
    if (lastChapter < 1 || lastChapter > maximumChapters) {
      return;
    }
    final releasedBelow = [
      for (final release in await _scans.releasesOf(seriesId))
        if (release.chapter <= lastChapter) release.chapter,
    ];
    await _scans.markRead(seriesId, {for (var whole = 1; whole <= lastChapter; whole++) whole.toDouble(), lastChapter, ...releasedBelow});
  }
}
