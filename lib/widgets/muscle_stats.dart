import 'package:flutter/material.dart';
import '../models/muscle_data.dart';

class MuscleStats extends StatelessWidget {
  final Map<String, MuscleIntensity> muscleIntensity;

  const MuscleStats({super.key, required this.muscleIntensity});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Muscle Group Stats',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: muscleIntensity.entries.map((entry) {
                final muscle = entry.value;
                return Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: muscle.color.withOpacity(
                      0.3 + (muscle.intensity / 10).clamp(0, 0.7),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Text(
                        muscle.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Intensity: ${muscle.intensity.toStringAsFixed(1)}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        'Volume: ${(muscle.totalVolume / 1000).toStringAsFixed(1)}k kg',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
