class SchoolModel {
  final String faculty;

  SchoolModel({required this.faculty});

  get name => null;

  static SchoolModel fromMap(Map<String, dynamic> map) {
    return SchoolModel(
      faculty: map['faculty'] ?? "default faculty",
    );
  }
}
