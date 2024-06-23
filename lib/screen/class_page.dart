import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:libera_flutter/screen/post/class_post_page.dart';

class ClassPage extends StatefulWidget {
  const ClassPage({Key? key}) : super(key: key);

  @override
  _ClassPageState createState() => _ClassPageState();
}

enum FruitList { apple, banana, grape }

class _ClassPageState extends State<ClassPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Add this line
        title: Text("授業評価"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () async {
          final User? user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            final String uid = user.uid;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ClassPostPage(uid: uid)),
            );
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
