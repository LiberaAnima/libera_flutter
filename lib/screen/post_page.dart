import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPagePageState createState() => _PostPagePageState();
}

class _PostPagePageState extends State<PostPage> {
  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _titleEditingController = TextEditingController();
  bool _isAnonymous = false;
  File? _bookImage;

  _onSubmitted(String content) {
    /// 入力欄をクリアにする
    _textEditingController.clear();
    _titleEditingController.clear();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _bookImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("投稿作成"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Center(
              //タイトル作成
              child: TextField(
                controller: _titleEditingController,
                onSubmitted: _onSubmitted,
                enabled: true,
                //maxLengthEnforced: false, // 入力上限になったときに、文字入力を抑制するか
                style: TextStyle(color: Colors.black),
                obscureText: false,
                maxLines: 1,
                decoration: const InputDecoration(
                  hintText: 'Titleを入力してください',
                  labelText: 'Titleを入力してください ',
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              // 内容作成
              child: TextField(
                controller: _textEditingController,
                onSubmitted: _onSubmitted,
                enabled: true,
                //maxLengthEnforced: false, // 入力上限になったときに、文字入力を抑制するか
                style: TextStyle(color: Colors.black),
                obscureText: false,
                maxLines: 1,
                decoration: const InputDecoration(
                  hintText: '投稿内容を記載します',
                  labelText: '投稿内容を記載します ',
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const Text('匿名投稿'),
                Checkbox(
                  overlayColor: MaterialStateProperty.all(Colors.blue),
                  value: _isAnonymous,
                  onChanged: (bool? value) {
                    setState(() {
                      _isAnonymous = value!;
                      print(_isAnonymous);
                    });
                  },
                ),
                SizedBox(
                  width: 20,
                ),
                IconButton(
                  onPressed: _pickImage,
                  icon: Icon(Icons.camera_alt_outlined),
                ),
              ],
            )
          ],
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
              'title': _titleEditingController.text,
              'post_message': _textEditingController.text,
              'date': FieldValue.serverTimestamp(),
              'name': userDoc['username'],
              'likes': [],
              'uid': uid,
              'documentID': post.id,
              'isAnonymous': _isAnonymous,
              'imageUrl': _bookImage != null ? _bookImage!.path : null,
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
