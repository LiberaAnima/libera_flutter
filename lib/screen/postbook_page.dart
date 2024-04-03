import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
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
          // _onSubmitted(
          //     _booknameEditingController.text,
          //     _bookauthorEditingController.text,
          //     _priceEditingController.text,
          //     _detailsEditingController.text);
          Navigator.pushNamed(context, '/');
        },
        child: Icon(Icons.send),
      ),
    );
  }
}
