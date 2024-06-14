// input_widgets.dart
import 'package:flutter/material.dart';

class EmailInput extends StatelessWidget {
  final TextEditingController controller;

  const EmailInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autofocus: true,
      validator: (val) {
        if (val!.isEmpty) {
          return "メールアドレスを入力してください";
        } else {
          return null;
        }
      },
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.mail_outline),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        hintText: "メールアドレスを入力してください",
        labelText: "メールアドレス",
      ),
    );
  }
}

class PasswordInput extends StatefulWidget {
  final TextEditingController controller;

  PasswordInput({required this.controller});

  @override
  _PasswordInputState createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _isObscure,
      controller: widget.controller,
      autofocus: true,
      validator: (val) {
        if (val!.isEmpty) {
          return "パスワードを入力してください";
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock_outline),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        hintText: "パスワードを入力してください",
        labelText: "パスワード",
        suffixIcon: IconButton(
          icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        ),
      ),
    );
  }
}
