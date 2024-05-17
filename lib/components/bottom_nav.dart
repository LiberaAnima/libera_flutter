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
      backgroundColor: const Color.fromARGB(60, 255, 255, 255),
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
          icon: Icon(Icons.home),
          label: 'ホーム',
        ),
        NavigationDestination(
          icon: Icon(Icons.book),
          label: 'フリマ',
        ),
        NavigationDestination(
          icon:
              // label: Text('2'),
              Icon(Icons.article),
          label: '掲示板',
        ),
        NavigationDestination(
          icon:
              // label: Text('3'),
              Icon(Icons.chat),
          label: 'チャット',
        ),
        NavigationDestination(
            icon:
                // label: Text('4'),
                // Badge count追加予定
                Icon(Icons.school),
            label: '授業'),
      ],
    );
  }
}
