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
  final ScrollController _scrollController = ScrollController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _posts = [];
  bool _isLoading = false;
  DocumentSnapshot? _lastDocument;

  Future<void> _handleRefresh() async {
    // Clear the existing posts
    _posts.clear();
    _lastDocument = null;

    // Load the posts again
    _loadPosts();
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _loadPosts();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadPosts();
    }
  }

  void _loadPosts() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    Query query = _firestore
        .collection('posts')
        .orderBy('date', descending: true)
        .limit(10);

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    final querySnapshot = await query.get();

    if (querySnapshot.docs.isNotEmpty) {
      _lastDocument = querySnapshot.docs.last;
      _posts.addAll(querySnapshot.docs);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: _isLoading ? _posts.length + 1 : _posts.length,
          itemBuilder: (context, index) {
            if (index == _posts.length) {
              return const CircularProgressIndicator();
            } else {
              final post = _posts[index];
              // Render your post
              // print(post);
              return GestureDetector(
                onTap: () {
                  // print(document.id);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostSpecificPage(
                        id: post['documentID'],
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
                    contentPadding: const EdgeInsets.only(top: 0, bottom: 0),
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
                                  '${post['title']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20, // ここでタイトルのフォントサイズを変更
                                  ),
                                ),
                                post['tag'] == null
                                    ? Container()
                                    : Row(
                                        children: <Widget>[
                                          const SizedBox(width: 10),
                                          Tag(title: '${post['tag']}')
                                        ],
                                      ),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 25),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    post['post_message'].length > 15
                                        ? '${post['post_message'].substring(0, 15)}...'
                                        : post['post_message'],
                                  ),
                                  if (post['imageUrl'] != null) ...[
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: Image.network(post['imageUrl'],
                                          width: 150, height: 100),
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(width: 10),
                                Text(
                                  post["isAnonymous"] == true
                                      ? '匿名'
                                      : post["name"],
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  post['date'] != null
                                      ? timeAgo(post['date'].toDate())
                                      : 'Unknown date',
                                  style: const TextStyle(
                                    fontSize: 10,
                                  ),
                                ),
                                FavoriteButton(
                                  documentid: post['documentID'],
                                  collectionname: 'posts',
                                ),
                                Text(
                                  '${post['likes'].length.toString()} いいね',
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
                                        builder: (context) => PostSpecificPage(
                                          id: post['documentID'],
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
                                      .doc(post['documentID'])
                                      .collection('comments')
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasData) {
                                      // Change 'haspost' to 'hasData'
                                      return Text(
                                          '${snapshot.data!.docs.length.toString()} コメント',
                                          style: const TextStyle(
                                            fontSize: 10,
                                          ));
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
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
            }
          },
        ),
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
