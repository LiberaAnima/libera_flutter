// lib/models/user_model.dart
class UserModel {
  final String uid;
  final String email;
  final String username;
  final String faculty;
  final String school;
  final String gender;
  final String year;

  UserModel({
    required this.uid,
    required this.email,
    required this.username,
    required this.faculty,
    required this.school,
    required this.gender,
    required this.year,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'],
      email: data['email'],
      username: data['username'],
      faculty: data['faculty'],
      school: data['school'],
      gender: data['gender'],
      year: data['year'],
    );
  }
}
