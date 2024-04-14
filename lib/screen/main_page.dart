import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
            onPressed: () {},
            icon: Icon(Icons.account_circle),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(),
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
                            // Text(userData?['email']),
                          ],
                        );
                      }
                    },
                  ),
                  Text(style: TextStyle(color: Colors.white), "hello"),
                  ElevatedButton(
                    onPressed: () async => await _auth
                        .signOut()
                        .then((_) => Navigator.pushNamed(context, "/logIn")),
                    child: Text("Log Out"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
