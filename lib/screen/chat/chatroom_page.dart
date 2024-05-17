import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:libera_flutter/models/user_model.dart';
import 'package:libera_flutter/services/user_service.dart';

class ChatRoom extends StatefulWidget {
  final String otherId;
  final String userId;
  final String chatroomId;

  ChatRoom({
    required this.otherId,
    required this.userId,
    required this.chatroomId,
  });

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final UserService _userService = UserService();
  UserModel? _user;
  final User? user = FirebaseAuth.instance.currentUser;

  void setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;

    await fcm.requestPermission();

    fcm.subscribeToTopic('chat');
    final token = await fcm.getToken();
    // print(token);
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    setupPushNotifications();
  }

  void _fetchUserData() async {
    try {
      UserModel userData = await _userService.getUserData(user!.uid);
      setState(() {
        _user = userData;
      });
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.otherId)
              .get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            print(_user?.username);
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
        otherId: widget.otherId,
        userId: widget.userId,
        chatroomId: widget.chatroomId,
        username: _user?.username ?? '',
      ),
    );
  }
}

class ChatroomPage extends StatelessWidget {
  final String otherId;
  final String userId;
  final String chatroomId;
  final String username;

  ChatroomPage({
    required this.otherId,
    required this.userId,
    required this.chatroomId,
    required this.username,
  });

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
            theme: const DefaultChatTheme(
              inputBackgroundColor: Color.fromARGB(255, 254, 185, 80),
              inputTextColor: Colors.white,
              primaryColor: Color.fromARGB(255, 254, 185, 80),
            ),
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
                'username': username,
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
                        leading: const Icon(Icons.delete),
                        title: const Text('Delete Message'),
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
