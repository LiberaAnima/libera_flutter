import "package:flutter/material.dart";

class DiscountPage extends StatefulWidget {
  const DiscountPage({Key? key}) : super(key: key);

  @override
  _DiscountPageState createState() => _DiscountPageState();
}

class _DiscountPageState extends State<DiscountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("割引画面"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text("割引画面"),
          ],
        ),
      ),
    );
  }
}
