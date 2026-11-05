import 'package:akashic/layers/functional/Steam/domain/entities/steam_achievement.dart';
import 'package:akashic/layers/functional/Steam/domain/gateways/steam_player_api.dart';

class SteamAccountMissing implements Exception {
  const SteamAccountMissing();
}

class LoadSteamAchievements {
  LoadSteamAchievements(this._api, this._steamIdOfLinkedAccount);

  final SteamPlayerApi _api;
  final Future<String?> Function() _steamIdOfLinkedAccount;

  Future<List<SteamAchievement>> call(String appId) async {
    final steamId = await _steamIdOfLinkedAccount();
    if (steamId == null || !_api.isConfigured) {
      throw const SteamAccountMissing();
    }
    return _api.achievements(steamId, appId);
  }
}
