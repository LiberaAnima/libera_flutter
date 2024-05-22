import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:libera_flutter/models/user_model.dart';
import 'package:libera_flutter/screen/market/marketspecific_page.dart';
import 'package:libera_flutter/screen/post/post_specific.dart';
import 'package:libera_flutter/services/user_service.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({super.key, required this.uid});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserService _userService = UserService();
  UserModel? _user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<dynamic> _posts = [];
  List<dynamic> _books = [];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchPosts();
  }

  void _fetchUserData() async {
    try {
      UserModel userData = await _userService.getUserData(widget.uid);
      setState(() {
        _user = userData;
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  void _fetchPosts() async {
    var postsSnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .where('uid', isEqualTo: widget.uid)
        .get();

    var booksSnapshot = await FirebaseFirestore.instance
        .collection('books')
        .where('uid', isEqualTo: widget.uid)
        .get();

    setState(() {
      _posts = postsSnapshot.docs.map((doc) => doc.data()).toList();
      _books = booksSnapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: _userService.getUserData(widget.uid),
      builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          _user = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title:
                  const Text('プロフィール', style: TextStyle(color: Colors.black)),
              elevation: 0,
            ),
            body: _user == null
                ? const Center(child: CircularProgressIndicator())
                : Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListView(
                        children: <Widget>[
                          const SizedBox(height: 24),
                          Text(
                            _user!.username,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _user!.email,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Divider(height: 40, thickness: 2),
                          profileInfo('大学', _user!.school),
                          profileInfo('学部', _user!.faculty),
                          profileInfo('学科、専攻', _user!.field),
                          profileInfo('学年', _user!.year),
                          profileInfo('性別', _user!.gender),
                          ElevatedButton(
                            onPressed: () =>
                                {Navigator.pushNamed(context, "/editprofile")},
                            child: const Text("修正"),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: () async => await _auth.signOut().then(
                                (_) => Navigator.pushNamed(context, "/logIn")),
                            child: const Text("ログアウト"),
                          ),
                          const Divider(height: 40, thickness: 2),
                          const Text('自分の投稿',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          _posts.isEmpty
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Text('投稿がありません',
                                      textAlign: TextAlign.center),
                                )
                              : Column(
                                  children: _posts
                                      .map((post) => GestureDetector(
                                            onTap: () {
                                              DocumentReference docRef =
                                                  FirebaseFirestore.instance
                                                      .collection('posts')
                                                      .doc(post['documentID']);

                                              // Increment the viewCount field

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      PostSpecificPage(
                                                          id: post[
                                                              'documentID']),
                                                ),
                                              );
                                            },
                                            child: ListTile(
                                              title: Text(
                                                post['title'],
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              subtitle: Text(
                                                  'Likes: ${post['likes'].length}'),
                                            ),
                                          ))
                                      .toList(),
                                ),
                          const Divider(height: 40, thickness: 2),
                          const Text('フリマ投稿',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          _books.isEmpty
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Text('フリマ投稿がありません',
                                      textAlign: TextAlign.center),
                                )
                              : Column(
                                  children: _books
                                      .map((book) => GestureDetector(
                                            onTap: () {
                                              DocumentReference docRef =
                                                  FirebaseFirestore.instance
                                                      .collection('books')
                                                      .doc(book['documentId']);

                                              // Increment the viewCount field
                                              docRef.update({
                                                'viewCount':
                                                    FieldValue.increment(1)
                                              });
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      MarketSpecificPage(
                                                          uid: book[
                                                              'documentId']),
                                                ),
                                              );
                                            },
                                            child: ListTile(
                                              title: Text(
                                                book['bookname'],
                                                style: const TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              subtitle:
                                                  Text('${book['price']}円'),
                                            ),
                                          ))
                                      .toList(),
                                ),
                          const Divider(height: 40, thickness: 2),
                          const Text('お気に入り商品',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
          );
        }
      },
    );
  }

  Widget profileInfo(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
