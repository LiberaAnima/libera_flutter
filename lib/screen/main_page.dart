// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:libera_flutter/components/bottomButton.dart';
import 'package:libera_flutter/components/timetable.dart';
import 'package:libera_flutter/models/user_model.dart';
import 'package:libera_flutter/screen/login_page.dart';
import 'package:libera_flutter/screen/profile_page.dart';
import 'package:libera_flutter/services/launchUrl_service.dart';

import 'package:libera_flutter/services/user_service.dart';

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
  void setupPushNotifications() async {
    // print(userId);
    final fcm = FirebaseMessaging.instance;

    await fcm.requestPermission();

    fcm.subscribeToTopic(userId);
    final token = await fcm.getToken();
    // print(token);
  }

  // void _subscribe() async {
  //   final fcm = FirebaseMessaging.instance;
  //   fcm.subscribeToTopic(userId);
  // }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    setupPushNotifications();
    // _subscribe();
    print('d');
  }

  void _fetchUserData() async {
    try {
      UserModel userData = await _userService.getUserData(userId);
      setState(() {
        _user = userData;
      });
    } catch (e) {
      print('Error fetching user data: $e');
      if (e.toString() == 'Exception: User not found') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(), // Replace with your login page
          ),
        );
      }
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
                                height: 10,
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
                                          fontSize: 20,
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Timetable(userId: userId),
                              const SizedBox(
                                height: 20,
                              ),
                              // ElevatedButton(
                              //   onPressed: () {
                              //     // TODO: Implement logout functionality
                              //     _auth.signOut();
                              //   },
                              //   child: Text('logout'),
                              // ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Flexible(
                                    child: menuIcon(
                                      Icons.home,
                                      "https://kwic.kwansei.ac.jp/",
                                      "大学ホーム",
                                    ),
                                  ),
                                  Flexible(
                                    child: menuIcon(Icons.shopping_bag,
                                        "/discount", "学割情報"),
                                  ),
                                  Flexible(
                                    child: menuIcon(Icons.business_center,
                                        "/intern", "インターン\n　バイト"),
                                  ),
                                  Flexible(
                                    child: menuIcon(
                                        Icons.discount, "/event", "課外イベント"),
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
                              const BottomButton(),
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
