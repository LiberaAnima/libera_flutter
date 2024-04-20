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
        backgroundColor: Colors.white,
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
                  child: Card(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Image.network(
                            post['imageUrl'],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(post['bookname'],
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    )),
                                Text(post['faculty'] ?? 'null'),
                                Text(post['username'] ?? 'null'),
                                Text(timeAgo(postedAt)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                "${post['price']}円",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.orange[700],
                                  fontWeight: FontWeight.bold,
                                ),
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
