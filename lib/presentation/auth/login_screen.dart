
import 'package:resident/app_export.dart';
import 'package:resident/repository/model/user_response_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with ErrorSnackBar, FormInputFields, TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _loadingPage;
  final TextEditingController _emailController =
      TextEditingController(text: DummyData.emailAddress);
  final TextEditingController _passwordController = TextEditingController();
  bool _isHidden = true;
  bool showMessageError = false;
  User user = User();
  Future<void>? _login;
  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  void initState() {
    super.initState();
    // _emailController.text = "Femi@gmail.com";
    // _passwordController.text = "123456";
    _loadingPage = AnimationController(vsync: this);
  }

  @override
  @protected
  @mustCallSuper
  void dispose() {
    _loadingPage.dispose();
    super.dispose();
  }

  Future<void> loginRequest(context) async {
    FocusScope.of(context).unfocus();
    await AuthBackend().login(context,
        email: _emailController.text, pwd: _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.whiteA700,
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return SafeArea(
      top: false,
      child: Stack(children: [
        GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: AppColors.whiteA700,
            body: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
                children: [
                  SizedBox(
                    height: displaySize.height * 0.05,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () =>
                          navigateReplace(context, const SignUpScreen()),
                      child: Container(
                        // alignment: Alignment.topRight,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        decoration: BoxDecoration(
                            color: AppColors.lightGrey,
                            borderRadius: BorderRadius.circular(12)),
                        child: Text('Sign up',
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
                  Text('Sign in',
                      style: TextStyle(
                          fontSize: 18,
                          color: AppColors.black900,
                          fontWeight: FontWeight.w700)),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Welcome back',
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.darkGrey,
                          fontWeight: FontWeight.w400)),
                  SizedBox(
                    height: displaySize.height * 0.1,
                  ),
                  loginForm(),
                ]),
          ),
        ),
        FutureBuilder(
            future: _login,
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

  Widget loginForm() {
    return Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
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
          const SizedBox(
            height: 20.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                  setState(() {});
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
                style: const TextStyle(height: 1),
                cursorOpacityAnimates: true,
                cursorWidth: 1,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                    //labelStyle: const TextStyle(color: Colors.black54),
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
                        _isHidden
                            ? Icons.visibility
                            : Icons.visibility_off_outlined,
                        color: AppColors.iconGrey,
                        size: 18,
                      ),
                    )),
                obscureText: _isHidden,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                // onPressed: () => context.replace('/signup'),

                onTap: () =>
                    navigatePush(context, const ForgotPasswordScreen()),
                // navigateReplace(context, const SignupPageOne()),

                child: Text(
                  "Forgot Password",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppColors.error),
                ),
              )),
          SizedBox(
            height: displaySize.height * .05,
          ),
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
              onPressed:
                  //=> navigateReplace(context, Dashboard())
                  (_emailController.text.isNotEmpty &&
                          _passwordController.text.isNotEmpty)
                      ? () async {
                          if (!_formKey.currentState!.validate()) {
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //     const SnackBar(content: Text('Processing Data')));
                            return;
                          }
                          setState(() {
                            _login = loginRequest(context);
                          });
                          _login;
                          // navigatePush(context, const SignUpScreen());
                        }
                      : null,

              child: Text(
                'Sign in',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: _emailController.text.isNotEmpty &&
                            _passwordController.text.isNotEmpty
                        ? AppColors.whiteA700
                        : AppColors.baseBlack),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.03,
          ),
          TextButton(
            // onPressed: () => context.replace('/signup'),
            onPressed: () => navigatePush(context, const Dashboard()),
            // navigateReplace(context, const SignupPageOne()),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
              AppColors.whiteA700,
            )),
            child: Text(
              "Skip to Dashboard",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.appGold),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          // IconButton(
          //     onPressed: () {
          //       _loadingPage.repeat();
          //       _loadingPage.stop();
          //     },
          //     icon: Lottie.asset(
          //       '$assetsUrl/bio.json',
          //       controller: _loadingPage,
          //       onLoaded: (composite) {
          //         _loadingPage
          //           ..duration = composite.duration
          //           ..forward();
          //       },
          //       height: 60,
          //       width: 60,
          //     ))
        ]));
  }
}
