import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:flutter/painting.dart';

abstract final class AkashicTypography {
  static TextStyle displayTitle({double size = 28}) => TextStyle(
        fontFamily: 'Lora',
        fontWeight: FontWeight.w700,
        fontSize: size,
        height: 1,
        color: AkashicColors.text,
        fontFeatures: const [FontFeature.liningFigures()],
      );

  static TextStyle numeral({double size = 15}) => TextStyle(
        fontFamily: 'Lora',
        fontWeight: FontWeight.w600,
        fontFeatures: const [FontFeature.liningFigures(), FontFeature.tabularFigures()],
        fontSize: size,
        color: AkashicColors.lavender,
      );

  static TextStyle body({double size = 14, FontWeight weight = FontWeight.w400}) => TextStyle(
        fontFamily: 'Lato',
        fontWeight: weight,
        fontSize: size,
        color: AkashicColors.text,
      );
}
