import 'package:resident/app_export.dart';

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.whiteA700,
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(
            Icons.alarm,
            size: 32,
          ),
          SizedBox(
            height: 10,
          ),
          Text("Coming soon...",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey200))
        ])));
  }
}
