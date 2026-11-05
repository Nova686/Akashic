import 'dart:io';
import 'dart:ui' as ui;

import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/functional/Stats/domain/entities/recap.dart';
import 'package:akashic/layers/functional/Stats/presentation/views/stats_view.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_empty_state.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:akashic/layers/technical/Theme/safe_scroll_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class RecapView extends StatefulWidget {
  const RecapView({required this.loadMonth, required this.onOpenYear, required this.now, super.key});

  final Future<Recap> Function(DateTime month) loadMonth;
  final ValueChanged<int> onOpenYear;
  final DateTime now;

  @override
  State<RecapView> createState() => _RecapViewState();
}

class _RecapViewState extends State<RecapView> {
  late DateTime _month = DateTime(widget.now.year, widget.now.month);
  late Future<Recap> _recap = widget.loadMonth(_month);

  bool get _isCurrentMonth => _month.year == widget.now.year && _month.month == widget.now.month;

  void _shift(int months) => setState(() {
        _month = DateTime(_month.year, _month.month + months);
        _recap = widget.loadMonth(_month);
      });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final monthLabel = toBeginningOfSentenceCase(DateFormat.yMMMM(l10n.localeName).format(_month));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.monthlyRecap, style: AkashicTypography.displayTitle(size: 26))),
      body: ListView(
        padding: safeListPadding(context),
        children: [
          Row(
            children: [
              IconButton(tooltip: l10n.previousMonth, icon: const Icon(Icons.chevron_left), onPressed: () => _shift(-1)),
              Expanded(child: Text(monthLabel, textAlign: TextAlign.center, style: AkashicTypography.displayTitle(size: 22))),
              IconButton(tooltip: l10n.nextMonth, icon: const Icon(Icons.chevron_right), onPressed: _isCurrentMonth ? null : () => _shift(1)),
            ],
          ),
          FutureBuilder<Recap>(
            future: _recap,
            builder: (context, snapshot) => switch (snapshot.data) {
              null => const Padding(padding: EdgeInsets.only(top: 40), child: AkashicLoader()),
              final recap when recap.isEmpty => Padding(padding: const EdgeInsets.only(top: 40), child: AkashicEmptyState(message: l10n.recapEmptyMonth)),
              final recap => Semantics(liveRegion: true, child: _RecapTiles(recap: recap)),
            },
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(onPressed: () => widget.onOpenYear(_month.year), icon: const Icon(Icons.auto_awesome), label: Text(l10n.yearRecapOf(_month.year))),
        ],
      ),
    );
  }
}

class _RecapTiles extends StatelessWidget {
  const _RecapTiles({required this.recap});

  final Recap recap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final top = recap.mostValued.firstOrNull;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.5,
          children: [
            _RecapTile(label: l10n.recapAdded, value: '${recap.addedCount}', color: AkashicColors.lavender),
            _RecapTile(label: l10n.recapSpent, value: formatEuros(l10n, recap.spentCents), color: AkashicColors.gold),
            _RecapTile(label: l10n.recapFinished, value: '${recap.finishedCount}', color: AkashicColors.teal),
            _RecapTile(label: l10n.recapSeriesCompleted, value: '${recap.completedSeries.length}', color: AkashicColors.lavender),
          ],
        ),
        if (top != null) ...[
          const SizedBox(height: 14),
          Text(l10n.recapMostValued.toUpperCase(), style: AkashicTypography.body(size: 11, weight: FontWeight.w800).copyWith(color: AkashicColors.textSoft, letterSpacing: 1.1)),
          const SizedBox(height: 4),
          Text('${resolveDisplayTitle(top.titles, PreferredLanguages.defaults) ?? l10n.untitled} · ${formatEuros(l10n, top.marketValue!.cents)}', style: AkashicTypography.body(size: 15, weight: FontWeight.w700)),
        ],
        if (recap.completedSeries.isNotEmpty) ...[
          const SizedBox(height: 14),
          Text(l10n.recapSeriesCompleted.toUpperCase(), style: AkashicTypography.body(size: 11, weight: FontWeight.w800).copyWith(color: AkashicColors.textSoft, letterSpacing: 1.1)),
          const SizedBox(height: 4),
          Text(recap.completedSeries.join(' · '), style: AkashicTypography.body(size: 15, weight: FontWeight.w700)),
        ],
      ],
    );
  }
}

