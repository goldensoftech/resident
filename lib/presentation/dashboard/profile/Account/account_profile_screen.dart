import 'package:resident/app_export.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart'
    as intlPhone;

class AccountProfileScreen extends StatefulWidget {
  const AccountProfileScreen({super.key});

  @override
  State<AccountProfileScreen> createState() => _AccountProfileScreenState();
}

class _AccountProfileScreenState extends State<AccountProfileScreen>
    with CustomAppBar, CustomWidgets {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _secondNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phonecontroller = TextEditingController();
  String initialCountry = 'NG';
  intlPhone.PhoneNumber? number;
  Future<void>? _request;
  @override
  void initState() {
    setInits();
    super.initState();
  }

  setInits() {
    if (ResponseData.loginResponse != null &&
        ResponseData.loginResponse!.user != null) {
      _firstNameController.text = ResponseData.loginResponse!.user!.firstName!;
      _secondNameController.text = ResponseData.loginResponse!.user!.lastName!;
      _emailController.text = ResponseData.loginResponse!.user!.userName!;

      number = intlPhone.PhoneNumber(
          isoCode: 'NG',
          phoneNumber:
              ResponseData.loginResponse!.user!.phoneNumber!.startsWith("0000")
                  ? ""
                  : ResponseData.loginResponse!.user!.phoneNumber!);
    } else {
      number = intlPhone.PhoneNumber(
        isoCode: 'NG',
      );
    }
  }

  Future<void> updateProfile(context) async {
    await AuthBackend().updateProfile(context,
        lastName: _secondNameController.text,
        phoneNumber: _phonecontroller.text,
        firstName: _firstNameController.text);
    navigateBack(context);
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
                  backgroundColor: AppColors.whiteA700,
                  appBar: profileAppBar(title: "Account Profile"),
                  body: Form(
                    key: _formKey,
                    child: ListView(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20),
                      children: [
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'First Name',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.appGold),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                    controller: _firstNameController,
                                    keyboardType: TextInputType.text,
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
                                      filled: true,
                                      fillColor: AppColors.lightGrey,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 20),
                                      //labelStyle: const TextStyle(color: Colors.black54),
                                      hintText: 'Enter  first name ',
                                      hintStyle: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.grey200),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(8.r)),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Last Name',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.appGold),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                    controller: _secondNameController,
                                    keyboardType: TextInputType.text,
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your last name';
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
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 20),
                                      //labelStyle: const TextStyle(color: Colors.black54),
                                      hintText: 'Enter last name',
                                      hintStyle: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.grey200),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(8.r)),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Email Address',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.appGold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              controller: _emailController,
                              readOnly: true,
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) {
                                setState(() {});
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter email address';
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
                                hintText: 'Enter email address ',
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
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Phone Number',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.appGold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            intlPhone.InternationalPhoneNumberInput(
                              onInputChanged: (number) {
                                print(number.parseNumber());
                              },
                              onInputValidated: (bool value) {
                                print(value);
                              },
                              selectorConfig: const intlPhone.SelectorConfig(
                                selectorType: intlPhone
                                    .PhoneInputSelectorType.BOTTOM_SHEET,
                                useBottomSheetSafeArea: true,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter phone number';
                                }
                                if (value.length <10 ||
                                    value.length > 11) {
                                  return 'Invalid phone number';
                                }
                                return null;
                              },
                              ignoreBlank: false,
                              autoValidateMode: AutovalidateMode.disabled,
                              selectorTextStyle:
                                  const TextStyle(color: Colors.black),
                              initialValue: number,
                              textFieldController: _phonecontroller,
                              formatInput: true,
                              inputDecoration: InputDecoration(
                                filled: true,
                                fillColor: AppColors.lightGrey,
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 20),
                                //labelStyle: const TextStyle(color: Colors.black54),
                                hintText: 'Enter phone number ',
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
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      signed: true, decimal: true),
                              inputBorder: const OutlineInputBorder(),
                              onSaved: (number) {
                                print('On Saved: $number');
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Contact Address',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.appGold),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextFormField(
                              controller: _addressController,
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) {
                                setState(() {});
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your address';
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
                                hintText: 'Enter address',
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
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          setState(() {
                            _request = updateProfile(context);
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
        ));
  }
}
