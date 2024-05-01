import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom extends StatelessWidget {
  final String otherId;
  final String userId;
  final String chatroomId;

  ChatRoom(
      {required this.otherId, required this.userId, required this.chatroomId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<DocumentSnapshot>(
          future:
              FirebaseFirestore.instance.collection('users').doc(otherId).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading...");
            } else {
              if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                return Text(data['username']);
              }
            }
          },
        ),
      ),
      body: ChatroomPage(
        otherId: otherId,
        userId: userId,
        chatroomId: chatroomId,
      ),
    );
  }
}

class ChatroomPage extends StatelessWidget {
  final String otherId;
  final String userId;
  final String chatroomId;

  ChatroomPage(
      {required this.otherId, required this.userId, required this.chatroomId});

  @override
  Widget build(BuildContext context) {
    if (chatroomId.isEmpty) {
      throw ArgumentError('chatroomId cannot be empty');
    }
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chatroom')
          .doc(chatroomId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.hasData) {
          final messages = _firebaseMessagesToChatMessages(snapshot.data!.docs);
          return Chat(
            messages: messages,
            onSendPressed: (types.PartialText message) async {
              final docRef = FirebaseFirestore.instance
                  .collection('chatroom')
                  .doc(chatroomId)
                  .collection('messages')
                  .doc();
              await docRef.set({
                'otherId': otherId,
                'senderId': userId,
                'text': message.text,
                'timestamp': FieldValue.serverTimestamp(),
              });
            },
            user: types.User(id: userId),
            onMessageLongPress: (context, message) {
              if (message.author.id == userId) {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Wrap(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.delete),
                        title: Text('Delete Message'),
                        onTap: () {
                          Navigator.of(context).pop(); // Close the bottom sheet
                          FirebaseFirestore.instance
                              .collection('chatroom')
                              .doc(chatroomId)
                              .collection('messages')
                              .doc(message.id)
                              .delete();
                        },
                      ),
                    ],
                  ),
                );
              }
            },
          );
        }
        return Container();
      },
    );
  }

  List<types.Message> _firebaseMessagesToChatMessages(
      List<QueryDocumentSnapshot> messageDocs) {
    return messageDocs.map<types.Message>((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final Timestamp timestamp =
          data['timestamp'] as Timestamp? ?? Timestamp.now();
      final text = data['text'] ?? '';

      return types.TextMessage(
        author: types.User(id: data['senderId'] ?? ''),
        createdAt: timestamp.toDate().millisecondsSinceEpoch,
        id: doc.id,
        text: text,
      );
    }).toList();
  }
}
