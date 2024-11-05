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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'muscleGroup': muscleGroup,
      'exercise': exercise,
      'sets': sets,
      'reps': reps,
      'weight': weight,
      'isBodyweight': isBodyweight ? 1 : 0,
      'additionalWeight': additionalWeight,
      'restTime': restTime,
      'intensity': intensity,
      'volumeLoad': volumeLoad,
      'timestamp': timestamp,
    };
  }

  factory Workout.fromMap(Map<String, dynamic> map) {
    return Workout(
      id: map['id'],
      muscleGroup: map['muscleGroup'],
      exercise: map['exercise'],
      sets: map['sets'],
      reps: map['reps'],
      weight: map['weight'],
      isBodyweight: map['isBodyweight'] == 1,
      additionalWeight: map['additionalWeight'],
      restTime: map['restTime'],
      intensity: map['intensity'],
      volumeLoad: map['volumeLoad'],
      timestamp: map['timestamp'],
    );
  }
}