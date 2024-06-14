import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostEditPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const PostEditPage({super.key, required this.data});

  @override
  _PostEditPageState createState() => _PostEditPageState();
}

class _PostEditPageState extends State<PostEditPage> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.data['title']);
    _descriptionController =
        TextEditingController(text: widget.data['post_message'] ?? '');
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.data);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Post'),
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
          String title = _titleController.text;
          String postMessage = _descriptionController.text;

          // Firebase에 데이터를 업데이트합니다.
          await FirebaseFirestore.instance
              .collection('posts')
              .doc(widget.data['documentID'])
              .update({
            'title': title,
            'post_message': postMessage,
          });

          // 수정된 데이터를 이전 화면으로 전달합니다.
          Navigator.pop(context, {
            'title': title,
            'post_message': postMessage,
          });
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
