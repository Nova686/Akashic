import 'package:akashic/layers/technical/Theme/akashic_empty_state.dart';
import 'package:akashic/layers/functional/Steam/domain/entities/steam_achievement.dart';
import 'package:akashic/layers/functional/Steam/domain/gateways/steam_player_api.dart';
import 'package:akashic/layers/functional/Steam/domain/use_cases/load_steam_achievements.dart';
import 'package:akashic/layers/functional/Steam/presentation/widgets/achievement_rarity_style.dart';
import 'package:akashic/layers/functional/Lookup/domain/entities/source_unavailable.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SteamAchievementsTab extends StatefulWidget {
  const SteamAchievementsTab({required this.load, super.key});

  final Future<List<SteamAchievement>> Function() load;

  @override
  State<SteamAchievementsTab> createState() => _SteamAchievementsTabState();
}

class _SteamAchievementsTabState extends State<SteamAchievementsTab> {
  late Future<List<SteamAchievement>> _achievements = widget.load();
  AchievementFilter _filter = AchievementFilter.all;
  AchievementSort _sort = AchievementSort.rarity;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FutureBuilder<List<SteamAchievement>>(
      future: _achievements,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Padding(padding: EdgeInsets.all(32), child: Center(child: LabelledSpinner()));
        }
        final failure = snapshot.error;
        if (failure != null) {
          return _Message(
            text: switch (failure) {
              SteamAccountMissing() => l10n.steamAchievementsNeedAccount,
              SteamProfilePrivate() => l10n.steamLibraryPrivate,
              SourceUnavailable() => l10n.steamAchievementsUnavailable,
              _ => l10n.steamAchievementsUnavailable,
            },
            onRetry: failure is SteamAccountMissing ? null : () => setState(() => _achievements = widget.load()),
          );
        }
        final achievements = snapshot.data ?? const <SteamAchievement>[];
        if (achievements.isEmpty) {
          return _Message(text: l10n.steamNoAchievements);
        }
        final arranged = arrangeAchievements(achievements, filter: _filter, sort: _sort);
        final sortLabel = switch (_sort) {
          AchievementSort.rarity => l10n.achievementSortRarity,
          AchievementSort.date => l10n.achievementSortDate,
          AchievementSort.name => l10n.achievementSortName,
        };
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 14),
            _AchievementSummary(achievements: achievements),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final (filter, label) in [
                  (AchievementFilter.all, l10n.achievementsAll),
                  (AchievementFilter.unlocked, l10n.achievementsUnlocked),
                  (AchievementFilter.locked, l10n.achievementsLocked),
                  (AchievementFilter.rare, l10n.achievementsRare),
                ])
                  ChoiceChip(label: Text(label), selected: _filter == filter, onSelected: (_) => setState(() => _filter = filter)),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.achievementsListCaption(arranged.length, _filter == AchievementFilter.all ? 'yes' : 'no', sortLabel),
                    style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => setState(() => _sort = AchievementSort.values[(_sort.index + 1) % AchievementSort.values.length]),
                  icon: const Icon(Icons.swap_vert, size: 18),
                  label: Text(toBeginningOfSentenceCase(sortLabel)),
                ),
              ],
            ),
            for (final achievement in arranged) _AchievementRow(achievement: achievement),
          ],
        );
      },
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.text, this.onRetry});

  final String text;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          Text(text, textAlign: TextAlign.center, style: AkashicTypography.body(size: 14).copyWith(color: AkashicColors.textSoft)),
          if (onRetry case final retry?) TextButton(onPressed: retry, child: Text(l10n.retry)),
        ],
      ),
    );
  }
}

class _AchievementSummary extends StatelessWidget {
  const _AchievementSummary({required this.achievements});

  final List<SteamAchievement> achievements;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final unlocked = achievements.where((achievement) => achievement.isUnlocked).length;
    final remaining = achievements.length - unlocked;
    final remainingLegendary = achievements.where((achievement) => !achievement.isUnlocked && achievement.rarity == AchievementRarity.legendary).length;
    final percent = (unlocked * 100 / achievements.length).round();
    return Semantics(
      label: l10n.achievementsSummary(unlocked, achievements.length, percent),
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AkashicColors.surface, borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            SizedBox.square(
              dimension: 76,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(value: unlocked / achievements.length, strokeWidth: 8, color: AkashicColors.lavender, backgroundColor: AkashicColors.line),
                  Center(child: Text('$percent %', style: AkashicTypography.numeral(size: 17))),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: '$unlocked', style: AkashicTypography.numeral(size: 28).copyWith(color: AkashicColors.lavender)),
                        TextSpan(text: ' / ${achievements.length}', style: AkashicTypography.numeral(size: 18).copyWith(color: AkashicColors.textSoft)),
                      ],
                    ),
                  ),
                  Text(l10n.achievementsRemaining(remaining, remainingLegendary), style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AchievementRow extends StatelessWidget {
  const _AchievementRow({required this.achievement});

  final SteamAchievement achievement;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final rarity = achievement.rarity;
    final color = rarityColor(rarity);
    final isLegendary = rarity == AchievementRarity.legendary;
    final iconUrl = achievement.isUnlocked ? achievement.iconUrl : achievement.lockedIconUrl ?? achievement.iconUrl;
    final description = achievement.isHidden && !achievement.isUnlocked ? l10n.hiddenAchievement : achievement.description;
    final percent = achievement.globalPercent;
    final state = achievement.unlockedAt == null ? l10n.achievementLocked : l10n.achievementUnlockedOn(DateFormat.yMMMd(l10n.localeName).format(achievement.unlockedAt!.toLocal()));
    return Semantics(
      label: [achievement.name, ?description, state, rarityLabel(l10n, rarity), if (percent != null) l10n.achievementPlayersPercent(NumberFormat.decimalPattern(l10n.localeName).format(percent))].join('. '),
      excludeSemantics: true,
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AkashicColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: isLegendary && achievement.isUnlocked ? Border.all(color: AkashicColors.gold.withValues(alpha: 0.7)) : null,
          boxShadow: isLegendary && achievement.isUnlocked ? [BoxShadow(color: AkashicColors.gold.withValues(alpha: 0.18), blurRadius: 14)] : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Opacity(
              opacity: achievement.isUnlocked ? 1 : 0.55,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox.square(
                  dimension: 48,
                  child: iconUrl == null
                      ? ColoredBox(color: AkashicColors.line, child: Icon(Icons.emoji_events_outlined, color: color))
                      : Image.network(iconUrl, fit: BoxFit.cover, cacheWidth: 96, errorBuilder: (context, error, stack) => ColoredBox(color: AkashicColors.line, child: Icon(Icons.emoji_events_outlined, color: color))),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(achievement.name, style: AkashicTypography.body(size: 15, weight: FontWeight.w700).copyWith(color: achievement.isUnlocked ? AkashicColors.text : AkashicColors.textSoft)),
                  if (description != null && description.isNotEmpty) Text(description, style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(border: Border.all(color: color.withValues(alpha: 0.6)), borderRadius: BorderRadius.circular(999)),
                        child: Text('${raritySymbol(rarity)} ${rarityLabel(l10n, rarity)}', style: AkashicTypography.body(size: 11, weight: FontWeight.w700).copyWith(color: color)),
                      ),
                      if (percent != null)
                        Text(l10n.achievementPlayersPercent(NumberFormat.decimalPattern(l10n.localeName).format(percent)), style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(state, style: AkashicTypography.body(size: 12).copyWith(color: achievement.isUnlocked ? AkashicColors.teal : AkashicColors.textSoft)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
