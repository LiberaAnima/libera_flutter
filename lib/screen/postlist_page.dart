import 'package:flutter/material.dart';

class PostListPage extends StatefulWidget {
  const PostListPage({Key? key}) : super(key: key);

  @override
  _PostListPagePageState createState() => _PostListPagePageState();
}

class _PostListPagePageState extends State<PostListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("投稿一覧画面"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text("投稿一覧画面"),
          ],
        ),
      ),
    );
  }
}
