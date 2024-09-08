import 'package:resident/app_export.dart';

class ChangePasswordScreen extends StatefulWidget {
  ChangePasswordScreen({super.key, required this.email, required this.otp});
  String otp;
  String email;
  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen>
    with FormInputFields {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final bool _isHidden = true;
  bool passwordMatch = false;
  bool _isHiddenForPassword = true;
  late String _password;
  double _strength = 0;
  Future<dynamic>? _changePwd;
  String notSuccessfullMessage = '';

  void _checkPassword(String value) {
    _password = value.trim();

    if (_password.isEmpty) {
      setState(() {
        _strength = 0;
      });
    } else if (_password.length < 6) {
      setState(() {
        _strength = 1 / 4;
      });
    } else if (_password.length < 8) {
      setState(() {
        _strength = 2 / 4;
      });
    } else {
      if (letterReg.hasMatch(_password) &&
          numReg.hasMatch(_password) &&
          _password.contains(regExp)) {
        setState(() {
          _strength = 1;
        });
      }
    }
  }

  void _togglePasswordView() {
    setState(() {
      _isHiddenForPassword = !_isHiddenForPassword;
    });
  }

  void callTheErrorText(error) {
    setState(() {
      notSuccessfullMessage = error;
    });
  }

  Future<void> changePwdRequest(context) async {
    await AuthBackend().resetPassword(
        token: widget.otp,
        context,
        email: widget.email,
        password: _passwordController.text.trim());
  }

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
              body: ListView(
                padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
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
                  changePasswordForm()
                ],
              ),
              persistentFooterAlignment: AlignmentDirectional.bottomCenter,
              persistentFooterButtons: [
                SizedBox(
                  width: displaySize.width * 0.7,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: _passwordController.text.isNotEmpty
                            ? AppColors.appGold
                            : AppColors.lightGrey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))
                        //minimumSize: const Size.fromHeight(60)
                        ),
                    onPressed: (_passwordController.text.isNotEmpty &&
                            _confirmPasswordController.text.isNotEmpty)
                        ? () {
                            if (!_formKey.currentState!.validate()) {
                              return;
                            }
                            setState(() {
                              _changePwd = changePwdRequest(context);
                            });
                            _changePwd;
                          }
                        : null,
                    child: Text(
                      'Continue',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: (_passwordController.text.isNotEmpty)
                              ? AppColors.whiteA700
                              : AppColors.baseBlack),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        FutureBuilder(
            future: _changePwd,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return const SizedBox(
                    height: 0,
                    width: 0,
                  );
                case ConnectionState.waiting:
                  return const LoadingPageGif();
                case ConnectionState.active:
                  debugPrint("active");
                  return const Text('active');
                case ConnectionState.done:
                  return const SizedBox(
                    height: 0,
                    width: 0,
                  );
              }
            })
      ],
    );
  }

  Widget changePasswordForm() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              'New Password',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkGrey),
            ),
          ),
          TextFormField(
            controller: _passwordController,
            onChanged: (value) {
              _checkPassword(value);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please create a password';
              }
              return null;
            },
            obscureText: _isHiddenForPassword,
            style: const TextStyle(height: 1),
            cursorOpacityAnimates: true,
            cursorWidth: 1,
            cursorColor: Colors.black,
            decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                hintText: 'Enter New Password',
                hintStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey200),
                border: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 1.w, color: AppColors.formGrey),
                    borderRadius: BorderRadius.circular(8.r)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: AppColors.appGold),
                ),
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
          _strength == 0
              ? SizedBox.shrink()
              : Padding(
                  padding: EdgeInsets.fromLTRB(
                      0, MediaQuery.of(context).size.height * 0.01, 0, 0),
                  child: LinearProgressIndicator(
                    backgroundColor: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(10),
                    value: _strength,
                    color: _strength <= 1 / 4
                        ? Colors.red
                        : _strength == 2 / 4
                            ? Colors.yellow
                            : _strength == 3 / 4
                                ? Colors.blue
                                : Colors.green,
                    minHeight: 5,
                  ),
                ),
          const SizedBox(
            height: 10.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Text(
              'Confirm Password',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.darkGrey),
            ),
          ),
          TextFormField(
              controller: _confirmPasswordController,
              onChanged: (value) {
                if (_passwordController.text.length == value.length) {
                  if (_passwordController.text == value) {
                    setState(() {
                      passwordMatch = false;
                    });
                  } else {
                    setState(() {
                      passwordMatch = true;
                    });
                  }
                } else if (_passwordController.text.length != value.length) {
                  setState(() {
                    passwordMatch = true;
                  });
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please retype your password';
                }
                return null;
              },
              obscureText: _isHiddenForPassword,
              style: const TextStyle(height: 1),
              cursorOpacityAnimates: true,
              cursorWidth: 1,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                hintText: 'Confirm New Password',
                hintStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.grey200),
                border: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 1.w, color: AppColors.lightGrey),
                    borderRadius: BorderRadius.circular(8.r)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide(color: AppColors.appGold),
                ),
              )),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * 0.0009),
            child: Center(
              child: notSuccessfullMessage.isEmpty
                  ? null
                  : Text(
                      notSuccessfullMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.00),
              child: passwordMatch
                  ? Text(
                      'Password does not match',
                      style: TextStyle(color: Colors.red, fontSize: 11.sp),
                    )
                  : null),
        ],
      ),
    );
  }
}
