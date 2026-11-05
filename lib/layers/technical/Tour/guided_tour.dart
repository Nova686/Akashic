import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:flutter/material.dart';

class TourStep {
  const TourStep({required this.title, required this.text, this.target});

  final String title;
  final String text;
  final GlobalKey? target;
}

class TourLabels {
  const TourLabels({required this.previous, required this.next, required this.done, required this.close, required this.progress});

  final String previous;
  final String next;
  final String done;
  final String close;
  final String Function(int current, int total) progress;
}

class GuidedTour extends StatefulWidget {
  const GuidedTour({required this.steps, required this.labels, required this.onFinished, super.key});

  static const double spotlightPadding = 6;
  static const Duration moveDuration = Duration(milliseconds: 280);

  final List<TourStep> steps;
  final TourLabels labels;
  final VoidCallback onFinished;

  @override
  State<GuidedTour> createState() => _GuidedTourState();
}

class _GuidedTourState extends State<GuidedTour> {
  int _index = 0;

  TourStep get _step => widget.steps[_index];

  @override
  void initState() {
    super.initState();
    _reveal();
  }

  void _goTo(int index) {
    setState(() => _index = index);
    _reveal();
  }

  void _reveal() {
    final targetContext = _step.target?.currentContext;
    if (targetContext != null) {
      Scrollable.ensureVisible(targetContext, alignment: 0.5, duration: const Duration(milliseconds: 200)).whenComplete(() {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  Rect? _targetRect() {
    final renderObject = _step.target?.currentContext?.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.attached || !renderObject.hasSize) {
      return null;
    }
    return (renderObject.localToGlobal(Offset.zero) & renderObject.size).inflate(GuidedTour.spotlightPadding);
  }

  @override
  Widget build(BuildContext context) {
    final target = _targetRect();
    final isLast = _index == widget.steps.length - 1;
    return LayoutBuilder(
      builder: (context, constraints) {
        final screen = Offset.zero & constraints.biggest;
        final popover = _TourPopover(
          step: _step,
          labels: widget.labels,
          current: _index + 1,
          total: widget.steps.length,
          isLast: isLast,
          onPrevious: _index == 0 ? null : () => _goTo(_index - 1),
          onNext: isLast ? widget.onFinished : () => _goTo(_index + 1),
          onClose: widget.onFinished,
        );
        return BlockSemantics(
          child: Semantics(
            scopesRoute: true,
            namesRoute: true,
            explicitChildNodes: true,
            label: _step.title,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ExcludeSemantics(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {},
                      child: TweenAnimationBuilder<Rect?>(
                        tween: RectTween(end: target ?? Rect.fromCenter(center: screen.center, width: 0, height: 0)),
                        duration: GuidedTour.moveDuration,
                        curve: Curves.easeOutCubic,
                        builder: (context, spotlight, _) => CustomPaint(painter: _SpotlightPainter(spotlight)),
                      ),
                    ),
                  ),
                ),
                if (target == null)
                  Center(
                    child: Padding(padding: const EdgeInsets.all(24), child: popover),
                  )
                else if (target.center.dy > screen.height / 2)
                  Positioned(left: 16, right: 16, bottom: screen.height - target.top + 12, child: popover)
                else
                  Positioned(left: 16, right: 16, top: target.bottom + 12, child: popover),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SpotlightPainter extends CustomPainter {
  const _SpotlightPainter(this.spotlight);

  final Rect? spotlight;

  @override
  void paint(Canvas canvas, Size size) {
    final hole = spotlight;
    final shade = Path()
      ..fillType = PathFillType.evenOdd
      ..addRect(Offset.zero & size);
    if (hole != null && !hole.isEmpty) {
      shade.addRRect(RRect.fromRectAndRadius(hole, const Radius.circular(14)));
    }
    canvas.drawPath(shade, Paint()..color = Colors.black.withValues(alpha: 0.72));
    if (hole != null && !hole.isEmpty) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(hole, const Radius.circular(14)),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = AkashicColors.lavender,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SpotlightPainter oldDelegate) => oldDelegate.spotlight != spotlight;
}

class _TourPopover extends StatelessWidget {
  const _TourPopover({
    required this.step,
    required this.labels,
    required this.current,
    required this.total,
    required this.isLast,
    required this.onPrevious,
    required this.onNext,
    required this.onClose,
  });

  final TourStep step;
  final TourLabels labels;
  final int current;
  final int total;
  final bool isLast;
  final VoidCallback? onPrevious;
  final VoidCallback onNext;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AkashicColors.surface,
      elevation: 8,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 8, 8, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Semantics(
                    header: true,
                    liveRegion: true,
                    child: Text(step.title, style: AkashicTypography.body(size: 17, weight: FontWeight.w800)),
                  ),
                ),
                IconButton(tooltip: labels.close, icon: const Icon(Icons.close, size: 20), onPressed: onClose),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(step.text, style: AkashicTypography.body(size: 14).copyWith(color: AkashicColors.textSoft, height: 1.4)),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(labels.progress(current, total), style: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textFaint)),
                const Spacer(),
                if (onPrevious case final previous?) TextButton(onPressed: previous, child: Text(labels.previous)),
                const SizedBox(width: 4),
                FilledButton(onPressed: onNext, child: Text(isLast ? labels.done : labels.next)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
