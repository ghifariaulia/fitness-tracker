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
  final Color baseColor;

  const MuscleIntensity({
    required this.name,
    required this.intensity,
    required this.totalVolume,
    required this.baseColor,
  });

  Color get color => Color.lerp(baseColor, Colors.pink, intensity / 200)!;

  MuscleIntensity copyWith({
    double? intensity,
    double? totalVolume,
  }) {
    return MuscleIntensity(
      name: this.name,
      intensity: intensity ?? this.intensity,
      totalVolume: totalVolume ?? this.totalVolume,
      baseColor: this.baseColor,
    );
  }
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
      'Dips'
    ],
    color: Colors.grey[300]!,
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
    color: Colors.grey[300]!,
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
    color: Colors.grey[300]!,
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
    color: Colors.grey[300]!,
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
    color: Colors.grey[300]!,
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
    color: Colors.grey[300]!,
  ),
};