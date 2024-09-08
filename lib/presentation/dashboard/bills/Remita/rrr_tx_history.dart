import 'package:resident/app_export.dart';

class RRRTxHistoryScreen extends StatefulWidget {
  const RRRTxHistoryScreen({super.key});

  @override
  State<RRRTxHistoryScreen> createState() => _RRRTxHistoryScreenState();
}

class _RRRTxHistoryScreenState extends State<RRRTxHistoryScreen>
    with CustomAlerts, CustomAppBar {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Scaffold(
            appBar: customAppBar(title: "RRR Transaction"),
            backgroundColor: AppColors.whiteA700,
            body: GroupedListView<RRRTxModel, DateTime>(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                elements: DummyData().rrrPayments,
                groupBy: (RRRTxModel tx) =>
                    DateTime(tx.date.year, tx.date.month, tx.date.day),
                // groupComparator: (value1, value2) =>
                //     value2.day.compareTo(value1.day),
                // itemComparator: (item1, item2) =>
                //     item1['rrr'].compareTo(item2['rrr']),
                groupComparator: (DateTime value1, DateTime value2) =>
                    value2.compareTo(value1),
                itemComparator: (RRRTxModel element1, RRRTxModel element2) =>
                    element1.date.compareTo(element2.date),
                order: GroupedListOrder.ASC,
                floatingHeader: false,
                useStickyGroupSeparators: false,
                physics: BouncingScrollPhysics(),
                groupSeparatorBuilder: (DateTime tx) {
                  return Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.all(10),
                    // constraints:
                    //     const BoxConstraints
                    //         .tightFor(
                    //         height:
                    //             30),
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
                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: AppColors.greyF9,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: AppColors.whiteA700,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 1, color: AppColors.appGold)),
                              child: SvgPicture.asset(billsInactvIcon,
                                  height: 14,
                                  width: 14,
                                  color: AppColors.appGold)),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      tx.rrr,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.baseBlack,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      "N ${tx.amount}",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.baseBlack,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      tx.txId,
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: AppColors.grey500,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      UtilFunctions().getTxDate(tx.date),
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: AppColors.grey500,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                })));
  }
}
