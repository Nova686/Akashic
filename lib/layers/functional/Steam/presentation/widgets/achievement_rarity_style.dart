import 'package:akashic/layers/functional/Steam/domain/entities/steam_achievement.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:flutter/material.dart';

Color rarityColor(AchievementRarity rarity) => switch (rarity) {
      AchievementRarity.common => AkashicColors.textSoft,
      AchievementRarity.rare => AkashicColors.teal,
      AchievementRarity.epic => AkashicColors.lavender,
      AchievementRarity.legendary => AkashicColors.gold,
    };

String raritySymbol(AchievementRarity rarity) => switch (rarity) {
      AchievementRarity.common => '○',
      AchievementRarity.rare => '◆',
      AchievementRarity.epic => '✦',
      AchievementRarity.legendary => '★',
    };

String rarityLabel(AppLocalizations l10n, AchievementRarity rarity) => switch (rarity) {
      AchievementRarity.common => l10n.rarityCommon,
      AchievementRarity.rare => l10n.rarityRare,
      AchievementRarity.epic => l10n.rarityEpic,
      AchievementRarity.legendary => l10n.rarityLegendary,
    };
