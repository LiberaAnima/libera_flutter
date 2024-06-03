import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:libera_flutter/screen/post/post_specific.dart';
import 'package:libera_flutter/services/likebutton.dart';
import 'package:libera_flutter/services/timeago.dart';

class PostSearchPage extends StatefulWidget {
  const PostSearchPage({Key? key}) : super(key: key);

  @override
  _PostSearchPageState createState() => _PostSearchPageState();
}

class _PostSearchPageState extends State<PostSearchPage> {
  final TextEditingController searchController = TextEditingController();
  late Stream<QuerySnapshot> postList;

  @override
  void initState() {
    super.initState();
    postList = FirebaseFirestore.instance
        .collection('posts')
        .orderBy('date', descending: true)
        .snapshots();
    searchController.addListener(searchPosts);
  }

  @override
  void dispose() {
    searchController.removeListener(searchPosts);
    searchController.dispose();
    super.dispose();
  }

  void searchPosts() {
    if (searchController.text.isEmpty) {
      setState(() {
        postList = FirebaseFirestore.instance
            .collection('posts')
            .orderBy('date', descending: true)
            .snapshots();
      });
    } else {
      setState(() {
        postList = FirebaseFirestore.instance
            .collection("posts")
            .where("title", isGreaterThanOrEqualTo: searchController.text)
            .where("title",
                isLessThanOrEqualTo: searchController.text + '\uf8ff')
            .where("post_message",
                isGreaterThanOrEqualTo: searchController.text)
            .where("post_message",
                isLessThanOrEqualTo: searchController.text + '\uf8ff')
            .orderBy('date', descending: true)
            .snapshots();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: '投稿を検索',
            hintStyle: TextStyle(color: Colors.black),
          ),
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: StreamBuilder(
        stream: postList,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Text('Error: ${snapshot.error}');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            children: [
              const Divider(
                color: Colors.grey,
                thickness: .5,
                indent: 0,
                endIndent: 0,
              ),
              Expanded(
                child: ListView(
                  children: snapshot.data!.docs
                      .map((DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;
                        return GestureDetector(
                          onTap: () {
                            print(document.id);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PostSpecificPage(
                                  id: data['documentID'],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(),
                              ),
                            ),
                            child: ListTile(
                              contentPadding:
                                  const EdgeInsets.only(top: 0, bottom: 0),
                              title: Column(
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: <Widget>[
                                          const SizedBox(width: 10),
                                          Text(
                                            '${data['title']}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize:
                                                  20, // ここでタイトルのフォントサイズを変更
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const SizedBox(width: 10),
                                          if (data['imageUrl'] != null) ...[
                                            Image.network(data['imageUrl'],
                                                width: 100, height: 100),
                                            const SizedBox(width: 30),
                                          ],
                                          Text(
                                            data['post_message'].length > 15
                                                ? '${data['post_message'].substring(0, 15)}...'
                                                : data['post_message'],
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const SizedBox(width: 10),
                                          Text(
                                            data["isAnonymous"] == true
                                                ? '匿名'
                                                : data["name"],
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            data['date'] != null
                                                ? timeAgo(data['date'].toDate())
                                                : 'Unknown date',
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
                                                      PostSpecificPage(
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
                                                      fontSize: 10,
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
                                ],
                              ),
                            ),
                          ),
                        );
                      })
                      .toList()
                      .cast(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
