import 'package:resident/app_export.dart';
import 'package:resident/presentation/dashboard/transaction/tx_info_screen.dart';

class TransactionItem extends StatelessWidget {
  TransactionItem({super.key, required this.tx});
  TransactionModel tx;
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: AppColors.greyF9,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => navigatePush(context, TransactionInfoScreen(tx: tx)),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: AppColors.whiteA700,
                      shape: BoxShape.circle,
                      border: Border.all(width: 1, color: AppColors.appGold)),
                  child: SvgPicture.asset(getTxLogo(tx.type),
                      height: 14, width: 14, color: AppColors.appGold)),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: displaySize.width * .4,
                          child: Text(
                            tx.refId ?? "",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 14,
                                color: AppColors.baseBlack,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        Text(
                          "$ngnIcon${formatNumber(tx.amount)}",
                          style: TextStyle(
                              fontSize: 14,
                              color: AppColors.baseBlack,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: displaySize.width * .4,
                          child: Text(
                            tx.txnId ?? "",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 10,
                                color: AppColors.grey32,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        Text(
                          UtilFunctions().getTxDate(tx.txnDate),
                          style: TextStyle(
                              fontSize: 10,
                              color: AppColors.grey32,
                              fontWeight: FontWeight.w400),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
