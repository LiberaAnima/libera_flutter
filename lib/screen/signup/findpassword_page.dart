import 'package:flutter/material.dart';
import 'package:libera_flutter/components/button.dart';
import 'package:libera_flutter/services/auth/resetPassword.dart';

class FindPasswordPage extends StatelessWidget {
  FindPasswordPage({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {FocusScope.of(context).unfocus()},
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
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
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'メールアドレス',
                  ),
                ),
                const SizedBox(height: 15),
                SendButton(
                  text: '送信',
                  onPressed: () {
                    if (_emailController.text.isNotEmpty) {
                      resetPassword(_emailController.text);
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
