// Ce fichier définit le thème de l’application - FasoArtisan.

import 'package:flutter/material.dart';

class AppTheme {
  // Couleurs FasoArtisan
  static const Color primaryGreen = Color(0xFF8CD82C);
  static const Color darkText = Color(0xFF1E1E1E);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color surfaceColor = Colors.white;
  static const Color borderColor = Color(0xFFE9ECEF);
  static const Color inputFillColor = Color(0xFFF1F3F5);
  static const Color greyText = Color(0xFF6C757D);
  static const Color darkGreen = Color(0xFF2E4A0B);

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryGreen,
        primary: primaryGreen,
        onPrimary: darkText,
        surface: surfaceColor,
        onSurface: darkText,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        foregroundColor: darkText,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: darkText,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryGreen),
        ),
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: darkText,
          height: 1.2,
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: darkText,
        ),
        headlineSmall: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: darkText,
        ),
        bodyMedium: TextStyle(color: greyText, fontSize: 15),
      ),
    );
  }
}
