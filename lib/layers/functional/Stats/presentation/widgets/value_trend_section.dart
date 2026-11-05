import 'dart:io';

import 'package:akashic/layers/functional/Collection/domain/use_cases/resolve_display_title.dart';
import 'package:akashic/layers/functional/Settings/domain/entities/preferred_languages.dart';
import 'package:akashic/layers/functional/Stats/domain/entities/value_history.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const Color _fallColor = Color(0xFFFF8A80);

class ValueTrendSection extends StatefulWidget {
  const ValueTrendSection({required this.loadTrend, super.key});

  final Future<ValueTrend> Function({int? months}) loadTrend;

  @override
  State<ValueTrendSection> createState() => _ValueTrendSectionState();
}

class _ValueTrendSectionState extends State<ValueTrendSection> {
  static const List<int?> _periods = [6, 12, null];

  int? _months = 12;
  late Future<ValueTrend> _trend = widget.loadTrend(months: _months);
  int? _touchedIndex;

  void _choose(int? months) => setState(() {
        _months = months;
        _touchedIndex = null;
        _trend = widget.loadTrend(months: months);
      });

  int _indexAt(double dx, double width, int count) => ((dx / width) * (count - 1)).round().clamp(0, count - 1);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final euros = NumberFormat.simpleCurrency(locale: l10n.localeName, name: 'EUR', decimalDigits: 0);
    return FutureBuilder<ValueTrend>(
      future: _trend,
      builder: (context, snapshot) {
        final trend = snapshot.data;
        final points = [
          if (trend != null)
            for (final point in trend.points)
              if (point.totals[trend.currency] case final cents?) (point.month, cents),
        ];
        final shownIndex = _touchedIndex ?? points.length - 1;
        String pointLabel(int index) => '${toBeginningOfSentenceCase(DateFormat.yMMMM(l10n.localeName).format(points[index].$1))} · ${euros.format(points[index].$2 / 100)}';
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 22),
            Text(l10n.valueOverTime, style: AkashicTypography.displayTitle(size: 22)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                for (final months in _periods)
                  ChoiceChip(
                    label: Text(switch (months) {
                      6 => l10n.lastSixMonths,
                      12 => l10n.lastYear,
                      _ => l10n.wholeHistory,
                    }),
                    selected: _months == months,
                    onSelected: (_) => _choose(months),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            if (points.length < 2)
              Text(l10n.valueHistoryFilling, style: AkashicTypography.body(size: 13).copyWith(color: AkashicColors.textSoft))
            else ...[
              Semantics(
                label: l10n.valueChartSummary(
                  euros.format(points.first.$2 / 100),
                  euros.format(points.last.$2 / 100),
                  euros.format(points.map((point) => point.$2).reduce((lowest, cents) => cents < lowest ? cents : lowest) / 100),
                  euros.format(points.map((point) => point.$2).reduce((highest, cents) => cents > highest ? cents : highest) / 100),
                ),
                value: pointLabel(shownIndex),
                increasedValue: shownIndex < points.length - 1 ? pointLabel(shownIndex + 1) : null,
                decreasedValue: shownIndex > 0 ? pointLabel(shownIndex - 1) : null,
                onIncrease: shownIndex < points.length - 1 ? () => setState(() => _touchedIndex = shownIndex + 1) : null,
                onDecrease: shownIndex > 0 ? () => setState(() => _touchedIndex = shownIndex - 1) : null,
                excludeSemantics: true,
                child: LayoutBuilder(
                builder: (context, constraints) => GestureDetector(
                  onHorizontalDragUpdate: (details) => setState(() => _touchedIndex = _indexAt(details.localPosition.dx, constraints.maxWidth, points.length)),
                  onTapDown: (details) => setState(() => _touchedIndex = _indexAt(details.localPosition.dx, constraints.maxWidth, points.length)),
                  child: CustomPaint(
                    size: Size(constraints.maxWidth, 170),
                    painter: _ValueChartPainter(values: [for (final (_, cents) in points) cents], touchedIndex: _touchedIndex, lineColor: AkashicColors.teal, gridColor: AkashicColors.line),
                  ),
                ),
              ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  '${toBeginningOfSentenceCase(DateFormat.yMMMM(l10n.localeName).format(points[shownIndex].$1))} · ${euros.format(points[shownIndex].$2 / 100)}',
                  style: AkashicTypography.numeral(size: 15),
                ),
              ),
            ],
            Text(l10n.valueHistoryNote, style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft)),
            if (trend != null && trend.risers.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(l10n.biggestRises.toUpperCase(), style: AkashicTypography.body(size: 11, weight: FontWeight.w700).copyWith(color: AkashicColors.textSoft, letterSpacing: 1.1)),
              for (final change in trend.risers) _MoverRow(change: change, color: AkashicColors.teal),
            ],
            if (trend != null && trend.fallers.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(l10n.biggestFalls.toUpperCase(), style: AkashicTypography.body(size: 11, weight: FontWeight.w700).copyWith(color: AkashicColors.textSoft, letterSpacing: 1.1)),
              for (final change in trend.fallers) _MoverRow(change: change, color: _fallColor),
            ],
          ],
        );
      },
    );
  }
}

