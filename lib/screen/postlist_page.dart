import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostListPage extends StatefulWidget {
  const PostListPage({Key? key}) : super(key: key);

  @override
  _PostListPagePageState createState() => _PostListPagePageState();
}

class _PostListPagePageState extends State<PostListPage> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> postlists =
        FirebaseFirestore.instance.collection('posts').snapshots();
    return Scaffold(
      appBar: AppBar(
        title: Text("投稿一覧画面"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: postlists,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs
                .map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return ListTile(
                    title: Text("投稿日: " +
                        data['date'] +
                        " 投稿者" +
                        data['name'] +
                        "  " +
                        data['post_message']),
                  );
                })
                .toList()
                .cast(),
          );
        },
      ),
    );
  }
}
