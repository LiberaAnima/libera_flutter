import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:libera_flutter/services/timeago.dart';

class postSpecificPage extends StatefulWidget {
  final String id;

  const postSpecificPage({super.key, required this.id});

  @override
  _postSpecificPageState createState() => _postSpecificPageState();
}

class _postSpecificPageState extends State<postSpecificPage> {
  late Future<DocumentSnapshot> _future;

  @override
  void initState() {
    super.initState();
    _future =
        FirebaseFirestore.instance.collection('posts').doc(widget.id).get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Object?>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          Map<String, dynamic> post =
              snapshot.data!.data() as Map<String, dynamic>;

          DateTime postedAt =
              post['date'] != null ? post['date'].toDate() : DateTime.now();

          print(post);
          return Scaffold(
            appBar: AppBar(
              title: Text("投稿一覧画面"),
            ),
            body: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage('https://example.com/user-icon.jpg'),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('ユーザーネーム: ${post['name']}'),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    // Padding(
                    //   padding: EdgeInsets.all(8.0),
                    //   child: Text('文学部'),
                    // ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(timeAgo(postedAt)),
                    ),
                  ],
                ),
              ],
            ),
          );
          // 이제 `user` 맵에서 사용자 정보를 불러올 수 있습니다.
          // 예: user['username'], user['email'], 등...
        }
      },
    );
  }
}
