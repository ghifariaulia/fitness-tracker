import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/workout.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final String exercise;
  final List<Workout> workouts;

  ExerciseDetailScreen({required this.exercise, required this.workouts});

  @override
  Widget build(BuildContext context) {
    workouts.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return Scaffold(
      appBar: AppBar(
        title: Text('$exercise Progression'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < workouts.length) {
                            final date = DateTime.parse(workouts[index].timestamp);
                            return Text('${date.month}/${date.day}');
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text('${value.toInt()} kg');
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: workouts.asMap().entries.map((entry) {
                        int index = entry.key;
                        Workout workout = entry.value;
                        return FlSpot(index.toDouble(), workout.weight);
                      }).toList(),
                      isCurved: true,
                      barWidth: 2,
                      color: Colors.blue,
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: workouts.length,
              itemBuilder: (context, index) {
                final workout = workouts[index];
                return ListTile(
                  title: Text('Date: ${workout.timestamp}'),
                  subtitle: Text('Weight: ${workout.weight} kg, Sets: ${workout.sets}, Reps: ${workout.reps}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
