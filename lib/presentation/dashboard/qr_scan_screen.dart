import 'dart:ui';

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
  void initState() {
    getUserBanks(context);
    super.initState();
  }

  void getUserBanks(context) async {
    if (ResponseData.userBanks.isEmpty) {
      ResponseData.userBanks = await TransactionBackend().getUserBanks(context);
    }
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
                    onTap: () {
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
                                        itemCount: ResUser.length,
                                        shrinkWrap: true,
                                        physics: const ScrollPhysics(),
                                        separatorBuilder:
                                            (BuildContext context, int index) =>
                                                Divider(
                                                    height: 1,
                                                    color: AppColors.grey200),
                                        itemBuilder: (ctx, index) {
                                          final data = ResUser[index];
                                          return ListTile(
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
                                              data.accountNumber.toString(),
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            subtitle: Text(
                                              "${data.accountName} -${data.bankName}",
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          );
                                        }),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        navigatePush(
                                            context, const AddAccountScreen());
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
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(
                                      onTap: () async {
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
                                      child: Icon(Icons.content_copy_rounded,
                                          color: AppColors.appGold, size: 16),
                                    )
                                  ],
                                ),
                                Text(
                                  selectedAccount!.bankName.toString(),
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.baseBlack),
                                ),
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
                          showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (ctx) {
                                return BackdropFilter(
                                  filter:
                                      ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                  child: SimpleDialog(
                                    insetPadding: EdgeInsets.zero,
                                    contentPadding: EdgeInsets.zero,

                                    //   children: [],
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.r)),
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
                                                          color: AppColors
                                                              .black900),
                                                    ),
                                                    const Spacer(),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
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

List<UserBankDetails> ResUser = [
  UserBankDetails(
      bankName: "Uba", accountNumber: 2089988434, accountName: "Adubuola Femi"),
  UserBankDetails(
      bankName: "Kuda", accountNumber: 1111111111, accountName: "Adubuola Femi")
];
