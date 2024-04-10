import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
        title: Text("メイン画面"),
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
              Image.asset(
                ('assets/images/icon.png'),
                width: 300,
                // color: Color.fromARGB(150, 255, 255, 255),
              ),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
