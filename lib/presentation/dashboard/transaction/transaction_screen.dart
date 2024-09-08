// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:resident/app_export.dart';
import 'package:resident/utils/enums.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen>
    with CustomAppBar, CustomAlerts, ErrorSnackBar {
  List<TransactionModel> txHistory = [];
  List<TransactionModel> filteredTxHistory = [];
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();
  @override
  void initState() {
    txHistory = ResponseData.txHistory;
    filteredTxHistory = txHistory;
    super.initState();
  }

  String? dropdownvalue;
  final items = [
    'All',
    'Last 7 Days',
    'Last 30 Days',
    'Last 6 Months',
    'Custom'
  ];
  final _keyForm = GlobalKey<FormState>();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  Future<void> _handleRefresh(
      {required DateTime start, required DateTime end}) async {
    final tx = await TransactionBackend().getTransactionHistory(context,
        email: DummyData.emailAddress, startDate: start, endDate: end);
    filteredTxHistory.clear();
    filteredTxHistory.addAll(tx);
    setState(() {});
  }

  Future<void> _filterTransactions() async {
    DateTime now = DateTime.now();
    if (dropdownvalue == "All") {
      start = now.subtract(const Duration(days: 30));
    } else if (dropdownvalue == "Last 7 Days") {
      start = now.subtract(const Duration(days: 7));
    } else if (dropdownvalue == "Last 30 Days") {
      start = now.subtract(const Duration(days: 30));
    } else if (dropdownvalue == "Last 6 Months") {
      start = now.subtract(const Duration(days: 180));
    } else {}
    await _handleRefresh(start: start, end: end);
  }

  Future<void>? _request;

  DateTime start = DateTime.now().subtract(const Duration(days: 30));

  DateTime end = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Stack(
          children: [
            Scaffold(
                appBar: defaultAppBar(title: "Transactions"),
                backgroundColor: AppColors.whiteA700,
                body: LiquidPullToRefresh(
                  key: _refreshIndicatorKey,
                  onRefresh: () => _handleRefresh(start: start, end: end),
                  color: AppColors.gold100,
                  backgroundColor: AppColors.appGold,
                  showChildOpacityTransition: true,
                  child: Scrollbar(
                    radius: const Radius.circular(5),
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      children: [
                        Container(
                          height: 50,
                          // width: displaySize.width * .3,
                          alignment: Alignment.topLeft,
                          child: FittedBox(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                isExpanded: false,
                                hint: SizedBox(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        CupertinoIcons.calendar,
                                        color: AppColors.grey500,
                                        size: 18,
                                      ),
                                      const SizedBox(
                                        width: 2,
                                      ),
                                      Text('Filter',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors.grey500)),
                                    ],
                                  ),
                                ),
                                // Array list of items
                                items: items
                                    .map<DropdownMenuItem<String>>((period) {
                                  return DropdownMenuItem<String>(
                                      value: period,
                                      child: SizedBox(
                                          child: Text(period,
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ))));
                                }).toList(),
                                value: dropdownvalue,
                                onChanged: (String? newValue) async {
                                  setState(() {
                                    dropdownvalue = newValue!;
                                  });
                                  if (newValue != 'Custom') {
                                    setState(() {
                                      _request = _filterTransactions();
                                    });
                                  } else {
                                    _showCustomModal();
                                  }

                                  await _request;
                                },

                                buttonStyleData: ButtonStyleData(
                                    height: 40,
                                    // width: displaySize.width * .3,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                            width: 1,
                                            color: AppColors.appGold))),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        filteredTxHistory.isEmpty
                            ? const EmptyListWidget()
                            : GroupedListView<TransactionModel, DateTime>(
                                elements: filteredTxHistory,
                                groupBy: (TransactionModel tx) => DateTime(
                                    tx.txnDate.year,
                                    tx.txnDate.month,
                                    tx.txnDate.day),
                                // groupComparator: (value1, value2) =>
                                //     value2.day.compareTo(value1.day),
                                // itemComparator: (item1, item2) =>
                                //     item1['rrr'].compareTo(item2['rrr']),
                                groupComparator:
                                    (DateTime value1, DateTime value2) =>
                                        value2.compareTo(value1),
                                itemComparator: (TransactionModel element1,
                                        TransactionModel element2) =>
                                    element1.txnDate
                                        .compareTo(element2.txnDate),
                                order: GroupedListOrder.ASC,
                                physics: const BouncingScrollPhysics(),
                                floatingHeader: false,
                                shrinkWrap: true,
                                useStickyGroupSeparators: false,
                                groupSeparatorBuilder: (DateTime tx) {
                                  return Container(
                                    color: Colors.transparent,
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      UtilFunctions().getDateHeader(tx),
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.black900,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  );
                                },
                                itemBuilder: (c, tx) {
                                  return TransactionItem(tx: tx);
                                }),
                      ],
                    ),
                  ),
                )),
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

  void _showCustomModal() {
    showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.whiteA700,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) => Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
              child: Wrap(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        'Custom Date',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                  Form(
                      key: _keyForm,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: startDateController,
                            readOnly: true,
                            onTap: () {
                              _selectStartDate();
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a date';
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
                                hintText: 'Select Start Date',
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
                          TextFormField(
                            controller: endDateController,
                            readOnly: true,
                            onTap: () {
                              _selectEndDate();
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a date';
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
                                hintText: 'Select End Date',
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
                            height: 40,
                          ),
                          Center(
                            child: SizedBox(
                              width: displaySize.width * 0.7,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14),
                                    backgroundColor: AppColors.appGold,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12))),
                                onPressed: () async {
                                  if (!_keyForm.currentState!.validate()) {
                                    return;
                                  }
                                  setState(() {
                                    _request = _handleRefresh(
                                        start: customStartDate!,
                                        end: customEndDate!);
                                  });
                                  await _request;
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
                          ),
                        ],
                      )),
                ],
              ),
            ));
  }

  DateTime? customStartDate;
  DateTime? customEndDate;
  Future<void> _selectStartDate() async {
    final DateTime? picked = await showDatePicker(
        context: context, firstDate: DateTime(2021), lastDate: DateTime(3035));
    (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: AppColors.appGold, // Customize primary color
                onPrimary: Colors.white, //s
              ),
          // textTheme: theme.textTheme.copyWith(
          //   // Customize text styles
          //   subtitle1: TextStyle(color: Colors.blue),
          //   button: TextStyle(color: Colors.white),
          // ),
        ),
        child: child!,
      );
    };
    if (picked != null) {
      setState(() {
        customStartDate = picked;
        startDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
        context: context, firstDate: DateTime(2021), lastDate: DateTime(3025));

    (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: AppColors.appGold, // Customize primary color
                onPrimary: Colors.white, //s
              ),
        ),
        child: child!,
      );
    };

    if (picked != null) {
      if (customStartDate != null && picked.isBefore(customStartDate!)) {
        sendErrorMessage("Invalid Date",
            "'End date cannot be earlier than start date.", context,
            up: true);
      } else {
        setState(() {
          customEndDate = picked;
          endDateController.text = DateFormat('yyyy-MM-dd').format(picked);
        });
      }
    }
  }
}
