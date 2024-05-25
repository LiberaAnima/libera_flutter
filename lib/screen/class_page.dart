import 'package:flutter/material.dart';

class ClassPage extends StatefulWidget {
  const ClassPage({Key? key}) : super(key: key);

  @override
  _ClassPageState createState() => _ClassPageState();
}

class _ClassPageState extends State<ClassPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("授業画面"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text("授業画面"),
          ],
        ),
      ),
    );
  }
}
