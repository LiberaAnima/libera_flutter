import 'package:flutter/material.dart';

class SchoolPage extends StatefulWidget {
  const SchoolPage({Key? key}) : super(key: key);

  @override
  _SchoolPageState createState() => _SchoolPageState();
}

class _SchoolPageState extends State<SchoolPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
