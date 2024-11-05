import 'package:flutter/material.dart';

class MuscleGroup {
  final String name;
  final List<String> exercises;
  final Color color;

  const MuscleGroup({
    required this.name,
    required this.exercises,
    required this.color,
  });
}

class MuscleIntensity {
  final String name;
  final double intensity;
  final double totalVolume;
  final Color color;

  const MuscleIntensity({
    required this.name,
    required this.intensity,
    required this.totalVolume,
    required this.color,
  });
}

final Map<String, MuscleGroup> muscleGroups = {
  'chest': MuscleGroup(
    name: 'Chest',
    exercises: [
      'Bench Press',
      'Push-ups',
      'Dumbbell Flyes',
      'Incline Bench Press',
      'Decline Bench Press',
    ],
    color: Colors.red[300]!,
  ),
  'back': MuscleGroup(
    name: 'Back',
    exercises: [
      'Pull-ups',
      'Lat Pulldowns',
      'Barbell Rows',
      'Deadlifts',
      'Face Pulls',
    ],
    color: Colors.blue[300]!,
  ),
  'legs': MuscleGroup(
    name: 'Legs',
    exercises: [
      'Squats',
      'Lunges',
      'Leg Press',
      'Calf Raises',
      'Romanian Deadlifts',
    ],
    color: Colors.green[300]!,
  ),
  'shoulders': MuscleGroup(
    name: 'Shoulders',
    exercises: [
      'Overhead Press',
      'Lateral Raises',
      'Front Raises',
      'Reverse Flyes',
      'Shrugs',
    ],
    color: Colors.purple[300]!,
  ),
  'arms': MuscleGroup(
    name: 'Arms',
    exercises: [
      'Bicep Curls',
      'Tricep Extensions',
      'Hammer Curls',
      'Skull Crushers',
      'Chin-ups',
    ],
    color: Colors.orange[300]!,
  ),
  'core': MuscleGroup(
    name: 'Core',
    exercises: [
      'Crunches',
      'Planks',
      'Russian Twists',
      'Leg Raises',
      'Ab Wheel Rollouts',
    ],
    color: Colors.yellow[300]!,
  ),
};
