import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:libera_flutter/screen/market/bookmarketlist_page.dart';
import 'package:libera_flutter/screen/chat/chatlist_page.dart';
import 'package:libera_flutter/screen/class_page.dart';
import 'package:libera_flutter/screen/discount_page.dart';
import 'package:libera_flutter/screen/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:libera_flutter/screen/login_page.dart';
import 'package:libera_flutter/screen/main_page.dart';
import 'package:libera_flutter/screen/post/post_page.dart';
import 'package:libera_flutter/screen/market/postbook_page.dart';
import 'package:libera_flutter/screen/post/postlist_page.dart';
import 'package:libera_flutter/screen/profileEdit_page.dart';
import 'package:libera_flutter/screen/signup/checkPolicy_page.dart';
import 'package:libera_flutter/screen/signup/findpassword_page.dart';
import 'package:libera_flutter/screen/signup/signup_page.dart';

import 'firebase_options.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

Future<void> main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle().copyWith(
      statusBarColor: Colors.white,
      systemNavigationBarColor: Colors.white,
    ),
  );

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
        primarySwatch: Colors.blue,
        // colorScheme:
        //     ColorScheme.fromSeed(seedColor: Color.fromARGB(0, 242, 183, 7)),
        textTheme: GoogleFonts.ibmPlexSansJpTextTheme(
          Theme.of(context).textTheme,
        ),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const HomePage(),
        '/main': (context) => const MainPage(),
        '/logIn': (context) => const LoginPage(),
        '/signUp': (context) => const SignupPage(),
        // '/profile': (context) => const ProfilePage(),
        '/postlist': (context) => const PostListPage(),
        '/bookmarketlist': (context) => const BookMarketListPage(),
        // '/marketspecific': (context) => const MarketSpecificPage(),
        '/class': (context) => const ClassPage(),
        '/post': (context) => PostPage(),
        '/postbook': (context) => const PostBookPage(),
        '/chatlist': (context) => const ChatListPage(),
        '/discount': (context) => const DiscountPage(),
        '/findpassword': (context) => FindPasswordPage(),
        '/editprofile': (context) => const ProfileEditPage(),
        '/checkpolicy': (context) => const TermsOfServiceAgreement(),
      },
    );
  }
}
