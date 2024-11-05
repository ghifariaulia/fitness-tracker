import 'package:flutter/material.dart';
import '../models/workout.dart';
import '../models/muscle_data.dart';

class WorkoutForm extends StatefulWidget {
  final Function(Workout) onSubmit;
  final double? bodyweight;

  const WorkoutForm({
    super.key,
    required this.onSubmit,
    this.bodyweight,
  });

  @override
  WorkoutFormState createState() => WorkoutFormState();
}

class WorkoutFormState extends State<WorkoutForm> {
  String selectedMuscleGroup = muscleGroups.keys.first;
  String? selectedExercise;
  final _setsController = TextEditingController();
  final _repsController = TextEditingController();
  final _weightController = TextEditingController();
  final _restTimeController = TextEditingController(text: '60');

  @override
  void initState() {
    super.initState();
    selectedExercise = muscleGroups[selectedMuscleGroup]!.exercises.first;
  }

  bool isBodyweightExercise(String exercise) {
    return [
      'Push-ups',
      'Pull-ups',
      'Chin-ups',
      'Dips',
      'Planks',
      'Crunches',
    ].contains(exercise);
  }

  void _submitWorkout() {
    final sets = int.tryParse(_setsController.text) ?? 0;
    final reps = int.tryParse(_repsController.text) ?? 0;
    final weight = double.tryParse(_weightController.text) ?? 0;
    final restTime = int.tryParse(_restTimeController.text) ?? 60;

    if (sets == 0 || reps == 0) return;

    final isBodyweight = isBodyweightExercise(selectedExercise!);
    final effectiveWeight = isBodyweight ? (widget.bodyweight ?? 0) + weight : weight;
    final volumeLoad = sets * reps * effectiveWeight;
    final intensity = volumeLoad / (sets * reps);

    final workout = Workout(
      id: DateTime.now().toString(),
      muscleGroup: selectedMuscleGroup,
      exercise: selectedExercise!,
      sets: sets,
      reps: reps,
      weight: weight,
      isBodyweight: isBodyweight,
      additionalWeight: isBodyweight ? weight : 0,
      restTime: restTime,
      intensity: intensity,
      volumeLoad: volumeLoad,
      timestamp: DateTime.now().toString(),
    );

    widget.onSubmit(workout);
    _clearForm();
  }

  void _clearForm() {
    _setsController.clear();
    _repsController.clear();
    _weightController.clear();
    _restTimeController.text = '60';
  }
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add Workout',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedMuscleGroup,
              decoration: const InputDecoration(
                labelText: 'Muscle Group',
                border: OutlineInputBorder(),
              ),
              items: muscleGroups.keys.map((String group) {
                return DropdownMenuItem<String>(
                  value: group,
                  child: Text(group),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedMuscleGroup = newValue!;
                  selectedExercise =
                      muscleGroups[selectedMuscleGroup]!.exercises.first;
                });
              },
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: selectedExercise,
              decoration: const InputDecoration(
                labelText: 'Exercise',
                border: OutlineInputBorder(),
              ),
              items: muscleGroups[selectedMuscleGroup]!.exercises.map((
                  String exercise) {
                return DropdownMenuItem<String>(
                  value: exercise,
                  child: Text(exercise),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedExercise = newValue;
                });
              },
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _setsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Sets',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _repsController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Reps',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: isBodyweightExercise(selectedExercise!)
                    ? 'Additional Weight (kg)'
                    : 'Weight (kg)',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _restTimeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Rest Time (seconds)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _submitWorkout,
              child: const Text('Add Workout'),
            ),
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    _setsController.dispose();
    _repsController.dispose();
    _weightController.dispose();
    _restTimeController.dispose();
    super.dispose();
  }
}