import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:libera_flutter/services/timeago.dart';

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
    // print(chatroomId);
    // print(lastmessage.docs.first.data()['text']);

    final messageData = lastmessage.docs.first.data();
    return messageData['text'] ?? 'No message content';
  }
  // get last messages

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: db.collection('chatroom').where('who').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          // Process the snapshot data and return the desired widget
          return Scaffold(
            appBar: AppBar(
              title: const Text('チャット'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var chatroomData =
                      snapshot.data!.docs[index].data() as Map<String, dynamic>;

                  // print(chatroomData);
                  if (chatroomData['who'] != null &&
                      chatroomData['who'].contains(user!.uid)) {
                    return ListTile(
                      // tileColor: Colors.red,
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
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
                            return const Text('Loading...');
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            if (snapshot.data!.data() == null) {
                              return const Text('User not found');
                            }
                            var userData =
                                snapshot.data!.data() as Map<String, dynamic>;
                            var nickname = userData['username'];
                            // print("chatroom :" + chatroomData['id']);
                            return Row(
                              children: [
                                Text(
                                  nickname,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 40),
                                Text(
                                  timeAgo(chatroomData['timestamp'].toDate()),
                                  style: const TextStyle(
                                      fontSize: 10, color: Colors.grey),
                                )
                              ],
                            );
                          }
                        },
                      ),
                      subtitle: StreamBuilder<String>(
                        stream: getLastMessage(chatroomData['id']).asStream(),
                        builder: (context, snapshot) {
                          // print(snapshot.data);
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Text('Loading last message...');
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return Text(
                              '${snapshot.data}',
                              style: const TextStyle(fontSize: 15),
                            );
                          }
                        },
                      ),
                      isThreeLine: true,
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
                    return const Text('');
                  }
                },
              ),
            ),
          );
        }
      },
    );
  }
}
