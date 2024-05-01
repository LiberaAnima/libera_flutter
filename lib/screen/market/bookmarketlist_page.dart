import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:libera_flutter/screen/market/marketspecific_page.dart';
import 'package:libera_flutter/screen/market/search_page.dart';
import 'package:libera_flutter/screen/market/postbook_page.dart';
import 'package:libera_flutter/services/timeago.dart';

class BookMarketListPage extends StatefulWidget {
  const BookMarketListPage({Key? key}) : super(key: key);

  @override
  _BookMarketListPageState createState() => _BookMarketListPageState();
}

class _BookMarketListPageState extends State<BookMarketListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("キャンパスフリマ"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchPage()));
              // 検索画面に遷移
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // フィルター画面に遷移
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('books')
            .orderBy('postedAt', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          return Container(
            color: Colors.white,
            child: ListView(
              padding: const EdgeInsets.all(0),
              children: (snapshot.data!.docs).map((DocumentSnapshot document) {
                Map<String, dynamic> post =
                    document.data() as Map<String, dynamic>;

                DateTime postedAt = post['postedAt'] != null
                    ? post['postedAt'].toDate()
                    : DateTime.now();
                // int viewCount = post['viewCount' ?? 0];

                return GestureDetector(
                  onTap: () {
                    DocumentReference docRef = FirebaseFirestore.instance
                        .collection('books')
                        .doc(document.id);

                    // Increment the viewCount field
                    docRef.update({'viewCount': FieldValue.increment(1)});
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MarketSpecificPage(
                          uid: document.id,
                        ),
                      ),
                    );
                  },
                  child: ListTile(
                    minVerticalPadding: 0,
                    contentPadding: EdgeInsets.zero,
                    title: Column(
                      children: [
                        const Divider(
                          color: Colors.black,
                          thickness: 1,
                          indent: 0.0,
                          endIndent: 0.0,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: <Widget>[
                                const SizedBox(width: 8),
                                Image.network(
                                  post['imageUrl'],
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(post['bookname'],
                                        style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    Text(
                                      "${post['price']}円",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.orange[700],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          post['username'] ?? 'null',
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          post['faculty'] ?? 'null',
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          timeAgo(postedAt),
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Text(
                                          '${post['bookmark']?.length?.toString() ?? '0'} ',
                                          style: const TextStyle(
                                            fontSize: 12,
                                          ),
                                        ),
                                        const Icon(Icons.bookmark_border),
                                        const SizedBox(width: 10),
                                        // Text("${post["viewCount"]}閲覧",
                                        // style: TextStyle(
                                        //   fontSize: 12,
                                        // )),
                                        // Text('$viewCount閲覧'),
                                      ],
                                    ),
                                  ],
                                ),

                                // いいね数とコメント数を表示
                                // Row(
                                //   children: <Widget>[
                                //     const Icon(Icons.favorite_border),
                                //     Text(post['likes'].toString()),
                                //     const SizedBox(width: 8),
                                //     const Icon(Icons.comment),
                                //     Text(post['comments'].toString()),
                                //   ],
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.grey,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PostBookPage()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
