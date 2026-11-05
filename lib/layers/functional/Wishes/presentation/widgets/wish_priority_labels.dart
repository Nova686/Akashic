import 'package:akashic/layers/functional/Wishes/domain/entities/wish.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:flutter/material.dart';

String wishPriorityLabel(WishPriority priority, AppLocalizations l10n) => switch (priority) {
      WishPriority.mustHave => l10n.wishPriorityMustHave,
      WishPriority.want => l10n.wishPriorityWant,
      WishPriority.someday => l10n.wishPrioritySomeday,
    };

IconData wishPriorityIcon(WishPriority priority) => switch (priority) {
      WishPriority.mustHave => Icons.priority_high,
      WishPriority.want => Icons.favorite,
      WishPriority.someday => Icons.schedule,
    };

Color wishPriorityColor(WishPriority priority) => switch (priority) {
      WishPriority.mustHave => AkashicColors.gold,
      WishPriority.want => AkashicColors.lavender,
      WishPriority.someday => AkashicColors.teal,
    };
