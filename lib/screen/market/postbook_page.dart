import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class PostBookPage extends StatefulWidget {
  const PostBookPage({Key? key}) : super(key: key);

  @override
  _PostBookPagePageState createState() => _PostBookPagePageState();
}

class _PostBookPagePageState extends State<PostBookPage> {
  TextEditingController _booknameEditingController = TextEditingController();
  TextEditingController _bookauthorEditingController = TextEditingController();
  TextEditingController _priceEditingController = TextEditingController();
  TextEditingController _detailsEditingController = TextEditingController();
  File? _bookImage;

  void _onSubmitted(String bookname, String bookauthor, String price,
      String details, File? bookImage) async {
    //firebase storageに画像をアップロード,URL取得
    String imageUrl = '';
    if (bookImage != null) {
      String fileName = 'books/${DateTime.now().millisecondsSinceEpoch}.jpg';
      FirebaseStorage storage = FirebaseStorage.instance;
      TaskSnapshot snapshot = await storage.ref(fileName).putFile(bookImage);
      imageUrl = await snapshot.ref.getDownloadURL();
    }

    // Get current user
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('No user logged in');
    }
    // Get user's username from Firestore
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    print(user.uid);
    String username = userDoc.get('username');
    String faculty = userDoc.get('faculty');
    //firestoreにデータを追加
    CollectionReference books = FirebaseFirestore.instance.collection('books');
    print(books);
    final post = FirebaseFirestore.instance.collection('books').doc();
    await post.set(
      {
        'bookname': bookname,
        'bookauthor': bookauthor,
        'price': price,
        'details': details,
        'imageUrl': imageUrl,
        'uid': user.uid,
        'documentId': post.id,
        'username': username,
        'faculty': faculty,
        'postedAt': FieldValue.serverTimestamp(),
      },
    );

    /// 入力欄をクリアにする
    _booknameEditingController.clear();
    _bookauthorEditingController.clear();
    _priceEditingController.clear();
    _detailsEditingController.clear();
    if (mounted) {
      setState(() {
        _bookImage = null;
      });
    }
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
        title: const Text("商品投稿画面"),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text(
                '商品画像を選択*',
                style: const TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                fixedSize: Size(500, 40),
                backgroundColor: Colors.orange,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _booknameEditingController,
              enabled: true,
              maxLength: 50, // 入力数
              style: const TextStyle(color: Colors.black),
              obscureText: false,
              maxLines: 1,
              decoration: const InputDecoration(
                hintText: '例)微分積分入門 第二版',
                labelText: '商品名*',
              ),
            ),
            TextField(
              controller: _bookauthorEditingController,
              enabled: true,
              maxLength: 30,
              style: const TextStyle(color: Colors.black),
              obscureText: false,
              maxLines: 1,
              decoration: const InputDecoration(
                hintText: '例)田中太郎',
                labelText: '著者名*',
              ),
            ),
            if (_bookImage != null)
              Image.file(
                _bookImage!,
                width: 200,
                height: 200,
              ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _priceEditingController,
                    enabled: true,
                    maxLength: 5,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    style: const TextStyle(color: Colors.black),
                    obscureText: false,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      hintText: '例) 1500',
                      labelText: '価格(円)*',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text('円', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
            TextField(
              controller: _detailsEditingController,
              enabled: true,
              maxLength: 200, // 入力数
              style: const TextStyle(color: Colors.black),
              obscureText: false,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: '商品詳細、状態、取引場所などを記入してください',
                labelText: '詳細 ',
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          print(_booknameEditingController.text); // デバッグ用
          if (_booknameEditingController.text.isEmpty ||
              _bookauthorEditingController.text.isEmpty ||
              _priceEditingController.text.isEmpty ||
              _bookImage == null) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('エラー'),
                  content: Text('テキスト名、著者名、商品画像、価格は必須事項です'),
                  actions: <Widget>[
                    TextButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            _onSubmitted(
                _booknameEditingController.text,
                _bookauthorEditingController.text,
                _priceEditingController.text,
                _detailsEditingController.text,
                _bookImage);
            Navigator.pop(context);
          }
        },
        child: const Icon(Icons.send,
            color: Colors.white), // 送信ボタン、押すと_onSubmittedが呼ばれる
      ),
    );
  }
}
