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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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
              if (chatroomData['who'].contains(user!.uid)) {
                print(chatroomData);
                return Container(
                  child: Column(children: [
                    ListTile(
                      title: Text("tests"),

                      // subtitle: Text(chatroomData['description']),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatroomPage(
                              chatroomId: chatroomData['uid'],
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
                return SizedBox.shrink();
              }
            },
          ));
        }
      },
    );
  }
}
