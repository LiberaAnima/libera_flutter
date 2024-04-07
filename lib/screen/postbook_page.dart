import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
    String username = userDoc.get('username');
    String faculty = userDoc.get('faculty');

    //firestoreにデータを追加
    CollectionReference books = FirebaseFirestore.instance.collection('books');
    await books.add({
      'bookname': bookname,
      'bookauthor': bookauthor,
      'price': price,
      'details': details,
      'imageUrl': imageUrl,
      'uid': user.uid,
      'username': username,
      'faculty': faculty,
    });

    void _onSubmitted(
        String bookname, String bookauthor, String price, String details) {
      /// 入力欄をクリアにする
      ///
      /// firebase との連携
      _booknameEditingController.clear();
      _bookauthorEditingController.clear();
      _priceEditingController.clear();
      _detailsEditingController.clear();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("テキスト投稿画面"),
        ),
        body: Column(
          children: <Widget>[
            TextField(
              controller: _booknameEditingController,
              enabled: true,
              maxLength: 50, // 入力数
              style: TextStyle(color: Colors.black),
              obscureText: false,
              maxLines: 1,
              decoration: const InputDecoration(
                icon: Icon(Icons.speaker_notes),
                hintText: '例)微分積分入門 第二版',
                labelText: 'テキスト名*',
              ),
            ),
            TextField(
              controller: _bookauthorEditingController,
              enabled: true,
              maxLength: 30,
              style: TextStyle(color: Colors.black),
              obscureText: false,
              maxLines: 1,
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                hintText: '例)田中太郎',
                labelText: '著者名*',
              ),
            ),
            TextField(
              controller: _priceEditingController,
              enabled: true,
              maxLength: 5,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
              style: TextStyle(color: Colors.black),
              obscureText: false,
              maxLines: 1,
              decoration: const InputDecoration(
                icon: Icon(Icons.currency_yen),
                hintText: '例)○○○○',
                labelText: '価格(円)*',
              ),
            ),
            TextField(
              controller: _detailsEditingController,
              enabled: true,
              maxLength: 200, // 入力数
              style: TextStyle(color: Colors.black),
              obscureText: false,
              maxLines: 5,
              decoration: const InputDecoration(
                icon: Icon(Icons.subject),
                hintText: 'テキストの詳細、テキストの状態、取引場所など',
                labelText: '詳細 ',
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            print(_booknameEditingController.text); // デバッグ用
            if (_booknameEditingController.text.isEmpty ||
                _bookauthorEditingController.text.isEmpty ||
                _priceEditingController.text.isEmpty) {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('エラー'),
                      content: Text('テキスト名、著者名、価格は必須事項です'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  });
            } else {
              _onSubmitted(
                  _booknameEditingController.text,
                  _bookauthorEditingController.text,
                  _priceEditingController.text,
                  _detailsEditingController.text,
                  _bookImage);
              Navigator.pushNamed(context, '/bookmarketlist');
            }
          },
          child: Icon(Icons.send),
        ),
      );
    }
  }
}

class FirebaseStorage {}
