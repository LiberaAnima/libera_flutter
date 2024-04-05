import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:libera_flutter/screen/login_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPagePageState createState() => _MainPagePageState();
}

class _MainPagePageState extends State<MainPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot> getUserInfo() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      return await _firestore.collection('users').doc(user.uid).get();
    }
    throw Exception('No user logged in');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[
              Color.fromARGB(255, 255, 201, 135),
              Color.fromARGB(255, 252, 225, 190),
            ],
          ),
        ),
        child: Center(
          child: FutureBuilder<DocumentSnapshot>(
            future: getUserInfo(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final data = snapshot.data!.data() as Map<String, dynamic>;
                print(data);
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Email: ${data['email']}',
                          style: TextStyle(color: Colors.black)),
                      Text('Name: ${data['username']}'),
                      Text('Gender: ${data['gender']}',
                          style: TextStyle(color: Colors.black)),
                      Text('School: ${data['school']}',
                          style: TextStyle(color: Colors.black)),
                      // ...
                      ElevatedButton(
                        onPressed: () async => await _auth
                            .signOut()
                            .then((_) => Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginPage()),
                                  (Route<dynamic> route) => false,
                                )),
                        child: Text("Log Out"),
                      ),
                      ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, '/post'),
                        child: Text("post"),
                      ),
                      ElevatedButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, '/postbook'),
                        child: Text("postbook"),
                      )
                    ],
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.none) {
                return Text("No data");
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
