// ignore_for_file: must_be_immutable

import 'package:resident/app_export.dart';

class OnboardingSlide extends StatefulWidget {
  OnboardingSlide(
      {super.key,
      required this.title,
      required this.description,
      required this.image});
  String? title;
  String? description;
  String? image;

  @override
  State<OnboardingSlide> createState() => _OnboardingSlideState();
}

class _OnboardingSlideState extends State<OnboardingSlide> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: displaySize.height * .0,
          child: SizedBox(
            width: displaySize.width * .9,
            height: displaySize.height * .7,
            child: Image.asset(fit: BoxFit.contain, widget.image!),
          ),
        ),
        // Positioned(
        //   top: -displaySize.height * 3,
        //   child: Container(
        //     padding: EdgeInsets.symmetric(vertical: 20),
        //     width: displaySize.width,
        //     // height: 200,
        //     color: AppColors.whiteA700,
        //     child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.center,
        //         children: [
        //           Text('${widget.title!}\nEasily',
        //               textAlign: TextAlign.center,
        //               style: TextStyle(
        //                   fontSize: 24,
        //                   color: AppColors.black900,
        //                   fontWeight: FontWeight.w800))
        //         ]),
        //   ),
        // )
      ],
    );
  }
}
