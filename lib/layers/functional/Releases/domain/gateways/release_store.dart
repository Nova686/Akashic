import 'package:akashic/layers/functional/Releases/domain/entities/upcoming_release.dart';

abstract interface class ReleaseStore {
  Future<ReleaseOutlook?> cachedOutlook();
  Future<void> saveOutlook(ReleaseOutlook outlook);
  Future<Set<String>?> announcedReleases();
  Future<void> saveAnnouncedReleases(Set<String> releaseKeys);
}
