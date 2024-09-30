import 'package:resident/app_export.dart';

class AddAccountScreen extends StatefulWidget {
  const AddAccountScreen({super.key});

  @override
  State<AddAccountScreen> createState() => _AddAccountScreenState();
}

class _AddAccountScreenState extends State<AddAccountScreen>
    with CustomAppBar, CustomAlerts, ErrorSnackBar {
  Future<void>? _request;
  UserBankDetails? bankDetails;
  Bank? selectedBank;
  TextEditingController _bankController = TextEditingController();
  TextEditingController _accountNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    getUserBanks(context);
    super.initState();
  }

  void getUserBanks(context) async {
    if (ResponseData.bankList.isEmpty) {
      ResponseData.bankList = await TransactionBackend().getBankList(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: AppColors.whiteA700,
            appBar: customAppBar(title: "Add Bank Account"),
            body: Form(
              key: _formKey,
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                children: [
                  Text(
                    'Bank',
                    style: TextStyle(color: AppColors.baseBlack, fontSize: 12),
                  ),
                  TextFormField(
                    controller: _bankController,
                    readOnly: true,
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          backgroundColor: AppColors.whiteA700,
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
                                      MediaQuery.of(context).size.height),
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Scrollbar(
                                radius: const Radius.circular(5),
                                child: ListView(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: Row(
                                        //  mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          IconButton(
                                              onPressed: () =>
                                                  navigateBack(context),
                                              icon:
                                                  Icon(Icons.cancel_outlined)),
                                          Expanded(
                                            child: Container(
                                              alignment: Alignment.center,
                                              //width: double.infinity,
                                              child: Text(
                                                "Choose Bank",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: AppColors.baseBlack,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: AppColors.grey200,
                                      thickness: 1,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    ListView.separated(
                                        itemCount: ResponseData.bankList.length,
                                        shrinkWrap: true,
                                        physics: const ScrollPhysics(),
                                        separatorBuilder:
                                            (BuildContext context, int index) =>
                                                Divider(
                                                    height: 1,
                                                    color: AppColors.grey200),
                                        itemBuilder: (context, index) {
                                          final data =
                                              ResponseData.bankList[index];
                                          return ListTile(
                                            tileColor: AppColors.whiteA700,
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    vertical: 10),
                                            onTap: () {
                                              setState(() {
                                                selectedBank = data;
                                                _bankController.text =
                                                    data.name;
                                                _accountNumberController.text =
                                                    "";
                                              });
                                              navigateBack(context);
                                            },
                                            // leading: ClipRRect(
                                            //   borderRadius:
                                            //       BorderRadius.circular(40),
                                            //   child: Image.asset(
                                            //       DummyData().networkItems[
                                            //               selectedNetworkIndex!]
                                            //           ['url'],
                                            //       height: 40,
                                            //       filterQuality:
                                            //           FilterQuality.high,
                                            //       width: 40,
                                            //       fit: BoxFit.contain),
                                            // ),
                                            title: Text(
                                              data.name,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600),
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
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 12),
                        //labelStyle: const TextStyle(color: Colors.black54),
                        hintText: 'Select plan',
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
                  Text(
                    'Account Number',
                    style: TextStyle(color: AppColors.baseBlack, fontSize: 12),
                  ),
                  TextFormField(
                    controller: _accountNumberController,
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
                            borderSide:
                                BorderSide(width: 1.w, color: AppColors.grey50),
                            borderRadius: BorderRadius.circular(8.r)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(color: AppColors.appGold),
                        ),
                        suffix: GestureDetector(
                            onTap: () {},
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Paste",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.appGold),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(Icons.paste_rounded,
                                    size: 16, color: AppColors.appGold)
                              ],
                            ))),
                  ),
                ],
              ),
            ),
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
