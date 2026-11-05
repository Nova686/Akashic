import 'package:akashic/layers/functional/Steam/domain/entities/steam_game_stats.dart';
import 'package:equatable/equatable.dart';

class SteamWishWatch extends Equatable {
  const SteamWishWatch({required this.appId, required this.checkedAt, this.price, this.isComingSoon = false});

  final String appId;
  final StorePrice? price;
  final bool isComingSoon;
  final DateTime checkedAt;

  @override
  List<Object?> get props => [appId, price, isComingSoon, checkedAt];
}

class KnownSteamDlcs extends Equatable {
  const KnownSteamDlcs({required this.appId, required this.dlcIds, required this.checkedAt});

  final String appId;
  final Set<String> dlcIds;
  final DateTime checkedAt;

  @override
  List<Object?> get props => [appId, dlcIds, checkedAt];
}
