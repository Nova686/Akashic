import 'package:equatable/equatable.dart';

enum AchievementRarity { common, rare, epic, legendary }

AchievementRarity rarityOf(double? globalPercent) => switch (globalPercent) {
      null => AchievementRarity.common,
      < 1 => AchievementRarity.legendary,
      < 5 => AchievementRarity.epic,
      < 20 => AchievementRarity.rare,
      _ => AchievementRarity.common,
    };

class SteamAchievement extends Equatable {
  const SteamAchievement({
    required this.apiName,
    required this.name,
    this.description,
    this.iconUrl,
    this.lockedIconUrl,
    this.isHidden = false,
    this.unlockedAt,
    this.globalPercent,
  });

  final String apiName;
  final String name;
  final String? description;
  final String? iconUrl;
  final String? lockedIconUrl;
  final bool isHidden;
  final DateTime? unlockedAt;
  final double? globalPercent;

  bool get isUnlocked => unlockedAt != null;

  AchievementRarity get rarity => rarityOf(globalPercent);

  @override
  List<Object?> get props => [apiName, name, description, iconUrl, lockedIconUrl, isHidden, unlockedAt, globalPercent];
}

enum AchievementFilter { all, unlocked, locked, rare }

enum AchievementSort { rarity, date, name }

List<SteamAchievement> arrangeAchievements(List<SteamAchievement> achievements, {required AchievementFilter filter, required AchievementSort sort}) {
  final kept = [
    for (final achievement in achievements)
      if (switch (filter) {
        AchievementFilter.all => true,
        AchievementFilter.unlocked => achievement.isUnlocked,
        AchievementFilter.locked => !achievement.isUnlocked,
        AchievementFilter.rare => achievement.rarity != AchievementRarity.common,
      })
        achievement,
  ];
  int byCriterion(SteamAchievement first, SteamAchievement second) => switch (sort) {
        AchievementSort.rarity => (first.globalPercent ?? 100).compareTo(second.globalPercent ?? 100),
        AchievementSort.date => (second.unlockedAt ?? DateTime(0)).compareTo(first.unlockedAt ?? DateTime(0)),
        AchievementSort.name => first.name.toLowerCase().compareTo(second.name.toLowerCase()),
      };
  return kept
    ..sort((first, second) {
      if (filter == AchievementFilter.all && first.isUnlocked != second.isUnlocked) {
        return first.isUnlocked ? 1 : -1;
      }
      final compared = byCriterion(first, second);
      return compared != 0 ? compared : first.name.compareTo(second.name);
    });
}
