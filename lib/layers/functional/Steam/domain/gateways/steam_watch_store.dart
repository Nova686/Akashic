import 'package:akashic/layers/functional/Steam/domain/entities/steam_wish_watch.dart';

abstract interface class SteamWatchStore {
  Future<Map<String, SteamWishWatch>> wishWatches();
  Stream<Map<String, SteamWishWatch>> watchWishWatches();
  Future<void> saveWishWatches(Iterable<SteamWishWatch> watches);
  Future<KnownSteamDlcs?> knownDlcsOf(String appId);
  Future<void> saveKnownDlcs(KnownSteamDlcs known);
}
