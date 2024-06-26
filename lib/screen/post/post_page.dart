import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  File? _postImage;
  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  List<String> selectedTags = [];
  String dropdownValue = 'その他'; // Add this line

  void _onSubmitted(String content, File? postImage) async {
    String imageUrl = '';
    if (postImage != null) {
      String fileName = 'books/${DateTime.now().millisecondsSinceEpoch}.jpg';
      FirebaseStorage storage = FirebaseStorage.instance;
      TaskSnapshot snapshot = await storage.ref(fileName).putFile(postImage);
      imageUrl = await snapshot.ref.getDownloadURL();
    }

    final User? user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final post = FirebaseFirestore.instance.collection('posts').doc();
    post.set(
      {
        // 匿名投稿の場合は、名前を「名無し」とする　( if 得意名　checks -> true)
        'title': _titleEditingController.text,
        'post_message': _textEditingController.text,
        'date': FieldValue.serverTimestamp(),
        'name': userDoc['username'],
        'likes': [],
        'uid': uid,
        'documentID': post.id,
        'isAnonymous': _isAnonymous,
        'imageUrl': imageUrl == '' ? null : imageUrl,
        'tag': dropdownValue,
      },
    );

    /// 入力欄をクリアにする
    _textEditingController.clear();
    _titleEditingController.clear();
    if (mounted) {
      setState(() {
        _postImage = null;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _postImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {FocusScope.of(context).unfocus()},
      child: Scaffold(
        appBar: AppBar(
          title: const Text("投稿作成"),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Center(
                //タイトル作成
                child: Form(
                  key: _formKey1,
                  child: TextFormField(
                    controller: _titleEditingController,
                    // onSubmitted: _onSubmitted,
                    enabled: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'タイトルを入力してください';
                      }
                      return null;
                    },
                    //maxLengthEnforced: false, // 入力上限になったときに、文字入力を抑制するか
                    style: const TextStyle(color: Colors.black),
                    obscureText: false,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      hintText: '投稿タイトルを入力してください',
                      labelText: 'タイトル*',
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                // 内容作成
                child: Form(
                  key: _formKey2,
                  child: TextFormField(
                    controller: _textEditingController,
                    enabled: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return '投稿内容を入力してください';
                      }
                      return null;
                    },
                    //maxLengthEnforced: false, // 入力上限になったときに、文字入力を抑制するか
                    style: const TextStyle(color: Colors.black),
                    obscureText: false,
                    maxLines: 7,
                    decoration: const InputDecoration(
                      hintText: '投稿内容を記載します',
                      labelText: '投稿内容*',
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              if (_postImage != null)
                Image.file(
                  _postImage!,
                  width: 200,
                  height: 200,
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text('匿名投稿'),
                  Checkbox(
                    overlayColor: MaterialStateProperty.all(Colors.blue),
                    value: _isAnonymous,
                    onChanged: (bool? value) {
                      setState(() {
                        _isAnonymous = value!;
                        // print(_isAnonymous);
                      });
                    },
                  ),
                  IconButton(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.camera_alt_outlined),
                  ),
                  const Text("タグ選択 : "),
                  DropdownButton<String>(
                    value: dropdownValue,
                    // icon: const Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    // style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.grey,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    items: <String>['講義・授業', '部活・サークル', 'アルバイト', '就活', 'その他']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange,
          onPressed: () async {
            final User? user = FirebaseAuth.instance.currentUser;

            if (!_formKey1.currentState!.validate() ||
                !_formKey2.currentState!.validate()) {
              return;
            }
            if (user != null) {
              _onSubmitted(_textEditingController.text, _postImage);
              Navigator.pop(context);
            }
          },
          child: const Icon(Icons.send, color: Colors.white),
        ),
      ),
    );
  }
}
