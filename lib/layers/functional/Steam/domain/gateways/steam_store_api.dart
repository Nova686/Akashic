import 'package:akashic/layers/functional/Steam/domain/entities/steam_store_page.dart';

abstract interface class SteamStoreApi {
  Future<SteamStorePage?> storePage(String appId);
  Future<List<SteamNews>> news(String appId);
  Future<SteamDlc?> dlc(String appId);
}
