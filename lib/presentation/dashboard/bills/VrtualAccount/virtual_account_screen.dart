import 'package:resident/app_export.dart';

class VirtualAccountScreen extends StatefulWidget {
  const VirtualAccountScreen({super.key});

  @override
  State<VirtualAccountScreen> createState() => _VirtualAccountScreenState();
}

class _VirtualAccountScreenState extends State<VirtualAccountScreen>
    with CustomAlerts, CustomAppBar {
  String? selectedBankIcon;
  TextEditingController _bankNameController = TextEditingController();
  TextEditingController _acctNumController = TextEditingController();
  TextEditingController _acctNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Scaffold(
          appBar: customAppBar(title: "Virtual Account"),
          backgroundColor: AppColors.whiteA700,
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            children: [
              SizedBox(
                width: displaySize.width * .6,
                child: Text(
                  "Lorem ipsum dolor sit amet consectetur. Cursus duis lectus arcu sed nec convallis faucibus.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 12,
                      color: AppColors.baseBlack,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bank Name',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.baseBlack),
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          backgroundColor: AppColors.whiteA700,
                          showDragHandle: true,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10))),
                          builder: (context) {
                            // print("lenght of tiles ${dataPlans.length}");
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Select Account",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: AppColors.baseBlack,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  ListView.separated(
                                      itemCount: DummyData()
                                          .virtualAccountsList
                                          .length,
                                      shrinkWrap: true,
                                      separatorBuilder:
                                          (BuildContext context, int index) =>
                                              Divider(),
                                      itemBuilder: (context, index) {
                                        final data = DummyData()
                                            .virtualAccountsList[index];
                                        return ListTile(
                                          tileColor: AppColors.baseWhite,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          onTap: () {
                                            setState(() {
                                              selectedBankIcon =
                                                  data['bankLogo'];
                                              _bankNameController.text =
                                                  data['bank_name'];
                                              _acctNumController.text =
                                                  data['acc_number'];
                                              _acctNameController.text =
                                                  data['acc_name'];
                                            });
                                            navigateBack(context);
                                          },
                                          leading: Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: AppColors.whiteA700,
                                              ),
                                              padding: EdgeInsets.all(2),
                                              child: SvgPicture.asset(
                                                  data['bankLogo'])),
                                          title: Text(
                                            "${data['bank_name']}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        );
                                      }),
                                ],
                              ),
                            );
                          });
                    },
                    child: TextFormField(
                      controller: _bankNameController,
                      enabled: false,
                      onChanged: (value) {
                        setState(() {});
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
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
                              vertical: 0, horizontal: 20),
                          //labelStyle: const TextStyle(color: Colors.black54),
                          hintText: 'Select plan',
                          hintStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.grey200),
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(8.r)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: selectedBankIcon != null
                              ? Container(
                                  height: 25,
                                  width: 25,
                                  margin: EdgeInsets.only(left: 20, right: 10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.whiteA700,
                                  ),
                                  padding: EdgeInsets.all(1),
                                  child: SvgPicture.asset(
                                      selectedBankIcon != null
                                          ? selectedBankIcon!
                                          : logoSvg))
                              : SizedBox.shrink(),
                          suffixIcon: SvgPicture.asset(
                            arrowDown,
                            color: AppColors.grey400,
                            //size: 18,
                          )),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Virtual Account Number',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.baseBlack),
                  ),
                  TextFormField(
                    controller: _acctNumController,
                    enabled: false,
                    onChanged: (value) {
                      setState(() {});
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
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
                            vertical: 0, horizontal: 20),
                        //labelStyle: const TextStyle(color: Colors.black54),
                        hintText: 'Account Number ',
                        hintStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: AppColors.grey200),
                        border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8.r)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: GestureDetector(
                            onTap: () {},
                            child: Icon(
                              Icons.copy,
                              size: 16,
                              color: AppColors.baseBlack,
                            ))),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account Name',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.baseBlack),
                  ),
                  TextFormField(
                    controller: _acctNameController,
                    enabled: false,
                    onChanged: (value) {
                      setState(() {});
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
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
                          vertical: 0, horizontal: 20),
                      //labelStyle: const TextStyle(color: Colors.black54),
                      hintText: 'Account Name ',
                      hintStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.grey200),
                      border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(8.r)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
