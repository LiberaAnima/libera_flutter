import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MarketEditPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const MarketEditPage({Key? key, required this.data}) : super(key: key);

  @override
  _MarketEditPageState createState() => _MarketEditPageState();
}

class _MarketEditPageState extends State<MarketEditPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _authorController;
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.data['bookname']);
    _descriptionController =
        TextEditingController(text: widget.data['details'] ?? '');
    _priceController = TextEditingController(text: widget.data['price']);
    _authorController = TextEditingController(text: widget.data['bookauthor']);
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
                          labelText: '商品名',
                        ),
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _authorController,
                  decoration: const InputDecoration(
                    labelText: '著者名',
                  ),
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: '価格(円)',
                    hintText: '例) 1500',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
          final String title = _titleController.text;
          final String description = _descriptionController.text;
          final String price = _priceController.text;
          final String author = _authorController.text;

          await FirebaseFirestore.instance
              .collection('books')
              .doc(widget.data['documentId'])
              .update(
            {
              'bookname': title,
              'details': description,
              'price': price,
              'bookauthor': author,
            },
          );

          Navigator.pop(context, {
            'bookname': title,
            'details': description,
            'price': price,
            'bookauthor': author,
          });
          // 수정된 데이터를 이전 화면으로 전달합니다.
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
