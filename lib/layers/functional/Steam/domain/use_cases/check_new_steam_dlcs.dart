import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/functional/Steam/domain/entities/steam_wish_watch.dart';
import 'package:akashic/layers/functional/Steam/domain/gateways/steam_alerts.dart';
import 'package:akashic/layers/functional/Steam/domain/gateways/steam_stats_gateway.dart';
import 'package:akashic/layers/functional/Steam/domain/gateways/steam_store_api.dart';
import 'package:akashic/layers/functional/Steam/domain/gateways/steam_watch_store.dart';

class CheckNewSteamDlcs {
  CheckNewSteamDlcs(this._stats, this._store, this._collection, this._watches, this._alerts, {DateTime Function()? now}) : _now = now ?? DateTime.now;

  static const int gamesPerRun = 10;
  static const int namedDlcsPerGame = 3;
  static const Duration checkEvery = Duration(days: 7);

  final SteamStatsGateway _stats;
  final SteamStoreApi _store;
  final CollectionGateway _collection;
  final SteamWatchStore _watches;
  final SteamAlerts _alerts;
  final DateTime Function() _now;

  Future<void> call() async {
    final now = _now();
    final recentlyPlayed = [for (final stats in await _stats.watchAll().first) if (stats.lastPlayedAt != null) stats]
      ..sort((first, second) => second.lastPlayedAt!.compareTo(first.lastPlayedAt!));
    var checks = gamesPerRun;
    for (final stats in recentlyPlayed) {
      if (checks == 0) {
        return;
      }
      final known = await _watches.knownDlcsOf(stats.appId);
      if (known != null && now.difference(known.checkedAt) < checkEvery) {
        continue;
      }
      checks--;
      try {
        final page = await _store.storePage(stats.appId);
        if (page == null) {
          continue;
        }
        final dlcIds = page.dlcIds.toSet();
        final fresh = known == null ? const <String>{} : dlcIds.difference(known.dlcIds);
        if (fresh.isNotEmpty) {
          final names = [for (final dlcId in fresh.take(namedDlcsPerGame)) ?(await _store.dlc(dlcId))?.name];
          final item = await _collection.watchItem(stats.itemId).first;
          await _alerts.newDlcs(item == null ? page.name : (resolveDisplayTitle(item.titles, PreferredLanguages.defaults) ?? page.name), names);
        }
        await _watches.saveKnownDlcs(KnownSteamDlcs(appId: stats.appId, dlcIds: {...?known?.dlcIds, ...dlcIds}, checkedAt: now));
      } on SourceUnavailable {
        return;
      }
    }
  }
}
