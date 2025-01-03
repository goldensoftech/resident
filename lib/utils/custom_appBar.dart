import 'package:resident/app_export.dart';

mixin CustomWidgets<T extends StatefulWidget> on State<T> {
  Widget profileTile(
      {required String title,
      bool? isLogOut,
      bool? isVerification,
      required Widget pageToGo}) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {
        if (isVerification == true) {
          if (ResponseData.loginResponse!.user!.bvnStatus == false) {
            AuthBackend().bvnVerification(context);
            return;
          }
        } else {
          navigatePush(context, pageToGo);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: AppColors.lightGrey, borderRadius: BorderRadius.circular(5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 16,
                  color: isLogOut == true ? AppColors.red : AppColors.black900,
                  fontWeight: FontWeight.w400),
            ),
            Row(
              children: [
                isVerification == true &&
                        ResponseData.loginResponse!.user!.bvnStatus == false
                    ? Text(
                        "Not verified",
                        style: TextStyle(
                            color: AppColors.appGold,
                            fontSize: 12,
                            fontWeight: FontWeight.w400),
                      )
                    : const SizedBox.shrink(),
                const SizedBox(
                  width: 20,
                ),
                isLogOut != true
                    ? Icon(Icons.arrow_forward_ios_rounded,
                        size: 16, color: AppColors.black900)
                    : const SizedBox.shrink(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
mixin CustomAppBar<T extends StatefulWidget> on State<T> {
  AppBar defaultAppBar({String? title, double? height}) {
    return AppBar(
      elevation: 0,
      toolbarHeight: height,
      backgroundColor: AppColors.gold100,
      centerTitle: true,
      forceMaterialTransparency: false,
      scrolledUnderElevation: 0.0,
      foregroundColor: AppColors.gold100,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: AppColors.gold100,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      title: title != null
          ? Text(
              title ?? "",
              style: TextStyle(
                  fontSize: 18,
                  color: AppColors.baseBlack,
                  fontWeight: FontWeight.w700),
            )
          : SizedBox.shrink(),
    );
  }

  AppBar profileAppBar({String? title, Color? bgColor}) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: true,
      centerTitle: true,
      forceMaterialTransparency: false,

      backgroundColor: bgColor ?? AppColors.gold100,

      scrolledUnderElevation: 0.0,
      foregroundColor: bgColor ?? AppColors.gold100,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: bgColor ?? AppColors.gold100,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),

      //toolbarHeight: 80,
      title: Text(
        title ?? "",
        style: TextStyle(
            fontSize: 18,
            color: AppColors.baseBlack,
            fontWeight: FontWeight.w700),
      ),
      leadingWidth: 75,
      leading: GestureDetector(
        onTap: () => navigateBack(context),
        child: Container(
          margin: const EdgeInsets.only(right: 30, left: 20),
          //padding: EdgeInsets.all(1),
          decoration: BoxDecoration(
              color: Colors.transparent,
              border: Border.all(width: 2, color: AppColors.black900),
              shape: BoxShape.circle),
          child: Center(
            child: Icon(
              Icons.arrow_back,
              color: AppColors.black900,
              size: 14.0,
            ),
          ),
        ),
      ),
    );
  }

  AppBar customAppBar({
    String? title,
  }) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.whiteA700,
      foregroundColor: AppColors.whiteA700,
      toolbarHeight: 80,
      flexibleSpace: FractionallySizedBox(
        child: ListView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 10,
          ),
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () => navigateBack(context),
                  icon: Container(
                    margin: const EdgeInsets.only(right: 30),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: AppColors.appGold, shape: BoxShape.circle),
                    child: Center(
                      child: Icon(
                        Icons.arrow_back,
                        color: AppColors.whiteA700,
                        size: 18.0,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  decoration: BoxDecoration(
                      color: AppColors.appGold,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    title ?? "",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.whiteA700),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Divider(
              height: 1,
              thickness: .8,
              color: AppColors.grey200,
            )
          ],
        ),
      ),
    );
  }
}
