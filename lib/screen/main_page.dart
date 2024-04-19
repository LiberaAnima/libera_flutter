import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:libera_flutter/screen/profile_page.dart';
import 'package:libera_flutter/services/launchUrl_service.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPagePageState createState() => _MainPagePageState();
}

class _MainPagePageState extends State<MainPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  final userId = FirebaseAuth.instance.currentUser!.uid;

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() async {
    return await db.collection('users').doc(userId).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leadingWidth: 100,
        leading: Image.asset('assets/images/icon.png'),
        // title: Text("メイン画面"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notifications_none),
          ),
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
            icon: Icon(Icons.account_circle),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    // get user data
                    future: getUserData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final userData = snapshot.data!.data();
                        return Row(
                          children: [
                            Padding(
                              // 学校名
                              padding: const EdgeInsets.only(left: 30),
                              child: Text(
                                userData?['school'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    color: Colors.black),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Card.outlined(
                    child: Column(
                      children: [
                        SizedBox(
                          width: 350,
                          height: 150,
                          child: Center(
                            child: Text("今日の時間割"),
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      menuIcon(Icons.home, "https://kwic.kwansei.ac.jp/login",
                          "学校ホーム"),
                      menuIcon(Icons.discount, "/discount", "学割"),
                      menuIcon(Icons.discount, "/discount", "?"),
                      menuIcon(Icons.discount, "/discount", "?"),
                    ],
                  ),
                  Card.outlined(
                    child: Column(
                      children: [
                        SizedBox(
                          width: 350,
                          height: 150,
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
    );
  }

  Container menuIcon(IconData icon, String path, String title) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
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
