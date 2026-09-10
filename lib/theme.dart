import 'package:flutter/material.dart';

class AppTheme {
  // Surface Colors for Dark Mode
  static const Color scaffoldBackground = Color(0xFF121212); // deep black
  static const Color surfaceDark = Color(0xFF1E1E1E); // deep grey for cards/bottom sheets

  // Status Accent Colors
  static const Color statusGreen = Color(0xFF39FF14); // vivid green
  static const Color statusRed = Color(0xFFFF073A); // vivid red
  static const Color statusGrey = Color(0xFF888888); // neutral grey

  // Text Colors for Dark Mode
  static const Color textOnDark = Color(0xFFFFFFFF); // Body On Dark
  static const Color textMutedOnDark = Color(0xFFCCCCCC); // Body Muted

  // Lines
  static const Color hairline = Color(0xFF333333);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: scaffoldBackground,
      primaryColor: statusGreen,
      colorScheme: const ColorScheme.dark(
        primary: statusGreen,
        secondary: statusGreen,
        surface: surfaceDark,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: scaffoldBackground,
        elevation: 0,
        iconTheme: IconThemeData(color: textOnDark),
        titleTextStyle: TextStyle(
          fontFamily: 'Roboto', // Default modern sans-serif
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textOnDark,
        ),
      ),
      iconTheme: const IconThemeData(
        color: textOnDark,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'Roboto', fontSize: 48, fontWeight: FontWeight.w800, color: textOnDark),
        displayMedium: TextStyle(fontFamily: 'Roboto', fontSize: 36, fontWeight: FontWeight.w800, color: textOnDark),
        headlineMedium: TextStyle(fontFamily: 'Roboto', fontSize: 24, fontWeight: FontWeight.w700, color: textOnDark),
        headlineSmall: TextStyle(fontFamily: 'Roboto', fontSize: 20, fontWeight: FontWeight.w700, color: textOnDark),
        titleLarge: TextStyle(fontFamily: 'Roboto', fontSize: 18, fontWeight: FontWeight.w700, color: textOnDark),
        bodyLarge: TextStyle(fontFamily: 'Roboto', fontSize: 16, fontWeight: FontWeight.w400, color: textOnDark),
        bodyMedium: TextStyle(fontFamily: 'Roboto', fontSize: 14, fontWeight: FontWeight.w400, color: textMutedOnDark),
        titleMedium: TextStyle(fontFamily: 'Roboto', fontSize: 16, fontWeight: FontWeight.w600, color: textOnDark),
      ),
      cardTheme: CardThemeData(
        color: surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: surfaceDark,
          foregroundColor: textOnDark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          textStyle: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0x80000000), // Translucent black
        foregroundColor: textOnDark,
        shape: CircleBorder(),
        elevation: 0,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: scaffoldBackground,
        selectedItemColor: statusGreen,
        unselectedItemColor: textMutedOnDark,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}
