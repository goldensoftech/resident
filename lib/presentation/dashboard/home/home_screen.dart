import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:resident/app_export.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with CustomAppBar, TickerProviderStateMixin, FormInputFields {
  late AnimationController _loadingPage;
  TextEditingController searchController = TextEditingController();
  List<dynamic> _allUtitlities = [];
  List<dynamic> _filteredUtitlities = [];
  List<TransactionModel> txHistory = [];
  @override
  void initState() {
    super.initState();
    txHistory = ResponseData.txHistory;
    _loadingPage = AnimationController(vsync: this);
    _allUtitlities = DummyData().billItems;
    _filteredUtitlities = _allUtitlities;
  }

  @override
  @protected
  @mustCallSuper
  void dispose() {
    _loadingPage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   statusBarColor: AppColors.gold100,
    //   statusBarBrightness: Brightness.dark,
    //   statusBarIconBrightness: Brightness.dark,
    //   systemNavigationBarColor: Colors.black,
    //   systemNavigationBarDividerColor: Colors.black,
    //   systemNavigationBarIconBrightness: Brightness.dark,

    // ));
    return SafeArea(
      top: false,

      //backgroundColor: AppColors.whiteA700,
      child: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Scaffold(
          backgroundColor: AppColors.whiteA700,
          extendBody: true,
          appBar: defaultAppBar(title: "", height: 20),
          body: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            //  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),

            shrinkWrap: true,
            children: [
              Stack(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                        child: Container(
                      width: displaySize.width,
                      height: txHistory.isNotEmpty && AuthBackend.isLoggedIn()
                          ? displaySize.height * .35
                          : 120,
                      padding: EdgeInsets.only(
                        top: displaySize.height * .05,
                        left: 20,
                        right: 20,
                      ),
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30)),
                          color: AppColors.gold100),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AuthBackend.isLoggedIn()
                                  ? Text(
                                      "Hi ${ResponseData.loginResponse!.user!.lastName} ${ResponseData.loginResponse!.user!.firstName},",
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.baseBlack),
                                    )
                                  : Text(
                                      "Welcome back,",
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.baseBlack),
                                    ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                UtilFunctions().getDashboardDate(),
                                style: TextStyle(
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.baseBlack),
                              )
                            ],
                          ),
                          AuthBackend.isLoggedIn()
                              ? Column(
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          //  _loadingPage.repeat();

                                          navigatePush(context,
                                              const NotificationScreen());
                                        },
                                        child: SvgPicture.asset(
                                          bellIcon,
                                          color: AppColors.baseBlack,
                                          height: 24,
                                          width: 24,
                                        )),
                                  ],
                                )
                              : Align(
                                  alignment: Alignment.topRight,
                                  child: TextButton(
                                    // borderRadius: BorderRadius.circular(12),
                                    // style: ButtonStyle(shape: RoundedRectangular
                                    // ),
                                    onPressed: () {
                                      navigateRemoveAll(
                                          context, const LoginScreen());
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15, vertical: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: AppColors.whiteA700),
                                      child: Text(
                                        "Login",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppColors.baseBlack,
                                            fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    )),
                    // Padding(
                    //   padding:
                    //       const EdgeInsets.only(left: 20, right: 20, top: 30),
                    //   child: Text("",
                    //       style: TextStyle(
                    //           fontSize: 12,
                    //           fontWeight: FontWeight.w600,
                    //           color: AppColors.black900)),
                   // ),
                    Container(
                      // height: 200,
                      padding: const EdgeInsets.only(
                        top:20,
                        bottom: 10,
                      ),
                      color: AppColors.whiteA700,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // const SizedBox(
                              //   height: 20,
                              // ),

                              // GridView.builder(
                              //     padding:
                              //         const EdgeInsets.symmetric(vertical: 10),
                              //     gridDelegate:
                              //         SliverGridDelegateWithFixedCrossAxisCount(
                              //       childAspectRatio: 1,
                              //       crossAxisSpacing: 1,
                              //       mainAxisSpacing: 1,
                              //       crossAxisCount:
                              //           DummyData().shortcutItems.length,
                              //       // ((AuthBackend.isLoggedIn() &&
                              //       //         ResponseData.loginResponse!
                              //       //                 .user!.bvnStatus ==
                              //       //             true))
                              //       //     ? 4
                              //       //     : 3),
                              //     ),
                              //     shrinkWrap: true,
                              //     itemCount: DummyData().shortcutItems.length,
                              //     // itemCount: ((AuthBackend.isLoggedIn() &&
                              //     //         ResponseData.loginResponse!.user!
                              //     //                 .bvnStatus ==
                              //     //             true))
                              //     //     ? 4
                              //     //     : 3,

                              //     itemBuilder: (ctx, index) {
                              //       final shortCut =
                              //           DummyData().shortcutItems[index];
                              //       // if (shortCut['title'] == "QR Scan") {
                              //       //   if (!(AuthBackend.isLoggedIn() &&
                              //       //       ResponseData.loginResponse!.user!
                              //       //               .bvnStatus ==
                              //       //           true)) {
                              //       //     return SizedBox.shrink();
                              //       //   }
                              //       // }

                              //       return ShortCutItem(
                              //         isIconBlack: index == 0 ? true : false,
                              //         gridColor: shortCut['color'],
                              //         logoUrl: shortCut['logoUrl'],
                              //         pageToNavigate: shortCut['pageToGo'],
                              //         title: shortCut['title'],
                              //       );
                              //     }),

                              // const SizedBox(
                              //   height: 5,
                              // ),
                              //Divider(color: AppColors.grey200, height: 1.5),
                              // const SizedBox(
                              //   height: 5,
                              // ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: AdvertItem(),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: TextFormField(
                              controller: searchController,
                              style: const TextStyle(height: 1),
                              cursorOpacityAnimates: true,
                              cursorWidth: 1,
                              onChanged: _filterUtilities,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 15),
                                //labelStyle: const TextStyle(color: Colors.black54),
                                hintText: 'Search Biller',
                                filled: true,
                                fillColor: AppColors.lightGrey,
                                hintStyle: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.schemeColor),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.r),
                                    borderSide: BorderSide.none),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(28.r),
                                    borderSide: BorderSide.none),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: AppColors.schemeColor,
                                  size: 18,
                                ),

                                suffixIcon: searchController.text.isNotEmpty
                                    ? IconButton(
                                        onPressed: () {
                                          searchController.clear();
                                          _filterUtilities("");
                                        },
                                        icon: Icon(
                                          CupertinoIcons.clear_circled_solid,
                                          color: AppColors.grey500,
                                        ))
                                    : const SizedBox.shrink(),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          _filteredUtitlities.isEmpty
                              ? const EmptyListWidget()
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: GridView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                              childAspectRatio: 1,
                                              crossAxisSpacing: 40,
                                              mainAxisSpacing: 20,
                                              crossAxisCount: 2),
                                      shrinkWrap: true,
                                      itemCount: _filteredUtitlities.length,
                                      itemBuilder: (ctx, index) {
                                        final shortCut =
                                            _filteredUtitlities[index];
                                        if (Platform.isIOS &&
                                            shortCut['title'] ==
                                                'Sport Betting') {
                                          return const SizedBox.shrink();
                                        }
                                        return BillItem(
                                          logoUrl: shortCut['logoUrl'],
                                          pageToNavigate: shortCut['pageToGo'],
                                          isApplyColor:
                                              shortCut['color'] == null
                                                  ? true
                                                  : false,
                                          title: shortCut['title'],
                                        );
                                      }),
                                ),
                        ],
                      ),
                    )
                  ],
                ),
                txHistory.isNotEmpty && AuthBackend.isLoggedIn()
                    ? Positioned(
                        top: displaySize.height * .13,
                        child: SizedBox(
                            width: displaySize.width,
                            child:
                                RecentTransactionListBox(txHistory: txHistory)))
                    : const SizedBox.shrink(),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  void _filterUtilities(String searchText) {
    if (searchText.isEmpty) {
      setState(() {
        _filteredUtitlities = _allUtitlities;
      });
    } else {
      setState(() {
        _filteredUtitlities = _allUtitlities
            .where((utility) => utility['title']
                .toLowerCase()
                .contains(searchText.toLowerCase()))
            .toList();
      });
    }
  }
}

class RecentTransactionListBox extends StatelessWidget {
  RecentTransactionListBox({super.key, required this.txHistory});
  List<TransactionModel> txHistory;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Container(
          height: 180,
          margin: const EdgeInsets.only(
            top: 10,
            right: 20,
            left: 20,
            // vertical: 20
          ),
          padding:
              const EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5),
          decoration: BoxDecoration(
              color: AppColors.whiteA700,
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(.05),
                    spreadRadius: -3,
                    blurRadius: 5.0,
                    offset: const Offset(0.0, 6))
              ],
              borderRadius: BorderRadius.circular(5)),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text("Recent Transaction",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.black900)),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: Scrollbar(
                radius: const Radius.circular(10),
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: txHistory.take(5).length,
                    itemBuilder: (ctx, index) => TransactionItem(
                          tx: txHistory[index],
                        )),
              ),
            ),
          ])),
    );
  }
}
