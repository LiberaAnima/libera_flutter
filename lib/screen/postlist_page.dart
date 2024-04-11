import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:libera_flutter/services/timeago.dart';

//いいね機能
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/cupertino.dart';
import 'package:libera_flutter/screen/post_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
                    title: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1, color: Colors.white), // 枠線を追加
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(1),
                        ),
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  data['post_message'],
                                ),
                              ],
                            ),
                            Divider(
                              height: 10.0,
                              color: Color.fromRGBO(165, 165, 165, 1),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  timeAgo(data['date'].toDate()),
                                  style: TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                                FavoriteButton(documentid: data['documentID']),
                                Text(
                                  data['likes'].length.toString(),
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
                                            postSpecificPage(id: data['id']),
                                      ),
                                    );
                                  },
                                  icon: Icon(
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
        child: Icon(Icons.add),
      ),
    );
  }
}

//いいね
class FavoriteButton extends HookWidget {
  final String documentid;
  const FavoriteButton({super.key, required this.documentid});

  @override
  Widget build(BuildContext context) {
    final favorite = useState<bool>(false);
    final User? user = FirebaseAuth.instance.currentUser;
    final String? uid = user?.uid;
    final Future<DocumentSnapshot> postDocFuture =
        FirebaseFirestore.instance.collection('posts').doc(documentid).get();

    return IconButton(
      onPressed: () async {
        if (user != null) {
          final DocumentSnapshot postDoc = await postDocFuture;
          List likelists = postDoc['likes'] as List;
          if (likelists.contains(uid)) {
            likelists.remove(uid);
            favorite.value = false;
          } else {
            likelists.add(uid);
            favorite.value = true;
          }
          //いいね追加
          await FirebaseFirestore.instance
              .collection('posts')
              .doc(documentid)
              .update({'likes': likelists});
        } else {
          // Handle the case where the user is not signed in
          print("User is not signed in");
        }
      },
      icon: StreamBuilder<DocumentSnapshot>(
        stream: postDocFuture.asStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          final List likelists = snapshot.data?['likes'] as List;
          final bool isFavorite = likelists?.contains(uid) ?? false; //色を変化させる
          return Icon(
            Icons.favorite,
            size: 20,
            color: isFavorite ? Colors.pink : Colors.black12,
          );
        },
      ),
    );
  }
}
