import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:libera_flutter/services/timeago.dart';

//いいね機能
import 'package:flutter/cupertino.dart';
import 'package:libera_flutter/screen/post_page.dart';
import 'package:libera_flutter/services/likebutton.dart';

//返信機能
import 'package:libera_flutter/screen/post_specific.dart';

class PostListPage extends StatefulWidget {
  const PostListPage({Key? key}) : super(key: key);

  @override
  _PostListPagePageState createState() => _PostListPagePageState();
}

class _PostListPagePageState extends State<PostListPage> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> postlists;

    if (searchController.text.isEmpty) {
      postlists = FirebaseFirestore.instance
          .collection('posts')
          .orderBy('date', descending: true)
          .snapshots();
    } else {
      postlists = FirebaseFirestore.instance
          .collection("posts")
          .where("title", isGreaterThanOrEqualTo: searchController.text)
          .where("title", isLessThanOrEqualTo: searchController.text + '\uf8ff')
          .orderBy('date', descending: true)
          .snapshots();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('掲示板'),
      ),
      endDrawer: Drawer(
        child: Column(
          children: [
            const SizedBox(height: 90),
            const Text(
              "カテゴリー",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(
              color: Colors.orange,
              thickness: 1,
              indent: 0,
              endIndent: 0,
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: .5,
                  ),
                ),
              ),
              child: const ListTile(
                title: Text('講義・授業'),
                onTap: null,
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: .5,
                  ),
                ),
              ),
              child: const ListTile(
                title: Text('部活動・サークル'),
                onTap: null,
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: .5,
                  ),
                ),
              ),
              child: const ListTile(
                title: Text('アルバイト'),
                onTap: null,
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: .5,
                  ),
                ),
              ),
              child: const ListTile(
                title: Text('恋愛'),
                onTap: null,
              ),
            ),
          ],
        ),
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
          return Column(
            children: [
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    left: 10, right: 10, top: 10, bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: Colors.orange,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text(
                        "雑談",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: "inter",
                          fontWeight: FontWeight.w400,
                          height: 0.11,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: Colors.orange,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text(
                        "Q&A",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: "inter",
                          fontWeight: FontWeight.w400,
                          height: 0.11,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            width: 1,
                            color: Colors.orange,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: Text(
                        "募集",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: "inter",
                          fontWeight: FontWeight.w400,
                          height: 0.11,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
                                  const SizedBox(height: 5),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                            '${data['title']}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
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
                      })
                      .toList()
                      .cast(),
                ),
              ),
            ],
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
