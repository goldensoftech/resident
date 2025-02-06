import 'package:resident/app_export.dart';

class AccountSuccessScreen extends StatefulWidget {
  const AccountSuccessScreen({super.key});

  @override
  State<AccountSuccessScreen> createState() => _AccountSuccessScreenState();
}

class _AccountSuccessScreenState extends State<AccountSuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.whiteA700,
        body: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Account Created Successfully",
                      style: TextStyle(
                          color: AppColors.black900,
                          fontWeight: FontWeight.w700,
                          fontSize: 18.0)),
                  const SizedBox(height: 20.0),
                  SvgPicture.asset(
                    successImg,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20.0),
                  SizedBox(
                    width: displaySize.width * .8,
                    child: Text(
                        "You're now just a few taps away from paying your bills on time, every time. Start managing your bills today and never miss a payment again!",
                        style: TextStyle(
                            fontSize: 12.0,
                            color: AppColors.baseBlack,
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center),
                  )
                ],
              ))
            ],
          ),
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
              onPressed: () {
                navigateRemoveAll(context, Dashboard());
                // if (!_formKey.currentState!.validate()) {
                //   // ScaffoldMessenger.of(context).showSnackBar(
                //   //     const SnackBar(content: Text('Processing Data')));
                //   return;
                // }
                // setState(() {
                //   _login = loginRequest(context);
                // });
                // _login;
                // navigatePush(context, const SignUpScreen());
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
        ]);
  }
}
