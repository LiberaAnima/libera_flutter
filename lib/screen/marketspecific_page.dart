import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'main_page.dart';
import 'package:libera_flutter/screen/chatroom_page.dart';
import 'package:libera_flutter/services/timeago.dart';


class MarketSpecificPage extends StatefulWidget {
  final String uid;

  const MarketSpecificPage({super.key, required this.uid});

  @override
  _MarketSpecificPageState createState() => _MarketSpecificPageState();
}

class _MarketSpecificPageState extends State<MarketSpecificPage> {
  late Future<DocumentSnapshot> _future;

  final User? user = FirebaseAuth.instance.currentUser;

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
          print(user?.uid);

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text("商品詳細画面"),
            ),
            body: Column(
              children: <Widget>[
                Image.network(book['imageUrl'],
                    height: 300, width: double.infinity, fit: BoxFit.cover),
                Padding(
                  padding: EdgeInsets.only(
                      right: 8.0, left: 8.0, top: 8.0, bottom: 2.0),
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                          // backgroundImage:
                          //     NetworkImage('https://example.com/user-icon.jpg'),
                          ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('出品者: ${book['username']}'),
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
                const Divider(
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                  color: Colors.grey,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          top: 2.0, left: 8.0, right: 8.0, bottom: 2.0),
                      child: Text(
                        book['bookname'],
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 2.0, left: 8.0, right: 8.0, bottom: 2.0),
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
                    Padding(
                      padding:
                          EdgeInsets.only(left: 8.0, top: 2.0, bottom: 2.0),
                      child: Text(
                        '文学部',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2.0, bottom: 2.0),
                      child: Text(
                        '・',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2.0, bottom: 2.0),
                      child: Text(
                        '三日前',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    book['details'],
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 2.0, bottom: 2.0),
                      child: Text(
                        '3いいね',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 2.0, bottom: 2.0),
                      child: Text(
                        '・',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.only(top: 2.0, bottom: 2.0, right: 8.0),
                      child: Text(
                        '10閲覧',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      padding: EdgeInsets.all(8.0),
                      child: Text(timeAgo(postedAt)),
                    ),
                  ],
                ),
                const Divider(
                  thickness: .5,
                  indent: 0,
                  endIndent: 0,
                  color: Colors.grey,
                ),
                Row(
                  children: [
                    Icon(Icons.flag, color: Colors.grey, size: 20),
                    Padding(
                      padding:
                          EdgeInsets.only(top: 2.0, bottom: 2.0, left: 8.0),
                      child: Text(
                        '通報する',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                const Divider(
                  thickness: .5,
                  indent: 0,
                  endIndent: 0,
                  color: Colors.grey,
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                final docRef = await FirebaseFirestore.instance
                    .collection('chatroom')
                    .add({
                  'bookname': book['bookname'],
                  'who': [book['uid'], user?.uid],
                  'timestamp': DateTime.now(),
                });
                final chatroomid = docRef.id;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatRoom(
                      otherId: book['uid'],
                      userId: user!.uid,
                      chatroomId: chatroomid ?? '',
                    ),
                  ),
                );
              },
              label: Text('チャットする'),
              icon: Icon(Icons.chat),
              backgroundColor: Colors.orange,
              shape: StadiumBorder(),
            ),
          );
        }
      },
    );
  }
}
