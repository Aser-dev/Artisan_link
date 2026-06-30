// lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primary = Color(0xFF00450D);

  // Missing theme tokens used by accueil_citoyen_page
  static const Color background = neutralSand;
  static const Color tertiaryContainer = Color(0xFFFFF3E0);
  static const Color onTertiaryContainer = Color(0xFF4A2B00);

  static const Color primaryContainer = Color(0xFF1B5E20);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onPrimaryContainer = Color(0xFF90D689);
  static const Color inversePrimary = Color(0xFF91D78A);
  static const Color secondary = Color(0xFFB22C01);
  static const Color secondaryContainer = Color(0xFFFF6338);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color terracottaClay = Color(0xFFD87D4A);
  static const Color savannahGold = Color(0xFFFBC02D);
  static const Color neutralSand = Color(0xFFF5F5F1);
  static const Color surface = Color(0xFFF7FBF1);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF2F5EC);
  static const Color surfaceContainer = Color(0xFFECEFE6);
  static const Color surfaceContainerHigh = Color(0xFFE6E9E0);
  static const Color surfaceContainerHighest = Color(0xFFE0E4DB);
  static const Color surfaceVariant = Color(0xFFE0E4DB);
  static const Color onSurface = Color(0xFF191D17);
  static const Color onSurfaceVariant = Color(0xFF41493E);
  static const Color outline = Color(0xFF717A6D);
  static const Color outlineVariant = Color(0xFFC0C9BB);
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
 
  static const Color deepTeal = Color(0xFF004D40);
  static const Color secondaryFixed = Color(0xFFFFF3E0);
  static const Color onSecondaryFixedVariant = Color(0xFF4A2B00);
  
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      textTheme: GoogleFonts.beVietnamProTextTheme(),
      scaffoldBackgroundColor: neutralSand,
      colorScheme: const ColorScheme.light(
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondary,
        onSecondary: onSecondary,
        secondaryContainer: secondaryContainer,
        surface: surface,
        onSurface: onSurface,
        onSurfaceVariant: onSurfaceVariant,
        outline: outline,
        outlineVariant: outlineVariant,
        error: error,
        errorContainer: errorContainer,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceContainerLow,
        elevation: 0,
        foregroundColor: onSurface,
        centerTitle: false,
        titleTextStyle: GoogleFonts.hankenGrotesk(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: primary,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(color: onSurfaceVariant, fontSize: 14),
        labelStyle: const TextStyle(color: onSurfaceVariant),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          elevation: 2,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: outline),
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceContainerLow,
        selectedColor: primary,
        labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      cardTheme: CardThemeData(
        color: surfaceContainerLowest,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: outlineVariant.withValues(alpha: 0.3)),
        ),
      ),
    );
  }
}
