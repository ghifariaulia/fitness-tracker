import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user_preferences.dart';

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
  late TextEditingController _bodyweightController;
  late TextEditingController _heightController;
  late TextEditingController _ageController;

  @override
  void initState() {
    super.initState();
    _bodyweightController = TextEditingController(
      text: widget.user.bodyweight.toString(),
    );
    _heightController = TextEditingController(
      text: widget.user.height.toString(),
    );
    _ageController = TextEditingController(
      text: widget.user.age.toString(),
    );
  }

  @override
  void dispose() {
    _bodyweightController.dispose();
    _heightController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _updateUser() {
    final updatedUser = User(
      bodyweight: double.tryParse(_bodyweightController.text) ?? widget.user.bodyweight,
      height: double.tryParse(_heightController.text) ?? widget.user.height,
      age: int.tryParse(_ageController.text) ?? widget.user.age,
    );

    widget.onUpdate(updatedUser);
    UserPreferences.saveUserData(
      weight: updatedUser.bodyweight,
      height: updatedUser.height,
      age: updatedUser.age,
    );

    Navigator.pop(context); // Close the profile page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Bodyweight (kg):', style: TextStyle(fontSize: 16)),
            TextField(
              controller: _bodyweightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Enter your bodyweight'),
            ),
            const SizedBox(height: 16),
            const Text('Height (cm):', style: TextStyle(fontSize: 16)),
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Enter your height'),
            ),
            const SizedBox(height: 16),
            const Text('Age:', style: TextStyle(fontSize: 16)),
            TextField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Enter your age'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateUser,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
