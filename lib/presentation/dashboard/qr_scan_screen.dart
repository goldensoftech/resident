import 'dart:ui';

import 'package:resident/app_export.dart';
import 'package:flutter/foundation.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:resident/repository/model/nqr_model.dart';

class QRScanScreen extends StatefulWidget {
  const QRScanScreen({super.key});

  @override
  State<QRScanScreen> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen>
    with CustomAppBar, CustomAlerts, ErrorSnackBar {
  String? _scanResult;
  Future<void>? _request;
  String demo =
      "0002010102121531*999166999166*M000388764026710018NG.COM.NIBSSPLC.QR0111S000308541502301100132408202220597679531513345204000053035665406200.005802NG5911MTN NIGERIA6007Nigeria6304EFAE";
  //NibssQRModel? nqrData;
  Future<void> getMerchantDetails(context, String qrdata) async {
      await AuthBackend().setDefaultUser();
    NIBSSQRCodeData data = decryptNIBSSQRCode(qrdata);
    await TransactionBackend().payWithNQR(context, data: data);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: AppColors.whiteA700,
            appBar: customAppBar(title: "Scan QR"),
            body: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              children: [
                Text(
                  'Scan Payment Code',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.baseBlack),
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: displaySize.width * 0.7,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: AppColors.appGold,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12))
                        //minimumSize: const Size.fromHeight(60)
                        ),
                    onPressed: () async {
                      showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (ctx) {
                            return BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: SimpleDialog(
                                insetPadding: EdgeInsets.zero,
                                contentPadding: EdgeInsets.zero,

                                //   children: [],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r)),
                                children: [
                                  Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 13.w, vertical: 20.h),
                                      decoration: BoxDecoration(
                                          color: AppColors.whiteA700,
                                          borderRadius:
                                              BorderRadius.circular(10.r)),
                                      // height: displaySize.height * .6,
                                      width: displaySize.width * .9,
                                      child: Column(
                                        children: [
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Spacer(),
                                                Text(
                                                  'Scan QRCode',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color:
                                                          AppColors.black900),
                                                ),
                                                const Spacer(),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 20.0),
                                                  child: InkWell(
                                                      onTap: () {
                                                        navigateBack(context);
                                                      },
                                                      child: Icon(
                                                        Icons.cancel_outlined,
                                                        color:
                                                            AppColors.black900,
                                                      )),
                                                ),
                                              ]),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          SizedBox(
                                            height: displaySize.height * .4,
                                            width: displaySize.width * .8,
                                            child: MobileScanner(
                                              onDetect: (value) async {
                                                setState(() {
                                                  _scanResult =
                                                      value.raw.toString();
                                                  if (_scanResult != null ||
                                                      _scanResult!.length >
                                                          20) {
                                                    _request =
                                                        getMerchantDetails(
                                                            context,
                                                            _scanResult!);
                                                  }
                                                });
                                                await _request;
                                              },
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            );
                          });

                      // await Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) => const SimpleBarcodeScannerPage(),
                      //     ));
                    },
                    child: Text(
                      'Open Scanner',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.whiteA700),
                    ),
                  ),
                ),
                //   Card(
                //     margin: EdgeInsets.only(top: 20),
                //     color: AppColors.whiteA700,
                //     shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(10)),
                //     child: Padding(
                //       padding: const EdgeInsets.symmetric(
                //           vertical: 10.0, horizontal: 10),
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(
                //             'Payment Details',
                //             style: TextStyle(
                //                 fontSize: 14,
                //                 fontWeight: FontWeight.w400,
                //                 color: AppColors.baseBlack),
                //           ),
                //           Align(
                //             alignment: Alignment.center,
                //             child: Column(
                //               children: [
                //                 Row(
                //                   mainAxisAlignment: MainAxisAlignment.center,
                //                   crossAxisAlignment: CrossAxisAlignment.center,
                //                   mainAxisSize: MainAxisSize.min,
                //                   children: [
                //                     Text(
                //                       '123456789',
                //                       style: TextStyle(
                //                           fontSize: 20,
                //                           fontWeight: FontWeight.w800,
                //                           color: AppColors.baseBlack),
                //                     ),
                //                     IconButton(
                //                       onPressed: () async {
                //                         // setState(() {
                //                         //   _request = getMerchantDetails(context);
                //                         // });
                //                         // await _request;
                //                         copyText("widget.tx.refId!");
                //                         sendErrorMessage(
                //                             "Copied",
                //                             isSuccess: true,
                //                             "Account Details copied",
                //                             context);
                //                       },
                //                       icon: Icon(Icons.content_copy_rounded,
                //                           color: AppColors.appGold, size: 18),
                //                     )
                //                   ],
                //                 ),
                //                 Text(
                //                   'Uba',
                //                   style: TextStyle(
                //                       fontSize: 16,
                //                       fontWeight: FontWeight.w800,
                //                       color: AppColors.baseBlack),
                //                 ),
                //                 Text(
                //                   'Adubuola Olwafemi',
                //                   style: TextStyle(
                //                       fontSize: 14,
                //                       fontWeight: FontWeight.w400,
                //                       color: AppColors.black900),
                //                 ),
                //               ],
                //             ),
                //           )
                //         ],
                //       ),
                //     ),
                //   )
              ],
            ),
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