class _RecapTile extends StatelessWidget {
  const _RecapTile({required this.label, required this.value, required this.color});

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AkashicColors.surface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AkashicColors.line)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AkashicTypography.body(size: 12, weight: FontWeight.w700).copyWith(color: AkashicColors.textSoft)),
            Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: AkashicTypography.numeral(size: 26).copyWith(color: color)),
          ],
        ),
      );
}

class YearPosterView extends StatefulWidget {
  const YearPosterView({required this.year, required this.loadYear, super.key});

  final int year;
  final Future<Recap> Function(int year) loadYear;

  @override
  State<YearPosterView> createState() => _YearPosterViewState();
}

class _YearPosterViewState extends State<YearPosterView> {
  final GlobalKey _poster = GlobalKey();
  late final Future<Recap> _recap = widget.loadYear(widget.year);

  Future<void> _share() async {
    final boundary = _poster.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) {
      return;
    }
    final image = await boundary.toImage(pixelRatio: 3);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    if (bytes == null) {
      return;
    }
    final file = File('${Directory.systemTemp.path}/akashic-${widget.year}.png');
    await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
    await SharePlus.instance.share(ShareParams(files: [XFile(file.path, mimeType: 'image/png')]));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.yearRecapOf(widget.year), style: AkashicTypography.displayTitle(size: 24))),
      body: FutureBuilder<Recap>(
        future: _recap,
        builder: (context, snapshot) => switch (snapshot.data) {
          null => const AkashicLoader(),
          final recap => ListView(
              padding: safeListPadding(context),
              children: [
                RepaintBoundary(key: _poster, child: YearPoster(year: widget.year, recap: recap)),
                const SizedBox(height: 16),
                FilledButton.icon(onPressed: _share, icon: const Icon(Icons.ios_share), label: Text(l10n.shareImage)),
              ],
            ),
        },
      ),
    );
  }
}

class YearPoster extends StatelessWidget {
  const YearPoster({required this.year, required this.recap, super.key});

  final int year;
  final Recap recap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final change = recap.valueChangeCents;
    final tiles = [
      (l10n.recapAdded, '${recap.addedCount}', AkashicColors.lavender),
      (l10n.recapSpent, formatEuros(l10n, recap.spentCents), AkashicColors.gold),
      (l10n.recapFinished, '${recap.finishedCount}', AkashicColors.teal),
      (l10n.recapSeriesCompleted, '${recap.completedSeries.length}', AkashicColors.lavender),
      (l10n.recapValueChange, change == null ? '—' : '${change >= 0 ? '+' : '−'}${formatEuros(l10n, change.abs())}', change == null || change >= 0 ? AkashicColors.teal : AkashicColors.coral),
      (l10n.recapBusiestMonth, recap.busiestMonth == null ? '—' : toBeginningOfSentenceCase(DateFormat.MMMM(l10n.localeName).format(recap.busiestMonth!)), AkashicColors.gold),
    ];
    return AspectRatio(
      aspectRatio: 4 / 5,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(colors: [Color(0xFF241C52), AkashicColors.night], begin: Alignment.topLeft, end: Alignment.bottomRight),
          border: Border.all(color: AkashicColors.line, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Akashic', style: AkashicTypography.body(size: 12, weight: FontWeight.w800).copyWith(color: AkashicColors.textSoft, letterSpacing: 2)),
            FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft, child: Text('$year', style: AkashicTypography.numeral(size: 64).copyWith(color: AkashicColors.lavender, height: 1))),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1,
                children: [
                  for (final (label, value, color) in tiles)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: AkashicColors.surface, borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(label, maxLines: 2, style: AkashicTypography.body(size: 10, weight: FontWeight.w700).copyWith(color: AkashicColors.textSoft)),
                          FittedBox(fit: BoxFit.scaleDown, alignment: Alignment.centerLeft, child: Text(value, style: AkashicTypography.numeral(size: 20).copyWith(color: color))),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            if (recap.mostValued.isNotEmpty) ...[
              Text(l10n.recapTopValued.toUpperCase(), style: AkashicTypography.body(size: 10, weight: FontWeight.w800).copyWith(color: AkashicColors.textSoft, letterSpacing: 1.1)),
              for (final (index, item) in recap.mostValued.indexed)
                Text(
                  '${index + 1}. ${resolveDisplayTitle(item.titles, PreferredLanguages.defaults) ?? l10n.untitled} · ${formatEuros(l10n, item.marketValue!.cents)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AkashicTypography.body(size: 12, weight: FontWeight.w700),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
