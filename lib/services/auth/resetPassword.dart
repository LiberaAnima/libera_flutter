import 'package:firebase_auth/firebase_auth.dart';

final firebaseAuth = FirebaseAuth.instance;

@override
Future<void> resetPassword(String email) async {
  await firebaseAuth.sendPasswordResetEmail(email: email);
}
