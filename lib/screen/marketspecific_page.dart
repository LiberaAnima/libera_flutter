import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: MarketSpecificPage(),
  ));
}

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
        title: Text("商品詳細画面"),
      ),
      body: Column(
        children: <Widget>[
          Image.network(
              "https://firebasestorage.googleapis.com/v0/b/libera-b72ea.appspot.com/o/books%2F1712298476555.jpg?alt=media&token=31ef49ba-4b6d-4b37-8848-5e088288aa98",
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage:
                      NetworkImage('https://example.com/user-icon.jpg'),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('ユーザーネーム: uiduid'),
                    Row(
                      children: [
                        Text('関西学院大学'),
                        SizedBox(width: 10),
                        Text('文学部'),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'キャリアで語る経営組織',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  '¥1,000',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('文学部'),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('三日前'),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        label: Text('チャットする'),
        icon: Icon(Icons.chat),
        backgroundColor: Colors.orange,
        shape: StadiumBorder(),
      ),
    );
  }
}