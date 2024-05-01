import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final Function()? onPressed;

  const Button({
    Key? key,
    required this.text,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          foregroundColor: Colors.black,
          backgroundColor: Colors.orange,
        ),
        onPressed: onPressed,
        child: const Text("次へ"),
      ),
    );
  }
}
