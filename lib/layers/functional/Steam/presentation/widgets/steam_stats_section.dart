import 'dart:io';

import 'package:akashic/layers/functional/Collection/domain/entities/collection_item.dart';
import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/functional/Stats/presentation/views/stats_view.dart';
import 'package:akashic/layers/functional/Steam/domain/use_cases/compute_steam_collection_stats.dart';
import 'package:akashic/layers/functional/Steam/presentation/widgets/steam_dashboard.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SteamStatsSection extends StatelessWidget {
  const SteamStatsSection({required this.stats, this.onOpenItem, super.key});

  final SteamCollectionStats stats;
  final ValueChanged<String>? onOpenItem;

  String _titleOf(CollectionItem item, AppLocalizations l10n) => resolveDisplayTitle(item.titles, PreferredLanguages.defaults) ?? l10n.untitled;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final completion = stats.averageCompletion;
    final busiest = stats.topPlayed.fold(1, (most, game) => game.minutes > most ? game.minutes : most);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 22),
        Semantics(header: true, child: Text(l10n.steamStatsTitle, style: AkashicTypography.displayTitle(size: 22))),
        const SizedBox(height: 12),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _StatTile(label: l10n.steamTotalPlaytime, value: playtimeLabel(stats.totalMinutes), caption: l10n.steamGameCount(stats.gameCount))),
              const SizedBox(width: 12),
              Expanded(
                child: _StatTile(
                  label: l10n.steamAverageCompletion,
                  value: completion == null ? '—' : '${(completion * 100).round()} %',
                  caption: l10n.steamAverageCompletionCaption,
                ),
              ),
            ],
          ),
        ),
        if (stats.neverPlayed.isNotEmpty) ...[
          const SizedBox(height: 12),
          _Card(
            label: l10n.steamShelfOfShame,
            children: [
              Text(l10n.steamNeverLaunchedCount(stats.neverPlayed.length), style: AkashicTypography.numeral(size: 24)),
              const SizedBox(height: 10),
              SizedBox(
                height: 72,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    const coverWidth = 48.0;
                    const gap = 6.0;
                    const moreWidth = 44.0;
                    final fitting = ((constraints.maxWidth + gap) / (coverWidth + gap)).floor();
                    final shown = stats.neverPlayed.length <= fitting ? stats.neverPlayed.length : ((constraints.maxWidth - moreWidth + gap) / (coverWidth + gap)).floor().clamp(0, stats.neverPlayed.length);
                    final hidden = stats.neverPlayed.length - shown;
                    return Row(
                      children: [
                        for (final item in stats.neverPlayed.take(shown))
                          Padding(
                            padding: const EdgeInsets.only(right: gap),
                            child: Semantics(
                              button: onOpenItem != null,
                              label: _titleOf(item, l10n),
                              onTap: onOpenItem == null ? null : () => onOpenItem!(item.id),
                              excludeSemantics: true,
                              child: InkWell(
                                onTap: onOpenItem == null ? null : () => onOpenItem!(item.id),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: SizedBox(
                                    width: coverWidth,
                                    height: 72,
                                    child: item.imagePath == null
                                        ? ColoredBox(color: Color(item.spineColorValue ?? AkashicColors.line.toARGB32()))
                                        : Image.file(File(item.imagePath!), fit: BoxFit.cover, cacheWidth: 120, errorBuilder: (context, error, stack) => ColoredBox(color: AkashicColors.line)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        if (hidden > 0)
                          SizedBox(
                            width: moreWidth,
                            child: Text('+$hidden', textAlign: TextAlign.center, style: AkashicTypography.numeral(size: 16).copyWith(color: AkashicColors.textSoft)),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ],
        if (stats.topPlayed.isNotEmpty) ...[
          const SizedBox(height: 12),
          _Card(
            label: l10n.steamTopPlayed,
            children: [
              for (final game in stats.topPlayed)
                Semantics(
                  label: '${_titleOf(game.item, l10n)}, ${playtimeLabel(game.minutes)}',
                  onTap: onOpenItem == null ? null : () => onOpenItem!(game.item.id),
                  excludeSemantics: true,
                  child: InkWell(
                    onTap: onOpenItem == null ? null : () => onOpenItem!(game.item.id),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(child: Text(_titleOf(game.item, l10n), maxLines: 1, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(size: 14, weight: FontWeight.w600))),
                              Text(playtimeLabel(game.minutes), style: AkashicTypography.numeral(size: 14)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(value: game.minutes / busiest, minHeight: 6, color: AkashicColors.lavender, backgroundColor: AkashicColors.line),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
        if (stats.libraryValue.isNotEmpty) ...[
          const SizedBox(height: 12),
          _Card(
            label: l10n.steamLibraryValue,
            children: [
              Text(formatAmounts(stats.libraryValue, l10n.localeName), style: AkashicTypography.numeral(size: 28).copyWith(color: AkashicColors.teal)),
              const SizedBox(height: 4),
              Text(
                [l10n.steamLibraryValueNote, if (stats.pricedAt case final pricedAt?) l10n.steamPricesOf(DateFormat.yMMMd(l10n.localeName).format(pricedAt.toLocal()))].join(' · '),
                style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.label, required this.children});

  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AkashicColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: Color(0x40000000), blurRadius: 32, offset: Offset(0, 12))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(label.toUpperCase(), style: AkashicTypography.body(size: 11, weight: FontWeight.w700).copyWith(color: AkashicColors.textSoft, letterSpacing: 1.1)),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      );
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value, required this.caption});

  final String label;
  final String value;
  final String caption;

  @override
  Widget build(BuildContext context) => _Card(
        label: label,
        children: [
          Text(value, style: AkashicTypography.numeral(size: 28)),
          Text(caption, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
        ],
      );
}
