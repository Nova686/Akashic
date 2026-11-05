import 'package:akashic/layers/functional/Catalog/domain/entities/category_type.dart';
import 'package:akashic/layers/functional/Collection/domain/entities/item_progress.dart';
import 'package:akashic/layers/functional/Collection/presentation/views/deck_editor_view.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/progress_section.dart';
import 'package:akashic/layers/functional/Steam/domain/entities/steam_achievement.dart';
import 'package:akashic/layers/functional/Steam/domain/entities/steam_game_stats.dart';
import 'package:akashic/layers/functional/Steam/presentation/widgets/achievement_rarity_style.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SteamCopySummary {
  const SteamCopySummary({required this.platform, this.pricePaidCents, this.addedAt});

  final String platform;
  final int? pricePaidCents;
  final DateTime? addedAt;
}

String playtimeLabel(int minutes) => minutes < 60 ? '$minutes min' : (minutes % 60 == 0 || minutes >= 600 ? '${minutes ~/ 60} h' : '${minutes ~/ 60} h ${(minutes % 60).toString().padLeft(2, '0')}');

class SteamDashboard extends StatefulWidget {
  const SteamDashboard({
    required this.stats,
    required this.loadAchievements,
    required this.status,
    required this.onStatusChanged,
    required this.onOpenAchievements,
    this.copy,
    super.key,
  });

  final SteamGameStats? stats;
  final Future<List<SteamAchievement>> Function() loadAchievements;
  final ProgressStatus? status;
  final ValueChanged<ProgressStatus> onStatusChanged;
  final VoidCallback onOpenAchievements;
  final SteamCopySummary? copy;

  @override
  State<SteamDashboard> createState() => _SteamDashboardState();
}

