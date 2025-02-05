// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:resident/app_export.dart';

class BuyDataScreen extends StatefulWidget {
  const BuyDataScreen({super.key});

  @override
  State<BuyDataScreen> createState() => _BuyDataScreenState();
}

class _BuyDataScreenState extends State<BuyDataScreen>
    with CustomAppBar, CustomAlerts, ErrorSnackBar {
  int? selectedNetworkIndex;
  int? selectedAmountIndex;
  DataItem? selectedPlan;

  List<DataItem> dataPlans = [];
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _planController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _contactPhoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final FlutterContactPickerPlus _contactPicker = FlutterContactPickerPlus();
  Contact? _contact;
  Future<void>? _request;
  OrderItem? order;
  final _formKey = GlobalKey<FormState>();

  Future<void> getDataPlans() async {
    final items = await TransactionBackend().getNetworkDataPlans(context,
        network: DummyData().networkItems[selectedNetworkIndex!]['type'],
        id: DummyData().networkItems[selectedNetworkIndex!]['ids']['data']);
    dataPlans.clear();
    dataPlans = items;
    setState(() {});
  }

  Future<void> validateCustomer(context) async {
    order = await TransactionBackend().validateCustomerPayment(context,
        customerId: _phoneController.text, paymentCode: selectedPlan!.code);
    setState(() {
      order;
    });
  }

  @override
  void initState() {
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
                appBar: customAppBar(title: "Buy Data"),
                backgroundColor: AppColors.whiteA700,
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
                            fontWeight: FontWeight.w400,
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
                            itemBuilder: (ctx, index) {
                              final network = DummyData().networkItems[index];
                              return GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    selectedNetworkIndex = index;

                                    _amountController.text = "";
                                    _planController.text = "";
                                    _request = getDataPlans();
                                  });
                                  await _request;
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5),
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
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {});
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
                                borderSide: BorderSide(
                                    width: 1.w, color: AppColors.grey50),
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
                                    _phoneController.text = _contact!
                                        .phoneNumbers!.first
                                        .toString();
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
                      // GestureDetector(
                      //   onTap: () {},
                      //   child: SizedBox(
                      //     child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.start,
                      //         children: [
                      //           SvgPicture.asset(
                      //             personIcon,
                      //           ),
                      //           const SizedBox(
                      //             width: 10,
                      //           ),
                      //           Text(
                      //             'Select Beneficiary',
                      //             style: TextStyle(color: AppColors.baseBlack),
                      //           ),
                      //         ]),
                      //   ),
                      // ),
                      // const SizedBox(
                      //   height: 30,
                      // ),
                      dataPlans.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Select Data Subscription',
                                  style: TextStyle(color: AppColors.baseBlack),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  controller: _planController,
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
                                          // print("lenght of tiles ${dataPlans.length}");
                                          return Container(
                                            color: AppColors.whiteA700,
                                            constraints: BoxConstraints(
                                                maxHeight:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.8),
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
                                                      "Select data plan",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: AppColors
                                                              .baseBlack,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  ListView.separated(
                                                      itemCount:
                                                          dataPlans.length,
                                                      shrinkWrap: true,
                                                      physics:
                                                          const ScrollPhysics(),
                                                      separatorBuilder:
                                                          (BuildContext context,
                                                                  int index) =>
                                                              Divider(
                                                                  height: 1,
                                                                  color: AppColors
                                                                      .grey200),
                                                      itemBuilder:
                                                          (context, index) {
                                                        final data =
                                                            dataPlans[index];
                                                        return ListTile(
                                                          tileColor: AppColors
                                                              .whiteA700,
                                                          contentPadding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 10),
                                                          onTap: () {
                                                            setState(() {
                                                              selectedPlan =
                                                                  data;
                                                              _planController
                                                                      .text =
                                                                  data.title;
                                                              _amountController
                                                                      .text =
                                                                  data.amount
                                                                      .toStringAsFixed(
                                                                          2);
                                                            });
                                                            navigateBack(
                                                                context);
                                                          },
                                                          leading: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        40),
                                                            child: Image.asset(
                                                                DummyData().networkItems[
                                                                        selectedNetworkIndex!]
                                                                    ['url'],
                                                                height: 40,
                                                                filterQuality:
                                                                    FilterQuality
                                                                        .high,
                                                                width: 40,
                                                                fit: BoxFit
                                                                    .contain),
                                                          ),
                                                          title: Text(
                                                            data.title,
                                                            style: const TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
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
                                      return 'Please select a plan';
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
                                          const EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 12),
                                      //labelStyle: const TextStyle(color: Colors.black54),
                                      hintText: 'Select plan',
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
                              ],
                            )
                          : const SizedBox.shrink(),

                      selectedPlan != null
                          ? Column(
                              children: [
                                TextFormField(
                                  controller: _amountController,
                                  readOnly: true,
                                  onChanged: (value) {
                                    setState(() {});
                                  },
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select a plan';
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
                                        color: AppColors.grey200),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius:
                                            BorderRadius.circular(8.r)),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                      borderSide: BorderSide.none,
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
                        if (!_formKey.currentState!.validate() ||
                            selectedPlan == null) {
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
                                                            "Data Purchase",
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
                                                          selectedPlan!
                                                              .network!,
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
                                                                  surcharge: order!
                                                                      .surcharge,
                                                                  customerEmail: AuthBackend.isLoggedIn()
                                                                      ? ResponseData
                                                                          .loginResponse!
                                                                          .user!
                                                                          .userName!
                                                                      : _emailController
                                                                          .text,
                                                                  amount: double.parse(
                                                                      _amountController
                                                                          .text),
                                                                  customerMobile:
                                                                      _phoneController
                                                                          .text,
                                                                  serviceId: selectedPlan!
                                                                      .code
                                                                      .toString(),
                                                                  serviceName:
                                                                      selectedPlan!
                                                                          .title,
                                                                  payerName: AuthBackend.isLoggedIn()
                                                                      ? "${ResponseData.loginResponse!.user!.lastName!} ${ResponseData.loginResponse!.user!.firstName!}"
                                                                      : _nameController
                                                                          .text,
                                                                  paymentCode:
                                                                      order!
                                                                          .code,
                                                                  transactionType:
                                                                      TransactionType.airtime_data),
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
