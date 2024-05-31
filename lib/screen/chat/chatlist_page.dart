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

  Stream<DocumentSnapshot> getLastMessage(String chatroomId) {
    return FirebaseFirestore.instance
        .collection('chatroom')
        .doc(chatroomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) => snapshot.docs.first);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('chatroom')
            .where('who', arrayContains: user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            var chatrooms = snapshot.data!.docs.map((doc) {
              var chatroomData = doc.data() as Map<String, dynamic>;
              return StreamBuilder<DocumentSnapshot>(
                  stream: getLastMessage(doc.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const ListTile(title: Text('Loading...'));
                    } else if (snapshot.hasError) {
                      return ListTile(title: Text('Error: ${snapshot.error}'));
                    } else {
                      var lastMessageData = snapshot.data!.data();
                      if (lastMessageData != null) {
                        chatroomData['lastMessage'] = lastMessageData;
                        // print(chatroomData);
                        return ListTile(
                          // tileColor: Colors.red,
                          dense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 5),
                          title: FutureBuilder<
                              DocumentSnapshot<Map<String, dynamic>>>(
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
                                var userData = snapshot.data!.data()
                                    as Map<String, dynamic>;
                                var nickname = userData['username'];
                                // print("chatroom :" + chatroomData['id']);
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      nickname,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(width: 40),
                                    Text(
                                      chatroomData['lastMessage']
                                                  ['timestamp'] !=
                                              null
                                          ? timeAgo(chatroomData['lastMessage']
                                                  ['timestamp']
                                              .toDate())
                                          : 'No last message',
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
                                    )
                                  ],
                                );
                              }
                            },
                          ),
                          subtitle: Text(
                            chatroomData['lastMessage']['text'] ??
                                'No last message',
                            style: const TextStyle(fontSize: 15),
                          ),
                          trailing: (chatroomData['isNew'] ?? false)
                              ? const Icon(
                                  Icons.new_releases,
                                  color: Colors.orange,
                                )
                              : null,
                          isThreeLine: true,
                          onTap: () async {
                            FirebaseFirestore.instance
                                .collection('chatroom')
                                .doc(chatroomData['id'])
                                .update({
                              'isNew': false,
                            });
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
                        return Container();
                      }
                    }
                  });
            }).toList();

            return ListView(
              children: chatrooms,
            );
          }
        },
      ),
    );
  }
}
