import 'package:flutter/material.dart';
import 'package:resident/app_export.dart';
import 'package:resident/presentation/dashboard/profile/Legal/privacy_policy_screen.dart';
import 'package:resident/presentation/dashboard/profile/Legal/terms_and_condition.dart';

class LegalScreen extends StatefulWidget {
  const LegalScreen({super.key});

  @override
  State<LegalScreen> createState() => _LegalScreenState();
}

class _LegalScreenState extends State<LegalScreen>
    with CustomAppBar, CustomWidgets {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Scaffold(
            backgroundColor: AppColors.whiteA700,
            appBar: profileAppBar(title: "Legal"),
            body: ListView(
                padding:
                    const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
                children: [
                  profileTile(
                      title: "Privacy Policy", pageToGo: PrivacyPolicyScreen()),
                  profileTile(
                      title: "Terms and Condition",
                      pageToGo: TermsAndCondition()),
                ])));
  }
}
