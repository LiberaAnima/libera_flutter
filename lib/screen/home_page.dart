import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:libera_flutter/screen/bookmarketlist_page.dart';
import 'package:libera_flutter/screen/login_page.dart';
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
    // const HomePage(),
    const BookMarketListPage(),
    const PostListPage(),
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
                  icon: Badge(child: Icon(Icons.notifications_sharp)),
                  label: 'book',
                ),
                NavigationDestination(
                  icon: Badge(
                    label: Text('2'),
                    child: Icon(Icons.messenger_sharp),
                  ),
                  label: 'postlist',
                ),
                NavigationDestination(
                  icon: Badge(
                    label: Text('3'),
                    child: Icon(Icons.messenger_sharp),
                  ),
                  label: 'class',
                ),
                NavigationDestination(
                  icon: Badge(
                    label: Text('4'),
                    child: Icon(Icons.messenger_sharp),
                  ),
                  label: 'profile',
                ),
              ],
            ),
            body: _pages[currentPageIndex],
            // body: Container(
            //   decoration: const BoxDecoration(
            //     gradient: LinearGradient(
            //       begin: Alignment.topCenter,
            //       end: Alignment.bottomCenter,
            //       colors: <Color>[
            //         Color.fromARGB(255, 255, 201, 135),
            //         Color.fromARGB(255, 252, 225, 190),
            //       ],
            //     ),
            //   ),
            //   child: Center(
            //     child: Column(
            //       mainAxisSize: MainAxisSize.min,
            //       children: [
            //         Text(style: TextStyle(color: Colors.white), "hello"),
            //         ElevatedButton(
            //           onPressed: () async => await _auth
            //               .signOut()
            //               .then((_) => Navigator.pushNamed(context, "/logIn")),
            //           child: Text("Log Out"),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          );
        }
      },
    );
  }
}
