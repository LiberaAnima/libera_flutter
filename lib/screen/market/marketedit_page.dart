import 'package:flutter/material.dart';

class MarketEditPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const MarketEditPage({Key? key, required this.data}) : super(key: key);

  @override
  _MarketEditPageState createState() => _MarketEditPageState();
}

class _MarketEditPageState extends State<MarketEditPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.data['bookname']);
    _descriptionController =
        TextEditingController(text: widget.data['details'] ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('修正'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Title',
                        ),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                  ),
                  maxLines: 6,
                ),
              ],
            ),
            // 여기에 추가적인 필드를 추가합니다.
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // 텍스트 필드에서 텍스트를 가져옵니다.

          // 수정된 데이터를 이전 화면으로 전달합니다.
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
