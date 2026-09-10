import 'package:flutter/material.dart';

class AppTheme {
  // Brand & Accent Colors
  static const Color primaryActionBlue = Color(0xFF0066CC);
  static const Color primaryFocusBlue = Color(0xFF0071E3);
  static const Color primaryOnDark = Color(0xFF2997FF);

  // Surface Colors for Dark Mode
  static const Color scaffoldBackground = Color(0xFF000000); // surface-black
  static const Color canvasParchment = Color(0xFFF5F5F7); // for footers/sticky if needed
  static const Color surfaceTile1 = Color(0xFF272729); // Near-black Tile 1
  static const Color surfaceTile2 = Color(0xFF2A2A2C); // Near-black Tile 2
  static const Color surfaceTile3 = Color(0xFF252527); // Near-black Tile 3
  static const Color pureWhiteCanvas = Color(0xFFFFFFFF); // Pure White Canvas for cards as per DESIGN.md

  // Text Colors for Dark Mode
  static const Color textOnDark = Color(0xFFFFFFFF); // Body On Dark
  static const Color textMutedOnDark = Color(0xFFCCCCCC); // Body Muted

  // Lines
  static const Color hairline = Color(0xFFE0E0E0);

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: scaffoldBackground,
      primaryColor: primaryActionBlue,
      colorScheme: const ColorScheme.dark(
        primary: primaryActionBlue,
        secondary: primaryActionBlue,
        surface: surfaceTile1,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: scaffoldBackground,
        elevation: 0,
        iconTheme: IconThemeData(color: textOnDark),
        titleTextStyle: TextStyle(
          fontFamily: 'SF Pro Display',
          fontSize: 21,
          fontWeight: FontWeight.w600,
          color: textOnDark,
          letterSpacing: 0.231, // tagline
        ),
      ),
      iconTheme: const IconThemeData(
        color: textOnDark,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'SF Pro Display', fontSize: 56, fontWeight: FontWeight.w600, color: textOnDark, letterSpacing: -0.28, height: 1.07), // hero-display
        displayMedium: TextStyle(fontFamily: 'SF Pro Display', fontSize: 40, fontWeight: FontWeight.w600, color: textOnDark, letterSpacing: 0, height: 1.1), // display-lg
        displaySmall: TextStyle(fontFamily: 'SF Pro Text', fontSize: 34, fontWeight: FontWeight.w600, color: textOnDark, letterSpacing: -0.374, height: 1.47), // display-md
        headlineMedium: TextStyle(fontFamily: 'SF Pro Display', fontSize: 28, fontWeight: FontWeight.w400, color: textOnDark, letterSpacing: 0.196, height: 1.14), // lead
        headlineSmall: TextStyle(fontFamily: 'SF Pro Display', fontSize: 21, fontWeight: FontWeight.w600, color: textOnDark, letterSpacing: 0.231, height: 1.19), // tagline
        titleLarge: TextStyle(fontFamily: 'SF Pro Text', fontSize: 17, fontWeight: FontWeight.w600, color: textOnDark, letterSpacing: -0.374, height: 1.24), // body-strong
        bodyLarge: TextStyle(fontFamily: 'SF Pro Text', fontSize: 17, fontWeight: FontWeight.w400, color: textOnDark, letterSpacing: -0.374, height: 1.47), // body
        bodyMedium: TextStyle(fontFamily: 'SF Pro Text', fontSize: 14, fontWeight: FontWeight.w400, color: textOnDark, letterSpacing: -0.224, height: 1.43), // caption
        titleMedium: TextStyle(fontFamily: 'SF Pro Text', fontSize: 14, fontWeight: FontWeight.w600, color: textOnDark, letterSpacing: -0.224, height: 1.29), // caption-strong
        bodySmall: TextStyle(fontFamily: 'SF Pro Text', fontSize: 12, fontWeight: FontWeight.w400, color: textMutedOnDark, letterSpacing: -0.12, height: 1.0), // fine-print
        labelLarge: TextStyle(fontFamily: 'SF Pro Text', fontSize: 17, fontWeight: FontWeight.w400, color: textOnDark, letterSpacing: -0.374, height: 1.47), // buttons mapping roughly
      ),
      cardTheme: CardThemeData(
        color: pureWhiteCanvas,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18), // rounded.lg
          side: const BorderSide(color: hairline, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryActionBlue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9999), // rounded.pill
          ),
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 22), // button-primary padding
          textStyle: const TextStyle(
            fontFamily: 'SF Pro Text',
            fontSize: 17,
            fontWeight: FontWeight.w400,
            letterSpacing: -0.374,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: pureWhiteCanvas,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9999),
          borderSide: const BorderSide(color: Color(0x14000000), width: 1), // rgba(0, 0, 0, 0.08) roughly
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9999),
          borderSide: const BorderSide(color: Color(0x14000000), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(9999),
          borderSide: const BorderSide(color: Color(0x14000000), width: 1),
        ),
        hintStyle: const TextStyle(
          fontFamily: 'SF Pro Text',
          fontSize: 17,
          fontWeight: FontWeight.w400,
          color: textMutedOnDark,
          letterSpacing: -0.374,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xA3D2D2D7), // Translucent Chip Gray ~64% alpha
        foregroundColor: Color(0xFF1D1D1F), // colors.ink
        shape: CircleBorder(),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: scaffoldBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(0)), // rounded.none as default for tiles? We'll keep transparent in UI if needed, but here's a default. Actually the current UI uses 20px for sheets. DESIGN.md doesn't explicitly mention bottom sheets, so we use surface-tile-1 or scaffold background.
        ),
      ),
    );
  }
}
