import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:libera_flutter/screen/profile_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPagePageState createState() => _MainPagePageState();
}

class _MainPagePageState extends State<MainPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/post'),
                child: Text("post"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/postbook'),
                child: Text("postbook"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/chatlist'),
                child: Text("chatlist"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
