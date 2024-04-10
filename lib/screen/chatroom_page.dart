import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom extends StatelessWidget {
  final String conversationId;
  final String userId;

  ChatRoom({required this.conversationId, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
      ),
      body: ChatroomPage(conversationId: conversationId, userId: userId),
    );
  }
}

class ChatroomPage extends StatelessWidget {
  final String conversationId;
  final String userId;

  ChatroomPage({required this.conversationId, required this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chatroom')
          // .where('who'[0], isEqualTo: conversationId)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final messages = _firebaseMessagesToChatMessages(snapshot.data!.docs);

        return Chat(
          messages: messages,
          onSendPressed: (types.PartialText message) async {
            final docRef = FirebaseFirestore.instance
                .collection('chatroom')
                .doc()
                .collection('messages')
                .doc();
            await docRef.set({
              'conversationId': conversationId,
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
