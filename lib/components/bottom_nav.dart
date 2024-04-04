import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  final Function(int) opPageSelected;
  const BottomNav({
    super.key,
    required this.opPageSelected,
  });

  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      onDestinationSelected: (int index) {
        setState(
          () {
            currentPageIndex = index;
          },
        );
        widget.opPageSelected(index);
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
    );
  }
}
