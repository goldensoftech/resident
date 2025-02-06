
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:resident/app_export.dart';
import 'package:delightful_toast/delight_toast.dart';

mixin ErrorSnackBar {
  void sendErrorMessage(String title, String msg, context,
      {bool? up, bool? isSuccess}) {
    DelightToastBar(
        autoDismiss: true,
        position: DelightSnackbarPosition.top,
        snackbarDuration: const Duration(seconds: 5),
        builder: (context) => Card(
            color: Colors.white,
            elevation: 1,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            //shadowColor: Colors.black.withOpacity(0.05),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 5,
                    height: 60,
                    margin: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                        color: isSuccess == true
                            ? Colors.green.shade400
                            : Colors.red.shade400,
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(15),
                            topLeft: Radius.circular(15))),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: displaySize.width * .5,
                        child: Text(
                          title,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.baseBlack),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        width: displaySize.width * .8,
                        child: Text(
                          msg,
                          style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w400,
                              color: AppColors.grey500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ))).show(context);
  
  }

  void fieldValidationErrorMessage(String msg, BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}