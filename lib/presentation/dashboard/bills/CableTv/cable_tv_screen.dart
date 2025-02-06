// ignore_for_file: use_build_context_synchronously

import 'dart:ui';

import 'package:resident/app_export.dart';

class CableTvScreen extends StatefulWidget {
  const CableTvScreen({super.key});

  @override
  State<CableTvScreen> createState() => _CableTvScreenState();
}

class _CableTvScreenState extends State<CableTvScreen>
    with CustomAlerts, CustomAppBar {
  Future<void>? _request;
  int? selectedNetworkIndex;

  final _formKey = GlobalKey<FormState>();
  List<DataItem> tvPlans = [];
  DataItem? selectedPlan;
  OrderItem? order;
  final TextEditingController _billerController = TextEditingController();
  final TextEditingController _meterTypeController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  Future<void> getTvPlans(String network, int id) async {
    final items = await TransactionBackend()
        .getNetworkDataPlans(context, network: network, id: id);
    tvPlans.clear();
    tvPlans = items;
    setState(() {
      tvPlans;
    });
  }

  Future<void> validateCustomer(context) async {
    order = await TransactionBackend().validateCustomerPayment(context,
        customerId: _idController.text,
        paymentCode: selectedPlan!.code.toString());
    setState(() {
      order;
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
                appBar: customAppBar(title: "Cable Tv"),
                backgroundColor: AppColors.whiteA700,
                body: Form(
                  key: _formKey,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    children: [
                      Text(
                        'Tv Details',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppColors.baseBlack),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _billerController,
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
                                              0.5),
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
                                            "Select a provider",
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
                                                .cableTvItems
                                                .length,
                                            shrinkWrap: true,
                                            separatorBuilder:
                                                (BuildContext context,
                                                        int index) =>
                                                    Divider(
                                                        height: 1,
                                                        color:
                                                            AppColors.grey200),
                                            itemBuilder: (ctx, index) {
                                              final data = DummyData()
                                                  .cableTvItems[index];
                                              return ListTile(
                                                tileColor: AppColors.baseWhite,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                onTap: () {
                                                  tvPlans.clear();
                                                  setState(() {
                                                    selectedNetworkIndex =
                                                        index;
                                                    selectedPlan = null;
                                                    _billerController.text =
                                                        data['type'];
                                                    _idController.text = "";
                                                    _amountController.text = "";

                                                    _meterTypeController.text =
                                                        "";
                                                    _request = getTvPlans(
                                                        data['type'],
                                                        data['id']);
                                                  });
                                                  navigateBack(context);
                                                  _request;
                                                },
                                                leading: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                  child: Image.asset(
                                                      data['logo'],
                                                      height: 40,
                                                      width: 40,
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
                            return 'Please select a provider';
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
                            hintText: 'Select Electricity Biller',
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
                      if (tvPlans.isNotEmpty)
                        TextFormField(
                          controller: _meterTypeController,
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
                                              itemCount: tvPlans.length,
                                              shrinkWrap: true,
                                              separatorBuilder: (BuildContext
                                                          context,
                                                      int index) =>
                                                  Divider(
                                                      height: 1,
                                                      color: AppColors.grey200),
                                              itemBuilder: (ctx, index) {
                                                final type = tvPlans[index];
                                                return ListTile(
                                                  tileColor:
                                                      AppColors.whiteA700,
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          vertical: 10),
                                                  onTap: () {
                                                    setState(() {
                                                      selectedPlan = type;
                                                      _amountController.text =
                                                          type.amount
                                                              .toString();
                                                      _meterTypeController
                                                          .text = type.title;
                                                    });
                                                    navigateBack(context);
                                                  },
                                                  leading: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            40),
                                                    child: Image.asset(
                                                        DummyData().cableTvItems[
                                                                selectedNetworkIndex!]
                                                            ['logo'],
                                                        height: 40,
                                                        filterQuality:
                                                            FilterQuality.high,
                                                        width: 40,
                                                        fit: BoxFit.contain),
                                                  ),
                                                  title: Text(
                                                    type.title,
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
                              hintText: 'Select Plan',
                              hintStyle: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.grey700),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(8.r)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                  borderSide: BorderSide.none),
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
                      if (tvPlans.isNotEmpty && selectedPlan != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 12),
                                //labelStyle: const TextStyle(color: Colors.black54),
                                hintText: 'Amount',
                                prefix: Text(
                                  "$ngnIcon ",
                                  style: TextStyle(color: AppColors.grey700),
                                ),
                                hintStyle: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.grey200),

                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 1.w, color: AppColors.formGrey),
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
                            TextFormField(
                              controller: _idController,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {});
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter decoder id';
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
                                  hintText: 'Enter Decoder Id',
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
                                  )),
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
                              borderRadius: BorderRadius.circular(12))),
                      onPressed: () async {
                        if (!_formKey.currentState!.validate() ||
                            selectedPlan == null) {
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
                                                            "Cable Tv",
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
                                                            'Decoder No',
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .grey500,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700),
                                                          ),
                                                          Text(
                                                            _idController.text,
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
                                                          'Account Name',
                                                          style: TextStyle(
                                                              color: AppColors
                                                                  .grey500,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                        SizedBox(
                                                          height: 20,
                                                          width: displaySize
                                                                  .width *
                                                              .6,
                                                          child: Text(
                                                            order!
                                                                .customerName!,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            textAlign:
                                                                TextAlign.right,
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
                                                                          .text
                                                                          .trim(),
                                                                  amount: double.parse(
                                                                      _amountController
                                                                          .text),
                                                                  customerMobile: AuthBackend.isLoggedIn()
                                                                      ? ResponseData
                                                                          .loginResponse!
                                                                          .user!
                                                                          .phoneNumber!
                                                                      : _phoneController
                                                                          .text
                                                                          .trim(),
                                                                  payerName: AuthBackend.isLoggedIn()
                                                                      ? "${ResponseData.loginResponse!.user!.lastName!} ${ResponseData.loginResponse!.user!.firstName!}"
                                                                      : _nameController
                                                                          .text,
                                                                  serviceId: selectedPlan!
                                                                      .code
                                                                      .toString(),
                                                                  serviceName:
                                                                      selectedPlan!.title.toString(),
                                                                  paymentCode: order!.code,
                                                                  transactionType: TransactionType.tv),
                                                            ));
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
