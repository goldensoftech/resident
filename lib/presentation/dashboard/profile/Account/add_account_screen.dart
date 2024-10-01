import 'package:resident/app_export.dart';
import 'package:resident/constants/api.dart';

class AddAccountScreen extends StatefulWidget {
  const AddAccountScreen({super.key});

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen>
    with CustomAppBar, CustomAlerts, ErrorSnackBar {
  Future<void>? _request;
  UserBankDetails? bankDetails;
  Bank? selectedBank;
  bool isReadyToCheck = false;
  final TextEditingController _bankController = TextEditingController();
  TextEditingController _accountNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    //  getUserBanks(context);
    super.initState();
  }

  validateCustomer(context) async {
    FocusScope.of(context).unfocus();
    bankDetails = await TransactionBackend().fetchBankDetails(context,
        accountNumber: _accountNumberController.text,
        bankNumber: selectedBank!.code);
    setState(() {
      bankDetails;
    });
  }

  addBankDetails(context) async {
    await TransactionBackend().addBankDetails(context,
        userBankDetails: bankDetails, bankCode: selectedBank!.code);
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
              backgroundColor: AppColors.whiteA700,
              appBar: customAppBar(title: "Add Bank Account"),
              body: Form(
                key: _formKey,
                child: ListView(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  children: [
                    Text(
                      'Bank',
                      style:
                          TextStyle(color: AppColors.baseBlack, fontSize: 12),
                    ),
                    TextFormField(
                      controller: _bankController,
                      readOnly: true,
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            backgroundColor: AppColors.whiteA700,
                            enableDrag: true,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10))),
                            builder: (context) {
                              // print("lenght of tiles ${dataPlans.length}");
                              return Container(
                                color: AppColors.whiteA700,
                                constraints: BoxConstraints(
                                    maxHeight:
                                        MediaQuery.of(context).size.height *
                                            .96),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Scaffold(
                                  backgroundColor: AppColors.whiteA700,
                                  appBar: profileAppBar(
                                      bgColor: AppColors.whiteA700,
                                      title: "Choose Bank"),
                                  body: Column(
                                    children: [
                                      // Padding(
                                      //   padding: const EdgeInsets.symmetric(
                                      //       horizontal: 10.0),
                                      //   child: Row(
                                      //     //  mainAxisAlignment: MainAxisAlignment.start,
                                      //     crossAxisAlignment:
                                      //         CrossAxisAlignment.center,
                                      //     children: [
                                      //       IconButton(
                                      //           onPressed: () =>
                                      //               navigateBack(context),
                                      //           icon:
                                      //               Icon(Icons.cancel_outlined)),
                                      //       Expanded(
                                      //         child: Container(
                                      //           alignment: Alignment.center,
                                      //           //width: double.infinity,
                                      //           child: Text(
                                      //             "Choose Bank",
                                      //             textAlign: TextAlign.center,
                                      //             style: TextStyle(
                                      //                 fontSize: 16,
                                      //                 color: AppColors.baseBlack,
                                      //                 fontWeight:
                                      //                     FontWeight.w600),
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),

                                      Divider(
                                        color: AppColors.grey200,
                                        thickness: 1,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: TextFormField(
                                          onChanged: (value) {
                                            setState(() {});
                                          },
                                          style: const TextStyle(height: 1),
                                          cursorOpacityAnimates: true,
                                          cursorWidth: 1,
                                          cursorColor: Colors.black,
                                          decoration: InputDecoration(
                                            filled: true,
                                            fillColor: AppColors.lightGrey,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 0,
                                                    horizontal: 12),
                                            //labelStyle: const TextStyle(color: Colors.black54),
                                            hintText: 'Search',
                                            hintStyle: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.grey700),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide.none,
                                                borderRadius:
                                                    BorderRadius.circular(8.r)),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 10,
                                      ),

                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Scrollbar(
                                            radius: const Radius.circular(5),
                                            child: ListView.separated(
                                                itemCount:
                                                    DummyData().bankList.length,
                                                physics: const ScrollPhysics(),
                                                separatorBuilder:
                                                    (BuildContext context,
                                                            int index) =>
                                                        Divider(
                                                            height: 1,
                                                            color: AppColors
                                                                .grey200),
                                                itemBuilder: (context, index) {
                                                  final data = DummyData()
                                                      .bankList[index];
                                                  Bank newBank = Bank(
                                                      name: data['name'],
                                                      logoUrl: data['url'],
                                                      code: data['code']);
                                                  return ListTile(
                                                    tileColor:
                                                        AppColors.whiteA700,
                                                    contentPadding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            vertical: 10),
                                                    onTap: () {
                                                      setState(() {
                                                        selectedBank = newBank;
                                                        _bankController.text =
                                                            newBank.name;
                                                        _accountNumberController
                                                            .text = "";
                                                      });
                                                      navigateBack(context);
                                                    },
                                                    leading: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: AppColors
                                                            .grey200, // Background color
                                                      ),
                                                      child: ClipOval(
                                                        child:
                                                            newBank.logoUrl !=
                                                                    null
                                                                ? Image.network(
                                                                    newBank
                                                                        .logoUrl!,
                                                                    height: 40,
                                                                    width: 40,
                                                                    fit: BoxFit
                                                                        .cover, // Ensures the image covers the container
                                                                    filterQuality:
                                                                        FilterQuality
                                                                            .high,
                                                                  )
                                                                : Image.asset(
                                                                    logoPng,
                                                                    height: 40,
                                                                    width: 40,
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    filterQuality:
                                                                        FilterQuality
                                                                            .high,
                                                                  ),
                                                      ),
                                                    ),
                                                    title: Text(
                                                      newBank.name,
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  );
                                                }),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      onChanged: (value) {
                        setState(() {});
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a bank';
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
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 12),
                          //labelStyle: const TextStyle(color: Colors.black54),
                          hintText: 'Select bank',
                          prefixIcon: selectedBank != null
                              ? Container(
                                  margin: const EdgeInsets.only(
                                    left: 10,
                                    top: 5,
                                    bottom: 5,
                                    right: 5,
                                  ),
                                  height: 10,
                                  width: 10,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        AppColors.grey200, // Background color
                                  ),
                                  child: ClipOval(
                                    child: selectedBank!.logoUrl != null
                                        ? Image.network(
                                            selectedBank!.logoUrl!,
                                            // height: 20,
                                            // width: 20,
                                            fit: BoxFit
                                                .cover, // Ensures the image covers the container
                                            filterQuality: FilterQuality.high,
                                          )
                                        : Image.asset(
                                            logoPng,
                                            // height: 20,
                                            // width: 20,
                                            fit: BoxFit.cover,
                                            filterQuality: FilterQuality.high,
                                          ),
                                  ),
                                )
                              : null,
                          hintStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.grey700),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(8.r)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide.none,
                          ),
                          suffixIcon: SvgPicture.asset(
                            arrowDown,
                            height: 14,
                            width: 14,
                            fit: BoxFit.scaleDown,
                            color: AppColors.grey700,
                            //size: 18,
                          )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Account Number',
                      style:
                          TextStyle(color: AppColors.baseBlack, fontSize: 12),
                    ),
                    TextFormField(
                      controller: _accountNumberController,
                      keyboardType: TextInputType.number,
                      maxLength: 10,
                      onChanged: (value) {
                        setState(() {
                          if (value.length == 10 && selectedBank != null) {
                            isReadyToCheck = true;
                          } else {
                            isReadyToCheck = false;
                          }
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter phone number';
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
                        hintText: 'Recipient Number',
                        hintStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.grey700),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 1.w, color: AppColors.grey50),
                            borderRadius: BorderRadius.circular(8.r)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(color: AppColors.appGold),
                        ),
                        // suffix: GestureDetector(
                        //     onTap: () {},
                        //     child: Row(
                        //       crossAxisAlignment: CrossAxisAlignment.center,
                        //       mainAxisAlignment: MainAxisAlignment.end,
                        //       children: [
                        //         Text(
                        //           "Paste",
                        //           style: TextStyle(
                        //               fontWeight: FontWeight.w600,
                        //               color: AppColors.appGold),
                        //         ),
                        //         SizedBox(
                        //           width: 5,
                        //         ),
                        //         Icon(Icons.paste_rounded,
                        //             size: 16, color: AppColors.appGold)
                        //       ],
                        //     ))
                      ),
                    ),
                    // if (bankDetails != null && isReadyToCheck)
                    //   Text(bankDetails!.accountName.toUpperCase(),
                    //       style: TextStyle(
                    //           color: Colors.green,
                    //           fontWeight: FontWeight.w600)),
                    const SizedBox(
                      height: 70,
                    ),
                    SizedBox(
                      width: displaySize.width * 0.7,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: isReadyToCheck
                                ? AppColors.appGold
                                : AppColors.grey200,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),

                        onPressed: isReadyToCheck
                            ? () async {
                                FocusScope.of(context).unfocus();

                                if (!_formKey.currentState!.validate()) {
                                  return;
                                }

                                setState(() {
                                  _request = validateCustomer(context);
                                });
                                await _request;
                                if (bankDetails != null) {
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
                                        // print("lenght of tiles ${dataPlans.length}");
                                        return Container(
                                            color: AppColors.whiteA700,
                                            constraints: BoxConstraints(
                                                maxHeight:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.5),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10.0, vertical: 10),
                                            child: Scrollbar(
                                              radius: const Radius.circular(5),
                                              child: ListView(
                                                children: [
                                                  const Align(
                                                    child: Text(
                                                      "Account Information",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 18),
                                                    ),
                                                  ),
                                                  Card(
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10),
                                                    color: AppColors.whiteA700,
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10,
                                                          vertical: 10),
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Account Number: ${bankDetails!.accountNumber}",
                                                            style: const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            "Account Name: ${bankDetails!.accountName}",
                                                            style: const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          Text(
                                                            "Bank Name: ${selectedBank!.name}",
                                                            style: const TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .info_outline_rounded,
                                                        color:
                                                            AppColors.appGold,
                                                        size: 14,
                                                      ),
                                                      const SizedBox(width: 5),
                                                      Expanded(
                                                        child: Text(
                                                          'Kindly ensure the bank information tallies with the Resident registered account information.',
                                                          // softWrap: true,
                                                          // overflow: TextOverflow
                                                          //     .ellipsis,
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: AppColors
                                                                  .appGold),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 40),
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
                                                        navigateBack(context);
                                                        setState(() {
                                                          _request =
                                                              addBankDetails(
                                                                  context);
                                                        });
                                                        await _request;
                                                        if (bankDetails !=
                                                            null) {}
                                                      },
                                                      child: Text(
                                                        'Add Account',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: AppColors
                                                                .whiteA700),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ));
                                      });
                                }
                              }
                            : null,

                        // showTxConfirmationAlert(
                        //   context,
                        //   type: TransactionType.data,
                        // ),

                        child: Text(
                          'Continue',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.whiteA700),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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
