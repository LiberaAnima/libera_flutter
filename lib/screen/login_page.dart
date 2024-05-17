import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:libera_flutter/components/input_box.dart';

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
    return GestureDetector(
      onTap: () => {FocusScope.of(context).unfocus()},
      child: Scaffold(
        body: Center(
          key: _key,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
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
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/findpassword');
                        },
                        child: const Text("パスワードを忘れた場合"),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  loginButton(),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.white,
                        ),
                        onPressed: () =>
                            Navigator.pushNamed(context, '/signUp'),
                        child: Text("アカウントを作成する")),
                  ),
                  SizedBox(
                    height: 80,
                  ),
                  Row(
                    // 利用契約、プライバシーポリシー、Q&A　リンク

                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/'),
                        child: const Text("利用契約"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/'),
                        child: const Text("プライバシーポリシー"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/'),
                        child: const Text("Q&A"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox loginButton() {
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
                content: Text("ログインに失敗しました。もう一度お試しください。"),
              ),
            );
          }
        },
        child: const Text("ログイン"),
      ),
    );
  }
}
