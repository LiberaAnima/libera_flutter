import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:libera_flutter/components/postDrawer.dart';
import 'package:libera_flutter/components/tag.dart';
import 'package:libera_flutter/screen/post/postsearch_page.dart';
import 'package:libera_flutter/services/timeago.dart';

//いいね機能
import 'package:libera_flutter/screen/post/post_page.dart';
import 'package:libera_flutter/services/likebutton.dart';

//返信機能
import 'package:libera_flutter/screen/post/post_specific.dart';

class PostListPage extends StatefulWidget {
  const PostListPage({super.key});

  @override
  _PostListPagePageState createState() => _PostListPagePageState();
}

class _PostListPagePageState extends State<PostListPage> {
  final StreamController<List<DocumentSnapshot>> streamController =
      StreamController<List<DocumentSnapshot>>();
  List<DocumentSnapshot>? currentDocuments;
  DocumentSnapshot? lastDocument;
  final int documentLimit = 10;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    Query query = FirebaseFirestore.instance
        .collection('posts')
        .orderBy('date', descending: true)
        .limit(documentLimit);

    if (lastDocument != null &&
        (lastDocument!.data() as Map<String, dynamic>).containsKey('date')) {
      query = query.startAfterDocument(lastDocument!);
    }

    QuerySnapshot querySnapshot = await query.get();

    if (querySnapshot.docs.length > 0) {
      lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
      currentDocuments = List<DocumentSnapshot>.from(currentDocuments ?? [])
        ..addAll(querySnapshot.docs);
      streamController.add(currentDocuments!);
    }
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> postlists;
    postlists = FirebaseFirestore.instance
        .collection('posts')
        .orderBy('date', descending: true)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        title: const Text('掲示板'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PostSearchPage()));
              // 検索画面に遷移
            },
          ),
        ],
      ),
      drawer: postDrawer(),
      body: StreamBuilder<List<DocumentSnapshot>>(
        stream: streamController.stream,
        builder: (BuildContext context,
            AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
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
                child: ListView.builder(
                  itemCount: snapshot.data!.length + 1,
                  itemBuilder: (context, index) {
                    if (index == snapshot.data!.length) {
                      getData();
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      DocumentSnapshot document = snapshot.data![index];

                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return GestureDetector(
                        onTap: () {
                          // print(document.id);
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        const SizedBox(width: 10),
                                        Text(
                                          '${data['title']}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20, // ここでタイトルのフォントサイズを変更
                                          ),
                                        ),
                                        data['tag'] == null
                                            ? Container()
                                            : Row(
                                                children: <Widget>[
                                                  const SizedBox(width: 10),
                                                  Tag(title: '${data['tag']}')
                                                ],
                                              ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 25),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            data['post_message'].length > 15
                                                ? '${data['post_message'].substring(0, 15)}...'
                                                : data['post_message'],
                                          ),
                                          if (data['imageUrl'] != null) ...[
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              child: Image.network(
                                                  data['imageUrl'],
                                                  width: 150,
                                                  height: 100),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
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
                                            return CircularProgressIndicator();
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
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PostPage()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
