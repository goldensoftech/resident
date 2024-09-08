import 'package:resident/app_export.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>
    with CustomAppBar, CustomWidgets, FormInputFields {


  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final bool _isHidden = true;
  bool passwordMatch = false;
  bool _isHiddenForPassword = true;
  late String _password;
  double _strength = 0;
  Future<dynamic>? _request;
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
    await AuthBackend().updatePassword(context,
      oldPassword:_oldPasswordController.text,
      newPassword:_newPasswordController.text
      );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Stack(
          children: [
            GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Scaffold(
                  backgroundColor: AppColors.whiteA700,
                  appBar: profileAppBar(title: "Account Profile"),
                  body: Form(
                    key: _formKey,
                    child: ListView(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 20),
                        children: [
                          TextFormField(
                            controller: _oldPasswordController,
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              setState(() {});
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter old password';
                              }
                              return null;
                            },
                            style: const TextStyle(height: 1),
                            cursorOpacityAnimates: true,
                            cursorWidth: 1,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.lightGrey,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 20),
                                //labelStyle: const TextStyle(color: Colors.black54),
                                hintText: 'Enter old password ',
                                hintStyle: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.grey200),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(8.r)),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: SvgPicture.asset(lockIcon,
                                    height: 14,
                                    width: 14,
                                    fit: BoxFit.scaleDown,
                                    color: AppColors.baseBlack),
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
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _newPasswordController,
                            onChanged: (value) {
                             // _checkPassword(value);
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter new password';
                              }
                              return null;
                            },
                            obscureText: _isHiddenForPassword,
                            style: const TextStyle(height: 1),
                            cursorOpacityAnimates: true,
                            cursorWidth: 1,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.lightGrey,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 12),
                                hintText: 'Enter new password',
                                hintStyle: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.grey200),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(8.r)),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide.none,
                                ),
                                prefixIcon: SvgPicture.asset(lockIcon,
                                    height: 14,
                                    width: 14,
                                    fit: BoxFit.scaleDown,
                                    color: AppColors.baseBlack),
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
                                      0,
                                      MediaQuery.of(context).size.height * 0.01,
                                      0,
                                      0),
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
                            height: 20.0,
                          ),
                         
                     
                        ]),
                  ),
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
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }

                          setState(() {
                            _request = changePwdRequest(context);
                          });
                          await _request;
                        },

                        child: Text(
                          'Continue',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.whiteA700),
                        ),
                      ),
                    ),
                  ]),
            ),
            FutureBuilder(
                future: _request,
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
        ));
  }
}
