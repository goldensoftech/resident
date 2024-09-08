import 'package:flutter/cupertino.dart';
import 'package:resident/app_export.dart';

class TransactionInfoScreen extends StatefulWidget {
  TransactionInfoScreen({super.key, required this.tx});
  TransactionModel tx;
  @override
  State<TransactionInfoScreen> createState() => _TransactionInfoScreenState();
}

class _TransactionInfoScreenState extends State<TransactionInfoScreen>
    with CustomAppBar, CustomWidgets, ErrorSnackBar {
  Future<void>? _request;
  Future<void> queryTx(context) async {
    final txDetails =
        await TransactionBackend().queryTx(context, txDetails: widget.tx);
    if (txDetails != null) {
      widget.tx = txDetails;
      int index = ResponseData.txHistory
          .indexWhere((tx) => tx.txnId == widget.tx.txnId);

      ResponseData.txHistory[index] = widget.tx;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Stack(
        children: [
          Scaffold(
              backgroundColor: AppColors.whiteA700,
              appBar: AppBar(
                elevation: 0,
                automaticallyImplyLeading: true,
                centerTitle: true,

                forceMaterialTransparency: false,
                backgroundColor: AppColors.gold100,
                scrolledUnderElevation: 0.0,
                foregroundColor: AppColors.whiteA700,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: AppColors.gold100,
                  statusBarBrightness: Brightness.dark,
                  statusBarIconBrightness: Brightness.dark,
                  systemNavigationBarColor: Colors.transparent,
                  systemNavigationBarDividerColor: Colors.transparent,
                  systemNavigationBarIconBrightness: Brightness.dark,
                ),
                //toolbarHeight: 80,
                title: Text(
                  "Transaction",
                  style: TextStyle(
                      fontSize: 18,
                      color: AppColors.baseBlack,
                      fontWeight: FontWeight.w700),
                ),
                leadingWidth: 75,
                leading: GestureDetector(
                  onTap: () => navigateBack(context),
                  child: Container(
                    margin: const EdgeInsets.only(right: 30, left: 20),
                    //padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(width: 2, color: AppColors.black900),
                        shape: BoxShape.circle),
                    child: Center(
                      child: Icon(
                        Icons.arrow_back,
                        color: AppColors.black900,
                        size: 14.0,
                      ),
                    ),
                  ),
                ),
                actions: [
                  if (widget.tx.status == PaymentStatus.completed ||
                      widget.tx.status == PaymentStatus.paid)
                    FittedBox(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                            color: AppColors.appGold,
                            borderRadius: BorderRadius.circular(5)),
                        child: Center(
                          child: Text(
                            'Share',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.whiteA700),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              body: ListView(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FittedBox(
                          child: Container(
                            margin: const EdgeInsets.only(top: 10),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            decoration: BoxDecoration(
                                color: AppColors.whiteA700,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 3,
                                      spreadRadius: 2,
                                      offset: Offset.zero,
                                      color: Colors.black.withOpacity(0.05))
                                ],
                                borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.lightGrey),
                                  child: SvgPicture.asset(
                                      widget.tx.gateway == PaymentGateway.remita
                                          ? remitaIcon
                                          : getTxLogo(widget.tx.type),
                                      //  filterQuality: FilterQuality.high,
                                      fit: BoxFit.contain,
                                      color: widget.tx.gateway ==
                                              PaymentGateway.remita
                                          ? null
                                          : AppColors.appGold,
                                      height: 20,
                                      width: 20),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                    widget.tx.gateway == PaymentGateway.remita
                                        ? "Remita"
                                        : getTxTitle(widget.tx.type),
                                    style: TextStyle(
                                      color: AppColors.appGold,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ))
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          "On ${UtilFunctions().getTxDate(widget.tx.txnDate)}",
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$ngnIcon${formatNumber(widget.tx.amount)}",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          width: displaySize.width * .8,
                          height: 30,
                          child: Text(
                            "${widget.tx.serviceType}",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: AppColors.black900,
                                fontSize: 14,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Divider(
                          color: AppColors.grey200,
                          height: 1,
                          thickness: .5,
                        ),
                      ],
                    ),
                    customTile(
                        title: "To",
                        subTitle: (widget.tx.destinationNum ?? "")),
                    customTile(
                        title: "Payment Method",
                        subTitle: (getPaymtGateway(widget.tx.gateway))),
                    customTile(
                        title: "Transaction Reference",
                        subTitle: (widget.tx.refId ?? ""),
                        leading: (widget.tx.refId != null &&
                                widget.tx.refId != "UNKNOWN" &&
                                widget.tx.refId!.isNotEmpty)
                            ? SizedBox(
                                child: Row(children: [
                                  Text(
                                    "COPY",
                                    style: TextStyle(
                                        color: AppColors.appGold,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14),
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      copyText(widget.tx.refId!);
                                      sendErrorMessage(
                                          "Copied",
                                          isSuccess: true,
                                          "Transaction Reference copied",
                                          context);
                                    },
                                    icon: Icon(Icons.content_copy_rounded,
                                        color: AppColors.appGold, size: 18),
                                  )
                                ]),
                              )
                            : const SizedBox.shrink()),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Status",
                          style: TextStyle(
                              fontSize: 12,
                              color: AppColors.grey200,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                            width: displaySize.width * .7,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(right: 10),
                                  height: 10,
                                  width: 10,
                                  decoration: BoxDecoration(
                                      color: getColor(),
                                      shape: BoxShape.circle),
                                ),
                                Text(
                                  widget.tx.status.name.toUpperCase(),
                                  style: TextStyle(
                                      color: AppColors.black900,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                        Divider(
                          color: AppColors.grey200,
                          height: 1,
                          thickness: .5,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ]),
              persistentFooterAlignment: AlignmentDirectional.bottomCenter,
              persistentFooterButtons: [
                if (widget.tx.status == PaymentStatus.pending ||
                    widget.tx.status == PaymentStatus.initiated ||
                    widget.tx.status == PaymentStatus.processing)
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
                      onPressed: () async {
                        setState(() {
                          _request = queryTx(context);
                        });
                        await _request;
                      },
                      child: Text(
                        'Re-query Transaction',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.whiteA700),
                      ),
                    ),
                  ),
              ]),
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

  Color getColor() {
    if (widget.tx.status == PaymentStatus.completed) {
      return Colors.green;
    } else if ((widget.tx.status == PaymentStatus.failed)) {
      return Colors.red;
    } else {
      return Colors.yellow;
    }
  }

  Widget customTile(
      {required String title, required String subTitle, Widget? leading}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 14,
                      color: AppColors.grey200,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 5,
                ),
                SizedBox(
                    width: displaySize.width * .6,
                    child: Text(
                      subTitle,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: AppColors.black900,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    )),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
            if (leading != null)
              Align(alignment: Alignment.centerRight, child: leading)
          ],
        ),
        Divider(
          color: AppColors.grey200,
          height: 1,
          thickness: .5,
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
