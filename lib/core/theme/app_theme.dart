// lib/core/theme/app_theme.dart
// Thème sombre minimaliste pro inspiré de Linear/Notion/Stripe
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Palette sombre ─────────────────────────────────────────
  static const Color fondPrincipal = Color(0xFF0F0F0F);      // noir profond
  static const Color surfaceCard = Color(0xFF1A1A1A);        // noir doux
  static const Color surfaceCardHover = Color(0xFF222222);   // hover
  static const Color accentPrimaire = Color(0xFF8CD82C);     // vert lime CTA
  static const Color accentSecondaire = Color(0xFF2E4A0B);   // vert forêt badges
  static const Color textePrimaire = Color(0xFFF5F5F5);      // blanc cassé
  static const Color texteSecondaire = Color(0xFF8A8A85);    // gris moyen
  static const Color texteTertiaire = Color(0xFF55554F);     // gris foncé placeholders
  static const Color bordureSubtile = Color(0xFF2A2A2A);     // séparateurs
  static const Color erreur = Color(0xFFE85D5D);
  static const Color succes = Color(0xFF8CD82C);

  // ── Anciennes couleurs Material (mappées) ──────────────────
  static const Color primary = accentPrimaire;
  static const Color primaryContainer = Color(0xFF2E4A0B);
  static const Color onPrimary = Color(0xFF0F0F0F);
  static const Color onPrimaryContainer = Color(0xFF8CD82C);
  static const Color inversePrimary = Color(0xFF8CD82C);
  static const Color secondary = Color(0xFF8CD82C);
  static const Color secondaryContainer = Color(0xFF2E4A0B);
  static const Color onSecondary = Color(0xFF0F0F0F);
  static const Color terracottaClay = Color(0xFF8CD82C);
  static const Color savannahGold = Color(0xFF8CD82C);
  static const Color neutralSand = fondPrincipal;
  static const Color surface = surfaceCard;
  static const Color surfaceContainerLowest = Color(0xFF1A1A1A);
  static const Color surfaceContainerLow = Color(0xFF1A1A1A);
  static const Color surfaceContainer = Color(0xFF1A1A1A);
  static const Color surfaceContainerHigh = Color(0xFF222222);
  static const Color surfaceContainerHighest = Color(0xFF222222);
  static const Color surfaceVariant = Color(0xFF2A2A2A);
  static const Color onSurface = Color(0xFFF5F5F5);
  static const Color onSurfaceVariant = Color(0xFF8A8A85);
  static const Color outline = Color(0xFF55554F);
  static const Color outlineVariant = Color(0xFF2A2A2A);
  static const Color error = Color(0xFFE85D5D);
  static const Color errorContainer = Color(0xFF3A1A1A);
  static const Color deepTeal = Color(0xFF8CD82C);
  static const Color secondaryFixed = Color(0xFF2E4A0B);
  static const Color onSecondaryFixedVariant = Color(0xFF8CD82C);
  static const Color background = fondPrincipal;
  static const Color onPrimaryContainerText = Color(0xFFF5F5F5);
  static const Color onTertiaryContainer = Color(0xFFF5F5F5);
  static const Color tertiaryContainer = Color(0xFF1A1A1A);

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: fondPrincipal,
      colorScheme: const ColorScheme.dark(
        primary: accentPrimaire,
        onPrimary: Color(0xFF0F0F0F),
        primaryContainer: accentSecondaire,
        onPrimaryContainer: accentPrimaire,
        secondary: accentPrimaire,
        onSecondary: Color(0xFF0F0F0F),
        secondaryContainer: accentSecondaire,
        surface: surfaceCard,
        onSurface: textePrimaire,
        onSurfaceVariant: texteSecondaire,
        outline: bordureSubtile,
        outlineVariant: bordureSubtile,
        error: erreur,
        errorContainer: Color(0xFF3A1A1A),
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        headlineLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          color: textePrimaire,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
          color: textePrimaire,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textePrimaire,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textePrimaire,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: textePrimaire,
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: texteSecondaire,
          height: 1.6,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: texteSecondaire,
          letterSpacing: 0.8,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: fondPrincipal,
        elevation: 0,
        foregroundColor: textePrimaire,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textePrimaire,
          letterSpacing: -0.3,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: bordureSubtile),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: bordureSubtile),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: accentPrimaire, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: erreur),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(color: texteTertiaire, fontSize: 14),
        labelStyle: const TextStyle(color: texteSecondaire),
        prefixIconColor: texteSecondaire,
        suffixIconColor: texteSecondaire,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentPrimaire,
          foregroundColor: const Color(0xFF0F0F0F),
          disabledBackgroundColor: surfaceCardHover,
          disabledForegroundColor: texteTertiaire,
          elevation: 0,
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: accentPrimaire,
          side: const BorderSide(color: accentPrimaire),
          minimumSize: const Size(double.infinity, 54),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
          textStyle: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceCard,
        selectedColor: accentPrimaire,
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: textePrimaire),
        secondaryLabelStyle: const TextStyle(color: Color(0xFF0F0F0F)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
        side: const BorderSide(color: bordureSubtile),
      ),
      cardTheme: CardThemeData(
        color: surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: bordureSubtile),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: bordureSubtile,
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: surfaceCard,
        contentTextStyle: const TextStyle(color: textePrimaire),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: fondPrincipal,
        selectedItemColor: accentPrimaire,
        unselectedItemColor: texteSecondaire,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}