import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:libera_flutter/screen/postbook_page.dart';

class BookMarketListPage extends StatefulWidget {
  const BookMarketListPage({Key? key}) : super(key: key);

  @override
  _BookMarketListPageState createState() => _BookMarketListPageState();
}

class _BookMarketListPageState extends State<BookMarketListPage> {
  String _selectedFaculty = "全学部";
  final List<String> _marketList = ['全学部', '文学部', '経済学部'];

  final List<Map<String, dynamic>> _posts = [
    {
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/libera-b72ea.appspot.com/o/books%2F1712298476555.jpg?alt=media&token=31ef49ba-4b6d-4b37-8848-5e088288aa98",
      "bookname": "キャリアで語る経営組織",
      "faculty": "文学部",
      "postedTime": "2021-10-10 10:00:00",
      "price": "1500",
      "likes": 3,
      "comments": 2,
    },
    {
      "imageUrl":
          "https://firebasestorage.googleapis.com/v0/b/libera-b72ea.appspot.com/o/books%2F1712298476555.jpg?alt=media&token=31ef49ba-4b6d-4b37-8848-5e088288aa98",
      "bookname": "キャリアで語る経営組織2",
      "faculty": "文学部",
      "postedTime": "2021-10-10 10:00:00",
      "price": "1500",
      "likes": 3,
      "comments": 2,
    },
    // 他の投稿データも追加
  ];

  DropdownButton<String> _buildDropdownButton() {
    return DropdownButton<String>(
      icon: const Icon(Icons.arrow_drop_down),
      value: _selectedFaculty,
      onChanged: (String? newValue) {
        setState(() {
          _selectedFaculty = newValue!;
        });
      },
      items: _marketList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[_buildDropdownButton(), Text("本のマーケット")],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('books').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> post =
                  document.data() as Map<String, dynamic>;
              return Card(
                margin: EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Image.network(
                        post['imageUrl'],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(post['bookname'],
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                )),
                            Text(post['faculty'] ?? 'null'),
                            Text(post['postedTime'] ?? 'null'),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            "${post['price']}円",
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.orange[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              const Icon(Icons.favorite_border),
                              Text(post['likes'].toString()),
                              const SizedBox(width: 8),
                              const Icon(Icons.comment),
                              Text(post['comments'].toString()),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PostBookPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
