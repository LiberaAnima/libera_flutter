import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePagePageState createState() => _ProfilePagePageState();
}

class _ProfilePagePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("プロフィール画面"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text("プロフィール画面"),
          ],
        ),
      ),
    );
  }
}
