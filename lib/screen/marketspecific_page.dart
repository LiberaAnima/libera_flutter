import 'package:flutter/material.dart';

class MarketSpecificPage extends StatefulWidget {
  const MarketSpecificPage({Key? key}) : super(key: key);

  @override
  _MarketSpecificPageState createState() => _MarketSpecificPageState();
}

class _MarketSpecificPageState extends State<MarketSpecificPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("市場別画面"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text("市場別画面"),
          ],
        ),
      ),
    );
  }
}
