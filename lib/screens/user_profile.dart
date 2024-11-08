import 'package:flutter/material.dart';
import '../models/user.dart';
import '../widgets/user_form.dart';

class UserProfilePage extends StatefulWidget {
  final User user;
  final Function(User) onUpdate;

  const UserProfilePage({
    super.key,
    required this.user,
    required this.onUpdate,
  });

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  bool _isEditMode = false;

  void _toggleEditMode() {
    setState(() {
      _isEditMode = !_isEditMode;
    });
  }

  double? _calculateBMI(double weight, double height) {
    if (weight <= 0 || height <= 0) return null;
    return weight / ((height / 100) * (height / 100));
  }

  @override
  Widget build(BuildContext context) {
    final bmi = _calculateBMI(widget.user.bodyweight, widget.user.height);
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditMode ? Icons.check : Icons.edit),
            onPressed: _toggleEditMode,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isEditMode
            ? UserForm(
          onSubmit: (double? weight, double? height, int? age, String? gender) {
            final updatedUser = User(
              bodyweight: weight ?? widget.user.bodyweight,
              height: height ?? widget.user.height,
              age: age ?? widget.user.age,
              gender: gender ?? widget.user.gender,
            );
            widget.onUpdate(updatedUser);
            _toggleEditMode();
          },
          initialWeight: widget.user.bodyweight,
          initialHeight: widget.user.height,
          initialAge: widget.user.age,
          initialGender: widget.user.gender,
        )
            : _buildPreviewMode(bmi),
      ),
    );
  }

  Widget _buildPreviewMode(double? bmi) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Weight: ${widget.user.bodyweight} kg', style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 16),
        Text('Height: ${widget.user.height} cm', style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 16),
        Text('Age: ${widget.user.age}', style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 16),
        Text('Gender: ${widget.user.gender}', style: const TextStyle(fontSize: 16)),
        const SizedBox(height: 16),
        if (bmi != null)
          Text('BMI: ${bmi.toStringAsFixed(1)}', style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
