import 'dart:core';

import 'package:flutter/material.dart';
import 'package:libera_flutter/screen/policy/privacypolicy_page.dart';
import 'package:libera_flutter/screen/policy/terms_of_service_page.dart';
import 'package:libera_flutter/services/launchUrl_service.dart';

Uri url = Uri.parse("https://forms.gle/ucn4UxGWKyDYufJN8");

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
              onPressed: () => launchURL(url),
              child: const Text("Q&A"),
            ),
          ],
        ));
  }
}
