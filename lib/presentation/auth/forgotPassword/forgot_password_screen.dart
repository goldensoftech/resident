import 'package:resident/app_export.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with ErrorSnackBar, FormInputFields {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Future<void>? _resetPassword;
  // Future<void> resetRequest(context)async{
  //   try{
  //     await AuthBackend().resetPassword(context, email:_emailController.text.toString());
  //   }on SocketException catch(_){
  //       sendErrorMessage(
  //         "Network failure", "Please check your internet connection", context);

  //   } on NoSuchMethodError catch(_){
  //         sendErrorMessage(
  //         "error", 'please check your credentials and try again.', context);

  //   }catch(e){

  //   }
  // }
  Future<void> resetRequest(context) async {
    await AuthBackend()
        .getOtpForPasswordReset(context, email: _emailController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
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
                  Text('Account Recovery',
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
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                      ],
                    ),
                  ),
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
                        backgroundColor: _emailController.text.isNotEmpty
                            ? AppColors.appGold
                            : AppColors.lightGrey,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))
                        //minimumSize: const Size.fromHeight(60)
                        ),
                    //onPressed: () => context.replace('/signup'),
                    onPressed: (_emailController.text.isNotEmpty)
                        ? () async {
                            if (!_formKey.currentState!.validate()) {
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //     const SnackBar(content: Text('Processing Data')));
                              return;
                            }
                            setState(() {
                              _resetPassword = resetRequest(context);
                            });
                            _resetPassword;
                            // navigatePush(context, const SignUpScreen());
                          }
                        : null,

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
                          color: (_emailController.text.isNotEmpty)
                              ? AppColors.whiteA700
                              : AppColors.baseBlack),
                    ),
                  ),
                ),
              ]),
        ),
        FutureBuilder(
            future: _resetPassword,
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
}
