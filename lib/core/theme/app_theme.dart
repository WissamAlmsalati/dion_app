// app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color mainColor = Color(0xFFFB847C);
  static const Color defaultFontColor = Color(0xFFEFF5FE); // Default font color
  static const Color textColor = Color(0xFF011A51);

  static ThemeData get purpleTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: mainColor,
        primary: mainColor,
        secondary: Colors.white,
      ),
      useMaterial3: true,
      scaffoldBackgroundColor: defaultFontColor,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: defaultFontColor,
        elevation: 0,
        titleTextStyle: GoogleFonts.titilliumWeb(
          color: textColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      textTheme: TextTheme(
        titleLarge: GoogleFonts.titilliumWeb(
          color: textColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: GoogleFonts.titilliumWeb(
          color: textColor,
          fontSize: 18,
        ),
        bodyMedium: GoogleFonts.titilliumWeb(
          color: textColor,
          fontSize: 16,
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.white,
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: mainColor,
          textStyle: GoogleFonts.titilliumWeb(
            fontSize: 16,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: defaultFontColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(1),
          borderSide: BorderSide(color: textColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(1),
          borderSide: BorderSide(color: textColor.withOpacity(0.5), width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(1),
          borderSide: BorderSide(color: mainColor, width: 2),
        ),
        labelStyle: GoogleFonts.titilliumWeb(
          color: textColor,
          fontSize: 16,
        ),
        hintStyle: GoogleFonts.titilliumWeb(
          color: textColor,
          fontSize: 14,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: mainColor,
        unselectedItemColor: textColor,
        selectedLabelStyle: GoogleFonts.titilliumWeb(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: GoogleFonts.titilliumWeb(
          fontSize: 12,
        ),
        showUnselectedLabels: true,
      ),
    );
  }
}