class _SteamDashboardState extends State<SteamDashboard> {
  late final Future<List<SteamAchievement>> _achievements = widget.loadAchievements().catchError((Object _) => const <SteamAchievement>[], test: (error) => error is Exception);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final stats = widget.stats;
    final statuses = progressStatusesFor(CategoryType.videoGames);
    final status = widget.status;
    final isAutomatic = stats != null && status != null && stats.autoProgressStatus == status.name;
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (stats != null)
            _Tile(
              label: l10n.steamPlaytime,
              trailingLabel: 'Steam',
              semanticsLabel: l10n.steamPlaytimeSummary(playtimeLabel(stats.playtimeMinutes), playtimeLabel(stats.recentMinutes)),
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: stats.playtimeMinutes < 60 ? '${stats.playtimeMinutes}' : '${stats.playtimeMinutes ~/ 60}', style: AkashicTypography.numeral(size: 56)),
                      TextSpan(text: stats.playtimeMinutes < 60 ? ' min' : ' h', style: AkashicTypography.numeral(size: 20).copyWith(color: AkashicColors.textSoft)),
                    ],
                  ),
                ),
                Text(
                  [
                    if (stats.recentMinutes > 0) l10n.steamRecentPlaytime(playtimeLabel(stats.recentMinutes)) else l10n.steamNotPlayedRecently,
                    if (stats.lastPlayedAt case final lastPlayed?) l10n.steamLastPlayed(DateFormat.yMMMd(l10n.localeName).add_Hm().format(lastPlayed.toLocal())) else if (stats.wasNeverPlayed) l10n.steamNeverPlayed,
                  ].join('\n'),
                  style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft, height: 1.5),
                ),
              ],
            ),
          if (stats?.achievements case final progress? when progress.total > 0) ...[
            const SizedBox(height: 16),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: _AchievementsTile(progress: progress, achievements: _achievements, onTap: widget.onOpenAchievements)),
                  const SizedBox(width: 16),
                  Expanded(child: _RarestTile(achievements: _achievements)),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _Tile(
                    label: l10n.steamStatus,
                    children: [
                      Semantics(
                        button: true,
                        label: l10n.steamStatusChange(status == null ? l10n.steamNoStatus : progressStatusLabel(status, CategoryType.videoGames, l10n)),
                        onTap: () => widget.onStatusChanged(statuses[status == null ? 0 : (statuses.indexOf(status) + 1) % statuses.length]),
                        excludeSemantics: true,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(999),
                          onTap: () => widget.onStatusChanged(statuses[status == null ? 0 : (statuses.indexOf(status) + 1) % statuses.length]),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(minHeight: 48),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(14, 8, 10, 8),
                                decoration: BoxDecoration(color: AkashicColors.lavender, borderRadius: BorderRadius.circular(999)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(status == null ? l10n.steamNoStatus : progressStatusLabel(status, CategoryType.videoGames, l10n), style: AkashicTypography.body(size: 13, weight: FontWeight.w800).copyWith(color: AkashicColors.night)),
                                    const Icon(Icons.arrow_drop_down, size: 18, color: AkashicColors.night),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(isAutomatic ? l10n.steamStatusAutomatic : l10n.steamStatusManual, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _Tile(
                    label: l10n.steamDeck,
                    children: [
                      Row(
                        children: [
                          Icon(switch (stats?.deckStatus) {
                            SteamDeckStatus.verified => Icons.check_circle,
                            SteamDeckStatus.playable => Icons.info,
                            SteamDeckStatus.unsupported => Icons.block,
                            _ => Icons.help_outline,
                          }, size: 18, color: AkashicColors.lavender),
                          const SizedBox(width: 6),
                          Flexible(child: Text(steamDeckLabel(l10n, stats?.deckStatus), style: AkashicTypography.body(size: 14, weight: FontWeight.w700))),
                        ],
                      ),
                      Text(steamDeckDetail(l10n, stats?.deckStatus), style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (widget.copy case final copy?) ...[
            const SizedBox(height: 16),
            _Tile(
              label: l10n.steamMyCopy,
              children: [
                _KeyValue(label: l10n.steamCopyPlatform, value: copy.platform),
                if (copy.pricePaidCents case final cents?) _KeyValue(label: l10n.steamCopyPrice, value: formatMoney(cents, 'EUR', l10n.localeName)),
                if (copy.addedAt case final addedAt?) _KeyValue(label: l10n.steamCopyAdded, value: DateFormat.yMMMd(l10n.localeName).format(addedAt)),
              ],
            ),
          ],
          if (stats != null)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(l10n.steamUpdatedAt(DateFormat.yMMMd(l10n.localeName).add_Hm().format(stats.syncedAt.toLocal())), textAlign: TextAlign.center, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
            ),
        ],
      ),
    );
  }
}

String steamDeckLabel(AppLocalizations l10n, SteamDeckStatus? status) => switch (status) {
      SteamDeckStatus.verified => l10n.steamDeckVerified,
      SteamDeckStatus.playable => l10n.steamDeckPlayable,
      SteamDeckStatus.unsupported => l10n.steamDeckUnsupported,
      _ => l10n.steamDeckUnknown,
    };

String steamDeckDetail(AppLocalizations l10n, SteamDeckStatus? status) => switch (status) {
      SteamDeckStatus.verified => l10n.steamDeckVerifiedDetail,
      SteamDeckStatus.playable => l10n.steamDeckPlayableDetail,
      SteamDeckStatus.unsupported => l10n.steamDeckUnsupportedDetail,
      _ => l10n.steamDeckUnknownDetail,
    };

class _Tile extends StatelessWidget {
  const _Tile({required this.label, required this.children, this.trailingLabel, this.semanticsLabel});

  final String label;
  final String? trailingLabel;
  final String? semanticsLabel;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final tile = Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AkashicColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Color(0x40000000), blurRadius: 32, offset: Offset(0, 12))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label.toUpperCase(), style: AkashicTypography.body(size: 11, weight: FontWeight.w700).copyWith(color: AkashicColors.textSoft, letterSpacing: 1.1))),
              if (trailingLabel case final trailing?) Text(trailing, style: AkashicTypography.body(size: 11).copyWith(color: AkashicColors.textSoft)),
            ],
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
    return semanticsLabel == null ? tile : Semantics(label: semanticsLabel, excludeSemantics: true, child: tile);
  }
}

class _AchievementsTile extends StatelessWidget {
  const _AchievementsTile({required this.progress, required this.achievements, required this.onTap});

