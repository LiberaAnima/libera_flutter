import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  late Stream<QuerySnapshot> bookList;

  @override
  void initState() {
    super.initState();
    bookList = FirebaseFirestore.instance
        .collection('books')
        .orderBy('postedAt', descending: true)
        .snapshots();
    searchController.addListener(searchBooks);
  }

  @override
  void dispose() {
    searchController.removeListener(searchBooks);
    searchController.dispose();
    super.dispose();
  }

  void searchBooks() {
    if (searchController.text.isEmpty) {
      setState(() {
        bookList = FirebaseFirestore.instance
            .collection('books')
            .orderBy('postedAt', descending: true)
            .snapshots();
      });
    } else {
      setState(() {
        bookList = FirebaseFirestore.instance
            .collection("books")
            .where("bookname", isGreaterThanOrEqualTo: searchController.text)
            .where("bookname",
                isLessThanOrEqualTo: searchController.text + '\uf8ff')
            .orderBy('postedAt', descending: true)
            .snapshots();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: "Search books...",
            hintStyle: TextStyle(color: Colors.black),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Colors.black),
          ),
          style: TextStyle(color: Colors.black),
          onChanged: (value) {
            searchBooks();
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: bookList,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              print(data);
              return ListTile(
                title: Text(data['bookname']),
                subtitle: Text(data['bookauthor']),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
