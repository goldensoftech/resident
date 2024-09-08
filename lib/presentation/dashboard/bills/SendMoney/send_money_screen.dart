import 'package:resident/app_export.dart';
import 'package:resident/utils/enums.dart';

class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({super.key});

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen>
    with CustomAppBar, CustomAlerts, FormInputFields {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _narrationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
          appBar: customAppBar(title: "Send Money"),
          backgroundColor: AppColors.whiteA700,
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Text(
                    'Account Number',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.darkGrey),
                  ),
                ),
                textInput(_amountController, 'Account Number', 1,
                    'Account Number', 1, TextInputType.number, true),
              ]),
              const SizedBox(
                height: 10.0,
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Text(
                    'Amount',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.darkGrey),
                  ),
                ),
                textInput(_amountController, "Enter Amount ", 1, "Enter Amount",
                    1, TextInputType.number, true),
              ]),
              const SizedBox(
                height: 10.0,
              ),
              textInput(_amountController, "Narration(Optional) ", 1,
                  "Narration(Optional)", 1, TextInputType.text, false),
            ],
          ),
          persistentFooterAlignment: AlignmentDirectional.bottomCenter,
          persistentFooterButtons: [
            SizedBox(
              //  padding: EdgeInsets.symmetric(horizontal: 40),
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
                onPressed: () => showTxConfirmationAlert(context,
                    type: TransactionType.remita),

                //  (_emailController.text.isNotEmpty &&

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
    );
  }
}
