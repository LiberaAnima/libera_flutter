import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:libera_flutter/services/timeago.dart';
import 'package:libera_flutter/services/likebutton.dart';
import 'package:firebase_auth/firebase_auth.dart';

class postSpecificPage extends StatefulWidget {
  final String id;

  const postSpecificPage({super.key, required this.id});

  @override
  _postSpecificPageState createState() => _postSpecificPageState();
}

class _postSpecificPageState extends State<postSpecificPage> {
  late Future<DocumentSnapshot> _future;

  TextEditingController _textEditingController = TextEditingController();

  _onSubmitted(String content) {
    /// 入力欄をクリアにする
    _textEditingController.clear();
  }

  @override
  void initState() {
    super.initState();
    _future =
        FirebaseFirestore.instance.collection('posts').doc(widget.id).get();
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> responselists = FirebaseFirestore.instance
        .collection('response')
        .orderBy('date', descending: true)
        .snapshots();
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

          return Scaffold(
            appBar: AppBar(
              title: Text("投稿一覧画面"),
            ),
            body: Container(
              // Wrap the Column with Container

              decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.white), // 枠線を追加
                color: Colors.white,
                borderRadius: BorderRadius.circular(1),
              ),
              padding: EdgeInsets.all(8),
              child: Column(
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
                            Text(
                              'ユーザーネーム: 匿名',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        post['post_message'],
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Divider(
                    height: 10.0,
                    color: Color.fromRGBO(165, 165, 165, 1),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        timeAgo(post['date'].toDate()),
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                      FavoriteButton(
                        documentid: post['documentID'],
                        collectionname: 'posts',
                      ),
                      Text(
                        'いいね ${post['likes'].length.toString()}  ',
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  /*
                  //返信内容を表示
                  StreamBuilder<QuerySnapshot>(
                    stream: responselists,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
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
                              if (data['documentID'] == post['documentID']) {
                                return ListTile(
                                  title: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1,
                                            color: Colors.white), // 枠線を追加
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(1),
                                      ),
                                      padding: EdgeInsets.all(8),
                                      child: Column(
                                        children: [
                                          Text('あいうえお'), //テスト用
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    'https://example.com/user-icon.jpg'),
                                              ),
                                              SizedBox(width: 10),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    'ユーザーネーム: 匿名',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                data['post_message'],
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5),
                                          Divider(
                                            height: 10.0,
                                            color: Color.fromRGBO(
                                                165, 165, 165, 1),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                timeAgo(data['date'].toDate()),
                                                style: TextStyle(
                                                  fontSize: 10,
                                                ),
                                              ),
                                              FavoriteButton(
                                                documentid: data['documentID'],
                                                collectionname: 'posts',
                                              ),
                                              Text(
                                                'いいね ${data['likes'].length.toString()}  ',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          postSpecificPage(
                                                        id: data['documentID'],
                                                      ),
                                                    ),
                                                  );
                                                },
                                                icon: Icon(
                                                  Icons
                                                      .messenger_outline_rounded,
                                                  size: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                );
                              }
                              ;
                            })
                            .toList()
                            .cast(),
                      );
                    },
                  ),*/

                  Center(
                    child: TextField(
                      controller: _textEditingController,
                      onSubmitted: _onSubmitted,
                      enabled: true,
                      maxLength: 200, // 入力数
                      //maxLengthEnforced: false, // 入力上限になったときに、文字入力を抑制するか
                      style: TextStyle(color: Colors.black),
                      obscureText: false,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.speaker_notes),
                        hintText: '返信',
                        labelText: '返信する * ',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                final User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  final String uid = user.uid;
                  final DocumentSnapshot userDoc = await FirebaseFirestore
                      .instance
                      .collection('users')
                      .doc(uid)
                      .get();
                  final response =
                      FirebaseFirestore.instance.collection('response').doc();
                  response.set({
                    'post_message': _textEditingController.text,
                    'date': FieldValue.serverTimestamp(),
                    'name': userDoc['username'],
                    'likes': [],
                    'uid': uid,
                    'documentID': post['documentID'],
                    'responseID': response.id,
                  });
                }
                _onSubmitted(_textEditingController.text);
              },
              child: Icon(Icons.send),
            ),
          );
        }
      },
    );
  }
}
