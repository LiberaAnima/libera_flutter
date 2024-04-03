import 'package:flutter/material.dart';
import 'package:libera_flutter/screen/post_page.dart';
import 'package:libera_flutter/screen/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:libera_flutter/screen/login_page.dart';
import 'package:libera_flutter/screen/signup_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      localizationsDelegates: [],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const HomePage(),
        '/logIn': (context) => const LoginPage(),
        '/signUp': (context) => const SignupPage(),
        '/postPage': (context) => PostPage(),
      },
    );
  }
}
