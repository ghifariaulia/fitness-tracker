class User {
  final double bodyweight;
  final double height;
  final int age;

  User({
    required this.bodyweight,
    required this.height,
    required this.age,
  });

  // Add a copyWith method for easy updates
  User copyWith({
    double? bodyweight,
    double? height,
    int? age,
  }) {
    return User(
      bodyweight: bodyweight ?? this.bodyweight,
      height: height ?? this.height,
      age: age ?? this.age,
    );
  }

  // Add fromJson constructor if you're storing user data
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      bodyweight: json['weight'] ?? 0.0,
      height: json['height'] ?? 0.0,
      age: json['age'] ?? 0,
    );
  }

  // Add toJson method if you're storing user data
  Map<String, dynamic> toJson() {
    return {
      'weight': bodyweight,
      'height': height,
      'age': age,
    };
  }
}