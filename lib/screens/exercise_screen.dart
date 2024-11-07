import 'package:flutter/material.dart';
import '../models/workout.dart';
import 'exercise_detail_screen.dart'; // Import the new screen

class ExerciseProgressionScreen extends StatelessWidget {
  final List<Workout> workouts;

  ExerciseProgressionScreen({required this.workouts});

  @override
  Widget build(BuildContext context) {
    Map<String, List<Workout>> groupedWorkouts = {};

    // Group workouts by exercise
    for (var workout in workouts) {
      if (!groupedWorkouts.containsKey(workout.exercise)) {
        groupedWorkouts[workout.exercise] = [];
      }
      groupedWorkouts[workout.exercise]!.add(workout);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise'),
      ),
      body: ListView.builder(
        itemCount: groupedWorkouts.keys.length,
        itemBuilder: (context, index) {
          String exercise = groupedWorkouts.keys.elementAt(index);
          List<Workout> exerciseWorkouts = groupedWorkouts[exercise]!;

          return ListTile(
            title: Text(exercise),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ExerciseDetailScreen(
                    exercise: exercise,
                    workouts: exerciseWorkouts,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
