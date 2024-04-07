import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../main.dart';

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

    //firestoreにデータを追加
    CollectionReference books = FirebaseFirestore.instance.collection('books');
    await books.add({
      'bookname': bookname,
      'bookauthor': bookauthor,
      'price': price,
      'details': details,
      'imageUrl': imageUrl,
    });

    /// 入力欄をクリアにする
    _booknameEditingController.clear();
    _bookauthorEditingController.clear();
    _priceEditingController.clear();
    _detailsEditingController.clear();
    setState(() {
      _bookImage = null;
    });
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
              icon: Icon(
                Icons.speaker_notes,
                color: Colors.black,
              ),
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
              icon: Icon(
                Icons.person,
                color: Colors.black,
              ),
              hintText: '例)田中太郎',
              labelText: '著者名*',
            ),
          ),
          if (_bookImage != null)
            Image.file(
              _bookImage!,
              width: 100,
              height: 100,
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start, // 要素を中央に配置
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, bottom: 8.0), // アイコンの位置を下に調整
                child: Icon(Icons.image, color: Colors.black),
              ),
              SizedBox(width: 80), // アイコンとボタンの間のスペース
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('テキストの画像を選択'),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _priceEditingController,
                  enabled: true,
                  maxLength: 5,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  style: TextStyle(color: Colors.black),
                  obscureText: false,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    icon: Icon(
                      Icons.currency_yen,
                      color: Colors.black,
                    ),
                    hintText: '例) 1500',
                    labelText: '価格(円)*',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text('円', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
          TextField(
            controller: _detailsEditingController,
            enabled: true,
            maxLength: 200, // 入力数
            style: TextStyle(color: Colors.black),
            obscureText: false,
            maxLines: 5,
            decoration: const InputDecoration(
              icon: Icon(
                Icons.subject,
                color: Colors.black,
              ),
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
              _detailsEditingController.text,
              _priceEditingController.text,
              _bookImage,
              // user.uid,
            );
            Navigator.pushNamed(context, '/bookmarketlist');
          }
        },
        child: Icon(Icons.send),
      ),
    );
  }
}