  final AchievementProgress progress;
  final Future<List<SteamAchievement>> achievements;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final percent = (progress.unlocked * 100 / progress.total).round();
    return Semantics(
      button: true,
      label: l10n.achievementsSummary(progress.unlocked, progress.total, percent),
      onTap: onTap,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: _Tile(
          label: l10n.achievementsTab,
          trailingLabel: '›',
          children: [
            SizedBox.square(
              dimension: 84,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(value: progress.unlocked / progress.total, strokeWidth: 6, strokeCap: StrokeCap.round, color: AkashicColors.lavender, backgroundColor: AkashicColors.lavender.withValues(alpha: 0.18)),
                  Center(child: Text('$percent %', style: AkashicTypography.numeral(size: 19))),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: '${progress.unlocked}', style: AkashicTypography.numeral(size: 24)),
                  TextSpan(text: ' / ${progress.total}', style: AkashicTypography.numeral(size: 14).copyWith(color: AkashicColors.textSoft)),
                ],
              ),
            ),
            FutureBuilder<List<SteamAchievement>>(
              future: achievements,
              builder: (context, snapshot) {
                final legendary = (snapshot.data ?? const <SteamAchievement>[]).where((achievement) => !achievement.isUnlocked && achievement.rarity == AchievementRarity.legendary).length;
                return Text(l10n.achievementsRemaining(progress.total - progress.unlocked, legendary), style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _RarestTile extends StatelessWidget {
  const _RarestTile({required this.achievements});

  final Future<List<SteamAchievement>> achievements;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FutureBuilder<List<SteamAchievement>>(
      future: achievements,
      builder: (context, snapshot) {
        final unlocked = [for (final achievement in snapshot.data ?? const <SteamAchievement>[]) if (achievement.isUnlocked && achievement.globalPercent != null) achievement]
          ..sort((first, second) => first.globalPercent!.compareTo(second.globalPercent!));
        final rarest = unlocked.firstOrNull;
        return _Tile(
          label: l10n.steamRarestAchievement,
          children: [
            if (snapshot.connectionState != ConnectionState.done)
              const Padding(padding: EdgeInsets.all(12), child: SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2)))
            else if (rarest == null)
              Text(l10n.steamNoRareAchievement, style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft))
            else ...[
              Container(
                width: 48,
                height: 48,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: rarest.rarity == AchievementRarity.legendary ? [BoxShadow(color: AkashicColors.gold.withValues(alpha: 0.35), blurRadius: 18)] : null,
                ),
                child: rarest.iconUrl == null ? ColoredBox(color: AkashicColors.line) : Image.network(rarest.iconUrl!, fit: BoxFit.cover, cacheWidth: 96, errorBuilder: (context, error, stack) => ColoredBox(color: AkashicColors.line)),
              ),
              const SizedBox(height: 6),
              Text(rarest.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(size: 14, weight: FontWeight.w800)),
              Text('${raritySymbol(rarest.rarity)} ${rarityLabel(l10n, rarest.rarity)}', style: AkashicTypography.body(size: 12, weight: FontWeight.w700).copyWith(color: rarityColor(rarest.rarity))),
              Text(l10n.achievementPlayersPercent(NumberFormat.decimalPattern(l10n.localeName).format(rarest.globalPercent)), style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
            ],
          ],
        );
      },
    );
  }
}

class _KeyValue extends StatelessWidget {
  const _KeyValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(child: Text(label, style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft))),
            Text(value, style: AkashicTypography.numeral(size: 14)),
          ],
        ),
      );
}

class SteamDashboardSection extends StatefulWidget {
  const SteamDashboardSection({
    required this.watchStats,
    required this.loadAchievements,
    required this.status,
    required this.onStatusChanged,
    required this.onOpenAchievements,
    this.copy,
    super.key,
  });

  final Stream<SteamGameStats?> Function() watchStats;
  final Future<List<SteamAchievement>> Function() loadAchievements;
  final ProgressStatus? status;
  final ValueChanged<ProgressStatus> onStatusChanged;
  final VoidCallback onOpenAchievements;
  final SteamCopySummary? copy;

  @override
  State<SteamDashboardSection> createState() => _SteamDashboardSectionState();
}

class _SteamDashboardSectionState extends State<SteamDashboardSection> {
  late final Stream<SteamGameStats?> _stats = widget.watchStats();

  @override
  Widget build(BuildContext context) => StreamBuilder<SteamGameStats?>(
        stream: _stats,
        builder: (context, snapshot) => SteamDashboard(
          stats: snapshot.data,
          loadAchievements: widget.loadAchievements,
          status: widget.status,
          onStatusChanged: widget.onStatusChanged,
          onOpenAchievements: widget.onOpenAchievements,
          copy: widget.copy,
        ),
      );
}
