import 'package:flutter/material.dart';

class postDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(height: 90),
          const Text(
            "カテゴリー",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(
            color: Colors.orange,
            thickness: 1,
            indent: 0,
            endIndent: 0,
          ),
          _buildDrawerItem('講義・授業'),
          _buildDrawerItem('部活動・サークル'),
          _buildDrawerItem('アルバイト'),
          _buildDrawerItem('就活'),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(String title) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: .5,
          ),
        ),
      ),
      child: ListTile(
        title: Text(title),
        onTap: () {
          // Handle tap
        },
      ),
    );
  }
}
