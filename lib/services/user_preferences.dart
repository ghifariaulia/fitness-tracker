import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String _keyWeight = 'weight';
  static const String _keyHeight = 'height';
  static const String _keyAge = 'age';

  static Future<void> saveUserData({
    double? weight,
    double? height,
    int? age,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (weight != null) await prefs.setDouble(_keyWeight, weight);
    if (height != null) await prefs.setDouble(_keyHeight, height);
    if (age != null) await prefs.setInt(_keyAge, age);
  }

  static Future<Map<String, dynamic>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'weight': prefs.getDouble(_keyWeight),
      'height': prefs.getDouble(_keyHeight),
      'age': prefs.getInt(_keyAge),
    };
  }
}
