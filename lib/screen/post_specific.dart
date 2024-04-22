// import 'dart:html';

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// import 'package:libera_flutter/services/likebutton.dart';

class PostSpecificPage extends StatefulWidget {
  final String id;

  PostSpecificPage({required this.id});

  @override
  _PostSpecificPageState createState() => _PostSpecificPageState();
}

class _PostSpecificPageState extends State<PostSpecificPage> {
  DocumentSnapshot? _post;

  @override
  void initState() {
    super.initState();
    _fetchPost();
  }

  void _fetchPost() async {
    final postRef =
        FirebaseFirestore.instance.collection('posts').doc(widget.id);
    final post = await postRef.get();
    setState(() {
      _post = post;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('投稿詳細'),
      ),
      body: _post != null
          ? Column(
              children: <Widget>[
                const SizedBox(width: 10),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "username",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        "2018-10-10 10:10:10",
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                      Divider(
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "title",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "content",
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          Text(
                            "10いいね",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            "5コメント",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: <Widget>[
                          FilledButton(
                            onPressed: null,
                            child: Row(
                              children: [
                                Icon(Icons.favorite_border,
                                    color: Colors.grey, size: 20),
                                SizedBox(width: 5),
                                Text('いいね'),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          FilledButton(
                            onPressed: null,
                            child: Row(
                              children: [
                                Icon(Icons.messenger_outline_rounded,
                                    color: Colors.grey, size: 20),
                                SizedBox(width: 5),
                                Text('コメント'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                ),
                const Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'コメントを入力してください。',
                      suffixIcon: Icon(Icons.send),
                    ),
                  ),
                ),
              ],
            )
          // Add more fields as needed
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:libera_flutter/services/timeago.dart';
// import 'package:libera_flutter/services/likebutton.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class PostSpecificPage extends StatefulWidget {
//   final String id;

//   const PostSpecificPage({super.key, required this.id});

//   @override
//   _PostSpecificPageState createState() => _PostSpecificPageState();
// }

// class _PostSpecificPageState extends State<PostSpecificPage> {
//   late Future<DocumentSnapshot> _future;

//   TextEditingController _textEditingController = TextEditingController();

//   _onSubmitted(String content) {
//     /// 入力欄をクリアにする
//     _textEditingController.clear();
//   }

//   @override
//   void initState() {
//     super.initState();
//     _future =
//         FirebaseFirestore.instance.collection('posts').doc(widget.id).get();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final Stream<QuerySnapshot> responselists = FirebaseFirestore.instance
//         .collection('response')
//         .orderBy('date', descending: true)
//         .snapshots();
//     return FutureBuilder<DocumentSnapshot<Object?>>(
//       future: _future,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator();
//         } else if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         } else {
//           Map<String, dynamic> post =
//               snapshot.data!.data() as Map<String, dynamic>;

//           DateTime postedAt =
//               post['date'] != null ? post['date'].toDate() : DateTime.now();

//           return Scaffold(
//             appBar: AppBar(
//               title: Text("投稿一覧画面"),
//             ),
//             body: Container(
//               // Wrap the Column with Container

//               decoration: BoxDecoration(
//                 border: Border.all(width: 1, color: Colors.white), // 枠線を追加
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(1),
//               ),
//               padding: EdgeInsets.all(8),
//               child: Column(
//                 children: <Widget>[
//                   Padding(
//                     padding: EdgeInsets.all(8.0),
//                     child: Row(
//                       children: <Widget>[
//                         SizedBox(width: 10),
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             Text(
//                               'ユーザーネーム: 匿名',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(height: 5),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Text(
//                         post['post_message'],
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 5),
//                   Divider(
//                     height: 10.0,
//                     color: Color.fromRGBO(165, 165, 165, 1),
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Text(
//                         timeAgo(post['date'].toDate()),
//                         style: TextStyle(
//                           fontSize: 10,
//                         ),
//                       ),
//                       FavoriteButton(
//                         documentid: post['documentID'],
//                         collectionname: 'posts',
//                       ),
//                       Text(
//                         'いいね ${post['likes'].length.toString()}  ',
//                         style: TextStyle(
//                           fontSize: 10,
//                         ),
//                       ),
//                     ],
//                   ),
//                   Center(
//                     child: TextField(
//                       controller: _textEditingController,
//                       onSubmitted: _onSubmitted,
//                       enabled: true,
//                       maxLength: 200, // 入力数
//                       //maxLengthEnforced: false, // 入力上限になったときに、文字入力を抑制するか
//                       style: TextStyle(color: Colors.black),
//                       obscureText: false,
//                       maxLines: 1,
//                       decoration: const InputDecoration(
//                         icon: Icon(Icons.speaker_notes),
//                         hintText: '返信',
//                         labelText: '返信する * ',
//                       ),
//                     ),
//                   ),
//                   //返信内容を表示
//                   StreamBuilder<QuerySnapshot>(
//                     stream: responselists,
//                     builder: (BuildContext context,
//                         AsyncSnapshot<QuerySnapshot> snapshot) {
//                       if (snapshot.hasError) {
//                         return const Text('Something went wrong');
//                       }

//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const Text("Loading");
//                       }

//                       return ListView(
//                         children: snapshot.data!.docs
//                             .map((DocumentSnapshot document) {
//                               Map<String, dynamic> data =
//                                   document.data()! as Map<String, dynamic>;
//                               return ListTile(
//                                 title: Container(
//                                     decoration: BoxDecoration(
//                                       border: Border.all(
//                                           width: 1,
//                                           color: Colors.white), // 枠線を追加
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(1),
//                                     ),
//                                     padding: EdgeInsets.all(8),
//                                     child: Column(
//                                       children: [
//                                         Text('あいうえお'), //テスト用
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           children: [
//                                             CircleAvatar(
//                                               backgroundImage: NetworkImage(
//                                                   'https://example.com/user-icon.jpg'),
//                                             ),
//                                             SizedBox(width: 10),
//                                             Column(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.start,
//                                               children: <Widget>[
//                                                 Text(
//                                                   'ユーザーネーム: 匿名',
//                                                   style: TextStyle(
//                                                     fontWeight: FontWeight.bold,
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                         SizedBox(height: 5),
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               data['post_message'],
//                                             ),
//                                           ],
//                                         ),
//                                         SizedBox(height: 5),
//                                         Divider(
//                                           height: 10.0,
//                                           color:
//                                               Color.fromRGBO(165, 165, 165, 1),
//                                         ),
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               timeAgo(data['date'].toDate()),
//                                               style: TextStyle(
//                                                 fontSize: 10,
//                                               ),
//                                             ),
//                                             FavoriteButton(
//                                               documentid: data['documentID'],
//                                               collectionname: 'posts',
//                                             ),
//                                             Text(
//                                               'いいね ${data['likes'].length.toString()}  ',
//                                               style: TextStyle(
//                                                 fontSize: 10,
//                                               ),
//                                             ),
//                                             IconButton(
//                                               onPressed: () {
//                                                 Navigator.push(
//                                                   context,
//                                                   MaterialPageRoute(
//                                                     builder: (context) =>
//                                                         PostSpecificPage(
//                                                       id: data['documentID'],
//                                                     ),
//                                                   ),
//                                                 );
//                                               },
//                                               icon: Icon(
//                                                 Icons.messenger_outline_rounded,
//                                                 size: 20,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     )),
//                               );
//                             })
//                             .toList()
//                             .cast(),
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             floatingActionButton: FloatingActionButton(
//               onPressed: () async {
//                 final User? user = FirebaseAuth.instance.currentUser;
//                 if (user != null) {
//                   final String uid = user.uid;
//                   final DocumentSnapshot userDoc = await FirebaseFirestore
//                       .instance
//                       .collection('users')
//                       .doc(uid)
//                       .get();
//                   final response =
//                       FirebaseFirestore.instance.collection('response').doc();
//                   response.set({
//                     'post_message': _textEditingController.text,
//                     'date': FieldValue.serverTimestamp(),
//                     'name': userDoc['username'],
//                     'likes': [],
//                     'uid': uid,
//                     'documentID': post['documentID'],
//                     'responseID': response.id,
//                   });
//                 }
//                 _onSubmitted(_textEditingController.text);
//               },
//               child: Icon(Icons.send),
//             ),
//           );
//         }
//       },
//     );
//   }
// }
