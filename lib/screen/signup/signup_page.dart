import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:libera_flutter/components/input_box.dart';
import 'package:libera_flutter/screen/signup/signup2_page.dart';

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
    return GestureDetector(
      onTap: () => {FocusScope.of(context).unfocus()},
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Form(
                  key: _key,
                  child: Column(
                    children: [
                      const Image(
                        image: AssetImage('assets/images/icon.png'),
                        width: 200,
                        height: 200,
                      ),
                      const SizedBox(height: 30),
                      EmailInput(
                        controller: _emailController,
                      ),
                      const SizedBox(height: 15),
                      PasswordInput(
                        controller: _passwordController,
                      ),
                      const SizedBox(height: 10),
                      signUpButton(),
                      const SizedBox(
                        height: 80,
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox signUpButton() {
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
        onPressed: () async {
          if (_key.currentState!.validate()) {
            try {
              final credential = await _auth.createUserWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text,
              );

              final user = credential.user;
              print(user?.uid);

              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      Signup2Page(userCredential: credential),
                  transitionDuration: Duration(seconds: 0),
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
        child: const Text("次へ"),
      ),
    );
  }
}
