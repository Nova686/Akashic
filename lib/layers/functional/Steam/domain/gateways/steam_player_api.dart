import 'package:akashic/layers/functional/Steam/domain/entities/steam_achievement.dart';
import 'package:akashic/layers/functional/Steam/domain/entities/steam_game_stats.dart';

class SteamProfilePrivate implements Exception {
  const SteamProfilePrivate();
}

class SteamWishlistItem {
  const SteamWishlistItem({required this.appId, this.priority = 0, this.addedAt});

  final String appId;
  final int priority;
  final DateTime? addedAt;
}

abstract interface class SteamPlayerApi {
  bool get isConfigured;
  Future<List<SteamOwnedGame>> ownedGames(String steamId);
  Future<AchievementProgress?> achievementProgress(String steamId, String appId);
  Future<SteamDeckStatus> deckStatus(String appId);
  Future<List<SteamAchievement>> achievements(String steamId, String appId);
  Future<Map<String, StorePrice?>> storePrices(List<String> appIds);
  Future<List<SteamWishlistItem>> wishlist(String steamId);
}
