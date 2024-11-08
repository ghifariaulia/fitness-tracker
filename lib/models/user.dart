class User {
  final double bodyweight;
  final double height;
  final int age;
  final String gender;

  User({
    required this.bodyweight,
    required this.height,
    required this.age,
    required this.gender,
  });

  // Add a copyWith method for easy updates
  User copyWith({
    double? bodyweight,
    double? height,
    int? age,
    String? gender,
  }) {
    return User(
      bodyweight: bodyweight ?? this.bodyweight,
      height: height ?? this.height,
      age: age ?? this.age,
      gender: gender ?? this.gender,
    );
  }

  // Add fromJson constructor if you're storing user data
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      bodyweight: json['weight'] ?? 0.0,
      height: json['height'] ?? 0.0,
      age: json['age'] ?? 0,
      gender: json['gender'] ?? '',
    );
  }

  // Add toJson method if you're storing user data
  Map<String, dynamic> toJson() {
    return {
      'weight': bodyweight,
      'height': height,
      'age': age,
      'gender': gender,
    };
  }
}