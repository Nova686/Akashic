import 'package:flutter/painting.dart';

class AkashicTextPalette {
  const AkashicTextPalette({required this.line, required this.text, required this.textSoft, required this.textFaint, required this.missing});

  static const AkashicTextPalette standard = AkashicTextPalette(
    line: Color(0xFF332D5C),
    text: Color(0xFFECE9FA),
    textSoft: Color(0xFFA39DC8),
    textFaint: Color(0xFF8A84B4),
    missing: Color(0xFF8F89B8),
  );

  static const AkashicTextPalette highContrast = AkashicTextPalette(
    line: Color(0xFF736BB4),
    text: Color(0xFFFFFFFF),
    textSoft: Color(0xFFDAD5F5),
    textFaint: Color(0xFFC2BCE6),
    missing: Color(0xFFC9C4EA),
  );

  final Color line;
  final Color text;
  final Color textSoft;
  final Color textFaint;
  final Color missing;
}

abstract final class AkashicColors {
  static AkashicTextPalette _palette = AkashicTextPalette.standard;

  static bool get isHighContrast => identical(_palette, AkashicTextPalette.highContrast);

  static void useHighContrast(bool isHighContrast) => _palette = isHighContrast ? AkashicTextPalette.highContrast : AkashicTextPalette.standard;

  static const Color night = Color(0xFF15122B);
  static const Color surface = Color(0xFF221E40);
  static Color get line => _palette.line;
  static Color get text => _palette.text;
  static Color get textSoft => _palette.textSoft;
  static Color get textFaint => _palette.textFaint;
  static const Color lavender = Color(0xFFB7A6FF);
  static const Color lavenderDeep = Color(0xFF7C66E8);
  static const Color teal = Color(0xFF5ED1C3);
  static const Color gold = Color(0xFFF2C46B);
  static const Color coral = Color(0xFFFF8A80);
  static const List<Color> chartPalette = [Color(0xFFB7A6FF), Color(0xFF5ED1C3), Color(0xFFF2C46B), Color(0xFFFF7A8A), Color(0xFF7FA8FF), Color(0xFF8BD17F), Color(0xFFE9A8D0)];

  static Color chartColor(int index) => chartPalette[index % chartPalette.length];
  static Color get missing => _palette.missing;
}
