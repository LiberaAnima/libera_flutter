import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//いいね
class FavoriteButton extends HookWidget {
  final String collectionname;
  final String documentid;
  const FavoriteButton(
      {super.key, required this.documentid, required this.collectionname});

  @override
  Widget build(BuildContext context) {
    final favorite = useState<bool>(false);
    final User? user = FirebaseAuth.instance.currentUser;
    final String? uid = user?.uid;
    final Future<DocumentSnapshot> postDocFuture = FirebaseFirestore.instance
        .collection(collectionname)
        .doc(documentid)
        .get();

    return IconButton(
      onPressed: () async {
        if (user != null) {
          final DocumentSnapshot postDoc = await postDocFuture;
          List likelists = postDoc['likes'] as List;
          if (likelists.contains(uid)) {
            likelists.remove(uid);
            favorite.value = false;
          } else {
            likelists.add(uid);
            favorite.value = true;
          }
          //いいね追加
          await FirebaseFirestore.instance
              .collection(collectionname)
              .doc(documentid)
              .update({'likes': likelists});
        } else {
          // Handle the case where the user is not signed in
          print("User is not signed in");
        }
      },
      icon: StreamBuilder<DocumentSnapshot>(
        stream: postDocFuture.asStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          final List likelists = snapshot.data?['likes'] as List;
          final bool isFavorite = likelists?.contains(uid) ?? false; //色を変化させる
          return Icon(
            Icons.favorite,
            size: 20,
            color: isFavorite ? Colors.pink : Colors.black12,
          );
        },
      ),
    );
  }
}
