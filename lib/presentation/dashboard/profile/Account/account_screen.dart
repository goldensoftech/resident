import 'package:resident/app_export.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with CustomAppBar, CustomWidgets {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Scaffold(
            backgroundColor: AppColors.whiteA700,
            appBar: profileAppBar(title: "Account Settings"),
            body: ListView(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
                children: [
                  profileTile(
                      title: "KYC Verification",
                      isVerification: true,
                      pageToGo: KycScreen()),
                  profileTile(
                      title: "Profile Information",
                      pageToGo: const AccountProfileScreen()),
                  profileTile(
                      title: "Reset Password", pageToGo: const ResetPasswordScreen()),
                ])));
  }
}
