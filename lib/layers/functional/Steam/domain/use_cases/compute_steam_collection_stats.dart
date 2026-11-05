import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/gateways/collection_gateway.dart';
import 'package:akashic/layers/functional/Steam/domain/entities/steam_game_stats.dart';
import 'package:akashic/layers/functional/Steam/domain/gateways/steam_stats_gateway.dart';
import 'package:equatable/equatable.dart';

class PlayedGame extends Equatable {
  const PlayedGame(this.item, this.minutes);

  final CollectionItem item;
  final int minutes;

  @override
  List<Object?> get props => [item, minutes];
}

class SteamCollectionStats extends Equatable {
  const SteamCollectionStats({
    required this.gameCount,
    required this.totalMinutes,
    required this.neverPlayed,
    required this.topPlayed,
    required this.libraryValue,
    this.averageCompletion,
    this.pricedAt,
  });

  final int gameCount;
  final int totalMinutes;
  final List<CollectionItem> neverPlayed;
  final List<PlayedGame> topPlayed;
  final double? averageCompletion;
  final Map<String, int> libraryValue;
  final DateTime? pricedAt;

  @override
  List<Object?> get props => [gameCount, totalMinutes, neverPlayed, topPlayed, averageCompletion, libraryValue, pricedAt];
}

class ComputeSteamCollectionStats {
  ComputeSteamCollectionStats(this._stats, this._collection);

  static const int topCount = 5;

  final SteamStatsGateway _stats;
  final CollectionGateway _collection;

  Stream<SteamCollectionStats> call() => _stats.watchAll().asyncMap((games) async => statsOf(games, {for (final item in await _collection.allItems()) item.id: item}));

  SteamCollectionStats statsOf(List<SteamGameStats> games, Map<String, CollectionItem> itemsById) {
    final known = [for (final game in games) if (itemsById[game.itemId] != null) game];
    final completions = [
      for (final game in known)
        if (game.achievements case final progress? when progress.total > 0 && !game.wasNeverPlayed) progress.unlocked / progress.total,
    ];
    final value = <String, int>{};
    DateTime? pricedAt;
    for (final game in known) {
      if (game.storePrice case final price?) {
        value[price.currency] = (value[price.currency] ?? 0) + price.cents;
      }
      if (game.pricedAt case final at? when pricedAt == null || at.isAfter(pricedAt)) {
        pricedAt = at;
      }
    }
    final played = [for (final game in known) if (!game.wasNeverPlayed) PlayedGame(itemsById[game.itemId]!, game.playtimeMinutes)]..sort((first, second) => second.minutes.compareTo(first.minutes));
    return SteamCollectionStats(
      gameCount: known.length,
      totalMinutes: known.fold(0, (total, game) => total + game.playtimeMinutes),
      neverPlayed: [for (final game in known) if (game.wasNeverPlayed) itemsById[game.itemId]!],
      topPlayed: played.take(topCount).toList(),
      averageCompletion: completions.isEmpty ? null : completions.reduce((sum, completion) => sum + completion) / completions.length,
      libraryValue: value,
      pricedAt: pricedAt,
    );
  }
}
