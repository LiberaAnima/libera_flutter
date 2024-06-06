import 'package:flutter/material.dart';

class SendButton extends StatelessWidget {
  final String text;
  final Function()? onPressed;

  const SendButton({
    super.key,
    required this.text,
    this.onPressed,
  });

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
        child: Text(text),
      ),
    );
  }
}
