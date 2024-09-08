import 'package:resident/app_export.dart';

class WebScreen extends StatefulWidget {
  WebScreen({super.key, required this.webTitle, required this.controller});
  String webTitle;

  WebViewController controller;

  @override
  State<WebScreen> createState() => _WebScreenState();
}

class _WebScreenState extends State<WebScreen>
    with CustomAlerts, CustomAppBar, ErrorSnackBar {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Scaffold(
          appBar: profileAppBar(title: widget.webTitle),
          body: WebViewWidget(controller: widget.controller),
        ));
  }
}
