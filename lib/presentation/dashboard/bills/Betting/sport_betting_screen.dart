// ignore_for_file: use_build_context_synchronously
import 'dart:ui';

import 'package:resident/app_export.dart';

class SportBettingScreen extends StatefulWidget {
  const SportBettingScreen({super.key});

  @override
  State<SportBettingScreen> createState() => _SportBettingScreenState();
}

class _SportBettingScreenState extends State<SportBettingScreen>
    with CustomAlerts, ErrorSnackBar, CustomAppBar {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _platformController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  BettingDataItem? selectedBet;
  int? selectedBillerIndex;
  OrderItem? order;
  Future<void>? _request;
  // void getBettingPlatforms() async {
  //   if (ResponseData.bettingPlatforms.isEmpty) {
  //     ResponseData.bettingPlatforms =
  //         await TransactionBackend().getBettingPlatforms(context);
  //   }
  // }

  Future<void> validateCustomer(context) async {
    order = await TransactionBackend().validateCustomerPayment(context,
        customerId: _idController.text,
        paymentCode: selectedBet!.code.toString());

    setState(() {
      order;
    });
  }

  Future<void> getBettingInfo(int id) async {
    selectedBet =
        await TransactionBackend().getBettingPlatformDetails(context, id: id);
    setState(() {
      selectedBet;
    });
  }

  @override
  void initState() {
    // getBettingPlatforms();
    super.initState();
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
                  appBar: customAppBar(title: "Sport Betting"),
                  body: Form(
                    key: _formKey,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      children: [
                        Text(
                          'Betting Details',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.baseBlack),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _platformController,
                          readOnly: true,
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
                                            MediaQuery.of(context).size.height *
                                                0.8),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                    ),
                                    child: Scrollbar(
                                      radius: const Radius.circular(5),
                                      child: ListView(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            width: double.infinity,
                                            child: Text(
                                              "Select a betting platform",
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
                                              itemCount: DummyData()
                                                  .bettingItems
                                                  .length,
                                              shrinkWrap: true,
                                              physics: const ScrollPhysics(),
                                              separatorBuilder: (BuildContext
                                                          context,
                                                      int index) =>
                                                  Divider(
                                                      height: 1,
                                                      color: AppColors.grey200),
                                              itemBuilder: (ctx, index) {
                                                final data = DummyData()
                                                    .bettingItems[index];
                                                return ListTile(
                                                  tileColor:
                                                      AppColors.whiteA700,
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 10),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10)),
                                                  onTap: () {
                                                    setState(() {
                                                      _platformController.text =
                                                          data['type'];
                                                      _idController.text = "";

                                                      _request = getBettingInfo(
                                                          data['ids']);
                                                    });
                                                    navigateBack(context);
                                                    _request;
                                                  },
                                                  leading: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            40),
                                                    // width: 40,
                                                    // height: 40,
                                                    // decoration: BoxDecoration(
                                                    //     shape: BoxShape.circle,
                                                    //     color: AppColors
                                                    //         .whiteA700),
                                                    child: Image.asset(
                                                        data['url'],
                                                        width: 40,
                                                        height: 40,
                                                        fit: BoxFit.contain),
                                                  ),
                                                  title: Text(
                                                    data['type'],
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                );
                                              }),
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
                              return 'Please select betting platform';
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
                              hintText: 'Betting Platform',
                              filled: true,
                              fillColor: AppColors.lightGrey,
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
                        if (selectedBet != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: _idController,
                                onChanged: (value) {
                                  setState(() {});
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter user Id';
                                  }
                                  return null;
                                },
                                style: const TextStyle(height: 1),
                                cursorOpacityAnimates: true,
                                cursorWidth: 1,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  // filled: true,
                                  // fillColor: AppColors.lightGrey,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 12),
                                  //labelStyle: const TextStyle(color: Colors.black54),
                                  hintText: 'Enter User ID',
                                  hintStyle: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.grey700),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1.w,
                                          color: AppColors.formGrey),
                                      borderRadius: BorderRadius.circular(8.r)),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide:
                                        BorderSide(color: AppColors.appGold),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Amount',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.baseBlack,
                                    fontSize: 14),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
                                controller: _amountController,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {});
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter amount';
                                  }
                                  return null;
                                },
                                style: const TextStyle(height: 1),
                                cursorOpacityAnimates: true,
                                cursorWidth: 1,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  // prefix: Text(
                                  //   "NGN",
                                  //   style: TextStyle(
                                  //       fontSize: 16,
                                  //       fontWeight: FontWeight.w400,
                                  //       color: AppColors.baseBlack),
                                  // ),
                                  // filled: true,
                                  // fillColor: AppColors.lightGrey,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0, horizontal: 12),
                                  //labelStyle: const TextStyle(color: Colors.black54),
                                  hintText: 'Amount',
                                  prefix: Text(
                                    "$ngnIcon ",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.black900),
                                  ),
                                  hintStyle: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.grey700),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 1.w,
                                          color: AppColors.formGrey),
                                      borderRadius: BorderRadius.circular(8.r)),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    borderSide:
                                        BorderSide(color: AppColors.appGold),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              if (!AuthBackend.isLoggedIn())
                                Column(
                                  children: [
                                    TextFormField(
                                      controller: _nameController,
                                      keyboardType: TextInputType.emailAddress,
                                      onChanged: (value) {
                                        setState(() {});
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your name';
                                        }
                                        return null;
                                      },
                                      style: const TextStyle(height: 1),
                                      cursorOpacityAnimates: true,
                                      cursorWidth: 1,
                                      cursorColor: Colors.black,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 0, horizontal: 12),
                                        //labelStyle: const TextStyle(color: Colors.black54),
                                        hintText: 'Payer Name',

                                        hintStyle: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.grey700),

                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1.w,
                                                color: AppColors.formGrey),
                                            borderRadius:
                                                BorderRadius.circular(8.r)),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          borderSide: BorderSide(
                                              color: AppColors.appGold),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      controller: _phoneController,
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        setState(() {});
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your phone number';
                                        }
                                        return null;
                                      },
                                      style: const TextStyle(height: 1),
                                      cursorOpacityAnimates: true,
                                      cursorWidth: 1,
                                      cursorColor: Colors.black,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 0, horizontal: 12),
                                        //labelStyle: const TextStyle(color: Colors.black54),
                                        hintText: 'Payer Number',

                                        hintStyle: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.grey700),

                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1.w,
                                                color: AppColors.formGrey),
                                            borderRadius:
                                                BorderRadius.circular(8.r)),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          borderSide: BorderSide(
                                              color: AppColors.appGold),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextFormField(
                                      controller: _emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      onChanged: (value) {
                                        setState(() {});
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your email';
                                        }
                                        return null;
                                      },
                                      style: const TextStyle(height: 1),
                                      cursorOpacityAnimates: true,
                                      cursorWidth: 1,
                                      cursorColor: Colors.black,
                                      decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 0, horizontal: 12),
                                        //labelStyle: const TextStyle(color: Colors.black54),
                                        hintText: 'Email Address',

                                        hintStyle: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: AppColors.grey700),

                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 1.w,
                                                color: AppColors.formGrey),
                                            borderRadius:
                                                BorderRadius.circular(8.r)),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          borderSide: BorderSide(
                                              color: AppColors.appGold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
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
                          if (selectedBet == null) {
                            sendErrorMessage("Error",
                                "Please select a betting platform", context);
                            return;
                          }
                          setState(() {
                            _request = validateCustomer(context);
                          });
                          await _request;
                          if (order != null) {
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
                                            height: displaySize.height * .6,
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
                                                              "Betting",
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
                                                              'User Id',
                                                              style: TextStyle(
                                                                  color: AppColors
                                                                      .grey500,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ),
                                                            Text(
                                                              _idController
                                                                  .text,
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
                                                            'Betting Platform',
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .grey500,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                          Text(
                                                            selectedBet!.name,
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
                                                              "$ngnIcon ${UtilFunctions.formatAmount(double.parse(_amountController.text))}",
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
                                                          navigateBack(context);
                                                          navigatePush(
                                                              context,
                                                              PaymentGatewayScreen(
                                                                details: PaymentDetails(
                                                                    customerId: order!
                                                                        .customerId,
                                                                    surcharge: order!
                                                                        .surcharge,
                                                                    customerEmail: AuthBackend.isLoggedIn()
                                                                        ? ResponseData
                                                                            .loginResponse!
                                                                            .user!
                                                                            .userName!
                                                                        : _emailController.text
                                                                            .trim(),
                                                                    amount: double.parse(
                                                                        _amountController
                                                                            .text),
                                                                    customerMobile: AuthBackend.isLoggedIn()
                                                                        ? ResponseData
                                                                            .loginResponse!
                                                                            .user!
                                                                            .phoneNumber!
                                                                        : _phoneController.text
                                                                            .trim(),
                                                                    payerName: AuthBackend.isLoggedIn()
                                                                        ? "${ResponseData.loginResponse!.user!.lastName!} ${ResponseData.loginResponse!.user!.firstName!}"
                                                                        : _nameController
                                                                            .text,
                                                                    serviceId:
                                                                        selectedBet!
                                                                            .code,
                                                                    serviceName:
                                                                        selectedBet!
                                                                            .name,
                                                                    paymentCode:
                                                                        order!.code,
                                                                    transactionType: TransactionType.betting),
                                                              ));
                                                          // _request;
                                                          // showSuccessAlert(context,
                                                          //     title:
                                                          //         "Data Purchase",
                                                          //     goToPage:
                                                          //         Dashboard());
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
        ));
  }
}
