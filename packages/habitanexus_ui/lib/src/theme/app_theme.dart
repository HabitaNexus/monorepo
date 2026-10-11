import 'package:flutter/material.dart';

/// Design System HabitaNexus — extraído de Stitch HAB-18 (dark).
/// Primary: #57f1db / Surface: #0d1322 — ver stitch 1952725287290286102 / 93bef2fc0fad49888cfc160855ba76d4
class AppTheme {
  AppTheme._();

  static const Color surfaceColor = Color(0xFFF8F9FA);

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A5276),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white,
      );

  // Dark theme — Stitch HAB-18 palette (background #0d1322, primary #57f1db)
  static const ColorScheme _darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF57F1DB),
    onPrimary: Color(0xFF003731),
    primaryContainer: Color(0xFF2DD4BF),
    onPrimaryContainer: Color(0xFF00574D),
    primaryFixed: Color(0xFF62FAE3),
    primaryFixedDim: Color(0xFF3CDDC7),
    onPrimaryFixed: Color(0xFF00201C),
    onPrimaryFixedVariant: Color(0xFF005047),
    secondary: Color(0xFF80D5CB),
    onSecondary: Color(0xFF003733),
    secondaryContainer: Color(0xFF007068),
    onSecondaryContainer: Color(0xFF9AF0E5),
    secondaryFixed: Color(0xFF9CF2E8),
    secondaryFixedDim: Color(0xFF80D5CB),
    onSecondaryFixed: Color(0xFF00201D),
    onSecondaryFixedVariant: Color(0xFF00504A),
    tertiary: Color(0xFFCEDAFB),
    onTertiary: Color(0xFF24304A),
    tertiaryContainer: Color(0xFFB2BEDE),
    onTertiaryContainer: Color(0xFF414D68),
    tertiaryFixed: Color(0xFFD8E2FF),
    tertiaryFixedDim: Color(0xFFBAC6E7),
    onTertiaryFixed: Color(0xFF0F1B34),
    onTertiaryFixedVariant: Color(0xFF3B4661),
    error: Color(0xFFFFB4AB),
    onError: Color(0xFF690005),
    errorContainer: Color(0xFF93000A),
    onErrorContainer: Color(0xFFFFDAD6),
    surface: Color(0xFF0D1322),
    onSurface: Color(0xFFDDE2F8),
    surfaceDim: Color(0xFF0D1322),
    surfaceBright: Color(0xFF33394A),
    surfaceContainerLowest: Color(0xFF080E1D),
    surfaceContainerLow: Color(0xFF151B2B),
    surfaceContainer: Color(0xFF191F2F),
    surfaceContainerHigh: Color(0xFF242A3A),
    surfaceContainerHighest: Color(0xFF2E3445),
    onSurfaceVariant: Color(0xFFBACAC5),
    outline: Color(0xFF859490),
    outlineVariant: Color(0xFF3C4A46),
    // surfaceVariant deprecated -> surfaceContainerHighest
    inverseSurface: Color(0xFFDDE2F8),
    inversePrimary: Color(0xFF006B5F),
    surfaceTint: Color(0xFF3CDDC7),
    scrim: Colors.black,
  );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        colorScheme: _darkScheme,
        scaffoldBackgroundColor: const Color(0xFF0D1322),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF151B2B),
          foregroundColor: Color(0xFFDDE2F8),
        ),
        cardTheme: CardThemeData(
          color: _darkScheme.surfaceContainerLow,
          surfaceTintColor: Colors.transparent,
        ),
      );
}
