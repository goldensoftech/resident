import 'package:flutter/material.dart';
import 'package:resident/app_export.dart';
import 'package:resident/repository/backend/payment_gateways.backend.dart';
import 'package:resident/repository/model/data_response_model.dart';

class PaymentGatewayScreen extends StatefulWidget {
  PaymentGatewayScreen(
      {super.key, this.showRemitta, this.showIsW, required this.details});
  PaymentDetails details;
  bool? showRemitta;
  bool? showIsW;

  @override
  State<PaymentGatewayScreen> createState() => _PaymentGatewayScreenState();
}

class _PaymentGatewayScreenState extends State<PaymentGatewayScreen>
    with CustomAppBar, CustomAlerts {
  Future<void>? _request;
  @override
  void initState() {
    initialize();
    super.initState();
  }

  void initialize() async {}

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Stack(
          children: [
            Scaffold(
                backgroundColor: AppColors.whiteA700,
                appBar: customAppBar(title: "Payment Method"),
                body: ListView(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    children: [
                      Text(
                        'Select Payment Mode',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.baseBlack),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: DummyData().pGateway.length,
                          itemBuilder: (ctx, index) {
                            final gateWay = DummyData().pGateway[index];
                            if ((widget.showIsW == null ||
                                    widget.showIsW == false) &&
                                gateWay['gateway_type'] ==
                                    PaymentGateway.interswitch) {
                              return const SizedBox.shrink();
                            }
                            if ((widget.showRemitta == null ||
                                    widget.showRemitta == false) &&
                                gateWay['gateway_type'] ==
                                    PaymentGateway.remita) {
                              return const SizedBox.shrink();
                            }

                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              elevation: 0,
                              child: ListTile(
                                  onTap: () async {
                                    if (gateWay['gateway_type'] ==
                                        PaymentGateway.interswitch) {
                                      _request = payWithISW(context);
                                    } else if (gateWay['gateway_type'] ==
                                        PaymentGateway.paystack) {
                                      _request = payWithPayStack(context);
                                    }
                                    setState(() {});
                                    await _request;
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  tileColor: AppColors.lightGrey,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 10),
                                  leading: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.whiteA700),
                                    child: Image.asset(gateWay['logo'],
                                        fit: BoxFit.contain),
                                  ),
                                  title: Text(gateWay['name'],
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600))),
                            );
                          })
                    ])),
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

  Future<void> payWithISW(context) async {
    PaymentDetails details = widget.details;
    details.paymentGateway = PaymentGateway.interswitch;
    // await TransactionBackend().with(context, details: details);
    //await PaymentGateways().getIswUrl(context).then((value) async {
    await Pay().withISW(context, details: details);
    // });
  }

  Future<void> payWithPayStack(context) async {
    PaymentDetails details = widget.details;
    details.paymentGateway = PaymentGateway.paystack;
    await TransactionBackend().preProcessPayment(context, details: details);
    await Pay().withPaystack(context, details: details);
  }
}
