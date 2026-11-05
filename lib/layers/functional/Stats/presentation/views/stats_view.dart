import 'package:akashic/layers/technical/Theme/akashic_empty_state.dart';
import 'package:akashic/layers/functional/Collection/presentation/views/deck_editor_view.dart';
import 'package:akashic/layers/functional/Stats/domain/entities/collection_stats.dart';
import 'package:akashic/layers/functional/Stats/domain/entities/collection_value.dart';
import 'package:akashic/layers/functional/Stats/presentation/cubit/collection_value_cubit.dart';
import 'package:akashic/layers/functional/Stats/presentation/cubit/collection_value_state.dart';
import 'package:akashic/layers/functional/Stats/presentation/cubit/stats_cubit.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/technical/Theme/safe_scroll_padding.dart';
import 'dart:math' as math;

import 'package:akashic/layers/functional/Steam/domain/use_cases/compute_steam_collection_stats.dart';
import 'package:akashic/layers/functional/Steam/presentation/widgets/steam_stats_section.dart';
import 'package:akashic/layers/functional/Stats/domain/entities/value_history.dart';
import 'package:akashic/layers/functional/Stats/presentation/widgets/value_trend_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class StatsView extends StatelessWidget {
  const StatsView({this.loadValueTrend, this.onOpenMissingVolumes, this.onOpenTrades, this.onOpenDuplicates, this.steamStats, this.onOpenItem, super.key});

  final VoidCallback? onOpenDuplicates;
  final Stream<SteamCollectionStats>? steamStats;
  final ValueChanged<String>? onOpenItem;
  final VoidCallback? onOpenTrades;
  final Future<ValueTrend> Function({int? months})? loadValueTrend;
  final VoidCallback? onOpenMissingVolumes;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<StatsCubit, CollectionStats?>(
      builder: (context, stats) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.statistics, style: AkashicTypography.displayTitle(size: 26)),
            actions: [if (onOpenTrades case final openTrades?) IconButton(tooltip: l10n.tradeHistory, icon: const Icon(Icons.receipt_long_outlined), onPressed: openTrades)],
          ),
          body: stats == null
              ? const Center(child: LabelledSpinner())
              : stats.itemCount == 0
                  ? Center(child: Text(l10n.noStatsYet, style: AkashicTypography.body().copyWith(color: AkashicColors.textSoft)))
                  : ListView(
                      padding: safeListPadding(context),
                      children: [
                        _TotalCard(stats: stats),
                        const SizedBox(height: 14),
                        _ValueSection(onOpenDuplicates: onOpenDuplicates),
                        if (loadValueTrend case final loadTrend?) ValueTrendSection(loadTrend: loadTrend),
                        if (onOpenMissingVolumes case final openMissingVolumes?) ...[
                          const SizedBox(height: 10),
                          OutlinedButton.icon(onPressed: openMissingVolumes, icon: const Icon(Icons.auto_stories_outlined), label: Text(l10n.missingVolumesTitle)),
                        ],
                        const SizedBox(height: 22),
                        Text(l10n.byCategory, style: AkashicTypography.displayTitle(size: 22)),
                        const SizedBox(height: 12),
                        _CategoryDonut(categories: stats.categories),
                        const SizedBox(height: 8),
                        for (final (index, category) in stats.categories.indexed) _CategoryBar(stat: category, largestCount: _largestItemCount(stats), color: AkashicColors.chartColor(index)),
                        const SizedBox(height: 22),
                        Text(l10n.purchasesByMonth, style: AkashicTypography.displayTitle(size: 22)),
                        const SizedBox(height: 12),
                        _MonthlyChart(months: stats.months),
                        if (steamStats case final steam?)
                          StreamBuilder<SteamCollectionStats>(
                            stream: steam,
                            builder: (context, snapshot) => switch (snapshot.data) {
                              final steamCollection? when steamCollection.gameCount > 0 => SteamStatsSection(stats: steamCollection, onOpenItem: onOpenItem),
                              _ => const SizedBox.shrink(),
                            },
                          ),
                        if (stats.years.length > 1) ...[
                          const SizedBox(height: 22),
                          Text(l10n.additionsByYear, style: AkashicTypography.displayTitle(size: 22)),
                          const SizedBox(height: 12),
                          _YearlyChart(years: stats.years),
                        ],
                        if (stats.series.total > 0) ...[
                          const SizedBox(height: 22),
                          Text(l10n.seriesCompletionTitle, style: AkashicTypography.displayTitle(size: 22)),
                          const SizedBox(height: 12),
                          _SeriesShareRing(share: stats.series),
                        ],
                      ],
                    ),
        );
      },
    );
  }

  int _largestItemCount(CollectionStats stats) => stats.categories.fold(1, (largest, category) => category.itemCount > largest ? category.itemCount : largest);
}

String formatEuros(AppLocalizations l10n, int cents) => NumberFormat.currency(locale: l10n.localeName, symbol: '€').format(cents / 100);

