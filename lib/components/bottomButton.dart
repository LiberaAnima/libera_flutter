import 'package:flutter/material.dart';
import 'package:libera_flutter/screen/policy/privacypolicy_page.dart';
import 'package:libera_flutter/screen/policy/terms_of_service_page.dart';

class BottomButton extends StatelessWidget {
  const BottomButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Row(
          // 利用契約、プライバシーポリシー、Q&A　リンク

          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TermsOfServicePage()),
              ),
              child: const Text("利用契約"),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacyPolicyPage()),
              ),
              child: const Text("プライバシーポリシー"),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/'),
              child: const Text("Q&A"),
            ),
          ],
        ));
  }
}
