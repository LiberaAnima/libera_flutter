import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class DiscountPage extends StatefulWidget {
  const DiscountPage({Key? key}) : super(key: key);

  @override
  _DiscountPageState createState() => _DiscountPageState();
}

class _DiscountPageState extends State<DiscountPage> {
  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> internlists;
    internlists = FirebaseFirestore.instance
        .collection('discounts')
        .orderBy('name', descending: true)
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        title: Text("割引画面"),
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
                                          '${data['name']}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20, // ここでタイトルのフォントサイズを変更
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const SizedBox(width: 10),
                                        Text(
                                          data['contents'],
                                        ),
                                      ],
                                    ),
                                    const Divider(
                                      color: Color.fromRGBO(165, 165, 165, 1),
                                      thickness: .5,
                                      indent: 15,
                                      endIndent: 15,
                                    ),
                                    IconButton(
                                        onPressed: () async {
                                          final url = Uri.parse(
                                            data['URL'],
                                          );
                                          if (await canLaunchUrl(url)) {
                                            launchUrl(url);
                                          } else {
                                            // ignore: avoid_print
                                            print("Can't launch $url");
                                          }
                                        },
                                        icon: const Icon(
                                          Icons.shopping_cart,
                                          color: Colors.black54,
                                          size: 30.0,
                                        )),
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
}
