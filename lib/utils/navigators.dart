import 'package:flutter/cupertino.dart';
import 'package:resident/app_export.dart';

///This method ensures navigation and kills the previous activity
navigateReplace(BuildContext context, Widget widget) {
  Navigator.pushReplacement(
      context, CupertinoPageRoute(builder: (context) => widget));
}

navigateRemoveAll(BuildContext context, Widget widget) {
  Navigator.pushAndRemoveUntil(context,
      CupertinoPageRoute(builder: (context) => widget), (route) => false);
}

///This method ensures navigation and does not kill the previous activity
navigatePush(BuildContext context, Widget widget) {
  Navigator.push(context, CupertinoPageRoute(builder: (context) => widget));
}

///This method backward navigation
navigateBack(BuildContext context) {
  Navigator.pop(context);
}

launchInURL(Uri testUrl) async {
  if (await canLaunchUrl(testUrl)) {
    await launchUrl(testUrl, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $testUrl';
  }
}
