import 'package:akashic/layers/technical/Localization/app_localizations.dart';
import 'package:akashic/layers/functional/Collection/presentation/widgets/item_spine.dart';
import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:flutter/material.dart';

class MissingVolumeSpine extends StatelessWidget {
  const MissingVolumeSpine({required this.volumeNumber, required this.size, super.key});

  final int volumeNumber;
  final SpineSize size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: AppLocalizations.of(context).missingVolumeLabel(volumeNumber),
      excludeSemantics: true,
      child: CustomPaint(
        painter: const _DashedOutlinePainter(),
        child: SizedBox(
          width: SpineThickness.volume.widthFor(size),
          height: size.shelfHeight - 8,
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '$volumeNumber',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.clip,
              style: AkashicTypography.numeral(size: size == SpineSize.compact ? 7 : 8).copyWith(color: AkashicColors.missing),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedOutlinePainter extends CustomPainter {
  const _DashedOutlinePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AkashicColors.missing
      ..strokeWidth = 1.5;
    const dash = 3.0;
    const gap = 2.5;
    for (var y = 0.0; y < size.height; y += dash + gap) {
      canvas.drawLine(Offset(0.75, y), Offset(0.75, (y + dash).clamp(0, size.height)), paint);
      canvas.drawLine(Offset(size.width - 0.75, y), Offset(size.width - 0.75, (y + dash).clamp(0, size.height)), paint);
    }
    for (var x = 0.0; x < size.width; x += dash + gap) {
      canvas.drawLine(Offset(x, 0.75), Offset((x + dash).clamp(0, size.width), 0.75), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
