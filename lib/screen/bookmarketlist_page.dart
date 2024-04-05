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

  DropdownButton<String> _buildDropdownButoon() {
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
        children: <Widget>[_buildDropdownButoon(), Text("本のマーケット")],
      )),
      body: Center(
        child: Column(
          children: <Widget>[
            Text("本のマーケット一覧画面"),
          ],
        ),
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
