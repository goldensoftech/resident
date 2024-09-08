// ignore_for_file: must_be_immutable

import 'package:resident/app_export.dart';

class ForgotPwdEmailVerificationScreen extends StatefulWidget {
  ForgotPwdEmailVerificationScreen({super.key, required this.email});
  String email;
  @override
  State<ForgotPwdEmailVerificationScreen> createState() =>
      _ForgotPwdEmailVerificationScreenState();
}

class _ForgotPwdEmailVerificationScreenState
    extends State<ForgotPwdEmailVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pinController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          top: false,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: AppColors.whiteA700,
              body: SafeArea(
                  child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
                children: [
                  SizedBox(
                    height: displaySize.height * 0.05,
                  ),
                  Text('Enter OTP',
                      style: TextStyle(
                          fontSize: 18,
                          color: AppColors.black900,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(
                    height: 10,
                  ),
                  Text("Let's get you back onboard!",
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.grey500,
                          fontWeight: FontWeight.w400)),
                  SizedBox(
                    height: displaySize.height * 0.1,
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
                          //navigateBack(context);
                        },
                        child: Text("Code has been sent to ${widget.email}",
                            style: TextStyle(
                                fontSize: 12,
                                color: AppColors.appGold,
                                fontWeight: FontWeight.w400))),
                  ),
                  getCodeForm(),
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
                    onPressed: (_pinController.text.isNotEmpty)
                        ? () async {
                            navigateReplace(
                                context,
                                ChangePasswordScreen(
                                  otp: _pinController.text,
                                  email: widget.email,
                                ));
                          }
                        : null,
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
              ],
            ),
          ),
        ),
      ],
    );
  }

  OtpTimerButtonController redController = OtpTimerButtonController();
  Widget getCodeForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          buildPinPut(),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
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
                onPressed: () async {
                  await AuthBackend()
                      .getOtpForPasswordReset(context, email: widget.email)
                      .then((value) {
                    redController.startTimer();
                  });
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
        setState(() {
          _pinController.text = pin;
        });
        // _sendCodeFuture;
      },
    );
  }
}
