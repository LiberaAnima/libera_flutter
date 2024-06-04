import 'package:flutter/material.dart';

class ClassCommentPage extends StatefulWidget {
  const ClassCommentPage({Key? key}) : super(key: key);

  @override
  _ClassCommentPageState createState() => _ClassCommentPageState();
}

class _ClassCommentPageState extends State<ClassCommentPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("準備中です",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
