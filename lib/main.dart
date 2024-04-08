import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:libera_flutter/firebase_options.dart';
import 'package:libera_flutter/screen/chat_list.dart'; // UserListScreenを含むファイル

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserListScreen(), // ユーザーリスト画面をホームとして設定
    );
  }
}