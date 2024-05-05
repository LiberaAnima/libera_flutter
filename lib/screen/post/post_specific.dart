// import 'dart:html';

import 'dart:io';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:libera_flutter/screen/post/post_edit.dart';
import 'package:libera_flutter/services/likebutton.dart';
import 'package:libera_flutter/services/timeago.dart';
// import 'package:libera_flutter/services/likebutton.dart';

class PostSpecificPage extends StatefulWidget {
  final String id;

  PostSpecificPage({required this.id});

  @override
  _PostSpecificPageState createState() => _PostSpecificPageState();
}

class _PostSpecificPageState extends State<PostSpecificPage> {
  bool _isAnonymous = false;
  final TextEditingController _commentController = TextEditingController();

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    print(user?.uid);
    return Scaffold(
      appBar: AppBar(
        title: const Text('投稿詳細'),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.id)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            Map<String, dynamic>? data =
                snapshot.data!.data() as Map<String, dynamic>?;
            if (data != null) {
              return Column(
                children: <Widget>[
                  const SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            Text(
                              data['name'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.more_vert),
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        ListTile(
                                          leading: Icon(Icons.edit),
                                          title: Text('修正'),
                                          onTap: () {
                                            // 수정하기 버튼이 눌렸을 때의 동작을 여기에 작성합니다.
                                            Navigator.pop(context); // 시트를 닫습니다.
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    PostEditPage(data: data),
                                              ),
                                            );
                                            // print(data);
                                          },
                                        ),
                                        ListTile(
                                          leading: Icon(Icons.delete),
                                          title: Text('削除'),
                                          onTap: () async {
                                            // 삭제하기 버튼이 눌렸을 때의 동작을 여기에 작성합니다.
                                            await FirebaseFirestore.instance
                                                .collection('posts')
                                                .doc(data[
                                                    'documentID']) // 'id'는 삭제하려는 문서의 ID입니다. 실제 ID로 교체해야 합니다.
                                                .delete();

                                            Navigator.pop(context); // 시트를 닫습니다.
                                            Navigator.pop(context); // 시트를 닫습니다.
                                          },
                                        ),
                                        SizedBox(height: 20),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                        Text(
                          data['date'] != null
                              ? timeAgo(data['date'].toDate())
                              : 'Unknown date',
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                        SizedBox(height: 5),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              data['title'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              ),
                            ),
                            Text(
                              data['post_message'],
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            FavoriteButton(
                              documentid: data['documentID'],
                              collectionname: 'posts',
                            ),
                            Text(
                              '${data['likes'].length.toString()} いいね',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(width: 5),

                            //  have to add comment lenght

                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('posts')
                                  .doc(data['documentID'])
                                  .collection('comments')
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                      '${snapshot.data!.docs.length.toString()} コメント',
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ));
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                }
                                // By default, show a loading spinner.
                                return CircularProgressIndicator();
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: Color.fromRGBO(165, 165, 165, 1),
                    thickness: .5,
                    indent: 15,
                    endIndent: 15,
                  ),
                  // comment box
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(widget.id)
                        .collection('comments')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.active) {
                        if (snapshot.data != null) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              var comment = snapshot.data!.docs[index].data()
                                  as Map<String, dynamic>;
                              return ListTile(
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        comment["isAnonymous"] == true
                                            ? '匿名'
                                            : data["name"],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(comment['text']),
                                    ],
                                  ),
                                  subtitle: Text(
                                    timeAgo(comment['timestamp'].toDate()),
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  )
                                  // Add other fields as needed
                                  );
                            },
                          );
                        } else {
                          return const Text('No comments');
                        }
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else {
                        return const Text('Error');
                      }
                    },
                  ),
                ],
              );
            } else {
              return const Text('No data');
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            return const Text('Error');
          }
        },
      ),

      // Add comment
      bottomSheet: Container(
        padding: const EdgeInsets.only(
            left: 2.0, right: 8.0, top: 8.0, bottom: 35.0),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Checkbox(
              value: _isAnonymous,
              onChanged: (bool? value) {
                setState(() {
                  _isAnonymous = value!;
                });
              },
              fillColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return Colors.orange;
                }
                return Colors.white;
              }),
            ),
            const Text("匿名",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300, width: 1),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController, // Add this
                        decoration: InputDecoration(
                          hintText: 'コメントを入力してください。',
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.only(top: 12, bottom: 5, left: 15),
                        ),
                        onSubmitted: (value) async {
                          // Add this

                          final DocumentSnapshot userDoc =
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user?.uid)
                                  .get();
                          await FirebaseFirestore.instance
                              .collection('posts')
                              .doc(widget.id)
                              .collection('comments')
                              .add({
                            'text': value,
                            'timestamp': DateTime.now(),
                            'user': user?.uid,
                            'name': userDoc['username'],
                            'isAnonymous': _isAnonymous,
                            // Add other fields as needed
                          });
                          _commentController.clear();
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () async {
                        // Add this
                        final DocumentSnapshot userDoc = await FirebaseFirestore
                            .instance
                            .collection('users')
                            .doc(user?.uid)
                            .get();
                        await FirebaseFirestore.instance
                            .collection('posts')
                            .doc(widget.id)
                            .collection('comments')
                            .add({
                          'text': _commentController.text,
                          'timestamp': DateTime.now(),
                          'user': user?.uid,
                          'name': userDoc['username'],
                          'isAnonymous': _isAnonymous,
                          // Add other fields as needed
                        });
                        _commentController.clear();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
