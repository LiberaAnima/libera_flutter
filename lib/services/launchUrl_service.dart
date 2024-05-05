import 'package:url_launcher/url_launcher.dart';

Future<void> launchURL(Uri url) async {
  if (!await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  )) {
    await launchUrl(url);
  } else {
    print('Could not launch it.'); //デバッグ用、外部URLに飛ばせるように設定する必要有
  }
}
