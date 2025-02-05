import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color mainColor = Color(0xFFFB847C);
  static const Color defaultFontColor = Color(0xFFEFF5FE); // Default font color
  static const Color bottomNavBackgroundColor = Color(0xFFE0E0E0); // Custom color for the Bottom Navigation Bar
  static const Color textColor = Color(0xFF011A51);

  static ThemeData get purpleTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: mainColor,
        primary: mainColor,
        secondary: Colors.white,
      ),
      useMaterial3: true, // Enable Material 3 design
      scaffoldBackgroundColor:defaultFontColor ,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        backgroundColor: mainColor,
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
        buttonColor: mainColor,
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white, // Text color
          backgroundColor: mainColor, // Button color
          textStyle: GoogleFonts.titilliumWeb(
            fontSize: 16,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          elevation: 4, // Shadow elevation
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14), // Padding inside the button
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: mainColor), // Default border color
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: mainColor), // Unfocused border
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: mainColor, width: 2), // Focused border
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
        backgroundColor: mainColor, // Custom background color for Bottom Navigation Bar
        selectedItemColor: defaultFontColor, // Color for the selected item
        unselectedItemColor: defaultFontColor.withOpacity(0.6), // Color for unselected items
        selectedLabelStyle: GoogleFonts.titilliumWeb(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: GoogleFonts.titilliumWeb(
          fontSize: 12,
        ),
        showUnselectedLabels: true, // Show labels for unselected items
      ),
    );
  }

  static AppBar defaultAppBar(String title, {List<Widget>? actions}) {
    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.titilliumWeb(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: actions,
      backgroundColor: mainColor,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
    );
  }
}
