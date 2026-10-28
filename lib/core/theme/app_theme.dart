import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Brand tokens
  static const Color primary = Color(0xFF2F6BFF);
  static const Color accent = Color(0xFFFF8A3D);
  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color star = Color(0xFFFFC107);

  // Light theme
  static const Color lightBg = Color(0xFFF5F7FB);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF1F2937);
  static const Color lightSecondaryText = Color(0xFF6B7280);
  static const Color lightBorder = Color(0xFFE2E8F0);

  // Dark theme
  static const Color darkBg = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkText = Color(0xFFF1F5F9);
  static const Color darkSecondaryText = Color(0xFF94A3B8);
  static const Color darkBorder = Color(0xFF334155);

  // Finger colors (TypingClub style)
  static const Color leftPinky = Color(0xFFEC4899); // Pink
  static const Color leftRing = Color(0xFFF97316);  // Orange
  static const Color leftMiddle = Color(0xFFEAB308); // Yellow
  static const Color leftIndex = Color(0xFF10B981);  // Green
  static const Color rightIndex = Color(0xFF06B6D4); // Teal
  static const Color rightMiddle = Color(0xFF3B82F6);// Blue
  static const Color rightRing = Color(0xFF6366F1);  // Indigo
  static const Color rightPinky = Color(0xFFA855F7); // Purple
  static const Color thumb = Color(0xFF94A3B8);      // Gray
}

class AppTheme {
  static ThemeData lightTheme() {
    final base = ThemeData.light();
    return base.copyWith(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.lightBg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.lightSurface,
        error: AppColors.error,
      ),
      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.inter(color: AppColors.lightText, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.inter(color: AppColors.lightText, fontWeight: FontWeight.bold),
        headlineLarge: GoogleFonts.inter(color: AppColors.lightText, fontWeight: FontWeight.bold),
        headlineMedium: GoogleFonts.inter(color: AppColors.lightText, fontWeight: FontWeight.w600),
        titleLarge: GoogleFonts.inter(color: AppColors.lightText, fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.inter(color: AppColors.lightText),
        bodyMedium: GoogleFonts.inter(color: AppColors.lightSecondaryText),
      ),
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.05),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(120, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
    );
  }

  static ThemeData darkTheme() {
    final base = ThemeData.dark();
    return base.copyWith(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.darkBg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: AppColors.darkSurface,
        error: AppColors.error,
      ),
      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.inter(color: AppColors.darkText, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.inter(color: AppColors.darkText, fontWeight: FontWeight.bold),
        headlineLarge: GoogleFonts.inter(color: Grade(AppColors.darkText, FontWeight.bold).color),
        headlineMedium: GoogleFonts.inter(color: AppColors.darkText, fontWeight: FontWeight.w600),
        titleLarge: GoogleFonts.inter(color: AppColors.darkText, fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.inter(color: AppColors.darkText),
        bodyMedium: GoogleFonts.inter(color: AppColors.darkSecondaryText),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size(120, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
    );
  }
}

class Grade {
  final Color color;
  final FontWeight weight;
  Grade(this.color, this.weight);
}
