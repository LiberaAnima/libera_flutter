import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:libera_flutter/screen/signup2_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _key = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: Center(
        child: Form(
          key: _key,
          child: Column(
            children: [
              emailInput(),
              const SizedBox(height: 15),
              passwordInput(),
              const SizedBox(height: 15),
              signUpButton(),
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

  ElevatedButton signUpButton() {
    return ElevatedButton(
      onPressed: () async {
        if (_key.currentState!.validate()) {
          try {
            final credential = await _auth.createUserWithEmailAndPassword(
              email: _emailController.text,
              password: _passwordController.text,
            );

            final user = credential.user;
            print(user?.uid);
            // await FirebaseFirestore.instance
            //     .collection('users')
            //     .doc(user?.uid)
            //     .set(
            //   {
            //     'email': _emailController.text,
            //     'uid': user?.uid,
            //     // 다른 필드를 추가하세요.
            //   },
            // );

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Signup2Page(userCredential: credential),
              ),
            );

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Sign Up Success"),
              ),
            );
          } on FirebaseAuthException catch (error) {
            if (error.code == 'email-already-in-use') {
              //
            }
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(error.message ?? "Authentication Failed"),
              ),
            );
          }
        }
      },
      child: const Text("Sign Up"),
    );
  }
}
