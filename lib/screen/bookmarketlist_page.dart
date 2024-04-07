import 'package:flutter/material.dart';

class BookMarketListPage extends StatefulWidget {
  const BookMarketListPage({Key? key}) : super(key: key);

  @override
  _BookMarketListPageState createState() => _BookMarketListPageState();
}

class _BookMarketListPageState extends State<BookMarketListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("本のマーケット一覧画面"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text("本のマーケット一覧画面"),
          ],
        ),
      ),
    );
  }
}
