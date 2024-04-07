import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

const List<String> list_sex = <String>['男性', '女性', 'その他'];
const List<String> list_year = <String>['B1', 'B2', 'B3', 'B4', 'M1', 'M2'];
const List<String> list_school = <String>['関西学院大学', '神戸大学'];
const List<String> list_faculty = <String>['法学部', '経営学部', '理工学部'];

class Signup2Page extends StatefulWidget {
  final UserCredential userCredential;

  const Signup2Page({Key? key, required this.userCredential}) : super(key: key);

  @override
  _Signup2PageState createState() => _Signup2PageState();
}

class _Signup2PageState extends State<Signup2Page> {
  String genderDropdouwnValue = 'Sex';
  String yearDropdouwnValue = 'Year';
  String schoolDropdouwnValue = 'School';
  String facultyDropdouwnValue = 'Faculty';
  final _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("授業画面"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            DropdownMenu<String>(
              menuStyle: MenuStyle(),
              initialSelection: list_school.first,
              onSelected: (String? value) {
                setState(
                  () {
                    schoolDropdouwnValue = value!;
                  },
                );
              },
              dropdownMenuEntries: list_school
                  .map<DropdownMenuEntry<String>>((String value) =>
                      DropdownMenuEntry<String>(value: value, label: value))
                  .toList(),
            ),
            // faculty
            DropdownMenu<String>(
              menuStyle: MenuStyle(),
              initialSelection: list_faculty.first,
              onSelected: (String? value) {
                setState(
                  () {
                    facultyDropdouwnValue = value!;
                  },
                );
              },
              dropdownMenuEntries: list_faculty
                  .map<DropdownMenuEntry<String>>((String value) =>
                      DropdownMenuEntry<String>(value: value, label: value))
                  .toList(),
            ),
            // year
            DropdownMenu<String>(
              menuStyle: MenuStyle(),
              initialSelection: list_year.first,
              onSelected: (String? value) {
                setState(
                  () {
                    yearDropdouwnValue = value!;
                  },
                );
              },
              dropdownMenuEntries: list_year
                  .map<DropdownMenuEntry<String>>((String value) =>
                      DropdownMenuEntry<String>(value: value, label: value))
                  .toList(),
            ),
            SizedBox(
              height: 20,
            ),
            // gender
            DropdownMenu<String>(
              menuStyle: MenuStyle(),
              initialSelection: list_sex.first,
              onSelected: (String? value) {
                setState(
                  () {
                    genderDropdouwnValue = value!;
                  },
                );
              },
              dropdownMenuEntries: list_sex
                  .map<DropdownMenuEntry<String>>((String value) =>
                      DropdownMenuEntry<String>(value: value, label: value))
                  .toList(),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Nickname',
              ),
            ),

            ElevatedButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                print(user);
                if (user != null) {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .set({
                    'email': user.email,
                    'uid': user.uid,
                    'school': schoolDropdouwnValue,
                    'faculty': facultyDropdouwnValue,
                    'year': yearDropdouwnValue,
                    'gender': genderDropdouwnValue,
                    'username': _usernameController.text,
                  });

                  Navigator.pushNamed(context, '/');
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
