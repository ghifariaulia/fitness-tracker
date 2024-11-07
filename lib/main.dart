import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'screens/home_screen.dart';
import 'services/themes.dart';

main() async {
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
  WidgetsFlutterBinding.ensureInitialized();
  final themeManager = ThemeManager();
  final isDarkMode = await themeManager.loadThemePreference();
  runApp(WorkoutTrackerApp(isDarkMode: isDarkMode, themeManager: themeManager));
}

class WorkoutTrackerApp extends StatefulWidget {
  final bool isDarkMode;
  final ThemeManager themeManager;

  const WorkoutTrackerApp(
      {super.key, required this.isDarkMode, required this.themeManager});

  @override
  WorkoutTrackerAppState createState() => WorkoutTrackerAppState();
}

class WorkoutTrackerAppState extends State<WorkoutTrackerApp> {
  late bool _isDarkMode;


  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
    widget.themeManager.saveThemePreference(_isDarkMode);
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
