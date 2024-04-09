import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:libera_flutter/services/timeago.dart';

// void main() {
//   runApp(MaterialApp(
//     home: MarketSpecificPage(),
//   ));
// }

class MarketSpecificPage extends StatefulWidget {
  final String uid;

  const MarketSpecificPage({super.key, required this.uid});

  @override
  _MarketSpecificPageState createState() => _MarketSpecificPageState();
}

class _MarketSpecificPageState extends State<MarketSpecificPage> {
  late Future<DocumentSnapshot> _future;

  @override
  void initState() {
    super.initState();
    _future =
        FirebaseFirestore.instance.collection('books').doc(widget.uid).get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          Map<String, dynamic> book =
              snapshot.data!.data() as Map<String, dynamic>;

          DateTime postedAt = book['postedAt'] != null
              ? book['postedAt'].toDate()
              : DateTime.now();

          print(book);
          return Scaffold(
            appBar: AppBar(
              title: Text("商品詳細画面"),
            ),
            body: Column(
              children: <Widget>[
                Image.network(book['imageUrl'],
                    height: 300, width: double.infinity, fit: BoxFit.cover),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage('https://example.com/user-icon.jpg'),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('ユーザーネーム: ${book['username']}'),
                          Row(
                            children: [
                              Text(book['faculty']),
                              SizedBox(width: 10),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        book['bookname'],
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        '¥${book['price']}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    // Padding(
                    //   padding: EdgeInsets.all(8.0),
                    //   child: Text('文学部'),
                    // ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(timeAgo(postedAt)),
                    ),
                  ],
                ),
                Text(book['details'])
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                FirebaseFirestore.instance.collection('chatroom').add({
                  'bookname': book['bookname'],
                  'who': [book['uid'], widget.uid],
                  'timestamp': DateTime.now(),
                });
              },
              label: Text('チャットする'),
              icon: Icon(Icons.chat),
              backgroundColor: Colors.orange,
              shape: StadiumBorder(),
            ),
          );
          // 이제 `user` 맵에서 사용자 정보를 불러올 수 있습니다.
          // 예: user['username'], user['email'], 등...
        }
      },
    );
  }
}
