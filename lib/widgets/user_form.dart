import 'package:flutter/material.dart';

class UserForm extends StatefulWidget {
  final Function(double?, double?, int?) onSubmit;
  final double? initialWeight;
  final double? initialHeight;
  final int? initialAge;

  const UserForm({
    super.key,
    required this.onSubmit,
    this.initialWeight,
    this.initialHeight,
    this.initialAge,
  });

  @override
  UserFormState createState() => UserFormState();
}

class UserFormState extends State<UserForm> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _weightController.text = widget.initialWeight?.toString() ?? '';
    _heightController.text = widget.initialHeight?.toString() ?? '';
    _ageController.text = widget.initialAge?.toString() ?? '';
  }

  double? calculateBMI() {
    final weight = double.tryParse(_weightController.text);
    final height = double.tryParse(_heightController.text);
    if (weight == null || height == null) return null;
    return weight / ((height / 100) * (height / 100));
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
              'Your Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Your bodyweight (kg)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Your height (cm)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Your age',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                widget.onSubmit(
                  double.tryParse(_weightController.text),
                  double.tryParse(_heightController.text),
                  int.tryParse(_ageController.text),
                );
              },
              child: const Text('Save'),
            ),
            if (calculateBMI() != null) ...[
              const SizedBox(height: 8),
              Text(
                'Your BMI: ${calculateBMI()!.toStringAsFixed(1)}',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
