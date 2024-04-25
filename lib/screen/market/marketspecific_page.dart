import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:libera_flutter/services/launchUrl_service.dart';
import 'package:libera_flutter/screen/chatroom_page.dart';
import 'package:libera_flutter/services/timeago.dart';

Uri url = Uri.parse(
    'https://docs.google.com/forms/d/e/1FAIpQLSfmAKkMXTtKehTmJtA2mJq1vIr3KNgD1MLc-x9egUUo82P2WQ/viewform');

class MarketSpecificPage extends StatefulWidget {
  final String uid;

  const MarketSpecificPage({super.key, required this.uid});

  @override
  _MarketSpecificPageState createState() => _MarketSpecificPageState();
}

class _MarketSpecificPageState extends State<MarketSpecificPage> {
  late Future<DocumentSnapshot> _future;

  final User? user = FirebaseAuth.instance.currentUser;

  bool isBookmarked = false;

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
            body: SingleChildScrollView(
              child: Column(
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
                          book['faculty'],
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
                          timeAgo(postedAt),
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
                    // bookmark and view count

                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 2.0, bottom: 2.0),
                        child: StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('books')
                              .doc(widget.uid)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text("Error: ${snapshot.error}",
                                  style: TextStyle(color: Colors.grey));
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.active) {
                              Map<String, dynamic>? data = snapshot.data?.data()
                                  as Map<String, dynamic>?;
                              if (data != null) {
                                List<dynamic> bookmarks =
                                    data['bookmark'] ?? [];
                                return Text(
                                    "保存数 : " + bookmarks.length.toString(),
                                    style: TextStyle(color: Colors.grey));
                              }
                            }

                            return Text("Loading",
                                style: TextStyle(color: Colors.grey));
                          },
                        ),
                      ),
                      const Padding(
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
                          "閲覧数 : " + book['viewCount'].toString(),
                          style: TextStyle(
                            color: Colors.grey,
                          ),
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
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 40),
                    width: double.infinity,
                    color: Colors.transparent,
                    child: GestureDetector(
                      onTap: () {
                        launchURL(url);
                      },
                      behavior: HitTestBehavior.opaque,
                      child: const Row(
                        children: [
                          Icon(Icons.flag, color: Colors.grey, size: 20),
                          SizedBox(width: 8),
                          Text(
                            '通報する',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Spacer(),
                          Icon(Icons.keyboard_arrow_right,
                              color: Colors.black, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    thickness: .5,
                    indent: 0,
                    endIndent: 0,
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: double.infinity,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            '${book['username']}さんの他の販売商品',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              height: 0.10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 178,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            height: 170,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    decoration: ShapeDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(""),
                                        fit: BoxFit.fill,
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // 他の商品の

                                // Padding(
                                //   padding: const EdgeInsets.all(8.0),
                                //   child: Text(
                                //     'product name1',
                                //     style: TextStyle(
                                //       color: Colors.black,
                                //       fontSize: 14,
                                //       fontFamily: 'Inter',
                                //       fontWeight: FontWeight.w400,
                                //       height: 0.09,
                                //     ),
                                //   ),
                                // ),
                                // Padding(
                                //   padding: const EdgeInsets.all(8.0),
                                //   child: Text(
                                //     'price1円',
                                //     style: TextStyle(
                                //       color: Colors.black,
                                //       fontSize: 14,
                                //       fontFamily: 'Inter',
                                //       fontWeight: FontWeight.w700,
                                //       height: 0.09,
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Container(
                            height: 170,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    decoration: ShapeDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(""),
                                        fit: BoxFit.fill,
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Padding(
                                //   padding: const EdgeInsets.all(8.0),
                                //   child: Text(
                                //     'product name2',
                                //     style: TextStyle(
                                //       color: Colors.black,
                                //       fontSize: 14,
                                //       fontFamily: 'Inter',
                                //       fontWeight: FontWeight.w400,
                                //       height: 0.09,
                                //     ),
                                //   ),
                                // ),
                                // Padding(
                                //   padding: const EdgeInsets.all(8.0),
                                //   child: Text(
                                //     'price2円',
                                //     style: TextStyle(
                                //       color: Colors.black,
                                //       fontSize: 14,
                                //       fontFamily: 'Inter',
                                //       fontWeight: FontWeight.w700,
                                //       height: 0.09,
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
            bottomNavigationBar: BottomAppBar(
              shape: const CircularNotchedRectangle(),
              color: Colors.white,
              notchMargin: 6.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      final User? user = FirebaseAuth.instance.currentUser;

                      if (user != null) {
                        setState(() {
                          isBookmarked = !isBookmarked;
                        });

                        if (isBookmarked) {
                          await FirebaseFirestore.instance
                              .collection('books')
                              .doc(widget.uid)
                              .update({
                            'bookmark': FieldValue.arrayUnion([user.uid]),
                          });
                        } else {
                          await FirebaseFirestore.instance
                              .collection('books')
                              .doc(widget.uid)
                              .update({
                            'bookmark': FieldValue.arrayRemove([user.uid]),
                          });
                        }
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        color: Colors.blue,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              '¥${book['price']}',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                height: 0.09,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              book['bookname'],
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w700,
                                height: 0.12,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      final chatroomQuery = await FirebaseFirestore.instance
                          .collection('chatroom')
                          .where('who',
                              arrayContainsAny: [book['uid'], user?.uid]).get();

                      if (chatroomQuery.docs.isNotEmpty) {
                        // Chatroom already exists, navigate to it
                        final chatroomid = chatroomQuery.docs.first.id;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatRoom(
                              otherId: book['uid'],
                              userId: user!.uid,
                              chatroomId: chatroomid,
                            ),
                          ),
                        );
                      } else {
                        // Chatroom does not exist, create it
                        final docRef = await FirebaseFirestore.instance
                            .collection('chatroom')
                            .add({
                          'bookname': book['bookname'],
                          'who': [book['uid'], user?.uid],
                          'timestamp': DateTime.now(),
                        });
                        final chatroomid = docRef.id;
                        FirebaseFirestore.instance
                            .collection('chatroom')
                            .doc(chatroomid)
                            .update({
                          'id': chatroomid,
                        });
                        print(" chatroom id : " + chatroomid);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatRoom(
                              otherId: book['uid'],
                              userId: user!.uid,
                              chatroomId: chatroomid,
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      decoration: ShapeDecoration(
                        color: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "チャットする",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                              height: 0.09,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}