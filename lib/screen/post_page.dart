import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
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
          maxLines: 1,
          decoration: const InputDecoration(
            icon: Icon(Icons.speaker_notes),
            hintText: '投稿内容を記載します',
            labelText: '内容',
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseFirestore.instance
              .collection('posts')
              .doc()
              .set({'post_message': _textEditingController.text, 'date': date});
          _onSubmitted(_textEditingController.text);
          print('_textEditingController.text: ${_textEditingController.text}');
          // _onSubmitted(_textEditingController.text);
          Navigator.pushNamed(context, '/');
        },
        child: Icon(Icons.send),
      ),
    );
  }
}
