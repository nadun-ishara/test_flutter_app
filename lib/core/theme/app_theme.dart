import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryViolet = Color(0xFF6366F1);
  static const Color accentNeonPink = Color(0xFFEC4899);
  static const Color accentCyan = Color(0xFF06B6D4);
  static const Color accentEmerald = Color(0xFF10B981);
  static const Color accentAmber = Color(0xFFF59E0B);
  static const Color darkBackground = Color(0xFF070913);
  static const Color darkCardBg = Color(0xFF0F172A);
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightCardBg = Color(0xFFFFFFFF);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: lightBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryViolet,
        brightness: Brightness.light,
        primary: primaryViolet,
        secondary: accentNeonPink,
        tertiary: accentCyan,
        surface: lightCardBg,
      ),
      cardTheme: CardThemeData(
        elevation: 6,
        shadowColor: primaryViolet.withValues(alpha: 0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryViolet,
        brightness: Brightness.dark,
        primary: primaryViolet,
        secondary: accentNeonPink,
        tertiary: accentCyan,
        surface: darkCardBg,
      ),
      cardTheme: CardThemeData(
        elevation: 8,
        shadowColor: primaryViolet.withValues(alpha: 0.35),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
    );
  }
}
