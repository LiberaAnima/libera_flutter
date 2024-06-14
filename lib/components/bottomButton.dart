import 'dart:core';

import 'package:flutter/material.dart';
import 'package:libera_flutter/screen/policy/privacypolicy_page.dart';
import 'package:libera_flutter/screen/policy/terms_of_service_page.dart';
import 'package:libera_flutter/services/launchUrl_service.dart';

Uri url = Uri.parse("https://forms.gle/ucn4UxGWKyDYufJN8");

class BottomButton extends StatelessWidget {
  const BottomButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.infinity,
        child: Row(
          // 利用契約、プライバシーポリシー、お問い合わせ　リンク

          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TermsOfServicePage()),
              ),
              child: const Text("利用契約", style: TextStyle(fontSize: 12)),
            ),
            TextButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacyPolicyPage()),
              ),
              child: const Text("プライバシーポリシー", style: TextStyle(fontSize: 12)),
            ),
            TextButton(
              onPressed: () => launchURL(url),
              child: const Text("お問い合わせ", style: TextStyle(fontSize: 12)),
            ),
          ],
        ));
  }
}
