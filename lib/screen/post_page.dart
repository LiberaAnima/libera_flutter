import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
            labelText: '内容 * ',
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final User? user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            final String uid = user.uid;
            final DocumentSnapshot userDoc = await FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .get();
            final post = FirebaseFirestore.instance.collection('posts').doc();
            post.set({
              // 匿名投稿の場合は、名前を「名無し」とする　( if 得意名　checks -> true)

              'post_message': _textEditingController.text,
              'date': FieldValue.serverTimestamp(),
              'name': userDoc['username'],
              'likes': [],
              'uid': uid,
              'documentID': post.id,
            });
            _onSubmitted(_textEditingController.text);
            Navigator.pushNamed(context, '/postlist');
          }
        },
        child: Icon(Icons.send),
      ),
    );
  }
}
