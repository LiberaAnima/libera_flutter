import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:libera_flutter/components/button.dart';
import 'package:libera_flutter/components/school_select.dart';
import 'package:libera_flutter/screen/home_page.dart';

const List<String> list_sex = <String>['男性', '女性', 'その他'];
const List<String> list_year = <String>['B1', 'B2', 'B3', 'B4', 'M1', 'M2'];

class Signup2Page extends StatefulWidget {
  final UserCredential userCredential;

  const Signup2Page({super.key, required this.userCredential});

  @override
  _Signup2PageState createState() => _Signup2PageState();
}

class _Signup2PageState extends State<Signup2Page> {
  String genderDropdouwnValue = '性別';
  String yearDropdouwnValue = 'Year';
  String schoolDropdouwnValue = 'School';
  String facultyDropdouwnValue = 'Faculty';
  String fieldDropdouwnValue = 'Field';
  final _usernameController = TextEditingController();

  Future<QuerySnapshot<Map<String, dynamic>>> getSchools() {
    return FirebaseFirestore.instance.collection('school').get();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {FocusScope.of(context).unfocus()},
      child: Scaffold(
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
                const SizedBox(
                  height: 10,
                ),
                SchoolDropdown(
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

                // const Text("学部",
                //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                // CupertinoButton(
                //   onPressed: () {
                //     showCupertinoModalPopup(
                //       context: context,
                //       barrierDismissible: true, // Add this line
                //       builder: (BuildContext context) {
                //         return Container(
                //           height: 200, // You can change this value
                //           color: Colors.white,
                //           child: CupertinoPicker(
                //             itemExtent: 32,
                //             onSelectedItemChanged: (int index) {
                //               setState(() {
                //                 facultyDropdouwnValue = list_faculty[index];
                //               });
                //             },
                //             children: list_faculty.map((String value) {
                //               return Text(value);
                //             }).toList(),
                //           ),
                //         );
                //       },
                //     );
                //   },
                //   child: Text(facultyDropdouwnValue),
                // ),
                const SizedBox(
                  height: 20,
                ),
                // year
                const Text("学年",
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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

                SendButton(
                  text: "アカウントを作成",
                  onPressed: () async {
                    final user = FirebaseAuth.instance.currentUser;
                    // print(user);
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
                        'field': fieldDropdouwnValue,
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
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
