import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:libera_flutter/screen/bookmarketlist_page.dart';
import 'package:libera_flutter/screen/class_page.dart';
import 'package:libera_flutter/screen/login_page.dart';
import 'package:libera_flutter/screen/main_page.dart';
import 'package:libera_flutter/screen/postlist_page.dart';
import 'package:libera_flutter/screen/profile_page.dart';
import 'package:libera_flutter/screen/signup_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  int currentPageIndex = 0;
  final List<Widget> _pages = <Widget>[
    const MainPage(),
    const BookMarketListPage(),
    const PostListPage(),
    const ClassPage(),
    const ProfilePage(),
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
            bottomNavigationBar: NavigationBar(
              onDestinationSelected: (int index) {
                setState(
                  () {
                    currentPageIndex = index;
                  },
                );
              },
              indicatorColor: Colors.amber,
              selectedIndex: currentPageIndex,
              destinations: const <Widget>[
                NavigationDestination(
                  selectedIcon: Icon(Icons.home),
                  icon: Icon(Icons.home_outlined),
                  label: 'Home',
                ),
                NavigationDestination(
                  icon: Badge(child: Icon(Icons.book)),
                  label: 'book',
                ),
                NavigationDestination(
                  icon: Badge(
                    label: Text('2'),
                    child: Icon(Icons.article),
                  ),
                  label: 'postlist',
                ),
                NavigationDestination(
                  icon: Badge(
                    label: Text('3'),
                    child: Icon(Icons.class_),
                  ),
                  label: 'class',
                ),

                NavigationDestination(
                  icon: Badge(
                    label: Text('4'),
                    child: Icon(Icons.person),
                  ),
                  label: 'profile',
                ),
              ],
            ),
            body: _pages[currentPageIndex],
          );
        }
      },
    );
  }
}
