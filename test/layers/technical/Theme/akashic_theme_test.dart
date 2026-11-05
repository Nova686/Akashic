import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_theme.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('colors match the spec', () {
    expect(AkashicColors.night, const Color(0xFF15122B));
    expect(AkashicColors.lavender, const Color(0xFFB7A6FF));
    expect(AkashicColors.teal, const Color(0xFF5ED1C3));
  });

  test('titles and numerals use Lora, running text uses Lato', () {
    expect(AkashicTypography.numeral().fontFamily, 'Lora');
    expect(AkashicTypography.displayTitle().fontFamily, 'Lora');
    expect(AkashicTypography.body().fontFamily, 'Lato');
  });

  test('theme is dark with night scaffold', () {
    final theme = buildAkashicTheme();
    expect(theme.brightness, Brightness.dark);
    expect(theme.scaffoldBackgroundColor, AkashicColors.night);
    expect(theme.colorScheme.primary, AkashicColors.lavender);
  });
}
