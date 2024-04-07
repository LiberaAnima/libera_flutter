import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../main.dart';
import 'package:intl/intl.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPagePageState createState() => _PostPagePageState();
}

class _PostPagePageState extends State<PostPage> {
  TextEditingController _textEditingController = TextEditingController();

  _onSubmitted(String content) {
    /// 入力欄をクリアにする
    _textEditingController.clear();
  }

  //ユーザー確認
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<DocumentSnapshot> getUserInfo() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      return await _firestore.collection('users').doc(user.uid).get();
    }
    throw Exception('No user logged in');
  }

  //日付を取得
  DateTime now = DateTime.now();
  DateFormat outputFormat = DateFormat('yyyy年MM月dd日 HH:mm');
  late String date = outputFormat.format(now);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("投稿画面"),
      ),
      body: Center(
        child: TextField(
          controller: _textEditingController,
          onSubmitted: _onSubmitted,
          enabled: true,
          maxLength: 200, // 入力数
          //maxLengthEnforced: false, // 入力上限になったときに、文字入力を抑制するか
          style: TextStyle(color: Colors.black),
          obscureText: false,
          maxLines: 5,
          decoration: const InputDecoration(
            icon: Icon(Icons.speaker_notes),
            hintText: '投稿内容を記載します',
            labelText: '授業はどうですか?',
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final User? user = _auth.currentUser;
          if (user != null) {
            final String uid = user.uid;
            final DocumentSnapshot userDoc =
                await _firestore.collection('users').doc(uid).get();
            FirebaseFirestore.instance.collection('posts').doc().set({
              'post_message': _textEditingController.text,
              'date': date,
              'name': userDoc['username'],
            });
            _onSubmitted(_textEditingController.text);
            Navigator.pushNamed(context, '/');
          }
        },
        child: Icon(Icons.send),
      ),
    );
  }
}
