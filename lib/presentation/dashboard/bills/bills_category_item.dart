import 'package:resident/app_export.dart';

class BillItem extends StatelessWidget {
  BillItem(
      {super.key,
      required this.logoUrl,
      this.isApplyColor,
      required this.pageToNavigate,
      required this.title});
  String logoUrl;
  Widget pageToNavigate;
  String title;
  bool? isApplyColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        FocusScope.of(context).unfocus();
        navigatePush(context, pageToNavigate);
        
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.baseWhite),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              logoUrl,
              height: 30,
              width: 30,
              color: isApplyColor != false ? AppColors.appGold : null,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              title,
              style: TextStyle(fontSize: 12.22, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
