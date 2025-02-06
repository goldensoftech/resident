import 'package:resident/app_export.dart';
import 'package:resident/repository/model/data_response_model.dart';
import "dart:ui";

import 'package:resident/utils/enums.dart';

mixin CustomAlerts {
  // String getTitle(TransactionType type) {
  //   switch (type) {
  //     case TransactionType.airtime:
  //       return "Airtime Purchase";
  //     case TransactionType.data:
  //       return "Data Purchase";
  //     case TransactionType.tv:
  //       return "TV Subscription";
  //     case TransactionType.utility:
  //       return "Utilities";
  //     default:
  //       return type.name;
  //   }
  // }

  showTxConfirmationAlert(BuildContext context,
      {required TransactionType type, bool? shareReceipt}) {
    bool isChecked = false;

    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: SimpleDialog(
                insetPadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.zero,

                //   children: [],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r)),
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.whiteA700,
                        borderRadius: BorderRadius.circular(10.r)),
                    height: displaySize.height * .6,
                    width: displaySize.width * .9,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 13.w, vertical: 20.h),
                      child: Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Spacer(),
                                Text(
                                  'Transaction Summary',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.black900),
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: InkWell(
                                      onTap: () {
                                        navigateBack(context);
                                      },
                                      child: Icon(
                                        Icons.cancel_outlined,
                                        color: AppColors.black900,
                                      )),
                                ),
                              ]),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 2.0, vertical: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Transaction Summary',
                                      style: TextStyle(
                                          color: AppColors.grey500,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      getTxTitle(type),
                                      style: TextStyle(
                                          color: AppColors.baseBlack,
                                          fontWeight: FontWeight.w700),
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 2.0, vertical: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Phone Number',
                                      style: TextStyle(
                                          color: AppColors.grey500,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      '08063299763',
                                      style: TextStyle(
                                          color: AppColors.baseBlack,
                                          fontWeight: FontWeight.w700),
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 2.0, vertical: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Network Provider',
                                    style: TextStyle(
                                        color: AppColors.grey500,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    'MTN',
                                    style: TextStyle(
                                        color: AppColors.baseBlack,
                                        fontWeight: FontWeight.w700),
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 2.0, vertical: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Amount to Pay',
                                      style: TextStyle(
                                          color: AppColors.grey500,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      'NGN 2,000',
                                      style: TextStyle(
                                          color: AppColors.appGold,
                                          fontWeight: FontWeight.w700),
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
                          if (shareReceipt != true)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.r)),
                                    side: BorderSide(
                                        width: 1.0, color: AppColors.appGold),
                                    value: isChecked,
                                    tristate: false,
                                    onChanged: (value) {
                                      isChecked = value!;
                                      // setState(() {});
                                    }),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text('Save as beneficiary',
                                    style: TextStyle(
                                        color: AppColors.appGold,
                                        fontWeight: FontWeight.w700))
                              ],
                            ),
                          const Spacer(),
                          SizedBox(
                            width: displaySize.width * 0.7,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  backgroundColor: AppColors.appGold,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))
                                  //minimumSize: const Size.fromHeight(60)
                                  ),
                              //onPressed: () => context.replace('/signup'),
                              onPressed: () {
                                if (shareReceipt == true) {
                                } else {
                                  showSuccessAlert(context,
                                      title: getTxTitle(type),
                                      goToPage: Dashboard());
                                }
                              },
                              child: Text(
                                shareReceipt == true ? "Share" : 'Continue',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.whiteA700),
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

  showAirtimeAndDataConfirmationAlert(BuildContext context,
      {required TransactionType type,
      required DataItem plan,
      required String phoneNumber,
      bool? shareReceipt}) {
    bool isChecked = false;

    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: SimpleDialog(
                insetPadding: EdgeInsets.zero,
                contentPadding: EdgeInsets.zero,

                //   children: [],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r)),
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: AppColors.whiteA700,
                        borderRadius: BorderRadius.circular(10.r)),
                    height: displaySize.height * .6,
                    width: displaySize.width * .8,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 13.w, vertical: 20.h),
                      child: Column(
                        children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Spacer(),
                                Text(
                                  'Transaction Summary',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.black900),
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 20.0),
                                  child: InkWell(
                                      onTap: () {
                                        navigateBack(context);
                                      },
                                      child: Icon(
                                        Icons.cancel_outlined,
                                        color: AppColors.black900,
                                      )),
                                ),
                              ]),
                          const SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 2.0, vertical: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Transaction Summary',
                                      style: TextStyle(
                                          color: AppColors.grey500,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      getTxTitle(type),
                                      style: TextStyle(
                                          color: AppColors.baseBlack,
                                          fontWeight: FontWeight.w700),
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 2.0, vertical: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Phone Number',
                                      style: TextStyle(
                                          color: AppColors.grey500,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      phoneNumber,
                                      style: TextStyle(
                                          color: AppColors.baseBlack,
                                          fontWeight: FontWeight.w700),
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 2.0, vertical: 15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Network Provider',
                                    style: TextStyle(
                                        color: AppColors.grey500,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(
                                    plan.network!,
                                    style: TextStyle(
                                        color: AppColors.baseBlack,
                                        fontWeight: FontWeight.w700),
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 2.0, vertical: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Amount to Pay',
                                      style: TextStyle(
                                          color: AppColors.grey500,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Text(
                                      type == TransactionType.airtime_data
                                          ? plan.amount.toString()
                                          : plan.title,
                                      style: TextStyle(
                                          color: AppColors.appGold,
                                          fontWeight: FontWeight.w700),
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
                          if (shareReceipt != true)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Checkbox(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.r)),
                                    side: BorderSide(
                                        width: 1.0, color: AppColors.appGold),
                                    value: isChecked,
                                    tristate: false,
                                    onChanged: (value) {
                                      isChecked = value!;
                                      // setState(() {});
                                    }),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text('Save as beneficiary',
                                    style: TextStyle(
                                        color: AppColors.appGold,
                                        fontWeight: FontWeight.w700))
                              ],
                            ),
                          const Spacer(),
                          SizedBox(
                            width: displaySize.width * 0.7,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 14),
                                  backgroundColor: AppColors.appGold,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))
                                  //minimumSize: const Size.fromHeight(60)
                                  ),
                              //onPressed: () => context.replace('/signup'),
                              onPressed: () {
                                if (shareReceipt == true) {
                                } else {
                                  showSuccessAlert(context,
                                      title: getTxTitle(type),
                                      goToPage: Dashboard());
                                }
                              },
                              child: Text(
                                shareReceipt == true ? "Share" : 'Continue',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.whiteA700),
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

  showKycAlert(BuildContext context, {required bool isSuccess}) {
    String successMsg = "BVN & Account Verification successful, Continue";
    String failedMsg = "BVN Verification failed, Retry once more";
    showDialog(
        context: context,
        barrierColor: Colors.transparent.withOpacity(.5),
        barrierDismissible: !isSuccess,
        builder: (ctx) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AlertDialog(
              insetPadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r)),
              content: Container(
                  decoration: BoxDecoration(
                      color: AppColors.whiteA700,
                      borderRadius: BorderRadius.circular(10.r)),
                  height: displaySize.height * .5,
                  width: displaySize.width * .6,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 13.w, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        SvgPicture.asset(isSuccess ? bvnSuccess : bvnFailed,
                            color: AppColors.appGold),
                        SizedBox(height: 10),
                        Text(isSuccess ? successMsg : failedMsg,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.black900)),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            if (isSuccess) {
                              navigateRemoveAll(context, const Dashboard());
                            } else {
                              navigateBack(context);
                            }
                          },
                          child: FittedBox(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              decoration: BoxDecoration(
                                  color: isSuccess
                                      ? AppColors.appGold
                                      : Colors.transparent,
                                  border: Border.all(
                                      width: 1, color: AppColors.appGold)),
                              child: Center(
                                  child: Text(
                                isSuccess ? "Yes, Continue" : "Retry",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    color: isSuccess
                                        ? AppColors.whiteA700
                                        : AppColors.appGold),
                              )),
                            ),
                          ),
                        ),
                        isSuccess
                            ? SizedBox.shrink()
                            : InkWell(
                                onTap: () {
                                  navigateBack(context);
                                },
                                child: FittedBox(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 10),
                                    decoration: BoxDecoration(
                                        color: AppColors.appGold,
                                        border: Border.all(
                                            width: 1,
                                            color: AppColors.appGold)),
                                    child: Center(
                                        child: Text(
                                      "No, Back",
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.whiteA700),
                                    )),
                                  ),
                                ),
                              ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  )),
            ),
          );
        });
  }

  showSuccessAlert(BuildContext context,
      {required String title, String? description, required Widget goToPage}) {
    showDialog(
        context: context,
        barrierColor: Colors.transparent.withOpacity(.5),
        barrierDismissible: false,
        builder: (ctx) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AlertDialog(
              insetPadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r)),
              content: Container(
                  decoration: BoxDecoration(
                      color: AppColors.whiteA700,
                      borderRadius: BorderRadius.circular(10.r)),
                  height: displaySize.height * .6,
                  width: displaySize.width * .9,
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 13.w, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Text('${title}\nSuccessful',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 18,
                                color: AppColors.baseBlack,
                                fontWeight: FontWeight.w700)),
                        if (description != null)
                          Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: 50,
                              ),
                              child: Text(description,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.grey200,
                                      fontWeight: FontWeight.w400))),
                        const Spacer(),
                        SvgPicture.asset(
                          successImg,
                        ),
                        const Spacer(),
                        SizedBox(
                          width: displaySize.width * 0.7,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 0,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                backgroundColor: AppColors.appGold,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12))
                                //minimumSize: const Size.fromHeight(60)
                                ),
                            //onPressed: () => context.replace('/signup'),
                            onPressed: () =>
                                navigateRemoveAll(context, goToPage),

                            child: Text(
                              'Continue',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.whiteA700),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  )),
            ),
          );
        });
  }

  showTxDetailsAlert(BuildContext context, {required TransactionModel tx}) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (ctx) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: SimpleDialog(
              insetPadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,

              //   children: [],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r)),
                  children: [
                    
                  ],
            ),
          );
        });
  }
}
