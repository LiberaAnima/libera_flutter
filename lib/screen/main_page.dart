// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:libera_flutter/models/user_model.dart';
import 'package:libera_flutter/screen/login_page.dart';
import 'package:libera_flutter/screen/profile_page.dart';
import 'package:libera_flutter/screen/school_page.dart';
import 'package:libera_flutter/services/launchUrl_service.dart';

import 'package:intl/intl.dart';
import 'package:libera_flutter/services/user_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPagePageState createState() => _MainPagePageState();
}

class _MainPagePageState extends State<MainPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  final UserService _userService = UserService();
  UserModel? _user;

  final userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    try {
      UserModel userData = await _userService.getUserData(userId);
      setState(() {
        _user = userData;
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            return const LoginPage(); // Redirect to LoginPage if not logged in
          } else {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                leadingWidth: 100,
                leading: Image.asset('assets/images/icon.png'),
                // title: Text("メイン画面"),
                actions: [
                  IconButton(
                    onPressed: () {
                      final String? uid = _auth.currentUser?.uid;
                      print(uid);

                      if (uid != null) {
                        // uid를 ProfilePage로 전달하면서 이동합니다.
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfilePage(uid: uid),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.account_circle),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Padding(
                                    // 学校名
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Text(
                                      _user?.school ?? '',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 30,
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
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
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)),
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
                                                  padding:
                                                      const EdgeInsets.all(4.0),
                                                  child: Text(
                                                    "$i限",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
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
                                              child: FutureBuilder<
                                                  DocumentSnapshot>(
                                                future: FirebaseFirestore
                                                    .instance
                                                    .collection('users')
                                                    .doc(userId)
                                                    .get(),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<
                                                            DocumentSnapshot>
                                                        snapshot) {
                                                  if (snapshot.hasError) {
                                                    return const Text(
                                                        "Something went wrong");
                                                  }

                                                  if (snapshot.hasData &&
                                                      !snapshot.data!.exists) {
                                                    return const Text(
                                                        "Document does not exist");
                                                  }

                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.done) {
                                                    Map<String, dynamic> data =
                                                        snapshot.data!.data()
                                                            as Map<String,
                                                                dynamic>;
                                                    if (data['timetable'] ==
                                                        null) {
                                                      return const Padding(
                                                        padding:
                                                            EdgeInsets.all(5.0),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text("  -  "),
                                                          ],
                                                        ),
                                                      );
                                                    }

                                                    tz.initializeTimeZones();
                                                    tz.TZDateTime now =
                                                        tz.TZDateTime.now(
                                                            tz.getLocation(
                                                                'Asia/Tokyo'));
                                                    var formatter =
                                                        DateFormat('EEEE');
                                                    String formattedDate =
                                                        formatter.format(now);
                                                    var todayTimetable =
                                                        data['timetable'][
                                                            formattedDate
                                                                .toLowerCase()];
                                                    print(formattedDate);

                                                    if (todayTimetable !=
                                                        null) {
                                                      Map<String, dynamic>
                                                          todayClasses =
                                                          todayTimetable as Map<
                                                              String, dynamic>;

                                                      var sortedEntries =
                                                          todayClasses.entries
                                                              .toList()
                                                            ..sort((a, b) =>
                                                                a.key.compareTo(
                                                                    b.key));

                                                      return Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: sortedEntries
                                                            .map((classInfo) {
                                                          // print(todayClasses);
                                                          // print(classInfo);
                                                          return Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  "${classInfo.value[0]}",
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontSize:
                                                                          16,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                                const Text(
                                                                  "  -  ",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontSize:
                                                                          16,
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                                Text(
                                                                  classInfo.value
                                                                              .length >
                                                                          1
                                                                      ? "${classInfo.value[1]}"
                                                                      : "Default Value",
                                                                  style:
                                                                      const TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700,
                                                                    fontSize:
                                                                        16,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          );
                                                        }).toList(),
                                                      );
                                                    } else {
                                                      return const Text(
                                                          "hogehoge");
                                                    }
                                                  }
                                                  return const Center(
                                                      child:
                                                          CircularProgressIndicator());
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
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // TODO: Implement logout functionality
                                  _auth.signOut();
                                },
                                child: Text('logout'),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Flexible(
                                    child: menuIcon(
                                      Icons.home,
                                      "https://kwic.kwansei.ac.jp/login",
                                      "大学ホーム",
                                    ),
                                  ),
                                  Flexible(
                                    child: menuIcon(Icons.shopping_bag,
                                        "/discount", "学割情報"),
                                  ),
                                  Flexible(
                                    child: menuIcon(Icons.business_center,
                                        "/discount", "インターン\n　バイト"),
                                  ),
                                  Flexible(
                                    child: menuIcon(
                                        Icons.discount, "/discount", "課外イベント"),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              const Card.outlined(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      height: 100,
                                      child: Center(
                                        child: Text("お知らせ？ "),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 40),
                                width: double.infinity,
                                child: const Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      "掲示板",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                              const Card.outlined(
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      height: 200,
                                      child: Center(
                                        child: Text("何か入れる"),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  Container menuIcon(IconData icon, String path, String title) {
    return Container(
      width: 100,
      height: 100,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Column(children: [
        IconButton(
          onPressed: () {
            if (path.startsWith('http')) {
              launchURL(Uri.parse(path));
            } else {
              Navigator.pushNamed(context, path);
              // Navigate to a named route
            }
          },
          icon: Icon(icon),
        ),
        Text(title)
      ]),
    );
  }
}