class _MoverRow extends StatelessWidget {
  const _MoverRow({required this.change, required this.color});

  final ItemValueChange change;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final money = NumberFormat.simpleCurrency(locale: l10n.localeName, name: change.currency, decimalDigits: 0);
    final sign = change.deltaCents > 0 ? '+' : '−';
    final title = resolveDisplayTitle(change.item.titles, PreferredLanguages.defaults) ?? l10n.untitled;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: SizedBox(
              width: 32,
              height: 44,
              child: change.item.imagePath == null
                  ? ColoredBox(color: AkashicColors.line)
                  : Image.file(File(change.item.imagePath!), fit: BoxFit.cover, cacheWidth: 96, errorBuilder: (context, error, stack) => ColoredBox(color: AkashicColors.line)),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(size: 14, weight: FontWeight.w700))),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('$sign${money.format(change.deltaCents.abs() / 100)}', style: AkashicTypography.numeral(size: 14).copyWith(color: color)),
              Text('$sign${(change.ratio.abs() * 100).round()} %', style: AkashicTypography.body(size: 11).copyWith(color: AkashicColors.textSoft)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ValueChartPainter extends CustomPainter {
  _ValueChartPainter({required this.values, required this.touchedIndex, required this.lineColor, required this.gridColor});

  final List<int> values;
  final int? touchedIndex;
  final Color lineColor;
  final Color gridColor;

  @override
  void paint(Canvas canvas, Size size) {
    final lowest = values.reduce((first, second) => first < second ? first : second);
    final highest = values.reduce((first, second) => first > second ? first : second);
    final span = highest - lowest == 0 ? 1 : highest - lowest;
    Offset pointAt(int index) => Offset(size.width * index / (values.length - 1), size.height - 8 - (values[index] - lowest) / span * (size.height - 24));
    final grid = Paint()
      ..color = gridColor
      ..strokeWidth = 1;
    for (final fraction in [0.0, 0.5, 1.0]) {
      final y = size.height - 8 - fraction * (size.height - 24);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }
    final line = Path()..moveTo(pointAt(0).dx, pointAt(0).dy);
    for (var index = 1; index < values.length; index++) {
      line.lineTo(pointAt(index).dx, pointAt(index).dy);
    }
    final area = Path.from(line)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(area, Paint()..shader = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [lineColor.withValues(alpha: 0.28), lineColor.withValues(alpha: 0)]).createShader(Offset.zero & size));
    canvas.drawPath(
      line,
      Paint()
        ..color = lineColor
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke,
    );
    final markedPoint = pointAt(touchedIndex ?? values.length - 1);
    if (touchedIndex != null) {
      canvas.drawLine(Offset(markedPoint.dx, 0), Offset(markedPoint.dx, size.height), grid);
    }
    canvas.drawCircle(markedPoint, 5, Paint()..color = lineColor);
  }

  @override
  bool shouldRepaint(_ValueChartPainter oldDelegate) => oldDelegate.values != values || oldDelegate.touchedIndex != touchedIndex;
}
