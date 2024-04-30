import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:libera_flutter/models/user_model.dart';
import 'package:libera_flutter/services/user_service.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({Key? key, required this.uid}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserService _userService = UserService();
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
        .collection('post')
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
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          _user = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text('プロフィール', style: TextStyle(color: Colors.black)),
              iconTheme: IconThemeData(color: Colors.blue),
              elevation: 0,
            ),
            body: _user == null
                ? Center(child: CircularProgressIndicator())
                : Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListView(
                        children: <Widget>[
                          SizedBox(height: 24),
                          Text(
                            _user!.username,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          Text(
                            _user!.email,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Divider(height: 40, thickness: 2),
                          profileInfo('大学', _user!.school),
                          profileInfo('学部', _user!.faculty),
                          profileInfo('学年', _user!.year),
                          profileInfo('性別', _user!.gender),
                          ElevatedButton(
                            onPressed: () async => await _auth.signOut().then(
                                (_) => Navigator.pushNamed(context, "/logIn")),
                            child: const Text("ログアウト"),
                          ),
                          Divider(height: 40, thickness: 2),
                          Text('自分の投稿',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          _posts.isEmpty
                              ? Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Text('投稿がありません',
                                      textAlign: TextAlign.center),
                                )
                              : Column(
                                  children: _posts
                                      .map((post) => ListTile(
                                            title: Text(post['post_message']),
                                            subtitle: Text(
                                                'Likes: ${post['likes'].length}'),
                                          ))
                                      .toList(),
                                ),
                          Divider(height: 40, thickness: 2),
                          Text('フリマ投稿',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          _books.isEmpty
                              ? Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Text('フリマ投稿がありません',
                                      textAlign: TextAlign.center),
                                )
                              : Column(
                                  children: _books
                                      .map((book) => ListTile(
                                            title: Text(book['bookname']),
                                            subtitle: Text('${book['price']}円'),
                                          ))
                                      .toList(),
                                ),
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
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
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
