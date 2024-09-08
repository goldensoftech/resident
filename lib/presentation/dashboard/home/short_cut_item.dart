import 'package:flutter/material.dart';
import 'package:resident/app_export.dart';

class ShortCutItem extends StatelessWidget {
  ShortCutItem(
      {super.key,
      required this.logoUrl,
      required this.pageToNavigate,
      required this.gridColor,
      this.isIconBlack,
      required this.title});
  String logoUrl;
  Widget pageToNavigate;
  String title;
  bool? isIconBlack;
  Color gridColor;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => navigatePush(context, pageToNavigate),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  color: gridColor, borderRadius: BorderRadius.circular(9.78)),
              child: SvgPicture.asset(
                logoUrl,
                color: isIconBlack == null || isIconBlack == true
                    ? AppColors.baseBlack
                    : AppColors.whiteA700,
              )),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
          )
        ],
      ),
    );
  }
}
