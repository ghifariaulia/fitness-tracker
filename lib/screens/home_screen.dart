import 'package:fitness_tracker/screens/user_profile.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import '../models/user.dart';
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
  User? user;
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

      // Initialize user object with null-safe values
      if (bodyweight != null && height != null && age != null) {
        user = User(
          bodyweight: bodyweight!,
          height: height!,
          age: age!,
        );
        showUserForm = false;
      } else {
        user = null;
        showUserForm = true;
      }
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

      // Create new user object when form is submitted
      if (weight != null && height != null && age != null) {
        user = User(
          bodyweight: weight,
          height: height,
          age: age,
        );
        showUserForm = false;
      }
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
    final workout = workouts.firstWhere((w) => w.id == id);
    if (workout != null) {
      await _dbHelper.deleteWorkout(id);
      setState(() {
        workouts.remove(workout);
        _decreaseMuscleIntensity(workout);
      });
    }
  }

  void _updateMuscleIntensity() {
    _initializeMuscleIntensity();
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
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // Only navigate to profile if user exists
              if (user != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserProfilePage(
                      user: user!,
                      onUpdate: (updatedUser) {
                        setState(() {
                          user = updatedUser;
                          bodyweight = updatedUser.bodyweight;
                          height = updatedUser.height;
                          age = updatedUser.age;
                        });
                      },
                    ),
                  ),
                );
              } else {
                // Show a message if user profile is not yet created
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please complete your profile information first'),
                  ),
                );
              }
            },
          ),
        ],
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
          if (!showUserForm && user != null) ...[
            // Show user info summary
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Weight: ${user!.bodyweight} kg'),
                    Text('Height: ${user!.height} cm'),
                    Text('Age: ${user!.age} years'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
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
