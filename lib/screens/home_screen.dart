import 'package:flutter/material.dart';
import '../widgets/user_form.dart';
import '../widgets/muscle_stats.dart';
import '../widgets/workout_form.dart';
import '../widgets/workout_list.dart';
import '../models/workout.dart';
import '../models/muscle_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  bool showUserForm = true;
  double? bodyweight;
  double? height;
  int? age;
  List<Workout> workouts = [];
  Map<String, MuscleIntensity> muscleIntensity = {};

  @override
  void initState() {
    super.initState();
    _initializeMuscleIntensity();
  }

  void _initializeMuscleIntensity() {
    muscleGroups.forEach((key, value) {
      muscleIntensity[key] = MuscleIntensity(
        name: value.name,
        intensity: 0,
        totalVolume: 0,
        color: value.color,
      );
    });
  }

  void updateUserInfo(double? weight, double? height, int? age) {
    setState(() {
      bodyweight = weight;
      this.height = height;
      this.age = age;
      showUserForm = false;
    });
  }

  void addWorkout(Workout workout) {
    setState(() {
      workouts.add(workout);
      _updateMuscleIntensity(workout);
    });
  }

  void deleteWorkout(String id) {
    setState(() {
      final workout = workouts.firstWhere((w) => w.id == id);
      _decreaseMuscleIntensity(workout);
      workouts.removeWhere((w) => w.id == id);
    });
  }

  void _updateMuscleIntensity(Workout workout) {
    setState(() {
      final intensity = muscleIntensity[workout.muscleGroup]!;
      muscleIntensity[workout.muscleGroup] = MuscleIntensity(
        name: intensity.name,
        intensity: intensity.intensity + workout.intensity,
        totalVolume: intensity.totalVolume + workout.volumeLoad,
        color: intensity.color,
      );
    });
  }

  void _decreaseMuscleIntensity(Workout workout) {
    setState(() {
      final intensity = muscleIntensity[workout.muscleGroup]!;
      muscleIntensity[workout.muscleGroup] = MuscleIntensity(
        name: intensity.name,
        intensity: intensity.intensity - workout.intensity,
        totalVolume: intensity.totalVolume - workout.volumeLoad,
        color: intensity.color,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Tracker'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          if (showUserForm)
            UserForm(
              onSubmit: updateUserInfo,
              initialWeight: bodyweight,
              initialHeight: height,
              initialAge: age,
            ),
          MuscleStats(muscleIntensity: muscleIntensity),
          WorkoutForm(
            onSubmit: addWorkout,
            bodyweight: bodyweight,
          ),
          WorkoutList(
            workouts: workouts,
            onDelete: deleteWorkout,
          ),
        ],
      ),
    );
  }
}