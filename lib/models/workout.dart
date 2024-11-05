class Workout {
  final String id;
  final String muscleGroup;
  final String exercise;
  final int sets;
  final int reps;
  final double weight;
  final bool isBodyweight;
  final double additionalWeight;
  final int restTime;
  final double intensity;
  final double volumeLoad;
  final String timestamp;

  Workout({
    required this.id,
    required this.muscleGroup,
    required this.exercise,
    required this.sets,
    required this.reps,
    required this.weight,
    required this.isBodyweight,
    required this.additionalWeight,
    required this.restTime,
    required this.intensity,
    required this.volumeLoad,
    required this.timestamp,
  });
}