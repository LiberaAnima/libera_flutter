import 'package:flutter/material.dart';
import 'package:libera_flutter/components/button.dart';

class FindPasswordPage extends StatelessWidget {
  const FindPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'パスワードを忘れた場合',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                '登録したメールアドレスを入力してください。',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 30),
              const TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'メールアドレス',
                ),
              ),
              const SizedBox(height: 15),
              Button(
                text: '送信',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
