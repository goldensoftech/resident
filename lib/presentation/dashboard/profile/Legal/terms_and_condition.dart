import 'package:flutter/material.dart';
import 'package:resident/app_export.dart';

class TermsAndCondition extends StatefulWidget {
  const TermsAndCondition({super.key});

  @override
  State<TermsAndCondition> createState() => _TermsAndConditionState();
}

class _TermsAndConditionState extends State<TermsAndCondition>
    with CustomAppBar, CustomWidgets {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: AppColors.whiteA700,
          appBar: profileAppBar(title: "Terms and Condition"),
        ));
  }
}
