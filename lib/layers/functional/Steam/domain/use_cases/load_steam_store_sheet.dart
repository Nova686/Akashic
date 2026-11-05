import 'dart:async';

import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/functional/Steam/domain/entities/steam_store_page.dart';
import 'package:akashic/layers/functional/Steam/domain/gateways/steam_store_api.dart';
import 'package:akashic/layers/functional/Steam/domain/use_cases/guess_text_language.dart';

class SteamStorePageMissing implements Exception {
  const SteamStorePageMissing();
}

class LoadSteamStoreSheet {
  LoadSteamStoreSheet(this._store, this._collection, {this._preferredLanguages});

  static const String steamSourceKey = 'steam';
  static const int shownDlcs = 8;
  static const int shownNews = 3;
  static const Duration keptFor = Duration(minutes: 30);

  final SteamStoreApi _store;
  final CollectionGateway _collection;
  final Future<PreferredLanguages> Function()? _preferredLanguages;
  final Map<String, (DateTime, Future<SteamStoreSheet>)> _sheets = {};
  final Map<String, (DateTime, Future<List<SteamDlc>>)> _dlcs = {};

  Future<T> _kept<T>(Map<String, (DateTime, Future<T>)> cache, String appId, Future<T> Function() load) {
    final now = DateTime.now();
    if (cache[appId] case (final storedAt, final future) when now.difference(storedAt) < keptFor) {
      return future;
    }
    final future = load();
    cache[appId] = (now, future);
    future.then<void>((_) {}, onError: (Object _) => cache.remove(appId));
    return future;
  }

  void prefetch(String appId) {
    unawaited(dlcsOf(appId).then<void>((_) {}, onError: (Object _) {}));
  }

  Future<List<SteamDlc>> dlcsOf(String appId) => _kept(_dlcs, appId, () async => _dlcsFor((await call(appId)).page.dlcIds.take(shownDlcs).toList()));

  Future<SteamStoreSheet> call(String appId) => _kept(_sheets, appId, () async {
        final news = _newsOf(appId);
        final page = await _store.storePage(appId);
        if (page == null) {
          throw const SteamStorePageMissing();
        }
        return SteamStoreSheet(page: page, news: await news);
      });

  Future<List<SteamNews>> _newsOf(String appId) async {
    try {
      final news = await _store.news(appId);
      final languages = {...?(await _preferredLanguages?.call())?.codes};
      return [
        for (final item in news)
          if (languages.isEmpty || languages.contains(guessTextLanguage('${item.title} ${item.snippet ?? ''}') ?? languages.first)) item,
      ].take(shownNews).toList();
    } on SourceUnavailable {
      return const [];
    }
  }

  Future<List<SteamDlc>> _dlcsFor(List<String> dlcIds) async {
    final dlcs = <SteamDlc>[];
    for (final dlcId in dlcIds) {
      try {
        final dlc = await _store.dlc(dlcId);
        if (dlc == null) {
          continue;
        }
        dlcs.add(await _collection.findByExternalWork(steamSourceKey, dlcId) == null ? dlc : dlc.inCollection());
      } on SourceUnavailable {
        break;
      }
    }
    return dlcs;
  }
}
