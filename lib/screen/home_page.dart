import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:libera_flutter/components/bottom_nav.dart';
import 'package:libera_flutter/models/user_model.dart';
import 'package:libera_flutter/screen/bookmarketlist_page.dart';
import 'package:libera_flutter/screen/chatlist_page.dart';
import 'package:libera_flutter/screen/login_page.dart';
import 'package:libera_flutter/screen/main_page.dart';
import 'package:libera_flutter/screen/postlist_page.dart';
import 'package:libera_flutter/screen/school_page.dart';
import 'package:libera_flutter/services/user_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserModel? _user;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserService _userService = UserService();

  int currentPageIndex = 0;
  final List<Widget> _pages = <Widget>[
    const MainPage(),
    const BookMarketListPage(),
    const PostListPage(),
    const ChatListPage(),
    const SchoolPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _auth.authStateChanges(),
      builder: (BuildContext con, AsyncSnapshot<User?> user) {
        if (!user.hasData) {
          return const LoginPage();
        } else {
          return Scaffold(
            body: _pages[currentPageIndex],
            bottomNavigationBar: BottomNav(
              opPageSelected: (index) {
                setState(() {
                  currentPageIndex = index;
                });
              },
            ),
          );
        }
      },
    );
  }
}
