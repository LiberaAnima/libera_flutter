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
          return (ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var chatroomData =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;

              // print(chatroomData);
              if (chatroomData['who'] != null &&
                  chatroomData['who'].contains(user!.uid)) {
                return Container(
                  child: Column(children: [
                    ListTile(
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
                            var userData =
                                snapshot.data!.data() as Map<String, dynamic>;
                            var nickname = userData['username'];
                            print("chatroom :" + chatroomData['id']);
                            return Text(nickname);
                          }
                        },
                      ),
                      // subtitle: Text(chatroomData['description']),
                      onTap: () {
                        // print("chatroom : " + chatroomData['who']);

                        print(chatroomData['id']);
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
                    ),
                  ]),
                );
              } else {
                return Text('');
              }
            },
          ));
        }
      },
    );
  }
}
