import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Center(
        key: _key,
        child: Column(
          children: [
            emailInput(),
            passwordInput(),
            loginButton(),
          ],
        ),
      ),
    );
  }

  TextFormField emailInput() {
    return TextFormField(
      controller: _emailController,
      autofocus: true,
      validator: (val) {
        if (val!.isEmpty) {
          return "Please enter your email";
        } else {
          return null;
        }
      },
      decoration: const InputDecoration(
        hintText: "Input your Email Address",
        labelText: "Email Address",
        // labelStyle: TextStyle(
        //   fontSize: 18,
        //   fontWeight: FontWeight.bold,
        // ),
      ),
    );
  }

  TextFormField passwordInput() {
    return TextFormField(
      controller: _passwordController,
      autofocus: true,
      validator: (val) {
        if (val!.isEmpty) {
          return "Please enter your password";
        } else {
          return null;
        }
      },
      decoration: const InputDecoration(
        hintText: "Input your Password",
        labelText: "Password",
        // labelStyle: TextStyle(
        //   fontSize: 18,
        //   fontWeight: FontWeight.bold,
        // ),
      ),
    );
  }

  ElevatedButton loginButton() {
    return ElevatedButton(
      onPressed: () async {
        try {
          await _auth
              .signInWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text,
              )
              .then((_) => Navigator.pushNamed(context, '/'));
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found') {
            debugPrint('No user found for that email');
          } else if (e.code == 'wrong-password') {
            debugPrint('Wrong password provided for that user');
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("test"),
            ),
          );
        }
      },
      child: const Text("Login"),
    );
  }
}
