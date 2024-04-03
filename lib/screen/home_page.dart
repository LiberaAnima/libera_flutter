import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:libera_flutter/screen/login_page.dart';
import 'package:libera_flutter/screen/signup_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _auth.authStateChanges(),
      builder: (BuildContext con, AsyncSnapshot<User?> user) {
        if (!user.hasData) {
          return const LoginPage();
        } else {
          return Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              onTap: (int Index) {
                if (Index == 0) {
                  Navigator.pushNamed(context, '/');
                } else if (Index == 1) {
                  Navigator.pushNamed(context, '/postlist');
                } else if (Index == 2) {
                  Navigator.pushNamed(context, '/mypage');
                }
              },
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.business),
                  label: "Business",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.school),
                  label: "School",
                ),
                // BottomNavigationBarItem(
                //     icon: Icon(Icons.person), label: "myPage"),
              ],
            ),
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Color.fromARGB(255, 255, 201, 135),
                    Color.fromARGB(255, 252, 225, 190),
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
            ),
          );
        }
      },
    );
  }
}
