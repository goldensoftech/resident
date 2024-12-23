import 'dart:io';

import 'package:resident/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin, ErrorSnackBar {
  late SharedPreferences sharedPreferences;
  late AnimationController _loadingPage;
  @override
  void initState() {
    _loadingPage = AnimationController(vsync: this);

    super.initState();
    Future.delayed(Duration.zero, () {
      checkUser(context);
    });
  }

  checkUser(context) async {
    //await AuthBackend().verifyAppVersion(context);
    // await AppVersionUpdate.checkForUpdates(
    //         appleId: appleId, playStoreId: playStoreId)
    //     .then((data) async {
    //   print(data.storeUrl);
    //   print(data.storeVersion);
    //   if (data.canUpdate! || !data.canUpdate!) {
    //     AppVersionUpdate.showAlertUpdate(
    //         mandatory: true, appVersionResult: data, context: context);
    //   }
    // });
    initData().then((onValue) async {
      //navigateReplace(context, const OnboardingScreen());
      try {
        displaySize = MediaQuery.of(context).size;

        sharedPreferences = await SharedPreferences.getInstance();
        DummyData.firstTimeOnApp = sharedPreferences.getBool("firstTimeOnApp");
        logger.t("First time on App? : ${DummyData.firstTimeOnApp}");
        if (DummyData.firstTimeOnApp == true ||
            DummyData.firstTimeOnApp == null) {
          await AuthBackend().setDefaultUser();
          // ResponseData.txHistory = await TransactionBackend()
          //     .getTransactionHistory(context,
          //         startDate: DateTime.now().subtract(const Duration(days: 60)),
          //         endDate: DateTime.now());
          navigateReplace(context, const OnboardingScreen());
        } else {
          //  await AuthBackend().getAuthToken(context);
          logger.i("Check User");
          DummyData.emailAddress = sharedPreferences.getString("Email");
          DummyData.password = sharedPreferences.getString("Password");
          if ((DummyData.emailAddress != null &&
                  DummyData.emailAddress!.isNotEmpty) &&
              (DummyData.password != null && DummyData.password!.isNotEmpty)) {
            submitLogin();
          } else {
            await AuthBackend().setDefaultUser();
            navigateReplace(context, const Dashboard());
            logger.e("error");
          }
        }
      } on TimeoutException catch (_) {
        sendErrorMessage("Network failure",
            "Please check your internet connection", context);
        //navigateReplace(context, const Dashboard());
      } on NoSuchMethodError catch (_) {
        sendErrorMessage(
            "error", 'please check your credentials and try again.', context);
      } catch (e) {
        logger.e(e);
        sendErrorMessage("Network failure",
            "Please check your internet connection", context);
        //navigateReplace(context, const Dashboard());
      }
    });
  }

  Future initData() async {
    //displaySize = MediaQuery.of(context).size;
    await Future.delayed(const Duration(seconds: 5));
  }

  submitLogin() async {
    logger.i("Call Login API");
    try {
      await AuthBackend().signInAuto(context,
          email: DummyData.emailAddress.toString(),
          pwd: DummyData.password.toString());
    } catch (e) {
      logger.e(e);
      //  navigateReplace(context, const LoginPage());
    }
  }

  @override
  @protected
  @mustCallSuper
  void dispose() {
    _loadingPage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
          backgroundColor: AppColors.whiteA700,
          body: Center(
              child: Image.asset(
                  repeat: ImageRepeat.noRepeat,
                  'assets/images/logoAnim.gif',
                  // width: MediaQuery.sizeOf(context).width * .8,
                  // height: MediaQuery.sizeOf(context).height * .3,
                  scale: 0.1,
                  fit: BoxFit.contain)),
          persistentFooterAlignment: AlignmentDirectional.bottomCenter,
          persistentFooterButtons: [
            SizedBox(
                width: MediaQuery.sizeOf(context).width * .8,
                child: Text("App Version 1.2",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: AppColors.black900),
                    textAlign: TextAlign.center))

            // Positioned(
            //     bottom: 30,
            //     child: Padding(
            //         padding: const EdgeInsets.only(bottom: 10),
            //         child: SizedBox(
            //             width: displaySize.width * .8,
            //             child: Text(
            //                 "Lorem ipsum dolor sit amet consectetur. Cursus duis lectus arcu sed nec convallis faucibus.",
            //                 style: TextStyle(
            //                     fontWeight: FontWeight.w400,
            //                     fontSize: 12,
            //                     color: AppColors.black900),
            //                 textAlign: TextAlign.center))))
          ]),
    );
  }
}
