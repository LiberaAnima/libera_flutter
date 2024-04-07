import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//いいね機能
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/cupertino.dart';

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
                              width: 1, color: Colors.black), // 枠線を追加
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.all(4),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  data['date'].toDate().toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  data['name'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
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
                            FavoriteButton()
                          ],
                        )),
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

//いいね
class FavoriteButton extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final favorite = useState<bool>(false);
    return IconButton(
      onPressed: () =>
          (favorite.value) ? favorite.value = false : favorite.value = true,
      icon: Icon(
        Icons.favorite,
        color: (favorite.value) ? Colors.pink : Colors.black12,
      ),
    );
  }
}
