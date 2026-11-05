import 'package:akashic/layers/functional/Steam/domain/entities/steam_game_stats.dart';

abstract interface class SteamStatsGateway {
  Stream<SteamGameStats?> watch(String itemId);
  Stream<List<SteamGameStats>> watchAll();
  Future<void> saveAll(List<SteamGameStats> stats);
}
