// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAa9fjmc9-doSXeb6uRPp56HRBU_SG7Gew',
    appId: '1:997188547316:web:e0d7d9610de976f0ee64a1',
    messagingSenderId: '997188547316',
    projectId: 'libera-b72ea',
    authDomain: 'libera-b72ea.firebaseapp.com',
    databaseURL: 'https://libera-b72ea-default-rtdb.firebaseio.com',
    storageBucket: 'libera-b72ea.appspot.com',
    measurementId: 'G-W9J5Z3Y4PL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBybdbXYoI1p_DIESpHKj-skrqzlxrwigY',
    appId: '1:997188547316:android:080d75e7389bb321ee64a1',
    messagingSenderId: '997188547316',
    projectId: 'libera-b72ea',
    databaseURL: 'https://libera-b72ea-default-rtdb.firebaseio.com',
    storageBucket: 'libera-b72ea.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCFrOCXNLVnpWDAthfPsAvp766Zgr0D-1E',
    appId: '1:997188547316:ios:a82cf213bb27e61eee64a1',
    messagingSenderId: '997188547316',
    projectId: 'libera-b72ea',
    databaseURL: 'https://libera-b72ea-default-rtdb.firebaseio.com',
    storageBucket: 'libera-b72ea.appspot.com',
    iosBundleId: 'com.campus.liberaFlutter',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCFrOCXNLVnpWDAthfPsAvp766Zgr0D-1E',
    appId: '1:997188547316:ios:fa4802d013492490ee64a1',
    messagingSenderId: '997188547316',
    projectId: 'libera-b72ea',
    databaseURL: 'https://libera-b72ea-default-rtdb.firebaseio.com',
    storageBucket: 'libera-b72ea.appspot.com',
    iosBundleId: 'com.example.liberaFlutter.RunnerTests',
  );
}
