import 'package:flutter/material.dart';

class InternPage extends StatelessWidget {
  const InternPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("インターン"),
      ),
      body: const Center(
        child: Text(
          '準備中です',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
