import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Signup2Page extends StatefulWidget {
  final UserCredential userCredential;

  const Signup2Page({Key? key, required this.userCredential}) : super(key: key);

  @override
  _Signup2PageState createState() => _Signup2PageState();
}

class _Signup2PageState extends State<Signup2Page> {
  final _ageController = TextEditingController();
  final _genderController = TextEditingController();
  final _schoolController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("授業画面"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _ageController,
              decoration: InputDecoration(
                labelText: 'Age',
              ),
            ),
            TextFormField(
              controller: _genderController,
              decoration: InputDecoration(
                labelText: 'Gender',
              ),
            ),
            TextFormField(
              controller: _schoolController,
              decoration: InputDecoration(
                labelText: 'School',
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
                    'age': _ageController.text,
                    'gender': _genderController.text,
                    'school': _schoolController.text,
                    'uid': user.uid,
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
