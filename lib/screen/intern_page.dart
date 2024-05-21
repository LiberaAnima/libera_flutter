import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';
import 'package:libera_flutter/services/launchUrl_service.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class InternPage extends StatefulWidget {
  const InternPage({Key? key}) : super(key: key);

  @override
  _InternPageState createState() => _InternPageState();
}

class _InternPageState extends State<InternPage> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> internlists;
    internlists = FirebaseFirestore.instance.collection('intern').snapshots();
    return Scaffold(
      appBar: AppBar(
        title: Text("インターン・バイト情報"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: internlists,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          return Column(children: [
            const Divider(
              color: Colors.grey,
              thickness: .5,
              indent: 0,
              endIndent: 0,
            ),
            Expanded(
              child: ListView(
                children: snapshot.data!.docs
                    .map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return GestureDetector(
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(),
                            ),
                          ),
                          child: ListTile(
                            contentPadding:
                                const EdgeInsets.only(top: 0, bottom: 0),
                            title: Column(
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: <Widget>[
                                        const SizedBox(width: 10),
                                        Text(
                                          '${data['company']}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20, // ここでタイトルのフォントサイズを変更
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(width: 10),
                                        Text("コース: "),
                                        Text(
                                          data['course'],
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      color: Color.fromRGBO(165, 165, 165, 1),
                                      thickness: .5,
                                      indent: 15,
                                      endIndent: 15,
                                    ),
                                    for (final pattern in data['pattern'])
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(width: 10),
                                          Flexible(
                                            child: Text(
                                              pattern,
                                              style: const TextStyle(
                                                fontSize:
                                                    15, // ここでタイトルのフォントサイズを変更
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                        ],
                                      ),
                                    const Divider(
                                      color: Color.fromRGBO(165, 165, 165, 1),
                                      thickness: .5,
                                      indent: 15,
                                      endIndent: 15,
                                    ),
                                    Flexible(
                                      child: menuIcon(
                                        Icons.apartment,
                                        data['URL'],
                                        "インターン情報は" + "\n" + "こちら",
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    })
                    .toList()
                    .cast(),
              ),
            ),
          ]);
        },
      ),
    );
  }

  Container menuIcon(IconData icon, String path, String title) {
    return Container(
      width: 100,
      height: 100,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Column(children: [
        IconButton(
          onPressed: () {
            if (path.startsWith('http')) {
              launchURL(Uri.parse(path));
            } else {
              Navigator.pushNamed(context, path);
              // Navigate to a named route
            }
          },
          icon: Icon(icon),
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 10, // ここでタイトルのフォントサイズを変更
          ),
        )
      ]),
    );
  }
}
