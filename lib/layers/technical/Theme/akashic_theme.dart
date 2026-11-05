import 'package:akashic/layers/technical/Theme/akashic_colors.dart';
import 'package:akashic/layers/technical/Theme/akashic_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData buildAkashicTheme() {
  final colorScheme = ColorScheme.dark(
    primary: AkashicColors.lavender,
    onPrimary: AkashicColors.night,
    secondary: AkashicColors.teal,
    onSecondary: AkashicColors.night,
    surface: AkashicColors.night,
    onSurface: AkashicColors.text,
    surfaceContainer: AkashicColors.surface,
    outline: AkashicColors.line,
  );
  return ThemeData(
    brightness: Brightness.dark,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: AkashicColors.night,
    fontFamily: 'Lato',
    textTheme: TextTheme(
      headlineLarge: AkashicTypography.displayTitle(size: 36),
      headlineMedium: AkashicTypography.displayTitle(size: 28),
      titleMedium: AkashicTypography.body(size: 16, weight: FontWeight.w700),
      bodyMedium: AkashicTypography.body(),
      bodySmall: AkashicTypography.body(size: 12).copyWith(color: AkashicColors.textSoft),
    ),
    dividerColor: AkashicColors.line,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: akashicSystemBars,
    ),
  );
}

const SystemUiOverlayStyle akashicSystemBars = SystemUiOverlayStyle(
  statusBarColor: Colors.transparent,
  statusBarIconBrightness: Brightness.light,
  statusBarBrightness: Brightness.dark,
  systemNavigationBarColor: Colors.transparent,
  systemNavigationBarIconBrightness: Brightness.light,
  systemNavigationBarContrastEnforced: true,
);
