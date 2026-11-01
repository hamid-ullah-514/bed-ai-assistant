import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Strict reference palette
  static const Color primaryDarkNavy = Color(0xFF12365A);
  static const Color primaryMintGreen = Color(0xFF19866D);
  static const Color lightMintBackground = Color(0xFFEAF7F0);
  static const Color softBlue = Color(0xFFEAF3FC);
  static const Color lightCream = Color(0xFFFFFDF5);
  static const Color mainBackground = Color(0xFFF7FAFC);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color primaryText = Color(0xFF17324D);
  static const Color secondaryText = Color(0xFF687B8D);
  static const Color lightBorder = Color(0xFFDCE8E9);

  // Accents
  static const Color accentBlue = Color(0xFF2B78C5);
  static const Color accentOrange = Color(0xFFE67E22);
  static const Color accentPurple = Color(0xFF8E44AD);
  static const Color accentAmber = Color(0xFFF39C12);
  static const Color successGreen = Color(0xFF10B981);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.mainBackground,
      primaryColor: AppColors.primaryMintGreen,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryMintGreen,
        onPrimary: Colors.white,
        secondary: AppColors.primaryDarkNavy,
        onSecondary: Colors.white,
        surface: AppColors.cardBackground,
        onSurface: AppColors.primaryText,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primaryDarkNavy,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.primaryDarkNavy,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: AppColors.primaryDarkNavy),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.lightBorder, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryMintGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryDarkNavy,
          side: const BorderSide(color: AppColors.lightBorder, width: 1.2),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.lightBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryMintGreen, width: 1.5),
        ),
        hintStyle: const TextStyle(
          color: AppColors.secondaryText,
          fontSize: 14,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primaryMintGreen,
        unselectedItemColor: AppColors.secondaryText,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
        unselectedLabelStyle: TextStyle(fontSize: 11),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        headlineMedium: const TextStyle(
          color: AppColors.primaryDarkNavy,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: const TextStyle(
          color: AppColors.primaryDarkNavy,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: const TextStyle(
          color: AppColors.primaryText,
          fontSize: 15,
        ),
        bodyMedium: const TextStyle(
          color: AppColors.primaryText,
          fontSize: 13.5,
        ),
      ),
    );
  }
}
