// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:io';
import 'dart:ui';


import 'package:flutter_native_contact_picker/model/contact.dart';
import 'package:resident/app_export.dart';

class BuyAirtimeScreen extends StatefulWidget {
  const BuyAirtimeScreen({super.key});

  @override
  State<BuyAirtimeScreen> createState() => _BuyAirtimeScreenState();
}

class _BuyAirtimeScreenState extends State<BuyAirtimeScreen>
    with CustomAppBar, CustomAlerts, ErrorSnackBar {
      
  int? selectedNetworkIndex;
  int? selectedAmountIndex;
  DataItem? selectedPlan;

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _contactPhoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final FlutterNativeContactPicker _contactPicker = FlutterNativeContactPicker();

  Contact? _contact;
  OrderItem? order;
  List<DataItem> dataPlans = [];
  Future<void>? _request;
  final _formKey = GlobalKey<FormState>();

  Future<void> getDataPlans() async {
    final items = await TransactionBackend().getNetworkDataPlans(context,
        network: DummyData().networkItems[selectedNetworkIndex!]['type'],
        id: DummyData().networkItems[selectedNetworkIndex!]['ids']['airtime']);
    dataPlans.clear();
    dataPlans = items;
    setState(() {});
  }

  @override
  void initState() {
    //getDataPlans();
    // if(dataPlans.isNotEmpty){
    //   selected
    // }
    super.initState();
  }

  Future<void> validateCustomer(context) async {
    order = await TransactionBackend().validateCustomerPayment(
      context,
      customerId: _phoneController.text,
      paymentCode: DummyData().networkItems[selectedNetworkIndex!]
          ['airtimeCode'],
    );
    setState(() {
      order;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  
    
     SafeArea(
      top: false,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
                backgroundColor: AppColors.whiteA700,
               appBar: customAppBar(title: "Buy Airtime"),
                body: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    children: [
                      Text(
                        'Select Provider',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.baseBlack),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 1.5,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 5,
                                    crossAxisCount: 4),
                            itemCount: DummyData().networkItems.length,
                            //scrollDirection: Axis.horizontal,
                            itemBuilder: (ctx, index) {
                              final network = DummyData().networkItems[index];
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedNetworkIndex = index;

                                    _amountController.text = "";
                                    selectedAmountIndex = null;
                                    _request = getDataPlans();
                                  });
                                  _request;
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: selectedNetworkIndex == index
                                          ? AppColors.appGold
                                          : AppColors.lightGrey),
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.asset(network['url'],
                                          filterQuality: FilterQuality.high,
                                          fit: BoxFit.contain,
                                          height: 40,
                                          width: 40),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      TextFormField(
                        controller: _phoneController,
                        onChanged: (value) {
                          setState(() {});
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a phone number';
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
                                borderSide: BorderSide(
                                    width: 1.w, color: AppColors.formGrey),
                                borderRadius: BorderRadius.circular(8.r)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                              borderSide: BorderSide(color: AppColors.appGold),
                            ),
                            suffixIcon: IconButton(
                                onPressed: () async {
                                  Contact? contact =
                                      await _contactPicker.selectContact();
                                  setState(() {
                                    _contact = contact;
                                  });
                                  if (_contact != null) {
                                    _phoneController.text =
                                        _contact!.phoneNumbers!.first.toString();
                                  }
                                },
                                icon: SvgPicture.asset(
                                  contactList,
                                  color: AppColors.appGold,
                                  //size: 18,
                                ))),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      dataPlans.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Select Amount',
                                  style: TextStyle(
                                      color: AppColors.black900,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 10),
                                GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            childAspectRatio: 2.7,
                                            crossAxisSpacing: 10,
                                            mainAxisSpacing: 20,
                                            crossAxisCount: 3),
                                    shrinkWrap: true,
                                    itemCount: dataPlans.length,
                                    itemBuilder: (ctx, index) {
                                      final airtime = dataPlans[index];
                                      bool isSelected =
                                          selectedAmountIndex == index;
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedAmountIndex = index;
                                            selectedPlan = airtime;
                                            _amountController.text =
                                                airtime.amount.toString();
                                          });
                                        },
                                        child: Container(
                                          width: 40,
                                          height: 20,
                                          //padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: isSelected
                                                  ? AppColors.appGold
                                                  : AppColors.whiteA700,
                                              border: Border.all(
                                                  color: isSelected
                                                      ? AppColors.appGold
                                                      : AppColors.neutralGrey),
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                          child: Center(
                                            child: Text(
                                              "NGN ${airtime.amount}",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: isSelected
                                                      ? AppColors.whiteA700
                                                      : AppColors.baseBlack),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                                const SizedBox(
                                  height: 30,
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
                                        borderRadius:
                                            BorderRadius.circular(8.r)),
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
                                        keyboardType:
                                            TextInputType.emailAddress,
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
                                        controller: _contactPhoneController,
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
                                        keyboardType:
                                            TextInputType.emailAddress,
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
                            )
                          : const SizedBox.shrink(),
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
                              borderRadius: BorderRadius.circular(12))),
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        if (selectedNetworkIndex == null) {
                          sendErrorMessage("Network failure",
                              "Please select a network", context);
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
                                          decoration: BoxDecoration(
                                              color: AppColors.whiteA700,
                                              borderRadius:
                                                  BorderRadius.circular(10.r)),
                                          height: displaySize.height * .6,
                                          width: displaySize.width * .9,
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
                                                                FontWeight.w700,
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
                                                            'Transaction Summary',
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .grey500,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                          Text(
                                                            "Airtime Purchase",
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
                                                  ],
                                                ),
                                                Column(
                                                  children: [
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
                                                            'Phone Number',
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .grey500,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                          Text(
                                                            _phoneController
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
                                                      color: AppColors.grey400,
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
                                                          'Network Provider',
                                                          style: TextStyle(
                                                              color: AppColors
                                                                  .grey500,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                        Text(
                                                          DummyData().networkItems[
                                                                  selectedNetworkIndex!]
                                                              ['type'],
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
                                                      color: AppColors.grey400,
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
                                                                  customerEmail: AuthBackend.isLoggedIn()
                                                                      ? ResponseData
                                                                          .loginResponse!
                                                                          .user!
                                                                          .userName!
                                                                      : _emailController
                                                                          .text
                                                                          .trim(),
                                                                  amount: double.parse(
                                                                      _amountController
                                                                          .text),
                                                                  serviceId:
                                                                      selectedPlan!
                                                                          .code
                                                                          .toString(),
                                                                  serviceName:
                                                                      selectedPlan!
                                                                          .title,
                                                                  customerMobile:
                                                                      _phoneController
                                                                          .text,
                                                                  payerName: AuthBackend.isLoggedIn()
                                                                      ? "${ResponseData.loginResponse!.user!.lastName!} ${ResponseData.loginResponse!.user!.firstName!}"
                                                                      : _nameController
                                                                          .text,
                                                                  paymentCode:
                                                                      order!
                                                                          .code,
                                                                  surcharge: order!.surcharge,
                                                                  transactionType: TransactionType.airtime_data),
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
      ),
    );
  
  }
}
