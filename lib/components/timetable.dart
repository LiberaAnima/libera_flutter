import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class Timetable extends StatelessWidget {
  final String userId;

  Timetable({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          const Text("今日の時間割",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          Row(
            children: [
              const SizedBox(width: 5),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    for (var i = 1; i < 6; i++)
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          "$i限",
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Colors.black),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(3),
                  child: GestureDetector(
                    onTap: () {},
                    child: FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text("Something went wrong");
                        }

                        if (snapshot.hasData && !snapshot.data!.exists) {
                          return const Text("Document does not exist");
                        }

                        if (snapshot.connectionState == ConnectionState.done) {
                          Map<String, dynamic> data =
                              snapshot.data!.data() as Map<String, dynamic>;
                          if (data['timetable'] == null) {
                            return const Padding(
                              padding: EdgeInsets.all(5.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("  -  "),
                                ],
                              ),
                            );
                          }

                          tz.initializeTimeZones();
                          tz.TZDateTime now =
                              tz.TZDateTime.now(tz.getLocation('Asia/Tokyo'));
                          var formatter = DateFormat('EEEE');
                          String formattedDate = formatter.format(now);
                          var todayTimetable =
                              data['timetable'][formattedDate.toLowerCase()];
                          print(formattedDate);

                          if (todayTimetable != null) {
                            Map<String, dynamic> todayClasses =
                                todayTimetable as Map<String, dynamic>;

                            var sortedEntries = todayClasses.entries.toList()
                              ..sort((a, b) => a.key.compareTo(b.key));

                            return Column(
                              mainAxisSize: MainAxisSize.max,
                              children: sortedEntries.map((classInfo) {
                                // print(todayClasses);
                                // print(classInfo);
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${classInfo.value[0]}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                      const Text(
                                        "  -  ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                            color: Colors.black),
                                      ),
                                      Text(
                                        classInfo.value.length > 1
                                            ? "${classInfo.value[1]}"
                                            : "Default Value",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }).toList(),
                            );
                          } else {
                            return const Text("");
                          }
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 5),
            ],
          ),
        ],
      ),
    );
  }
}
