import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:libera_flutter/screen/chat_post.dart';

class UserListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
      ),
      body: UsersList(),
    );
  }
}

class ChatlistPage extends StatelessWidget {
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
                      String conversationId =
                          document.id; // 仮のconversationId生成ロジック
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatRoom(
                              conversationId: conversationId, userId: myUserId),
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
