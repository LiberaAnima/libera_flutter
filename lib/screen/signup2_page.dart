import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:libera_flutter/screen/home_page.dart';

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                child: TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'ニックネーム',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              const Text("大学",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              CupertinoButton(
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context,
                    barrierDismissible: true, // Add this line
                    builder: (BuildContext context) {
                      return Container(
                        height: 200, // You can change this value
                        color: Colors.white,
                        child: CupertinoPicker(
                          itemExtent: 32,
                          onSelectedItemChanged: (int index) {
                            setState(() {
                              schoolDropdouwnValue = list_school[index];
                            });
                          },
                          children: list_school.map((String value) {
                            return Text(value);
                          }).toList(),
                        ),
                      );
                    },
                  );
                },
                child: Text(schoolDropdouwnValue),
              ),
              // faculty
              const Text("学部",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

              CupertinoButton(
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context,
                    barrierDismissible: true, // Add this line
                    builder: (BuildContext context) {
                      return Container(
                        height: 200, // You can change this value
                        color: Colors.white,
                        child: CupertinoPicker(
                          itemExtent: 32,
                          onSelectedItemChanged: (int index) {
                            setState(() {
                              facultyDropdouwnValue = list_faculty[index];
                            });
                          },
                          children: list_faculty.map((String value) {
                            return Text(value);
                          }).toList(),
                        ),
                      );
                    },
                  );
                },
                child: Text(facultyDropdouwnValue),
              ),

              // year
              const Text("学年",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              CupertinoButton(
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context,
                    barrierDismissible: true, // Add this line
                    builder: (BuildContext context) {
                      return Container(
                        height: 200, // You can change this value
                        color: Colors.white,
                        child: CupertinoPicker(
                          itemExtent: 32,
                          onSelectedItemChanged: (int index) {
                            setState(() {
                              yearDropdouwnValue = list_year[index];
                            });
                          },
                          children: list_year.map((String value) {
                            return Text(value);
                          }).toList(),
                        ),
                      );
                    },
                  );
                },
                child: Text(yearDropdouwnValue),
              ),
              // gender
              const Text("性別",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              CupertinoButton(
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context,
                    barrierDismissible: true, // Add this line
                    builder: (BuildContext context) {
                      return Container(
                        height: 200, // You can change this value
                        color: Colors.white,
                        child: CupertinoPicker(
                          itemExtent: 32,
                          onSelectedItemChanged: (int index) {
                            setState(() {
                              genderDropdouwnValue = list_sex[index];
                            });
                          },
                          children: list_sex.map((String value) {
                            return Text(value);
                          }).toList(),
                        ),
                      );
                    },
                  );
                },
                child: Text(genderDropdouwnValue),
              ),

              const SizedBox(
                height: 20,
              ),

              const SizedBox(
                height: 20,
              ),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.orange,
                  ),
                  onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;
                    print(user);
                    if (user != null) {
                      Map<String, Map<String, List<String>>> timetableTemplate =
                          {
                        'monday': {},
                        'tuesday': {},
                        'wednesday': {},
                        'thursday': {},
                        'friday': {}
                      };
                      timetableTemplate.forEach((day, dayMap) {
                        for (var period = 1; period <= 5; period++) {
                          dayMap[period.toString()] = ["", ""];
                        }
                      });

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
                        'timetable': timetableTemplate,
                      });

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    }
                  },
                  child: const Text('アカウントを作成'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
