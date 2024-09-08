import 'package:resident/app_export.dart';

class EmptyListWidget extends StatelessWidget {
  const EmptyListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
     // alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(sendIcon,
              width: displaySize.width * .4,
              height: displaySize.height * .2,
              color: AppColors.grey500,
              fit: BoxFit.contain),
          SizedBox(height: 20),
          Text(
            "No data found",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.grey500),
          )
        ],
      ),
    );
  }
}
