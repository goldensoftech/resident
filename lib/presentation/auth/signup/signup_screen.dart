import 'package:resident/app_export.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with ErrorSnackBar, FormInputFields {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();

  final TextEditingController _lastNameController = TextEditingController();

  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _bvnController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final bool _isHidden = true;
  bool passwordMatch = false;
  bool _isHiddenForPassword = true;
  late String _password;
  double _strength = 0;
  Future<dynamic>? _register;
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

  Future<void> registerRequest(context) async {
    await AuthBackend().signUp(context,
        email: _emailController.text.trim(),
        pwd: _passwordController.text.trim(),
        bvn: _bvnController.text.trim(),
        phoneNumber: _phoneNumberController.text.trim(),
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Stack(children: [
        GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: AppColors.whiteA700,
            body: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                children: [
                  SizedBox(
                    height: displaySize.height * 0.05,
                  ),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () =>
                                navigateReplace(context, const LoginScreen()),
                            child: Container(
                              // alignment: Alignment.topRight,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 8),
                              decoration: BoxDecoration(
                                  color: AppColors.lightGrey,
                                  borderRadius: BorderRadius.circular(12)),
                              child: Text('Sign in',
                                  style: TextStyle(
                                    color: AppColors.baseBlack,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  )),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: displaySize.height * 0.02,
                        ),
                        Text('Setup your Account',
                            style: TextStyle(
                                fontSize: 18,
                                color: AppColors.black900,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                            width: displaySize.width * 0.6,
                            child: Text(
                                'Please enter the following information to complete account setup',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.darkGrey,
                                    fontWeight: FontWeight.w400))),
                        SizedBox(
                          height: displaySize.height * 0.02,
                        ),
                        signUpForm(),
                      ]),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 50),
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                            color: AppColors.grey5002,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Mulish',
                            fontSize: 14),
                        children: <TextSpan>[
                          const TextSpan(
                              text: 'By pressing continue, you agree to '),
                          TextSpan(
                              text: "Resident's Terms of Service",
                              style: TextStyle(
                                  color: AppColors.appGold,
                                  fontFamily: 'Mulish',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  navigatePush(
                                      context, const TermsAndCondition());
                                }),
                          const TextSpan(
                              text: ' and ',
                              style: TextStyle(
                                fontFamily: 'Mulish',
                              )),
                          TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                  fontFamily: 'Mulish',
                                  color: AppColors.appGold,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  AuthBackend().toPrivacyPolicy(context);
                                  // navigatePush(
                                  //     context, const PrivacyPolicyScreen());
                                }),
                        ],
                      ),
                    ),
                  ),
                ]),
            persistentFooterAlignment: AlignmentDirectional.bottomCenter,
            persistentFooterButtons: [
              SizedBox(
                width: displaySize.width * 0.7,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: _emailController.text.isNotEmpty &&
                              _passwordController.text.isNotEmpty
                          ? AppColors.appGold
                          : AppColors.lightGrey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))
                      //minimumSize: const Size.fromHeight(60)
                      ),
                  //onPressed: () => context.replace('/signup'),
                  onPressed: (_emailController.text.isNotEmpty &&
                          _passwordController.text.isNotEmpty)
                      ? () async {
                          if (!_formKey.currentState!.validate()) {
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //     const SnackBar(content: Text('Processing Data')));
                            return;
                          }
                          setState(() {
                            _register = registerRequest(context);
                          });
                          await _register;
                        }
                      : null,
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: (_emailController.text.isNotEmpty &&
                                _passwordController.text.isNotEmpty &&
                                _passwordController.text.isNotEmpty &&
                                _confirmPasswordController.text.isNotEmpty)
                            ? AppColors.whiteA700
                            : AppColors.baseBlack),
                  ),
                ),
              ),
            ],
          ),
        ),
        FutureBuilder(
            future: _register,
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
      ]),
    );
  }

  Widget signUpForm() {
    return Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Text(
                'First Name',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.darkGrey),
              ),
            ),
            textInput(_firstNameController, "First Name", 1, "First Name", 1,
                TextInputType.text, true),
          ]),
          const SizedBox(
            height: 10.0,
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Text(
                'Last Name',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.darkGrey),
              ),
            ),
            textInput(_lastNameController, "Last Name", 1, "Last Name", 1,
                TextInputType.text, true),
          ]),
          const SizedBox(
            height: 10.0,
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Text(
                'Email Address',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.darkGrey),
              ),
            ),
            email(_emailController, false),
          ]),
          const SizedBox(
            height: 10.0,
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Text(
                'Phone Number',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.darkGrey),
              ),
            ),
            TextFormField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {});
              },
              validator: (value) {
                if (value == null || value.length < 10 || value.length > 11) {
                  return 'Please enter a valid phone address';
                }
                return null;
              },
              style: const TextStyle(height: 1),
              cursorOpacityAnimates: true,
              cursorWidth: 1,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  //labelStyle: const TextStyle(color: Colors.black54),
                  hintText: 'Enter phone number ',
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
                  )),
            ),
          ]),
          const SizedBox(
            height: 10.0,
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Text(
                'Bvn Number',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: AppColors.darkGrey),
              ),
            ),
             TextFormField(
              controller: _bvnController,
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {});
              },
              validator: (value) {
                if (value == null || value.length != 11) {
                  return 'Please enter a valid BVN';
                }
                return null;
              },
              style: const TextStyle(height: 1),
              cursorOpacityAnimates: true,
              cursorWidth: 1,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                  //labelStyle: const TextStyle(color: Colors.black54),
                  hintText: 'Enter Bank Verification Number (BVN) ',
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
                  )),
            ),
            // textInput(_bvnController, "Bvn Number", 1, "Bvn Number", 1,
            //     TextInputType.number, true),
          ]),
          const SizedBox(
            height: 10.0,
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Text(
                'Password',
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
                  hintText: 'Password',
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
                ? const SizedBox.shrink()
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
          ]),
          const SizedBox(
            height: 10.0,
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                obscureText: _isHidden,
                style: const TextStyle(height: 1),
                cursorOpacityAnimates: true,
                cursorWidth: 1,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  hintText: 'Confirm Password',
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
          ]),
        ]));
  }
}
