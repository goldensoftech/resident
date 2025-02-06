import 'dart:ui';

import 'package:resident/app_export.dart';
import 'package:resident/presentation/dashboard/transaction/tx_info_screen.dart';
import 'package:resident/repository/backend/payment_gateways.backend.dart';
import 'package:resident/utils/enums.dart';

class RRRPaymentScreen extends StatefulWidget {
  const RRRPaymentScreen({super.key});

  @override
  State<RRRPaymentScreen> createState() => _RRRPaymentScreenState();
}

class _RRRPaymentScreenState extends State<RRRPaymentScreen>
    with CustomAppBar, CustomWidgets, ErrorSnackBar {
  final TextEditingController _rrrController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  LookupDetails? lookupDetails;
  Future<void>? _request;
  Future<void> lookupRRR(context) async {
    String rrr = _rrrController.text;
    lookupDetails = await TransactionBackend().lookUpRemitta(context, rrr: rrr);
    setState(() {
      lookupDetails;
    });
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
                appBar: customAppBar(title: "RRR Payment"),
                backgroundColor: AppColors.whiteA700,
                body: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                        vertical: 24, horizontal: 20),
                    children: [
                      TextFormField(
                        controller: _rrrController,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {});
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter rrr';
                          }
                          return null;
                        },
                        style: const TextStyle(height: 1),
                        cursorOpacityAnimates: true,
                        cursorWidth: 1,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 12),
                          //labelStyle: const TextStyle(color: Colors.black54),
                          hintText: 'RRR No',

                          hintStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.grey700),

                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1.w, color: AppColors.formGrey),
                              borderRadius: BorderRadius.circular(8.r)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide(color: AppColors.appGold),
                          ),
                        ),
                      ),
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
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        setState(() {
                          _request = lookupRRR(context);
                        });
                        await _request;
                        if (lookupDetails != null) {
                          if (lookupDetails!.status == PaymentStatus.paid ||
                              lookupDetails!.status ==
                                  PaymentStatus.completed ||
                              lookupDetails!.status == PaymentStatus.failed) {
                            final txn = TransactionModel(
                                amount: lookupDetails!.detials.amount,
                                destinationNum:
                                    lookupDetails!.detials.customerMobile ?? "",
                                email: lookupDetails!.detials.customerEmail,
                                payerName: lookupDetails!.detials.payerName,
                                payerPhone:
                                    lookupDetails!.detials.customerMobile,
                                paymentCode: lookupDetails!.detials.paymentCode,
                                refId: lookupDetails!.rrrData.rrr,
                                gateway: PaymentGateway.remita,
                                txnId: lookupDetails!.rrrData.rrr,
                                serviceType: lookupDetails!.detials.serviceName,
                                status: lookupDetails!.status,
                                txnDate: lookupDetails!.date,
                                type: TransactionType.remita);
                            navigatePush(
                                context, TransactionInfoScreen(tx: txn));
                          } else {
                            showDialog(
                                barrierDismissible: true,
                                context: context,
                                builder: (context) {
                                  return BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 10, sigmaY: 10),
                                    child: SimpleDialog(
                                        insetPadding: EdgeInsets.zero,
                                        contentPadding: EdgeInsets.zero,

                                        //   children: [],
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.r)),
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                color: AppColors.whiteA700,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        10.r)),
                                            height: displaySize.height * .7,
                                            width: displaySize.width * .8,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 13.w,
                                                  vertical: 20.h),
                                              child: Column(
                                                children: [
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Spacer(),
                                                        Text(
                                                          'Transaction Summary',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              color: AppColors
                                                                  .black900),
                                                        ),
                                                        const Spacer(),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 20.0),
                                                          child: InkWell(
                                                              onTap: () {
                                                                navigateBack(
                                                                    context);
                                                              },
                                                              child: Icon(
                                                                Icons
                                                                    .cancel_outlined,
                                                                color: AppColors
                                                                    .black900,
                                                              )),
                                                        ),
                                                      ]),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 2.0,
                                                                vertical: 15),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Transaction Summary',
                                                              style: TextStyle(
                                                                  color: AppColors
                                                                      .grey500,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ),
                                                            Text(
                                                              "Remita",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  color: AppColors
                                                                      .baseBlack,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Divider(
                                                        height: 1,
                                                        thickness: .5,
                                                        color:
                                                            AppColors.grey400,
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 2.0,
                                                                vertical: 15),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'RRR No',
                                                              style: TextStyle(
                                                                  color: AppColors
                                                                      .grey500,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ),
                                                            Align(
                                                              alignment: Alignment
                                                                  .centerRight,
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .end,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    lookupDetails!
                                                                        .rrrData
                                                                        .rrr,
                                                                    style: TextStyle(
                                                                        color: AppColors
                                                                            .baseBlack,
                                                                        fontWeight:
                                                                            FontWeight.w700),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 2,
                                                                  ),
                                                                  InkWell(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            100),
                                                                    //// padding: EdgeInsets.only(left:3),
                                                                    onTap: () {
                                                                      copyText(lookupDetails!
                                                                          .rrrData!
                                                                          .rrr);
                                                                      sendErrorMessage(
                                                                          "Copied",
                                                                          isSuccess:
                                                                              true,
                                                                          "Transaction Reference copied",
                                                                          context);
                                                                    },

                                                                    child: Icon(
                                                                        Icons
                                                                            .content_copy_rounded,
                                                                        color: AppColors
                                                                            .appGold,
                                                                        size:
                                                                            18),
                                                                  )
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Divider(
                                                        height: 1,
                                                        thickness: .5,
                                                        color:
                                                            AppColors.grey400,
                                                      ),
                                                    ],
                                                  ),
                                                  Column(children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 2.0,
                                                          vertical: 15),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            'Customer Name',
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .grey500,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                           SizedBox(
                                                             
                                                              width: displaySize
                                                                      .width *
                                                                  .3,
                                                              child: Text(
                                                                lookupDetails!
                                                                        .detials
                                                                        .payerName ??
                                                                    "",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                                style: TextStyle(
                                                                    color: AppColors
                                                                        .baseBlack,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                              ),
                                                            ),
                                                        
                                                        ],
                                                      ),
                                                    ),
                                                    Divider(
                                                      height: 1,
                                                      thickness: .5,
                                                      color: AppColors.grey400,
                                                    ),
                                                  ]),
                                                  Column(children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 2.0,
                                                          vertical: 15),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            'Biller',
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .grey500,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                          SizedBox(
                                                           
                                                            width: displaySize
                                                                    .width *
                                                                .5,
                                                            child: Text(
                                                              lookupDetails!
                                                                      .detials
                                                                      .serviceName ??
                                                                  "Remita Payment",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: TextStyle(
                                                                  color: AppColors
                                                                      .baseBlack,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    Divider(
                                                      height: 1,
                                                      thickness: .5,
                                                      color: AppColors.grey400,
                                                    ),
                                                  ]),
                                                  Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 2.0,
                                                                vertical: 15),
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              'Amount to Pay',
                                                              style: TextStyle(
                                                                  color: AppColors
                                                                      .grey500,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ),
                                                            Text(
                                                              "$ngnIcon ${UtilFunctions.formatAmount(lookupDetails!.rrrData.amount)}",
                                                              style: TextStyle(
                                                                  color: AppColors
                                                                      .appGold,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Divider(
                                                        height: 1,
                                                        thickness: .5,
                                                        color:
                                                            AppColors.grey400,
                                                      ),
                                                    ],
                                                  ),
                                                  const Spacer(),
                                                  SizedBox(
                                                    width:
                                                        displaySize.width * 0.7,
                                                    child: ElevatedButton(
                                                      style: ElevatedButton.styleFrom(
                                                          elevation: 0,
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 14),
                                                          backgroundColor:
                                                              AppColors.appGold,
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          12))),
                                                      onPressed: () async {
                                                        {
                                                          FocusScope.of(context)
                                                              .unfocus();
                                                          // await TransactionBackend()
                                                          //     .preProcessPayment(
                                                          //         context,
                                                          //         details:
                                                          //             lookupDetails!
                                                          //                 .detials);
                                                          await Pay().withRemita(
                                                              context,
                                                              rrrData:
                                                                  lookupDetails!
                                                                      .rrrData,
                                                              details:
                                                                  lookupDetails!
                                                                      .detials);
                                                          //navigateBack(context);
                                                          // navigatePush(
                                                          //     context,
                                                          //     PaymentGatewayScreen(
                                                          //       details: PaymentDetails(
                                                          //           customerId: order!
                                                          //               .customerId,
                                                          //           surcharge: order!
                                                          //               .surcharge,
                                                          //           customerEmail: AuthBackend.isLoggedIn()
                                                          //               ? ResponseData
                                                          //                   .loginResponse!
                                                          //                   .user!
                                                          //                   .userName!
                                                          //               : _emailController.text
                                                          //                   .trim(),
                                                          //           amount: double.parse(
                                                          //               _amountController
                                                          //                   .text),
                                                          //           customerMobile:
                                                          //               _idController
                                                          //                   .text,
                                                          //           payerName: AuthBackend.isLoggedIn()
                                                          //               ? ResponseData
                                                          //                   .loginResponse!
                                                          //                   .user!
                                                          //                   .userName!
                                                          //               : "UNKNOWN",
                                                          //           serviceId: selectedPlan!
                                                          //               .code
                                                          //               .toString(),
                                                          //           serviceName:
                                                          //               selectedPlan!
                                                          //                   .title
                                                          //                   .toString(),
                                                          //           paymentCode:
                                                          //               order!.code,
                                                          //           transactionType: TransactionType.tv),
                                                          //     ));
                                                        }
                                                      },
                                                      child: Text(
                                                        'Continue',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: AppColors
                                                                .whiteA700),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ]),
                                  );
                                });
                          }
                        }
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
      ),
    );
  }
}
