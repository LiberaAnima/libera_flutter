import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

import 'chatroom_page.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final db = FirebaseFirestore.instance;

  final User? user = FirebaseAuth.instance.currentUser;

  Future<String> getLastMessage(String chatroomId) async {
    final lastmessage = await db
        .collection('chatroom')
        .doc(chatroomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .get();

    if (lastmessage.docs.isEmpty) {
      return 'No messages yet';
    }
    print(chatroomId);
    print(lastmessage.docs.first.data()['message']);

    final messageData = lastmessage.docs.first.data();
    return messageData['message'] ?? 'No message content';
  }
  // get last messages

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: db.collection('chatroom').where('who').get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          // Process the snapshot data and return the desired widget
          return Scaffold(
            appBar: AppBar(
              title: Text('チャット一覧'),
            ),
            body: ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var chatroomData =
                    snapshot.data!.docs[index].data() as Map<String, dynamic>;

                // print(chatroomData);
                if (chatroomData['who'] != null &&
                    chatroomData['who'].contains(user!.uid)) {
                  return ListTile(
                    title:
                        FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      future: db
                          .collection('users')
                          .doc(chatroomData['who']
                              .firstWhere((id) => id != user!.uid))
                          .get(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text('Loading...');
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          if (snapshot.data!.data() == null) {
                            return Text('User not found');
                          }
                          var userData =
                              snapshot.data!.data() as Map<String, dynamic>;
                          var nickname = userData['username'];
                          print("chatroom :" + chatroomData['id']);
                          return Text(
                            nickname,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          );
                        }
                      },
                    ),
                    subtitle: FutureBuilder<String>(
                      future: getLastMessage(chatroomData['id']),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Text('Loading last message...');
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return Text('Last message: ${snapshot.data}');
                        }
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatRoom(
                            chatroomId: chatroomData['id'],
                            otherId: chatroomData['who']
                                .firstWhere((id) => id != user!.uid),
                            userId: user!.uid,
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return Text('');
                }
              },
            ),
          );
        }
      },
    );
  }
}
