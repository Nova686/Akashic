import 'dart:math';

import 'package:akashic/layers/functional/Goals/domain/entities/goal.dart';
import 'package:akashic/layers/functional/Goals/presentation/widgets/goal_labels.dart';
import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:flutter/material.dart';

Color goalPaceColor(GoalProgress progress) => progress.gap >= 0 ? AkashicColors.teal : AkashicColors.gold;

class GoalRings extends StatelessWidget {
  const GoalRings({required this.progress, required this.onOpen, super.key});

  final List<GoalProgress> progress;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    if (progress.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: SizedBox(
        height: 132,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: progress.length,
          separatorBuilder: (context, index) => const SizedBox(width: 10),
          itemBuilder: (context, index) => GoalRing(progress: progress[index], onTap: onOpen),
        ),
      ),
    );
  }
}

class GoalRing extends StatelessWidget {
  const GoalRing({required this.progress, required this.onTap, super.key});

  final GoalProgress progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final color = goalPaceColor(progress);
    final label = goalLabel(progress, l10n);
    final pace = goalPaceLabel(progress, l10n);
    return Semantics(
      button: true,
      label: '$label, ${progress.done} / ${progress.goal.target}, $pace',
      excludeSemantics: true,
      onTap: onTap,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: 118,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: AkashicColors.surface, borderRadius: BorderRadius.circular(18), border: Border.all(color: AkashicColors.line)),
          child: Column(
            children: [
              SizedBox.square(
                dimension: 64,
                child: CustomPaint(
                  painter: _RingPainter(ratio: progress.ratio, todayRatio: progress.yearElapsed, color: color, trackColor: AkashicColors.line),
                  child: Center(child: Text('${progress.done}', style: AkashicTypography.numeral(size: 20))),
                ),
              ),
              const SizedBox(height: 6),
              Text(label, maxLines: 1, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(size: 12, weight: FontWeight.w700)),
              Text(pace, maxLines: 1, overflow: TextOverflow.ellipsis, style: AkashicTypography.body(size: 11, weight: FontWeight.w600).copyWith(color: color)),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({required this.ratio, required this.todayRatio, required this.color, required this.trackColor});

  final double ratio;
  final double todayRatio;
  final Color color;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 7.0;
    final rect = (Offset.zero & size).deflate(stroke / 2);
    canvas.drawArc(rect, 0, 2 * pi, false, Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke);
    canvas.drawArc(rect, -pi / 2, 2 * pi * ratio, false, Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = stroke);
    final angle = -pi / 2 + 2 * pi * todayRatio.clamp(0, 1);
    final center = rect.center;
    final radius = rect.width / 2;
    canvas.drawLine(
      center + Offset(cos(angle), sin(angle)) * (radius - stroke),
      center + Offset(cos(angle), sin(angle)) * (radius + stroke / 2),
      Paint()
        ..color = AkashicColors.text
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) => oldDelegate.ratio != ratio || oldDelegate.todayRatio != todayRatio || oldDelegate.color != color;
}
