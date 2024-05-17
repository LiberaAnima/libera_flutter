import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:libera_flutter/models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel> getUserData(String uid) async {
    var snapshot = await _firestore.collection('users').doc(uid).get();
    if (snapshot.exists) {
      return UserModel.fromMap(snapshot.data()!);
    } else {
      throw Exception('User not found');
    }
  }
}
