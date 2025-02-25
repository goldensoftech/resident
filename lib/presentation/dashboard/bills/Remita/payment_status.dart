import 'package:resident/app_export.dart';

class PaymentStatusScreen extends StatefulWidget {
  const PaymentStatusScreen({super.key});

  @override
  State<PaymentStatusScreen> createState() => _PaymentStatusScreenState();
}

class _PaymentStatusScreenState extends State<PaymentStatusScreen>
    with CustomAlerts, CustomAppBar {
  final TextEditingController _idController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
          appBar: customAppBar(title: "RRR Status"),
          backgroundColor: AppColors.whiteA700,
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            children: [
              Text(
                'RRR Status',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.baseBlack,
                    fontSize: 14),
              ),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: _idController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {});
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a password';
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
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  //labelStyle: const TextStyle(color: Colors.black54),
                  hintText: 'Enter RRR ID',
                  hintStyle: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.grey200),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide.none),
                  focusedBorder:
                      const OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
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
                    backgroundColor: AppColors.appGold,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))
                    //minimumSize: const Size.fromHeight(60)
                    ),
                //onPressed: () => context.replace('/signup'),
                onPressed: () => showTxConfirmationAlert(context,
                    type: TransactionType.remita),

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
