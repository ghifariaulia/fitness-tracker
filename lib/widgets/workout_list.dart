import 'package:flutter/material.dart';
import '../models/workout.dart';
import 'package:intl/intl.dart';

class WorkoutList extends StatelessWidget {
  final List<Workout> workouts;
  final Function(String) onDelete;

  const WorkoutList({
    super.key,
    required this.workouts,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final groupedWorkouts = groupWorkoutsByDateAndSession(workouts);

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: groupedWorkouts.length,
      itemBuilder: (context, dateIndex) {
        final date = groupedWorkouts.keys.elementAt(dateIndex);
        final sessions = groupedWorkouts[date]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                date,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sessions.length,
              itemBuilder: (context, sessionIndex) {
                final sessionWorkouts = sessions[sessionIndex];
                final totalVolumeLoad = sessionWorkouts
                    .map((w) => w.volumeLoad)
                    .reduce((a, b) => a + b);

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Session ${sessionIndex + 1}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Total Volume: ${(totalVolumeLoad / 1000).toStringAsFixed(1)}k kg',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1),
                      ...sessionWorkouts.map((workout) {
                        return Dismissible(
                          key: Key(workout.id),
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 16),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          direction: DismissDirection.endToStart,
                          onDismissed: (_) => onDelete(workout.id),
                          child: ListTile(
                            title: Text(workout.exercise),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${workout.sets} sets × ${workout.reps} reps'),
                                Text(
                                  workout.isBodyweight
                                      ? 'Bodyweight + ${workout.additionalWeight}kg'
                                      : '${workout.weight}kg',
                                ),
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${(workout.volumeLoad / 1000).toStringAsFixed(1)}k kg',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Rest: ${workout.restTime}s',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Map<String, List<List<Workout>>> groupWorkoutsByDateAndSession(
      List<Workout> workouts) {
    final grouped = <String, List<List<Workout>>>{};

    // First, group by date
    for (var workout in workouts) {
      final date = DateFormat('MMMM d, yyyy').format(
        DateTime.parse(workout.timestamp),
      );

      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }

      // Find the appropriate session or create a new one
      DateTime workoutTime = DateTime.parse(workout.timestamp);
      bool addedToExistingSession = false;

      for (var session in grouped[date]!) {
        DateTime sessionTime = DateTime.parse(session.first.timestamp);
        // If workout is within 2 hours of the first workout in the session,
        // add it to that session
        if (workoutTime.difference(sessionTime).inHours.abs() <= 2) {
          session.add(workout);
          addedToExistingSession = true;
          break;
        }
      }

      if (!addedToExistingSession) {
        // Create a new session
        grouped[date]!.add([workout]);
      }
    }

    // Sort workouts within each session by timestamp
    for (var date in grouped.keys) {
      for (var session in grouped[date]!) {
        session.sort((a, b) => DateTime.parse(a.timestamp)
            .compareTo(DateTime.parse(b.timestamp)));
      }
    }

    // Sort dates in reverse chronological order
    return Map.fromEntries(
      grouped.entries.toList()
        ..sort((a, b) {
          final dateA = DateTime.parse(a.value.first.first.timestamp);
          final dateB = DateTime.parse(b.value.first.first.timestamp);
          return dateB.compareTo(dateA);
        }),
    );
  }
}