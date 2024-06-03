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
import 'package:libera_flutter/models/user_model.dart';
import 'package:libera_flutter/screen/post/post_edit.dart';
import 'package:libera_flutter/services/likebutton.dart';
import 'package:libera_flutter/services/timeago.dart';
import 'package:libera_flutter/services/user_service.dart';
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
  final UserService _userService = UserService();
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    try {
      UserModel userData = await _userService.getUserData(user!.uid);
      setState(() {
        _user = userData;
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {FocusScope.of(context).unfocus()},
      child: Scaffold(
        appBar: AppBar(
          title: const Text('投稿詳細'),
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .doc(widget.id)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                Map<String, dynamic>? data =
                    snapshot.data!.data() as Map<String, dynamic>?;
                if (data != null) {
                  return Container(
                    color: Colors.white,
                    child: SingleChildScrollView(
                      child: Column(
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
                                      data["isAnonymous"] == true
                                          ? '匿名'
                                          : data["name"],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    if (data['uid'] == user?.uid)
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
                                                    leading:
                                                        const Icon(Icons.edit),
                                                    title: const Text('修正'),
                                                    onTap: () {
                                                      // 수정하기 버튼이 눌렸을 때의 동작을 여기에 작성합니다.
                                                      Navigator.pop(
                                                          context); // 시트를 닫습니다.
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              PostEditPage(
                                                                  data: data),
                                                        ),
                                                      );
                                                      // print(data);
                                                    },
                                                  ),
                                                  ListTile(
                                                    leading: const Icon(
                                                        Icons.delete),
                                                    title: const Text('削除'),
                                                    onTap: () async {
                                                      // 삭제하기 버튼이 눌렸을 때의 동작을 여기에 작성합니다.
                                                      await FirebaseFirestore
                                                          .instance
                                                          .collection('posts')
                                                          .doc(data[
                                                              'documentID']) // 'id'는 삭제하려는 문서의 ID입니다. 실제 ID로 교체해야 합니다.
                                                          .delete();

                                                      Navigator.pop(
                                                          context); // 시트를 닫습니다.
                                                    },
                                                  ),
                                                  const SizedBox(height: 20),
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
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.grey),
                                ),
                                const SizedBox(height: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      data['title'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      data['post_message'],
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                    const SizedBox(height: 20),
                                    if (data['imageUrl'] != null)
                                      Center(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: Image.network(
                                            data['imageUrl'],
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: <Widget>[
                                    FavoriteButton(
                                      documentid: data['documentID'],
                                      collectionname: 'posts',
                                    ),
                                    Text(
                                      '${data['likes'].length.toString()} いいね',
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(width: 5),

                                    //  have to add comment lenght

                                    StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('posts')
                                          .doc(data['documentID'])
                                          .collection('comments')
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.hasData) {
                                          return Text(
                                              '${snapshot.data!.docs.length.toString()} コメント',
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.grey,
                                              ));
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}');
                                        }
                                        // By default, show a loading spinner.
                                        return const CircularProgressIndicator();
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
                              if (snapshot.connectionState ==
                                  ConnectionState.active) {
                                if (snapshot.data != null) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 60.0),
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        var comment = snapshot.data!.docs[index]
                                            .data() as Map<String, dynamic>;
                                        return GestureDetector(
                                          child: ListTile(
                                              // コメントタイル
                                              title: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text(
                                                        comment["isAnonymous"] ==
                                                                true
                                                            ? '匿名'
                                                            : comment["name"],
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 5),
                                                      if (comment['user'] ==
                                                          user?.uid)
                                                        IconButton(
                                                          icon: Icon(
                                                              Icons.more_vert),
                                                          onPressed: () => {
                                                            showModalBottomSheet(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: <Widget>[
                                                                    ListTile(
                                                                      leading:
                                                                          const Icon(
                                                                              Icons.delete),
                                                                      title: const Text(
                                                                          '削除'),
                                                                      onTap:
                                                                          () async {
                                                                        // 삭제하기 버튼이 눌렸을 때의 동작을 여기에 작성합니다.
                                                                        await FirebaseFirestore
                                                                            .instance
                                                                            .collection('posts')
                                                                            .doc(widget.id)
                                                                            .collection('comments')
                                                                            .doc(snapshot.data!.docs[index].id)
                                                                            .delete();

                                                                        Navigator.pop(
                                                                            context); // 시트를 닫습니다.
                                                                      },
                                                                    ),
                                                                    const SizedBox(
                                                                        height:
                                                                            20),
                                                                  ],
                                                                );
                                                              },
                                                            ),
                                                          },
                                                        ),
                                                    ],
                                                  ),
                                                  Text(comment['text']),
                                                ],
                                              ),
                                              subtitle: Text(
                                                timeAgo(comment['timestamp']
                                                    .toDate()),
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey),
                                              )
                                              // Add other fields as needed
                                              ),
                                        );
                                      },
                                    ),
                                  );
                                } else {
                                  return const Text('No comments');
                                }
                              } else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else {
                                return const Text('Error');
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const Text('No data');
                }
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else {
                return const Text('Error');
              }
            },
          ),
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
                          decoration: const InputDecoration(
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
                        icon: const Icon(Icons.send),
                        onPressed: () async {
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
      ),
    );
  }
}
