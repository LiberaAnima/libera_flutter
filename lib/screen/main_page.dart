// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:libera_flutter/components/bottomButton.dart';
import 'package:libera_flutter/components/timetable.dart';
import 'package:libera_flutter/models/user_model.dart';
import 'package:libera_flutter/screen/login_page.dart';
import 'package:libera_flutter/screen/post/post_specific.dart';
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
            builder: (context) =>
                const LoginPage(), // Replace with your login page
          ),
        );
      }
    }
  }

// posts collection
  Future<List<DocumentSnapshot>> getPosts() async {
    // 한 주 전의 날짜를 계산
    DateTime oneWeekAgo = DateTime.now().subtract(const Duration(days: 7));

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .where('date', isGreaterThan: oneWeekAgo) // 한 주 동안 게시된 게시물만 쿼리
        .get();

    List<DocumentSnapshot> docs = querySnapshot.docs;

    if (docs.length <= 8) {
      return docs;
    } else {
      docs.shuffle();
      return docs.take(8).toList();
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
                      // print(uid);

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
                                        Icons.discount, "/event", "イベント"),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),

                              // アップデート

                              // const Card.outlined(
                              //   child: Column(
                              //     children: [
                              //       SizedBox(
                              //         width: double.infinity,
                              //         height: 100,
                              //         child: Center(
                              //           child: Text("お知らせ？ "),
                              //         ),
                              //       )
                              //     ],
                              //   ),
                              // ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: const EdgeInsets.only(left: 10),
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
                              Card.outlined(
                                child: FutureBuilder<List<DocumentSnapshot>>(
                                  future: getPosts(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<List<DocumentSnapshot>>
                                          snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else {
                                      return Container(
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Column(
                                            children: snapshot.data!
                                                .map<Widget>((post) {
                                              // Ensure that the map function returns a Widget
                                              var data = post.data()
                                                  as Map<String, dynamic>?;
                                              var title = data != null &&
                                                      data.containsKey('title')
                                                  ? data['title']
                                                  : 'No title';
                                              var likes = data != null &&
                                                      data.containsKey('likes')
                                                  ? data['likes'] as List
                                                  : [];
                                              // var messages = data != null &&
                                              //         data.containsKey(
                                              //             'post_message')
                                              //     ? data['post_message']
                                              //     : 'No message';
                                              var tag = data != null &&
                                                      data.containsKey('tag')
                                                  ? data['tag']
                                                  : 'No tag';
                                              return GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          PostSpecificPage(
                                                        id: post['documentID'],
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    SizedBox(
                                                      height: 30,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        '$tag',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text('$title'),
                                                          Row(
                                                            children: [
                                                              const Icon(
                                                                Icons
                                                                    .favorite_border_rounded,
                                                                size: 20,
                                                              ),
                                                              Text(
                                                                  '${likes.length}'),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ); // Return a Text widget
                                            }).toList(),
                                          ),
                                        ),
                                      );
                                    }
                                  },
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
