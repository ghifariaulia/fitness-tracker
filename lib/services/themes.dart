import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager {
  static const String _themeKey = 'theme_preference';

  Future<void> saveThemePreference(bool isDarkMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDarkMode);
  }

  Future<bool> loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false; // Default to light mode
  }
}

final ThemeData lightTheme = ThemeData(
  textTheme: GoogleFonts.rubikTextTheme(),
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Colors.blue,
    unselectedItemColor: Colors.grey,
  ),
);

final ThemeData darkTheme = ThemeData(
  textTheme: GoogleFonts.rubikTextTheme(
    ThemeData(brightness: Brightness.dark).textTheme.apply(
          bodyColor: Colors.white, // Change default text color for dark mode
          displayColor: Colors.white,
        ),
  ),
  brightness: Brightness.dark,
  primarySwatch: Colors.blue,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.grey[900],
    foregroundColor: Colors.white,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.grey[850],
    selectedItemColor: Colors.blue,
    unselectedItemColor: Colors.grey,
  ),
);
