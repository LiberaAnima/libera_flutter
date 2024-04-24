import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:libera_flutter/screen/marketspecific_page.dart';
import 'package:libera_flutter/screen/postbook_page.dart';
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
        title: Text("本のマーケット一覧画面"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('books').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return Container(
            color: Colors.white,
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> post =
                    document.data() as Map<String, dynamic>;

                DateTime postedAt = post['postedAt'] != null
                    ? post['postedAt'].toDate()
                    : DateTime.now();

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
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(),
                      ),
                    ),
                    child: ListTile(
                      contentPadding:
                          const EdgeInsets.only(top: 0.0, bottom: 0.0),
                      title: Column(
                        children: [
                          const SizedBox(height: 5),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: <Widget>[
                                  Image.network(
                                    post['imageUrl'],
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                  const SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(post['bookname'],
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          )),
                                      Text(
                                        "${post['price']}円",
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.orange[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Divider(
                                        color: Colors.grey,
                                        thickness: 5,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            post['username'] ?? 'null',
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            post['faculty'] ?? 'null',
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            timeAgo(postedAt),
                                            style: TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                          // Text(
                                          //   '${post['bookmark'].length.toString()}保存' ??
                                          //       'null',
                                          //   style: TextStyle(
                                          //     fontSize: 12,
                                          //   ),
                                          // ),
                                          // Text(
                                          //   '${post['viewCount'].toString()}閲覧' ??
                                          //       'null',
                                          //   style: TextStyle(
                                          //     fontSize: 12,
                                          //   ),
                                          // ),
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
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PostBookPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
