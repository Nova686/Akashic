import 'package:equatable/equatable.dart';

enum SteamDeckStatus { unknown, unsupported, playable, verified }

class StorePrice extends Equatable {
  const StorePrice({required this.cents, required this.currency, this.initialCents, this.discountPercent = 0});

  final int cents;
  final String currency;
  final int? initialCents;
  final int discountPercent;

  bool get isDiscounted => discountPercent > 0;

  @override
  List<Object?> get props => [cents, currency, initialCents, discountPercent];
}

class SteamOwnedGame extends Equatable {
  const SteamOwnedGame({required this.appId, required this.name, required this.playtimeMinutes, required this.recentMinutes, this.lastPlayedAt});

  final String appId;
  final String name;
  final int playtimeMinutes;
  final int recentMinutes;
  final DateTime? lastPlayedAt;

  @override
  List<Object?> get props => [appId, name, playtimeMinutes, recentMinutes, lastPlayedAt];
}

class AchievementProgress extends Equatable {
  const AchievementProgress({required this.unlocked, required this.total});

  final int unlocked;
  final int total;

  bool get isComplete => total > 0 && unlocked == total;

  @override
  List<Object?> get props => [unlocked, total];
}

class SteamGameStats extends Equatable {
  const SteamGameStats({
    required this.itemId,
    required this.appId,
    required this.syncedAt,
    this.playtimeMinutes = 0,
    this.recentMinutes = 0,
    this.lastPlayedAt,
    this.achievements,
    this.achievementsCheckedAt,
    this.deckStatus,
    this.deckCheckedAt,
    this.autoProgressStatus,
    this.storePrice,
    this.pricedAt,
  });

  final String itemId;
  final String appId;
  final int playtimeMinutes;
  final int recentMinutes;
  final DateTime? lastPlayedAt;
  final AchievementProgress? achievements;
  final DateTime? achievementsCheckedAt;
  final SteamDeckStatus? deckStatus;
  final DateTime? deckCheckedAt;
  final String? autoProgressStatus;
  final StorePrice? storePrice;
  final DateTime? pricedAt;
  final DateTime syncedAt;

  bool get wasNeverPlayed => playtimeMinutes == 0;

  @override
  List<Object?> get props => [itemId, appId, playtimeMinutes, recentMinutes, lastPlayedAt, achievements, achievementsCheckedAt, deckStatus, deckCheckedAt, autoProgressStatus, storePrice, pricedAt, syncedAt];
}
