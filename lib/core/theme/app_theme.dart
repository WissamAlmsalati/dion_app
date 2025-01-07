import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color mainColor = Color(0xFF6361D4);

  static ThemeData get purpleTheme {
    return ThemeData(
      primaryColor: mainColor,
      scaffoldBackgroundColor: Colors.white, // Set background color to white
      appBarTheme: AppBarTheme(
        backgroundColor: mainColor,
        elevation: 0,
        titleTextStyle: GoogleFonts.changa(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      textTheme: TextTheme(
        titleLarge: GoogleFonts.changa(
          color: mainColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: GoogleFonts.changa(
          color: mainColor,
          fontSize: 18,
        ),
        bodyMedium: GoogleFonts.changa(
          color: mainColor.withOpacity(0.7),
          fontSize: 16,
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: mainColor,
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, backgroundColor: mainColor,
          textStyle: GoogleFonts.changa(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: mainColor.withOpacity(0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: mainColor, width: 2),
        ),
        labelStyle: GoogleFonts.changa(
          color: mainColor.withOpacity(0.6),
        ),
        hintStyle: GoogleFonts.changa(
          color: mainColor.withOpacity(0.4),
        ),
      ),
    );
  }
}