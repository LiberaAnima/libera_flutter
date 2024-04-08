import 'package:cloud_firestore/cloud_firestore.dart';

void getMessages() async {
  FirebaseFirestore db = FirebaseFirestore.instance;

  QuerySnapshot querySnapshot = await db.collection('Messages').get();

  for (var doc in querySnapshot.docs) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    print("Message: ${data['text']}, Timestamp: ${data['timestamp']}");
  }
}
