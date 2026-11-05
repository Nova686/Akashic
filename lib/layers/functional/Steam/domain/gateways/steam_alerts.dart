import 'package:akashic/layers/functional/Steam/domain/entities/steam_game_stats.dart';

abstract interface class SteamAlerts {
  Future<void> wishOnSale(String title, StorePrice price);
  Future<void> wishReleased(String title);
  Future<void> newDlcs(String gameTitle, List<String> dlcNames);
  Future<void> wishUnderMaximum(String title, StorePrice price, int maxPriceCents);
}