class _TotalCard extends StatelessWidget {
  const _TotalCard({required this.stats});

  final CollectionStats stats;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: AkashicColors.surface, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.totalPaid, style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft)),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(formatEuros(l10n, stats.totalPaidCents), style: AkashicTypography.numeral(size: 36).copyWith(color: AkashicColors.lavender)),
          ),
          Text(l10n.itemCount(stats.itemCount), style: AkashicTypography.body(size: 13)),
        ],
      ),
    );
  }
}

class _CategoryBar extends StatelessWidget {
  const _CategoryBar({required this.stat, required this.largestCount, required this.color});

  final CategoryStat stat;
  final int largestCount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final color = this.color;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle, boxShadow: [BoxShadow(color: color.withValues(alpha: 0.6), blurRadius: 6)])),
              const SizedBox(width: 8),
              Expanded(child: Text(stat.category.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(size: 14, weight: FontWeight.w600))),
              Text('${stat.itemCount}', style: AkashicTypography.numeral(size: 13)),
              const SizedBox(width: 12),
              Text(formatEuros(l10n, stat.paidCents), style: AkashicTypography.numeral(size: 12).copyWith(color: AkashicColors.textSoft)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: stat.itemCount / largestCount, minHeight: 6, color: color, backgroundColor: AkashicColors.line),
          ),
        ],
      ),
    );
  }
}

class _MonthlyChart extends StatelessWidget {
  const _MonthlyChart({required this.months});

  static const double chartHeight = 120;

  final List<MonthlyPurchases> months;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final busiest = months.fold(1, (largest, month) => month.copyCount > largest ? month.copyCount : largest);
    return SizedBox(
      height: chartHeight + 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final month in months)
            Expanded(
              child: Tooltip(
                message: l10n.monthSummary(DateFormat.yMMM(l10n.localeName).format(month.month), month.copyCount, formatEuros(l10n, month.paidCents)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (month.copyCount > 0) Text('${month.copyCount}', style: AkashicTypography.numeral(size: 10)),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      height: chartHeight * month.copyCount / busiest + 2,
                      decoration: BoxDecoration(
                        color: month.copyCount == 0 ? AkashicColors.line : AkashicColors.lavender,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(DateFormat.MMM(l10n.localeName).format(month.month).substring(0, 1).toUpperCase(), style: AkashicTypography.body(size: 10).copyWith(color: AkashicColors.textSoft)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

String formatAmounts(Map<String, int> byCurrency, String localeName) =>
    byCurrency.isEmpty ? formatMoney(0, 'EUR', localeName) : [for (final MapEntry(key: currency, value: cents) in byCurrency.entries) formatMoney(cents, currency, localeName)].join(' + ');

class _ValueSection extends StatelessWidget {
  const _ValueSection({this.onOpenDuplicates});

  final VoidCallback? onOpenDuplicates;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocBuilder<CollectionValueCubit, CollectionValueState>(
      builder: (context, state) {
        final value = state.value;
        if (value == null) {
          return const SizedBox.shrink();
        }
        final duplicateCount = state.duplicates?.count ?? 0;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: AkashicColors.surface, borderRadius: BorderRadius.circular(20)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.estimatedValue, style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft)),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text('≈ ${formatAmounts(value.totalByCurrency, l10n.localeName)}', style: AkashicTypography.numeral(size: 32).copyWith(color: AkashicColors.teal)),
                  ),
                  Text(l10n.valuedItemsSummary(value.marketValuedItems, value.purchaseValuedItems, value.unvaluedItems), style: AkashicTypography.body(size: 13)),
                  const SizedBox(height: 6),
                  Text(l10n.estimatedValueExplanation, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
                  if (value.lastValuedAt case final valuedAt?)
                    Text(l10n.marketValuedOn(DateFormat.yMMMd(l10n.localeName).format(valuedAt)), style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
                  if (state.lastRefresh case ValueRefresh(isComplete: false))
                    Text(l10n.marketValuesIncomplete, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
                  const SizedBox(height: 8),
                  if (state.isRefreshing)
                    Row(
                      children: [
                        const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2)),
                        const SizedBox(width: 10),
                        Expanded(child: Text(l10n.updatingMarketValues(state.refreshDone, state.refreshTotal), style: AkashicTypography.body(size: 13))),
                      ],
                    )
                  else
                    TextButton.icon(
                      onPressed: context.read<CollectionValueCubit>().refreshMarketValues,
                      icon: const Icon(Icons.sync, color: AkashicColors.teal),
                      label: Text(l10n.updateMarketValues, style: AkashicTypography.body(weight: FontWeight.w600).copyWith(color: AkashicColors.teal)),
                    ),
                ],
              ),
            ),
            if (value.categories.any((category) => category.byCurrency.isNotEmpty)) ...[
              const SizedBox(height: 18),
              Text(l10n.valueByCategory, style: AkashicTypography.displayTitle(size: 22)),
              const SizedBox(height: 4),
              for (final (index, category) in value.categories.indexed)
                if (category.byCurrency.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Container(width: 8, height: 8, decoration: BoxDecoration(color: AkashicColors.chartColor(index), shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        Expanded(child: Text(category.category.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(size: 14, weight: FontWeight.w600))),
                        Text('≈ ${formatAmounts(category.byCurrency, l10n.localeName)}', style: AkashicTypography.numeral(size: 13)),
                      ],
                    ),
                  ),
            ],
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.copy_all_outlined, color: AkashicColors.lavender),
              title: Text(duplicateCount == 0 ? l10n.noDuplicates : l10n.duplicatesCount(duplicateCount), style: AkashicTypography.body(size: 15, weight: FontWeight.w600)),
              trailing: duplicateCount == 0 ? null : const Icon(Icons.chevron_right),
              onTap: duplicateCount == 0 ? null : onOpenDuplicates,
            ),
          ],
        );
      },
    );
  }
}

