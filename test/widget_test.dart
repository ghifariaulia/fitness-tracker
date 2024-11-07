import 'package:fitness_tracker/services/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_tracker/main.dart'; // Ensure this path matches your project structure

void main() {
  testWidgets('Basic UI test for WorkoutTrackerApp', (WidgetTester tester) async {
    // Initialize the ThemeManager
    final themeManager = ThemeManager();

    // Build the app and trigger a frame.
    await tester.pumpWidget(WorkoutTrackerApp(isDarkMode: false, themeManager: themeManager));

    // Verify that the app bar title is present.
    expect(find.text('Workout Tracker'), findsOneWidget);

    // Verify that a button with the icon 'brightness_6' (theme toggle) is present.
    expect(find.byIcon(Icons.brightness_6), findsOneWidget);

    // Tap the theme toggle button and trigger a frame.
    await tester.tap(find.byIcon(Icons.brightness_6));
    await tester.pump();

    // Add more interactions and verifications as needed.
  });
}
