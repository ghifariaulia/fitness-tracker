import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'screens/home_screen.dart';
import 'services/themes.dart';

void main() {
  if (!kIsWeb) {
    try {
      // Initialize FFI for desktop platforms only
      if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
        sqfliteFfiInit();
        databaseFactory = databaseFactoryFfi;
      }
    } catch (e) {
      print("Platform check not applicable on the web.");
    }
  }
  runApp(const WorkoutTrackerApp());
}

class WorkoutTrackerApp extends StatefulWidget {
  const WorkoutTrackerApp({super.key});

  @override
  WorkoutTrackerAppState createState() => WorkoutTrackerAppState();
}

class WorkoutTrackerAppState extends State<WorkoutTrackerApp> {

  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Workout Tracker',
      theme: _isDarkMode ? darkTheme : lightTheme,
      home: HomeScreen(onToggleTheme: _toggleTheme),
    );
  }
}
