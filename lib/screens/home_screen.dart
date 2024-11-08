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
import '../screens/exercise_screen.dart';
import '../screens/user_profile.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const HomeScreen({super.key, required this.onToggleTheme});

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
  String? gender;
  List<Workout> workouts = [];
  Map<String, MuscleIntensity> muscleIntensity = {};
  Timer? _timer;
  int _selectedIndex = 0;

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
      gender = userData['gender'];

      if (bodyweight != null && height != null && age != null && gender != null) {
        user = User(
          bodyweight: bodyweight!,
          height: height!,
          age: age!,
          gender: gender!,
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

  void updateUserInfo(double? weight, double? height, int? age, String? gender) async {
    await UserPreferences.saveUserData(
      weight: weight,
      height: height,
      age: age,
      gender: gender,
    );
    setState(() {
      bodyweight = weight;
      this.height = height;
      this.age = age;
      this.gender = gender;

      if (weight != null && height != null && age != null && gender != null) {
        user = User(
          bodyweight: weight,
          height: height,
          age: age,
          gender: gender,
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
    muscleIntensity[workout.muscleGroup] = intensity.copyWith(
      intensity: intensity.intensity - workout.intensity,
      totalVolume: intensity.totalVolume - workout.volumeLoad,
    );
  }

  void _onItemTapped(int index) {
    if (index == 2 && user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete your profile information first'),
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Widget _getSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return _buildStatsContent();
      case 2:
        return _buildProfileContent();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        if (showUserForm)
          UserForm(
            onSubmit: updateUserInfo,
            initialWeight: bodyweight,
            initialHeight: height,
            initialAge: age,
            initialGender: gender,
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
            onDelete: deleteWorkout,
            userBodyweight: bodyweight,
          ),
        if (muscleIntensity.isEmpty && workouts.isEmpty)
          const Center(child: Text("No data available. Please add workouts.")),
      ],
    );
  }

  Widget _buildStatsContent() {
    return ExerciseProgressionScreen(workouts: workouts);
  }

  Widget _buildProfileContent() {
    if (user == null) {
      return const Center(
        child: Text('Please complete your profile information first'),
      );
    } else {
      return UserProfilePage(
        user: user!,
        onUpdate: (updatedUser) {
          setState(() {
            user = updatedUser;
            bodyweight = updatedUser.bodyweight;
            height = updatedUser.height;
            age = updatedUser.age;
            gender = updatedUser.gender;
          });
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex == 0
          ? AppBar(
        title: const Text('Workout Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.onToggleTheme,
          ),
        ],
      )
          : null,
      body: _getSelectedScreen(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              spreadRadius: 0.5,
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart),
                label: 'Stats',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
            unselectedItemColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
