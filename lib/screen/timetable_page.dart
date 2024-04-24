import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/all.dart';

class TimeTablePage extends StatefulWidget {
  const TimeTablePage({Key? key}) : super(key: key);

  @override
  _TimeTablePageState createState() => _TimeTablePageState();
}

class _TimeTablePageState extends State<TimeTablePage> {
  final List<String> days = ['月', '火', '水', '木', '金'];
  final List<String> numbers = ['1', '2', '3', '4', '5'];
  final Map<int, Map<String, String>> classes = {};

//get current users
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    print(user?.uid);
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: days.map((day) => Text(day)).toList(),
                ),
              ),
              Positioned(
                top: 0,
                bottom: 0,
                left: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: numbers.map((number) => Text(number)).toList(),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 50.0, left: 30.0, right: 20.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: 25,
                  itemBuilder: (context, index) {
                    return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(user?.uid)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting)
                            return CircularProgressIndicator();
                          if (snapshot.hasError) {
                            return Text('Something went wrong');
                          } else {
                            Map<String, dynamic> data =
                                snapshot.data!.data() as Map<String, dynamic>;
                            int period = index ~/ 5 + 1;
                            String day = ''; // index % 5 -> room name
                            switch (index % 5) {
                              case 0:
                                day = '月曜';
                                break;
                              case 1:
                                day = '火曜';
                                break;
                              case 2:
                                day = '水曜';
                                break;
                              case 3:
                                day = '木曜';
                                break;
                              case 4:
                                day = '金曜';
                                break;
                            }

                            if (data.containsKey('timetable') &&
                                data['timetable'].containsKey(day) &&
                                data['timetable'][day]
                                    .containsKey(period.toString())) {
                              List<dynamic> classInfo = data['timetable'][day]
                                  [period.toString()] as List<dynamic>;
                              // Display the data
                              // print(classInfo.length);
                              // print(classInfo);

                              if (classInfo.length >= 2) {
                                print(classInfo[0] + 'a' + classInfo[1]);
                                return Container(
                                  child: Column(
                                    children: [
                                      Text(classInfo[0]),
                                      Text(classInfo[1]),
                                    ],
                                  ),
                                  // ... add more details ...
                                );
                              }
                            }
                          }
                          return GestureDetector(
                            onTap: () async {
                              int period = index ~/ 5 + 1;
                              String day = ''; // index % 5 -> room name
                              switch (index % 5) {
                                case 0:
                                  day = '月曜';
                                  break;
                                case 1:
                                  day = '火曜';
                                  break;
                                case 2:
                                  day = '水曜';
                                  break;
                                case 3:
                                  day = '木曜';
                                  break;
                                case 4:
                                  day = '金曜';
                                  break;
                              }
                              final result =
                                  await showDialog<Map<String, String>>(
                                context: context,
                                builder: (context) {
                                  String className = '';
                                  String roomName = '';

                                  return AlertDialog(
                                    title: Text('$day,$period限',
                                        textAlign: TextAlign.center),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          decoration: InputDecoration(
                                              hintText: 'Class name'),
                                          onChanged: (value) {
                                            className = value;
                                          },
                                        ),
                                        TextField(
                                          decoration: InputDecoration(
                                              hintText: 'Room name'),
                                          onChanged: (value) {
                                            roomName = value;
                                          },
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text('OK'),
                                        onPressed: () {
                                          Navigator.of(context).pop({
                                            'class': className,
                                            'room': roomName,
                                          });
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                              if (result != null) {
                                setState(() {
                                  classes[index] = result!;
                                });

                                // save the data in firebase

                                DocumentReference userDoc = FirebaseFirestore
                                    .instance
                                    .collection('users')
                                    .doc(user?.uid);
                                // Add the class information to the Firestore collection
                                userDoc.update({
                                  'timetable.$day.$period':
                                      FieldValue.arrayUnion(
                                          [result!['class'], result['room']])
                                });
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.all(5.0),
                              height: 200,
                              width: 200,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      classes[index]?['class'] ?? '',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(classes[index]?['room'] ?? ''),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
