import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:libera_flutter/screen/market/marketspecific_page.dart';
import 'package:libera_flutter/screen/market/search_page.dart';
import 'package:libera_flutter/screen/market/postbook_page.dart';
import 'package:libera_flutter/services/timeago.dart';

class BookMarketListPage extends StatefulWidget {
  const BookMarketListPage({super.key});

  @override
  _BookMarketListPageState createState() => _BookMarketListPageState();
}

class _BookMarketListPageState extends State<BookMarketListPage> {
  final ScrollController _scrollController = ScrollController();
  List<DocumentSnapshot> _books = [];
  bool _isLoading = false;
  DocumentSnapshot? _lastDocument;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _getBooks();
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
      _getBooks();
    }
  }

  Future<void> _getBooks() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    Query query = FirebaseFirestore.instance
        .collection('books')
        .orderBy('postedAt', descending: true)
        .limit(10);
    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    final querySnapshot = await query.get();

    if (querySnapshot.docs.isNotEmpty) {
      _lastDocument = querySnapshot.docs.last;
      _books.addAll(querySnapshot.docs);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Add this line
        backgroundColor: Colors.transparent,
        title: const Text("キャンパスフリマ"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchPage()));
              // 検索画面に遷移
            },
          ),
          // IconButton(
          //   icon: const Icon(Icons.filter_list),
          //   onPressed: () {
          //     // フィルター画面に遷移
          //   },
          // ),
        ],
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: _isLoading ? _books.length + 1 : _books.length,
        itemBuilder: (context, index) {
          if (index == _books.length) {
            return _isLoading
                ? const Center(child: CircularProgressIndicator())
                : null;
          } else {
            final book = _books[index];
            // Render your book
            return GestureDetector(
              onTap: () {
                DocumentReference docRef =
                    FirebaseFirestore.instance.collection('books').doc(book.id);

                // Increment the viewCount field
                docRef.update({'viewCount': FieldValue.increment(1)});
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MarketSpecificPage(
                      uid: book['documentId'],
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
                              book['imageUrl'],
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(book['bookname'],
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    )),
                                Text(
                                  "${book['price']}円",
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
                                      book['username'] ?? 'null',
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      book['faculty'] ?? 'null',
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      timeAgo((book['postedAt'] as Timestamp)
                                          .toDate()), // Convert Timestamp to DateTime
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      '${(book.data() as Map<String, dynamic>).containsKey('bookmark') ? book['bookmark'].length.toString() : '0'} ',
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
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
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
