import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:libera_flutter/services/timeago.dart';

//いいね機能
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/cupertino.dart';
import 'package:libera_flutter/screen/post_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:libera_flutter/services/likebutton.dart';

//返信機能
import 'package:libera_flutter/screen/post_specific.dart';

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
        title: const Text("自由掲示板"),
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
//Column使うのがよさそう
          return ListView(
            children: snapshot.data!.docs
                .map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return ListTile(
                    title: Container(
                        decoration: BoxDecoration(
                          border:
                              Border.all(width: 1, color: Colors.grey), // 枠線を追加
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(1),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      '${data['name']}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  data['post_message'],
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            const Divider(
                              height: 10.0,
                              color: Color.fromRGBO(165, 165, 165, 1),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
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
                                  'いいね ${data['likes'].length.toString()}  ',
                                  style: const TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => postSpecificPage(
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
                        )),
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
