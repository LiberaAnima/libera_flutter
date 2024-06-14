import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  // String? _selectedSchool;
  // String? _selectedField;
  // String? _selectedValue;

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
      body: const Center(
        // child: SchoolDropdown(
        //   futureSchools: getSchools(),
        //   onSchoolSelected: (String? school) {
        //     schoolDropdouwnValue = school!;
        //   },
        //   onFacultySelected: (String? faculty) {
        //     facultyDropdouwnValue = faculty!;
        //   },
        //   onFieldSelected: (String? field) {
        //     fieldDropdouwnValue = field!;
        //   },
        // ),
        child: Text(
          '準備中です',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
