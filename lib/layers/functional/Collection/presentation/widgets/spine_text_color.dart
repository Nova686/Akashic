import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:flutter/material.dart';

double contrastBetween(Color first, Color second) {
  final lighter = first.computeLuminance() > second.computeLuminance() ? first.computeLuminance() : second.computeLuminance();
  final darker = first.computeLuminance() > second.computeLuminance() ? second.computeLuminance() : first.computeLuminance();
  return (lighter + 0.05) / (darker + 0.05);
}

const double readableContrast = 4.5;

Color textColorOnSpine(Color spine) {
  final candidates = [AkashicColors.night, Colors.white, Colors.black];
  for (final candidate in candidates) {
    if (contrastBetween(spine, candidate) >= readableContrast) {
      return candidate;
    }
  }
  return candidates.reduce((best, candidate) => contrastBetween(spine, candidate) > contrastBetween(spine, best) ? candidate : best);
}
