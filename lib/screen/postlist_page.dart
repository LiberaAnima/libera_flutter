import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:libera_flutter/services/timeago.dart';

//いいね機能
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/cupertino.dart';
import 'package:libera_flutter/screen/post_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:libera_flutter/services/likebutton.dart';

//返信機能
import 'package:libera_flutter/screen/post_specific.dart';
import 'package:provider/provider.dart';

class PostListPage extends StatefulWidget {
  const PostListPage({Key? key}) : super(key: key);

  @override
  _PostListPagePageState createState() => _PostListPagePageState();
}

class _PostListPagePageState extends State<PostListPage> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> postlists = FirebaseFirestore.instance
        .collection('posts')
        .orderBy('date', descending: true)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        title: const Text("掲示板"),
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
                  return Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(),
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.only(top: 0, bottom: 0),
                      title: Column(
                        children: [
                          const SizedBox(height: 5),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(width: 10),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: ShapeDecoration(
                                      color: const Color(0xFFE0E0E0),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(3)),
                                    ),
                                    child: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Q&A",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                            height: 0.18,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: <Widget>[
                                  const SizedBox(width: 10),
                                  Text(
                                    '${data['name']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 10),
                                  Text(
                                    data['post_message'],
                                  ),
                                ],
                              ),
                              const Divider(
                                color: Color.fromRGBO(165, 165, 165, 1),
                                thickness: .5,
                                indent: 15,
                                endIndent: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 10),
                                  Text(
                                    timeAgo(data['date'].toDate()),
                                    style: const TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                                  FavoriteButton(
                                    documentid: data['documentID'],
                                    collectionname: 'posts',
                                  ),
                                  Text(
                                    '${data['likes'].length.toString()} いいね',
                                    style: const TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
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
                                    icon: const Icon(
                                      Icons.messenger_outline_rounded,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                })
                .toList()
                .cast(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PostPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
