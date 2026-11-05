import 'package:akashic/layers/functional/Scans/domain/entities/scan_follow.dart';
import 'package:akashic/layers/functional/Scans/domain/entities/scan_progress.dart';
import 'package:akashic/layers/functional/Scans/domain/entities/scan_release.dart';

abstract interface class ScanGateway {
  Stream<List<ScanProgress>> watchAll();
  Stream<ScanProgress?> watchSeries(String seriesId);
  Future<ScanFollow?> followOf(String seriesId);
  Future<List<ScanFollow>> follows();
  Future<void> saveFollow(ScanFollow follow);
  Future<void> unfollow(String seriesId);
  Future<void> markRead(String seriesId, Iterable<double> chapters);
  Future<void> unmarkRead(String seriesId, double chapter);
  Future<List<ScanRelease>> releasesOf(String seriesId);
  Future<List<ScanRelease>> addReleases(List<ScanRelease> releases);
  Future<void> markNotified(List<ScanRelease> releases);
  Future<void> clearReleases(String seriesId);
}
