import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class PostViewPage extends StatefulWidget {
  @override
  _PostViewPagePageState createState() => _PostViewPagePageState();
}

class _PostViewPagePageState extends State<PostViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ポストビュー"),
      ),
      body: Center(
        child: TextField(
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
    );
  }
}