class _CategoryDonut extends StatelessWidget {
  const _CategoryDonut({required this.categories});

  final List<CategoryStat> categories;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final filled = [for (final (index, category) in categories.indexed) if (category.itemCount > 0) (category, AkashicColors.chartColor(index))];
    final total = filled.fold(0, (sum, entry) => sum + entry.$1.itemCount);
    if (total == 0) {
      return const SizedBox.shrink();
    }
    final summary = [for (final (category, _) in filled) l10n.categoryShare(category.category.name, (category.itemCount * 100 / total).round())].join(', ');
    return Semantics(
      label: summary,
      excludeSemantics: true,
      child: Row(
        children: [
          SizedBox.square(
            dimension: 120,
            child: CustomPaint(
              painter: _DonutPainter(slices: [for (final (category, color) in filled) (category.itemCount / total, color)], trackColor: AkashicColors.line),
              child: Center(child: Text('$total', style: AkashicTypography.numeral(size: 26))),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final (category, color) in filled)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                        const SizedBox(width: 8),
                        Expanded(child: Text(category.category.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(size: 13))),
                        Text('${(category.itemCount * 100 / total).round()} %', style: AkashicTypography.numeral(size: 12).copyWith(color: AkashicColors.textSoft)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  const _DonutPainter({required this.slices, required this.trackColor});

  static const double strokeWidth = 16;
  static const double gap = 0.03;

  final List<(double, Color)> slices;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final bounds = (Offset.zero & size).deflate(strokeWidth / 2);
    canvas.drawArc(bounds, 0, math.pi * 2, false, Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = trackColor);
    var start = -math.pi / 2;
    for (final (fraction, color) in slices) {
      final sweep = math.pi * 2 * fraction;
      canvas.drawArc(bounds, start + (slices.length > 1 ? gap / 2 : 0), math.max(sweep - (slices.length > 1 ? gap : 0), 0.001), false, Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.butt
        ..color = color);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(_DonutPainter oldDelegate) => oldDelegate.slices != slices;
}

class _YearlyChart extends StatelessWidget {
  const _YearlyChart({required this.years});

  static const double chartHeight = 100;

  final List<YearlyAdditions> years;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final shown = years.length > 8 ? years.sublist(years.length - 8) : years;
    final busiest = shown.fold(1, (largest, year) => year.copyCount > largest ? year.copyCount : largest);
    return Semantics(
      label: [for (final year in shown) l10n.yearAdditions(year.year.toString(), year.copyCount)].join(', '),
      excludeSemantics: true,
      child: SizedBox(
        height: chartHeight + 40,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (final year in shown)
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('${year.copyCount}', style: AkashicTypography.numeral(size: 11)),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      height: chartHeight * year.copyCount / busiest + 2,
                      decoration: BoxDecoration(color: year.copyCount == 0 ? AkashicColors.line : AkashicColors.teal, borderRadius: BorderRadius.circular(3)),
                    ),
                    const SizedBox(height: 4),
                    Text('${year.year}', style: AkashicTypography.numeral(size: 11).copyWith(color: AkashicColors.textSoft)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SeriesShareRing extends StatelessWidget {
  const _SeriesShareRing({required this.share});

  final SeriesShare share;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final percent = (share.complete * 100 / share.total).round();
    return Semantics(
      label: l10n.seriesCompletionSummary(share.complete, share.total),
      excludeSemantics: true,
      child: Row(
        children: [
          SizedBox.square(
            dimension: 84,
            child: CustomPaint(
              painter: _DonutPainter(slices: [(share.complete / share.total, AkashicColors.lavender)], trackColor: AkashicColors.line),
              child: Center(child: Text('$percent %', style: AkashicTypography.numeral(size: 16))),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(child: Text(l10n.seriesCompletionSummary(share.complete, share.total), style: AkashicTypography.body(size: 14))),
        ],
      ),
    );
  }
}
