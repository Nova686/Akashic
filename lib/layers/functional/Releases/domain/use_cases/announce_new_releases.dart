import 'package:akashic/layers/functional/Releases/domain/entities/upcoming_release.dart';
import 'package:akashic/layers/functional/Releases/domain/gateways/release_notifier.dart';
import 'package:akashic/layers/functional/Releases/domain/gateways/release_store.dart';
import 'package:akashic/layers/functional/Releases/domain/use_cases/find_upcoming_releases.dart';

class AnnounceNewReleases {
  AnnounceNewReleases(this._findUpcomingReleases, this._store, this._notifier, {DateTime Function()? now, this._refreshAfter = const Duration(days: 1)})
      : _now = now ?? DateTime.now;

  final FindUpcomingReleases _findUpcomingReleases;
  final ReleaseStore _store;
  final ReleaseNotifier _notifier;
  final DateTime Function() _now;
  final Duration _refreshAfter;

  Future<List<UpcomingRelease>> call() async {
    final cached = await _store.cachedOutlook();
    final ReleaseOutlook outlook;
    if (cached != null && _now().difference(cached.computedAt) < _refreshAfter) {
      outlook = cached;
    } else {
      try {
        outlook = await _findUpcomingReleases();
      } on ReleasesUnavailable {
        return const [];
      }
    }
    final announced = await _store.announcedReleases();
    final today = _now();
    final wishedOut = [for (final release in outlook.releases) if (release.isWished && release.isReleasedBy(today)) release];
    final currentKeys = {for (final release in outlook.releases) release.key, for (final release in wishedOut) outKeyOf(release)};
    if (announced == null) {
      await _store.saveAnnouncedReleases(currentKeys);
      return const [];
    }
    final fresh = [for (final release in outlook.releases) if (!release.isEstimated && !announced.contains(release.key)) release];
    final freshOut = [for (final release in wishedOut) if (!announced.contains(outKeyOf(release))) release];
    if (fresh.isNotEmpty) {
      await _notifier.announce(fresh);
    }
    if (freshOut.isNotEmpty) {
      await _notifier.announceWishedOut(freshOut);
    }
    if (fresh.isNotEmpty || freshOut.isNotEmpty) {
      await _store.saveAnnouncedReleases({...announced, ...currentKeys});
    }
    return [...fresh, ...freshOut];
  }

  static String outKeyOf(UpcomingRelease release) => '${release.key}|out';
}
