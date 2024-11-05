import 'package:flutter/material.dart';
import 'dart:async';
import '../services/database_helper.dart';
import '../services/user_preferences.dart';
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
  final DatabaseHelper _dbHelper = DatabaseHelper();
  bool showUserForm = true;
  double? bodyweight;
  double? height;
  int? age;
  List<Workout> workouts = [];
  Map<String, MuscleIntensity> muscleIntensity = {};
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeMuscleIntensity();
    _loadUserData();
    _loadWorkouts();
    _startPeriodicCheck();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _initializeMuscleIntensity() {
    for (var entry in muscleGroups.entries) {
      muscleIntensity[entry.key] = MuscleIntensity(
        name: entry.value.name,
        intensity: 0.0,
        totalVolume: 0.0,
        baseColor: entry.value.color,
      );
    }
  }

  Future<void> _loadUserData() async {
    final userData = await UserPreferences.getUserData();
    setState(() {
      bodyweight = userData['weight'];
      height = userData['height'];
      age = userData['age'];
      showUserForm = bodyweight == null || height == null || age == null;
    });
  }

  Future<void> _loadWorkouts() async {
    final loadedWorkouts = await _dbHelper.getWorkouts();
    setState(() {
      workouts = loadedWorkouts;
      _updateMuscleIntensity();
    });
  }

  void _startPeriodicCheck() {
    _timer = Timer.periodic(Duration(days: 1), (timer) {
      _decreaseOldWorkoutsIntensity();
    });
  }

  void _decreaseOldWorkoutsIntensity() {
    final currentDate = DateTime.now();
    for (var workout in workouts) {
      final workoutDate = DateTime.parse(workout.timestamp);
      if (currentDate.difference(workoutDate).inDays > 7) {
        _decreaseMuscleIntensity(workout);
      }
    }
    setState(() {});
  }

  void updateUserInfo(double? weight, double? height, int? age) async {
    await UserPreferences.saveUserData(
      weight: weight,
      height: height,
      age: age,
    );
    setState(() {
      bodyweight = weight;
      this.height = height;
      this.age = age;
      showUserForm = false;
    });
  }

  void addWorkout(Workout workout) async {
    await _dbHelper.insertWorkout(workout);
    setState(() {
      workouts.add(workout);
      _updateMuscleIntensity();
    });
  }

  void deleteWorkout(String id) async {
    await _dbHelper.deleteWorkout(id);
    setState(() {
      workouts.removeWhere((w) => w.id == id);
      _updateMuscleIntensity();
    });
  }

  void _updateMuscleIntensity() {
    for (var workout in workouts) {
      _updateMuscleIntensityForWorkout(workout);
    }
  }

  void _updateMuscleIntensityForWorkout(Workout workout) {
    final intensity = muscleIntensity[workout.muscleGroup]!;
    muscleIntensity[workout.muscleGroup] = intensity.copyWith(
      intensity: intensity.intensity + workout.intensity,
      totalVolume: intensity.totalVolume + workout.volumeLoad,
    );
  }

  void _decreaseMuscleIntensity(Workout workout) {
    final intensity = muscleIntensity[workout.muscleGroup]!;
    // Decrease intensity by the workout's intensity for workouts older than a week
    muscleIntensity[workout.muscleGroup] = intensity.copyWith(
      intensity: intensity.intensity - workout.intensity,
      totalVolume: intensity.totalVolume - workout.volumeLoad,
    );
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
          if (muscleIntensity.isNotEmpty)
            MuscleStats(muscleIntensity: muscleIntensity),
          WorkoutForm(
            onSubmit: addWorkout,
            bodyweight: bodyweight,
          ),
          if (workouts.isNotEmpty)
            WorkoutList(
              workouts: workouts,
              onDelete: deleteWorkout, userBodyweight: bodyweight,
            ),
          if (muscleIntensity.isEmpty && workouts.isEmpty)
            const Center(
                child: Text("No data available. Please add workouts.")),
        ],
      ),
    );
  }
}
