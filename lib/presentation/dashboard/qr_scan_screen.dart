import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:resident/app_export.dart';

class QRScanScreen extends StatefulWidget {
  const QRScanScreen({super.key});

  @override
  State<QRScanScreen> createState() => _QRScanScreenState();
}

class _QRScanScreenState extends State<QRScanScreen>
    with CustomAppBar, CustomAlerts, ErrorSnackBar {
  String? _scanResult;
  UserBankDetails? selectedAccount;
  final TextEditingController _mechantNameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final MobileScannerController _scannerController = MobileScannerController();
  final _formKey = GlobalKey<FormState>();

  Future<void>? _request;
  // String demo =
  //     "0002010102121531**999166**999166****M000000000126720019NG.COM.NIBSS-PLC.QR0111S000000000102309991662005210922520163783561015204000053035665402105802NG5913Test Merchant6007Nigeria6304A54A"; //NibssQRModel? nqrData;
  String rawData =
      "0002010102121531**999166**999166****M000388764026710018NG.COM.NIBSSPLC.QR0111S000308541502301100132408202220597679531513345204000053035665406200.005802NG5911MTN NIGERIA6007Nigeria6304EFAE";

  NqrCodeData? getMerchantDetails(context, String? qrdata) {
    // await AuthBackend().setDefaultUser();
    // // Restructure the raw data
    if (qrdata!.contains("NIBSS")) {
      if (qrdata != null && qrdata.length > 185 && qrdata.length < 190) {
        String formattedData = restructureRawData(qrdata);
        NqrCodeData nqrData = NqrCodeData.fromQrString(formattedData);
        _mechantNameController.text = nqrData.merchantName;
        _amountController.text = nqrData.orderAmount;
        setState(() {});
        //await TransactionBackend().payWithNQR(context, data: data);
        print("length ${qrdata.length}");
        // Now you can pass this formatted data to your NQR model parser
        print("Formatted Data: $formattedData");

        print("Institution No: ${nqrData.institutionNumber}");
        print("Order Amount: ${nqrData.orderAmount}");
        print("Order SN: ${nqrData.orderSn}");
        print("Merchant No: ${nqrData.merchantNo}");
        print("Sub Merchant No: ${nqrData.subMerchantNo}");
        print("Is Dynamic Transaction: ${nqrData.isDynamic}");

        print("Merchant Name: ${nqrData.merchantName}");
        return nqrData;
      }
    }
    return null;
  }

  makeNQRPayment(context, {required NqrCodeData data}) async {

    await UtilFunctions().getLocation(context);

    await TransactionBackend()
        .makeNQRPayment(context, data: data, bankDetails: selectedAccount!);
  }

  @override
  void initState() {
    getUserBanks(context);
    super.initState();
  }

  getUserBanks(context) async {
    if (ResponseData.userBanks.isEmpty) {
      await TransactionBackend().getUserBanks(
        context,
      );
    }
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: AppColors.whiteA700,
            appBar: customAppBar(title: "Pay with NQR"),
            body: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () async {
                      setState(() {
                        _request = getUserBanks(context);
                      });
                      await _request;
                      showModalBottomSheet(
                          context: context,
                          backgroundColor: AppColors.whiteA700,
                          showDragHandle: true,
                          enableDrag: true,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10))),
                          builder: (context) {
                            return Container(
                              color: AppColors.whiteA700,
                              constraints: BoxConstraints(
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.5),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 20),
                              child: Scrollbar(
                                radius: const Radius.circular(5),
                                child: ListView(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      width: double.infinity,
                                      child: Text(
                                        "Select bank account",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: AppColors.baseBlack,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ListView.separated(
                                        itemCount:
                                            ResponseData.userBanks.length,
                                        shrinkWrap: true,
                                        physics: const ScrollPhysics(),
                                        separatorBuilder:
                                            (BuildContext context, int index) =>
                                                Divider(
                                                    height: 1,
                                                    color: AppColors.grey200),
                                        itemBuilder: (ctx, index) {
                                          final data =
                                              ResponseData.userBanks[index];
                                          return Dismissible(
                                            key: Key(data.accountNumber),
                                            direction: DismissDirection
                                                .endToStart, // Swipe from right to left
                                            background: Container(
                                              color: Colors.red,
                                              alignment: Alignment.centerRight,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: const Icon(
                                                  CupertinoIcons.delete,
                                                  color: Colors.white),
                                            ),
                                            confirmDismiss: (DismissDirection
                                                direction) async {
                                              selectedAccount = null;
                                              return await showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    backgroundColor:
                                                        AppColors.whiteA700,
                                                    insetPadding:
                                                        EdgeInsets.zero,
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 13.w,
                                                            vertical: 20.h),

                                                    //   children: [],
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.r)),

                                                    title:
                                                        Text("Confirm Delete"),

                                                    content: Text(
                                                        "Are you sure you want to delete this account?"),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () => Navigator
                                                                .of(context)
                                                            .pop(
                                                                false), // Cancel
                                                        child: Text("Cancel"),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          Navigator.of(context)
                                                              .pop(true);
                                                          setState(() {
                                                            _request = TransactionBackend()
                                                                .deleteAccount(
                                                                    context,
                                                                    accountNumber:
                                                                        data.accountNumber);
                                                          });
                                                          await _request;
                                                        },
                                                        child: Text(
                                                          "Delete",
                                                          style: TextStyle(
                                                              color: AppColors
                                                                  .red),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                            // onDismissed: (DismissDirection
                                            //     direction) async {
                                            //   // // Optionally show a snackbar
                                            //   // ScaffoldMessenger.of(context)
                                            //   //     .showSnackBar(
                                            //   //   SnackBar(
                                            //   //       content: Text(
                                            //   //           "Account deleted")),
                                            //   // );
                                            // },
                                            child: ListTile(
                                              tileColor: AppColors.whiteA700,
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              onTap: () {
                                                setState(() {
                                                  selectedAccount = data;
                                                });
                                                navigateBack(context);
                                              },
                                              title: Text(
                                                data.accountNumber,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              subtitle: Text(
                                                "${data.accountName} ",
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          );
                                        }),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        navigateBack(context);
                                        navigatePush(
                                            context, AddAccountScreen());
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: AppColors.gold100),
                                        margin: EdgeInsets.symmetric(
                                            horizontal:
                                                displaySize.width * .15),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 15,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Add',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                  color: AppColors.baseBlack),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Icon(
                                                Icons
                                                    .add_circle_outline_rounded,
                                                color: AppColors.baseBlack,
                                                size: 16)
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                          color: AppColors.gold100,
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        selectedAccount == null
                            ? 'Select Account'
                            : "Change Account",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.baseBlack),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (selectedAccount != null)
                  Card(
                    // margin: EdgeInsets.only(top: 20),
                    color: AppColors.whiteA700,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Pay From',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.baseBlack),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      selectedAccount!.accountNumber.toString(),
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.baseBlack),
                                    ),
                                    // const SizedBox(
                                    //   width: 5,
                                    // ),
                                    IconButton(
                                      onPressed: () async {
                                        // setState(() {
                                        //   _request = getMerchantDetails(context);
                                        // });
                                        // await _request;
                                        copyText(selectedAccount!.accountNumber
                                            .toString());
                                        sendErrorMessage(
                                            "Copied",
                                            isSuccess: true,
                                            "Account Details copied",
                                            context);
                                      },
                                      icon: Icon(Icons.content_copy_rounded,
                                          color: AppColors.appGold, size: 16),
                                    )
                                  ],
                                ),
                                // Text(
                                //   selectedAccount!.bankName.toString(),
                                //   style: TextStyle(
                                //       fontSize: 14,
                                //       fontWeight: FontWeight.w600,
                                //       color: AppColors.baseBlack),
                                // ),
                                Text(
                                  selectedAccount!.accountName.toString(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.black900),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
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
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: selectedAccount != null
                          ? AppColors.appGold
                          : AppColors.grey200,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))
                      //minimumSize: const Size.fromHeight(60)
                      ),
                  onPressed: selectedAccount == null
                      ? null
                      : () async {
                          NqrCodeData? nqrdata =
                              getMerchantDetails(context, rawData!);
                          _scannerController.stop();
                          //  navigateBack(context);
                          if (nqrdata != null) {
                            showModalBottomSheet(
                                context: context,
                                backgroundColor: AppColors.whiteA700,
                                showDragHandle: true,
                                enableDrag: true,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10))),
                                builder: (ctx) {
                                  return Container(
                                      color: AppColors.whiteA700,
                                      constraints: BoxConstraints(
                                          maxHeight: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.5),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 10),
                                      child: Scrollbar(
                                          radius: const Radius.circular(5),
                                          child: Form(
                                            key: _formKey,
                                            child: ListView(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 0,
                                                        horizontal: 10),
                                                children: [
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "Making payment to",
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: AppColors
                                                              .baseBlack,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    "Merchant Name",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            AppColors.baseBlack,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        _mechantNameController,
                                                    readOnly: true,
                                                    keyboardType: TextInputType
                                                        .emailAddress,
                                                    onChanged: (value) {
                                                      setState(() {});
                                                    },
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please enter your name';
                                                      }
                                                      return null;
                                                    },
                                                    style: const TextStyle(
                                                        height: 1),
                                                    cursorOpacityAnimates: true,
                                                    cursorWidth: 1,
                                                    cursorColor: Colors.black,
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              vertical: 0,
                                                              horizontal: 12),
                                                      //labelStyle: const TextStyle(color: Colors.black54),
                                                      hintText: 'Payer Name',
                                                      filled: true,
                                                      fillColor:
                                                          AppColors.lightGrey,
                                                      hintStyle: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: AppColors
                                                              .grey700),

                                                      border:
                                                          OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide
                                                                      .none,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.r)),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.r),
                                                        borderSide:
                                                            BorderSide.none,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    "Amount",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            AppColors.baseBlack,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  TextFormField(
                                                    controller:
                                                        _amountController,
                                                    readOnly:
                                                        !nqrdata.isDynamic,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    onChanged: (value) {
                                                      setState(() {});
                                                    },
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please amount';
                                                      }
                                                      return null;
                                                    },
                                                    style: const TextStyle(
                                                        height: 1),
                                                    cursorOpacityAnimates: true,
                                                    cursorWidth: 1,
                                                    cursorColor: Colors.black,
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              vertical: 0,
                                                              horizontal: 12),
                                                      //labelStyle: const TextStyle(color: Colors.black54),
                                                      hintText: 'Amount',
                                                      filled: nqrdata.isDynamic,
                                                      fillColor:
                                                          AppColors.lightGrey,
                                                      hintStyle: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w400,
                                                          color: AppColors
                                                              .grey700),

                                                      border: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              width: 1.w,
                                                              color: AppColors
                                                                  .formGrey),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.r)),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.r),
                                                        borderSide: BorderSide(
                                                            color: AppColors
                                                                .appGold),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  SizedBox(
                                                      width: displaySize.width *
                                                          0.7,
                                                      child: ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                              elevation: 0,
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          14),
                                                              backgroundColor:
                                                                  AppColors
                                                                      .appGold,
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12))),
                                                          onPressed: () async {
                                                            if (!_formKey
                                                                .currentState!
                                                                .validate()) {
                                                              return;
                                                            }
                                                            navigateBack(ctx);

                                                            setState(() {
                                                              _request =
                                                                  makeNQRPayment(
                                                                context,
                                                                data: nqrdata,
                                                              );
                                                            });

                                                            await _request;

                                                            // showTxConfirmationAlert(
                                                            //   context,
                                                            //   type: TransactionType.data,
                                                            // ),
                                                          },
                                                          child: Text(
                                                            'Make Payment',
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: AppColors
                                                                    .whiteA700),
                                                          )))
                                                ]),
                                          )));
                                });
                          } else {
                            sendErrorMessage(
                                "Error", "NQR Platform not suported", context);
                          }
                          // _scanResult = null;
                          // _scannerController.start();
                          // showDialog(
                          //     barrierDismissible: true,
                          //     context: context,
                          //     builder: (ctx) {
                          //       return BackdropFilter(
                          //         filter:
                          //             ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          //         child: SimpleDialog(
                          //           insetPadding: EdgeInsets.zero,
                          //           contentPadding: EdgeInsets.zero,

                          //           //   children: [],
                          //           shape: RoundedRectangleBorder(
                          //               borderRadius:
                          //                   BorderRadius.circular(10.r)),
                          //           children: [
                          //             Container(
                          //                 padding: EdgeInsets.symmetric(
                          //                     horizontal: 13.w, vertical: 20.h),
                          //                 decoration: BoxDecoration(
                          //                     color: AppColors.whiteA700,
                          //                     borderRadius:
                          //                         BorderRadius.circular(10.r)),
                          //                 // height: displaySize.height * .6,
                          //                 width: displaySize.width * .9,
                          //                 child: Column(
                          //                   children: [
                          //                     Row(
                          //                         mainAxisAlignment:
                          //                             MainAxisAlignment.center,
                          //                         children: [
                          //                           const Spacer(),
                          //                           Text(
                          //                             'Scan Payment QR',
                          //                             style: TextStyle(
                          //                                 fontSize: 16,
                          //                                 fontWeight:
                          //                                     FontWeight.w700,
                          //                                 color: AppColors
                          //                                     .black900),
                          //                           ),
                          //                           const Spacer(),
                          //                           Padding(
                          //                             padding:
                          //                                 const EdgeInsets.only(
                          //                                     right: 20.0),
                          //                             child: InkWell(
                          //                                 onTap: () {
                          //                                   _scannerController
                          //                                       .stop();
                          //                                   navigateBack(ctx);
                          //                                 },
                          //                                 child: Icon(
                          //                                   Icons
                          //                                       .cancel_outlined,
                          //                                   color: AppColors
                          //                                       .black900,
                          //                                 )),
                          //                           ),
                          //                         ]),
                          //                     const SizedBox(
                          //                       height: 20,
                          //                     ),
                          //                     SizedBox(
                          //                       height: displaySize.height * .4,
                          //                       width: displaySize.width * .8,
                          //                       child: MobileScanner(
                          //                         //  startDelay: true,

                          //                         onDetect: (value) async {
                          //                           if (value
                          //                               .barcodes.isNotEmpty) {
                          //                             // Get the first barcode only
                          //                             Barcode barcode =
                          //                                 value.barcodes.first;

                          //                             // Check if the barcode contains a rawValue
                          //                             if (barcode.rawValue !=
                          //                                 null) {
                          //                               _scanResult =
                          //                                   barcode.rawValue;
                          //                               setState(() {});
                          //                               print(
                          //                                   "Raw Value: $_scanResult");

                          //                               // Pass the rawValue to getMerchantDetails function
                          //                               NqrCodeData? nqrdata =
                          //                                   getMerchantDetails(
                          //                                       context,
                          //                                       _scanResult!);
                          //                               _scannerController
                          //                                   .stop();
                          //                               navigateBack(ctx);
                          //                               if (nqrdata != null) {
                          //                                 showModalBottomSheet(
                          //                                     context: context,
                          //                                     backgroundColor:
                          //                                         AppColors
                          //                                             .whiteA700,
                          //                                     showDragHandle:
                          //                                         true,
                          //                                     enableDrag: true,
                          //                                     isScrollControlled:
                          //                                         true,
                          //                                     shape: const RoundedRectangleBorder(
                          //                                         borderRadius: BorderRadius.only(
                          //                                             topLeft: Radius
                          //                                                 .circular(
                          //                                                     10),
                          //                                             topRight:
                          //                                                 Radius.circular(
                          //                                                     10))),
                          //                                     builder: (ctx) {
                          //                                       return Container(
                          //                                           color: AppColors
                          //                                               .whiteA700,
                          //                                           constraints: BoxConstraints(
                          //                                               maxHeight: MediaQuery.of(context).size.height *
                          //                                                   0.5),
                          //                                           padding: const EdgeInsets
                          //                                               .symmetric(
                          //                                               horizontal:
                          //                                                   10.0,
                          //                                               vertical:
                          //                                                   10),
                          //                                           child: Scrollbar(
                          //                                               radius: const Radius.circular(5),
                          //                                               child: Form(
                          //                                                 key:
                          //                                                     _formKey,
                          //                                                 child: ListView(
                          //                                                     padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          //                                                     children: [
                          //                                                       Align(
                          //                                                         alignment: Alignment.center,
                          //                                                         child: Text(
                          //                                                           "Making payment to",
                          //                                                           style: TextStyle(fontSize: 18, color: AppColors.baseBlack, fontWeight: FontWeight.w600),
                          //                                                         ),
                          //                                                       ),
                          //                                                       SizedBox(
                          //                                                         height: 20,
                          //                                                       ),
                          //                                                       Text(
                          //                                                         "Merchant Name",
                          //                                                         style: TextStyle(fontSize: 14, color: AppColors.baseBlack, fontWeight: FontWeight.w600),
                          //                                                       ),
                          //                                                       SizedBox(
                          //                                                         height: 5,
                          //                                                       ),
                          //                                                       TextFormField(
                          //                                                         controller: _mechantNameController,
                          //                                                         readOnly: true,
                          //                                                         keyboardType: TextInputType.emailAddress,
                          //                                                         onChanged: (value) {
                          //                                                           setState(() {});
                          //                                                         },
                          //                                                         validator: (value) {
                          //                                                           if (value == null || value.isEmpty) {
                          //                                                             return 'Please enter your name';
                          //                                                           }
                          //                                                           return null;
                          //                                                         },
                          //                                                         style: const TextStyle(height: 1),
                          //                                                         cursorOpacityAnimates: true,
                          //                                                         cursorWidth: 1,
                          //                                                         cursorColor: Colors.black,
                          //                                                         decoration: InputDecoration(
                          //                                                           contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                          //                                                           //labelStyle: const TextStyle(color: Colors.black54),
                          //                                                           hintText: 'Payer Name',
                          //                                                           filled: true,
                          //                                                           fillColor: AppColors.lightGrey,
                          //                                                           hintStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.grey700),

                          //                                                           border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(8.r)),
                          //                                                           focusedBorder: OutlineInputBorder(
                          //                                                             borderRadius: BorderRadius.circular(8.r),
                          //                                                             borderSide: BorderSide.none,
                          //                                                           ),
                          //                                                         ),
                          //                                                       ),
                          //                                                       SizedBox(
                          //                                                         height: 20,
                          //                                                       ),
                          //                                                       Text(
                          //                                                         "Amount",
                          //                                                         style: TextStyle(fontSize: 14, color: AppColors.baseBlack, fontWeight: FontWeight.w600),
                          //                                                       ),
                          //                                                       SizedBox(
                          //                                                         height: 5,
                          //                                                       ),
                          //                                                       TextFormField(
                          //                                                         controller: _amountController,
                          //                                                         readOnly: !nqrdata.isDynamic,
                          //                                                         keyboardType: TextInputType.number,
                          //                                                         onChanged: (value) {
                          //                                                           setState(() {});
                          //                                                         },
                          //                                                         validator: (value) {
                          //                                                           if (value == null || value.isEmpty) {
                          //                                                             return 'Please amount';
                          //                                                           }
                          //                                                           return null;
                          //                                                         },
                          //                                                         style: const TextStyle(height: 1),
                          //                                                         cursorOpacityAnimates: true,
                          //                                                         cursorWidth: 1,
                          //                                                         cursorColor: Colors.black,
                          //                                                         decoration: InputDecoration(
                          //                                                           contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                          //                                                           //labelStyle: const TextStyle(color: Colors.black54),
                          //                                                           hintText: 'Amount',
                          //                                                           filled: nqrdata.isDynamic,
                          //                                                           fillColor: AppColors.lightGrey,
                          //                                                           hintStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.grey700),

                          //                                                           border: OutlineInputBorder(borderSide: BorderSide(width: 1.w, color: AppColors.formGrey), borderRadius: BorderRadius.circular(8.r)),
                          //                                                           focusedBorder: OutlineInputBorder(
                          //                                                             borderRadius: BorderRadius.circular(8.r),
                          //                                                             borderSide: BorderSide(color: AppColors.appGold),
                          //                                                           ),
                          //                                                         ),
                          //                                                       ),
                          //                                                       SizedBox(
                          //                                                         height: 30,
                          //                                                       ),
                          //                                                       SizedBox(
                          //                                                           width: displaySize.width * 0.7,
                          //                                                           child: ElevatedButton(
                          //                                                               style: ElevatedButton.styleFrom(elevation: 0, padding: const EdgeInsets.symmetric(vertical: 14), backgroundColor: AppColors.appGold, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                          //                                                               onPressed: () async {
                          //                                                                 if (!_formKey.currentState!.validate()) {
                          //                                                                   return;
                          //                                                                 }
                          //                                                                 navigateBack(ctx);

                          //                                                                 setState(() {
                          //                                                                   _request = makeNQRPayment(
                          //                                                                     context,
                          //                                                                     data: nqrdata,
                          //                                                                   );
                          //                                                                 });

                          //                                                                 await _request;

                          //                                                                 // showTxConfirmationAlert(
                          //                                                                 //   context,
                          //                                                                 //   type: TransactionType.data,
                          //                                                                 // ),
                          //                                                               },
                          //                                                               child: Text(
                          //                                                                 'Make Payment',
                          //                                                                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.whiteA700),
                          //                                                               )))
                          //                                                     ]),
                          //                                               )));
                          //                                     });
                          //                               } else {
                          //                                 sendErrorMessage(
                          //                                     "Error",
                          //                                     "NQR Platform not suported",
                          //                                     context);
                          //                               }
                          //                             }
                          //                           }
                          //                         },
                          //                         controller:
                          //                             _scannerController,
                          //                       ),
                          //                     ),
                          //                   ],
                          //                 )),
                          //           ],
                          //         ),
                          //       );
                          //     });
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
            ],
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

// List<UserBankDetails> ResUser = [
//   UserBankDetails(
//       bankCode: "222",
//       channelCode: "89292",
//       kycLevel: "1",
//       accountNumber: "2089988434",
//       accountName: "Adubuola Femi"),
//   UserBankDetails(
//       bankCode: "222",
//       channelCode: "89292",
//       kycLevel: "1",
//       accountNumber: "1111111111",
//       accountName: "Adubuola Femi")
// ];
