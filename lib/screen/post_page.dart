import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
      ),
      body: MessagesList(),
    );
  }
}

class MessagesList extends StatelessWidget {
  List<types.Message> _firebaseMessagesToChatMessages(List<QueryDocumentSnapshot> messageDocs) {
    return messageDocs.map<types.Message>((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final Timestamp timestamp = data['timestamp'] as Timestamp? ?? Timestamp.now();
      final text = data['text'] ?? '';

      return types.TextMessage(
        author: types.User(id: data['senderId']),
        createdAt: timestamp.toDate().millisecondsSinceEpoch,
        id: doc.id,
        text: text,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Messages')
          .where('conversationId', isEqualTo: 'room1')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Error: ${snapshot.error}'),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        final messages = _firebaseMessagesToChatMessages(snapshot.data!.docs);

        return Chat(
          messages: messages,
          onSendPressed: (types.PartialText message) async {
            final docRef = FirebaseFirestore.instance.collection('Messages').doc();

            await docRef.set({
              'conversationId': 'room1',
              'messageId': docRef.id,
              'senderId': 'HbLC1lw9HZOcAb3IPkFHBYq7qcB3',
              'text': message.text,
              'timestamp': FieldValue.serverTimestamp(),
            });
          },
          user: types.User(id: 'HbLC1lw9HZOcAb3IPkFHBYq7qcB3'),
        );
      },
    );
  }
}
