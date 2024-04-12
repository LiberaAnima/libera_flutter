import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'chatroom_page.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  @override
  Widget build(BuildContext context) {
    final String myUserId = 'YQEvhBeccnZQFjbg6P7pIzrRiid2'; // 実際には動的に取得することを想定

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No users found.'));
        }

        return ListView(
          children: snapshot.data!.docs
              .map((document) {
                Map<String, dynamic> userData =
                    document.data() as Map<String, dynamic>;
                // ユーザー名が存在しない、または空文字列の場合はリストアイテムを作らない
                if (userData['username'] == null ||
                    userData['username']!.isEmpty) {
                  return Container(); // 空のコンテナを返してアイテムを表示しない
                } else {
                  String username = userData['username'];
                  return ListTile(
                    title: Text(username),
                    onTap: () {
                      String otherId = document.id; // 仮のotherId生成ロジック
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatroomPage(
                            otherId: otherId,
                            userId: myUserId,
                            chatroomId: '',
                          ),
                        ),
                      );
                    },
                  );
                }
              })
              .where((element) => element is! Container)
              .toList(), // Container（空のリストアイテム）を除外する
        );
      },
    );
  }
}
