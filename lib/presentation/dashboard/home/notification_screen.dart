import 'package:resident/app_export.dart';
import 'package:resident/repository/model/notification_response_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with CustomAppBar, CustomAlerts {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Scaffold(
            backgroundColor: AppColors.whiteA700,
            appBar: customAppBar(title: "Notifications"),
            body: ListView(
              children: [
                GroupedListView<NotificationModel, DateTime>(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    elements: DummyData().notifications,
                    groupBy: (NotificationModel note) => DateTime(
                        note.date.year, note.date.month, note.date.day),
                    // groupComparator: (value1, value2) =>
                    //     value2.day.compareTo(value1.day),
                    // itemComparator: (item1, item2) =>
                    //     item1['rrr'].compareTo(item2['rrr']),
                    groupComparator: (DateTime value1, DateTime value2) =>
                        value2.compareTo(value1),
                    itemComparator: (NotificationModel element1,
                            NotificationModel element2) =>
                        element1.date.compareTo(element2.date),
                    order: GroupedListOrder.ASC,
                    physics: BouncingScrollPhysics(),
                    floatingHeader: false,
                    shrinkWrap: true,
                    useStickyGroupSeparators: false,
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
                      return Container(
                        padding: EdgeInsets.only(
                          left: 2,
                          right: 10,
                          top: 5,
                          bottom: 5,
                        ),
                        margin: EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: tx.seen != true
                                ? AppColors.gold100
                                : Colors.transparent),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 20,
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: tx.seen != true
                                        ? AppColors.appGold
                                        : Colors.transparent),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tx.description,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.baseBlack,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                  UtilFunctions().callback(tx.date.toString()),
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AppColors.baseBlack,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    }),
              ],
            )));
  }
}
