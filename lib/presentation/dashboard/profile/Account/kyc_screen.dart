import 'package:resident/app_export.dart';

class KycScreen extends StatefulWidget {
   KycScreen({super.key});

  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen>
    with CustomAppBar, CustomWidgets, CustomAlerts {
  bool _isHiddenForPassword = false;
  void _togglePasswordView() {
    setState(() {
      _isHiddenForPassword = !_isHiddenForPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: AppColors.whiteA700,
          appBar: profileAppBar(title: ""),
          body: ListView(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
              children: [
                SizedBox(
                  width: displaySize.width * .5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                              color: AppColors.black900,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Mulish',
                              fontSize: 16),
                          children: <TextSpan>[
                            TextSpan(text: "Let's get to, "),
                            TextSpan(
                              text: "know you better!",
                              style: TextStyle(
                                  color: AppColors.appGold,
                                  fontFamily: 'Mulish',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16),
                              // recognizer: TapGestureRecognizer()
                              //   ..onTap = () {
                              //     print('Terms of Service"');
                              // }
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Please provide your BVN details to continue registration',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: AppColors.black900),
                      )
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.only(top: 30, bottom: 40, left: 40, right: 40),
                  margin: EdgeInsets.only(top: 50, bottom: 20),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: AppColors.appGold)),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    style: const TextStyle(height: 1),
                    cursorOpacityAnimates: true,
                    cursorWidth: 1,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                        labelText: "Input BVN",
                        labelStyle: TextStyle(color: AppColors.grey500),
                        suffixIcon: GestureDetector(
                          onTap: _togglePasswordView,
                          child: Icon(
                            _isHiddenForPassword
                                ? Icons.visibility
                                : Icons.visibility_off_outlined,
                            color: AppColors.iconGrey,
                            size: 18,
                          ),
                        )),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  margin: EdgeInsets.only(
                    top: 10,
                  ),
                  decoration: BoxDecoration(
                      color: AppColors.gold100,
                      border: Border.all(width: 1, color: AppColors.appGold)),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                          color: AppColors.black900,
                          fontWeight: FontWeight.w400,
                          fontFamily: 'Mulish',
                          fontSize: 14),
                      children: <TextSpan>[
                        TextSpan(text: "Dial "),
                        TextSpan(
                          text: "\"*565*0#\" ",
                          style: TextStyle(
                              color: AppColors.appGold,
                              fontFamily: 'Mulish',
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                          // recognizer: TapGestureRecognizer()
                          //   ..onTap = () {
                          //     print('Terms of Service"');
                          // }
                        ),
                        TextSpan(
                            text:
                                "using your registered phone number to get your BVN. It attracts a service charge of N20."),
                      ],
                    ),
                  ),
                )
              ]),
          persistentFooterAlignment: AlignmentDirectional.bottomCenter,
          persistentFooterButtons: [
            SizedBox(
              width: displaySize.width * 0.7,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: AppColors.appGold,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))
                    //minimumSize: const Size.fromHeight(60)
                    ),
                //onPressed: () => context.replace('/signup'),
                onPressed: () => showKycAlert(context, isSuccess: false),

                child: Text('Continue',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.whiteA700)),
              ),
            ),
          ],
        ));
  }
}
