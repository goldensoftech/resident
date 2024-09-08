// ignore_for_file: must_be_immutable

import 'package:resident/app_export.dart';

class SignupVerificationScreen extends StatefulWidget {
  SignupVerificationScreen({super.key, required this.email});
  String email;
  @override
  State<SignupVerificationScreen> createState() =>
      _SignupVerificationScreenState();
}

class _SignupVerificationScreenState extends State<SignupVerificationScreen>
    with ErrorSnackBar {
  final TextEditingController _pinController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            backgroundColor: AppColors.whiteA700,
            body: SafeArea(
                child: ListView(
              shrinkWrap: true,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
              children: [
                SizedBox(
                  height: displaySize.height * 0.05,
                ),
                Text('Email Verification',
                    style: TextStyle(
                        fontSize: 18,
                        color: AppColors.black900,
                        fontWeight: FontWeight.w700)),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: displaySize.width * 0.5,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                          color: AppColors.grey5002,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Mulish',
                          fontSize: 14),
                      children: <TextSpan>[
                        const TextSpan(
                            text:
                                'A 6-digit confirmation code has been sent to  '),
                        TextSpan(
                            text: "${widget.email}",
                            style: TextStyle(
                                color: AppColors.baseBlack,
                                fontFamily: 'Mulish',
                                fontWeight: FontWeight.w600,
                                fontSize: 14),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                print('Terms of Service"');
                              }),
                        const TextSpan(
                            text:
                                ', Kindly input code to confirm your registration. ',
                            style: TextStyle(
                              fontFamily: 'Mulish',
                            )),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: TextButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(EdgeInsets.zero),
                          backgroundColor: MaterialStateProperty.all(
                            AppColors.whiteA700,
                          )),
                      onPressed: () {
                        navigateBack(context);
                      },
                      child: Text("Edit Email Address",
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.appGold,
                              fontWeight: FontWeight.w400))),
                ),
                SizedBox(
                  height: displaySize.height * 0.04,
                ),
                getCodeForm(),
                // SizedBox(
                //   height: displaySize.height * .05,
                // ),
                // Align(alignment: Alignment.bottomCenter,

                // )
              ],
            )),
            persistentFooterAlignment: AlignmentDirectional.bottomCenter,
            persistentFooterButtons: [
              SizedBox(
                width: displaySize.width * 0.7,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: _pinController.text.isNotEmpty
                          ? AppColors.appGold
                          : AppColors.lightGrey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))
                      //minimumSize: const Size.fromHeight(60)
                      ),
                  //onPressed: () => context.replace('/signup'),
                  onPressed:()=>
                      navigateRemoveAll(context, const AccountSuccessScreen()),

                  //  (_pinController.text.isNotEmpty)
                  //     ? () {
                  //       //  navigatePush(context, const AccountSuccessScreen());
                  //         // if (!_formKey.currentState!.validate()) {
                  //         //   // ScaffoldMessenger.of(context).showSnackBar(
                  //         //   //     const SnackBar(content: Text('Processing Data')));
                  //         //   return;
                  //         // }
                  //         // setState(() {
                  //         //   _login = loginRequest(context);
                  //         // });
                  //         // _login;
                  //         // navigatePush(context, const SignUpScreen());
                  //       }
                  //     : null,
                  child: Text(
                    'Continue',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: (_pinController.text.isNotEmpty)
                            ? AppColors.whiteA700
                            : AppColors.baseBlack),
                  ),
                ),
              ),
            ])
      ],
    );
  }

  OtpTimerButtonController redController = OtpTimerButtonController();
  Widget getCodeForm() {
    return Form(
      // key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          buildPinPut(),
          SizedBox(
            height: displaySize.height * .05,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outlined,
                color: AppColors.appGold,
                size: 12,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Text("Didn't receive code ?",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.grey5002)),
              ),
              OtpTimerButton(
                controller: redController,
                height: 40,
                onPressed: () {
                  redController.startTimer();
                },
                text: const Text('Resend code  ',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    )),
                buttonType: ButtonType.text_button,
                backgroundColor: AppColors.appGold,
                duration: 60,
              ),
            ],
          ),
          SizedBox(
            height: displaySize.height * .38,
          ),
        ],
      ),
    );
  }

  Widget buildPinPut() {
    final defaultPinTheme = PinTheme(
      width: 37,
      height: 55,
      textStyle: TextStyle(
          fontSize: 20.sp,
          color: const Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightGrey),
        borderRadius: BorderRadius.circular(8),
      ),
    );
    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.appGold),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration:
          defaultPinTheme.decoration!.copyWith(color: AppColors.whiteA700),
    );
    return Pinput(
      controller: _pinController,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      validator: (value) {
        if (value == null || value.isEmpty) return 'Please enter your code';
        return null;
      },
      length: 6,
      closeKeyboardWhenCompleted: true,
      isCursorAnimationEnabled: true,
      onCompleted: (pin) async {
        // setState(() {
        //   pinCode = pin;
        //   _sendCodeFuture = pinCodeAPI(context);
        // });

        // _sendCodeFuture;
      },
    );
  }
}
