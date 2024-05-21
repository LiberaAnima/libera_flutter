import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:libera_flutter/components/school_select.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({Key? key}) : super(key: key);

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String? _selectedSchool;
  String? _selectedField;
  String? _selectedValue;

  String schoolDropdouwnValue = 'School';
  String facultyDropdouwnValue = 'Faculty';
  String fieldDropdouwnValue = 'Field';

  Future<QuerySnapshot<Map<String, dynamic>>> getSchools() {
    return FirebaseFirestore.instance.collection('school').get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("プロフィール編集"),
      ),
      body: Center(
        child: SchoolDropdown(
          futureSchools: getSchools(),
          onSchoolSelected: (String? school) {
            schoolDropdouwnValue = school!;
          },
          onFacultySelected: (String? faculty) {
            facultyDropdouwnValue = faculty!;
          },
          onFieldSelected: (String? field) {
            fieldDropdouwnValue = field!;
          },
        ),
      ),
    );
  }
}
