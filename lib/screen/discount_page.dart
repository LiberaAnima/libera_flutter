import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

List<String> categories = ['全体', 'グルメ', 'カフェー', '交通', 'その他'];

class DiscountPage extends StatefulWidget {
  const DiscountPage({super.key});

  @override
  State<DiscountPage> createState() => _DiscountPageState();
}

class _DiscountPageState extends State<DiscountPage> {
  String selectedCategory = categories[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("割引画面"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = categories[index];
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          color: selectedCategory == categories[index]
                              ? Colors.orange
                              : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 15.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: selectedCategory == '全体'
                    ? FirebaseFirestore.instance
                        .collection('discounts')
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection('discounts')
                        .where('category', isEqualTo: selectedCategory)
                        .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      var document = snapshot.data!.docs[index];
                      var content = document['contents'];
                      var title = document['title'];
                      var url = document['URL'];
                      // Cut the content to a maximum of 50 characters
                      if (content.length > 50) {
                        content = content.substring(0, 50) + '...';
                      }
                      return GestureDetector(
                        onTap: () => launch(url),
                        child: Card(
                          color: Colors.white,
                          shadowColor: Colors.grey,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                const SizedBox(height: 20),
                                Text(
                                  title,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 30),
                                Text(content,
                                    style: const TextStyle(fontSize: 15)),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
