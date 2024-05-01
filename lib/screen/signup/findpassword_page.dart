import 'package:flutter/material.dart';

class FindPasswordPage extends StatelessWidget {
  const FindPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '비밀번호 찾기',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              Text(
                '가입 시 입력한 이메일을 입력해주세요.',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 30),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '이메일',
                ),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: null,
                child: Text('비밀번호 찾기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
