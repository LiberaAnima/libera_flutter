import 'package:flutter/cupertino.dart';
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
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        key: _key,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('assets/images/icon.png'),
                width: 200,
                height: 200,
              ),
              SizedBox(height: 30),
              emailInput(),
              const SizedBox(height: 15),
              passwordInput(),
              Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text("Forgot Password?"),
                  ),
                ],
              ),
              loginButton(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/signUp'),
                    child: const Text("Sign Up")),
              )
            ],
          ),
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
        prefixIcon: Icon(Icons.mail_outline),
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
      obscureText: _isObscure,
      controller: _passwordController,
      autofocus: true,
      validator: (val) {
        if (val!.isEmpty) {
          return "Please enter your password";
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock_outline),
        hintText: "Input your Password",
        labelText: "Password",
        suffixIcon: IconButton(
          icon: Icon(Icons.visibility_off),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        ),

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
