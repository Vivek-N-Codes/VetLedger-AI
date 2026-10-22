import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryTeal = Color(0xFF006A60);
  static const Color primaryLight = Color(0xFFE6F5F2);
  static const Color primaryDark = Color(0xFF004D40);

  static const Color secondaryEmerald = Color(0xFF0F766E);
  static const Color accentSage = Color(0xFF2DD4BF);

  static const Color warningAmber = Color(0xFFD97706);
  static const Color warningBg = Color(0xFFFEF3C7);

  static const Color alertRed = Color(0xFFDC2626);
  static const Color alertBg = Color(0xFFFEE2E2);

  static const Color successGreen = Color(0xFF059669);
  static const Color successBg = Color(0xFFD1FAE5);

  static const Color surfaceBackground = Color(0xFFF8FAF9);
  static const Color cardSurface = Colors.white;
  static const Color borderSubtle = Color(0xFFE2E8F0);

  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textMuted = Color(0xFF64748B);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryTeal,
        primary: primaryTeal,
        secondary: secondaryEmerald,
        surface: surfaceBackground,
        error: alertRed,
      ),
      scaffoldBackgroundColor: surfaceBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: cardSurface,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 19,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borderSubtle, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: cardSurface,
        indicatorColor: primaryLight,
        elevation: 3,
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(color: primaryTeal, fontSize: 12, fontWeight: FontWeight.w700);
          }
          return const TextStyle(color: textMuted, fontSize: 12, fontWeight: FontWeight.w500);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primaryTeal);
          }
          return const IconThemeData(color: textMuted);
        }),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryTeal,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryTeal,
          side: const BorderSide(color: primaryTeal, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderSubtle),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderSubtle),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryTeal, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(color: textMuted, fontSize: 14),
      ),
    );
  }
}
