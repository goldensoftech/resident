import 'dart:convert';

import 'package:resident/app_export.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with CustomAppBar, CustomWidgets, ErrorSnackBar {
  String? _image;
  @override
  void initState() {
    _image = ResponseData.loginResponse?.user!.photo;
    super.initState();
  }

  Uint8List? convertImage(String? image) {
    if (image != null) {
      Uint8List bytes = base64Decode(image);
      return bytes;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: defaultAppBar(title: "Profile"),
        backgroundColor: AppColors.whiteA700,
        body: ListView(
          //  padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
          // physics: const BouncingScrollPhysics(),
          children: [
            ResponseData.loginResponse?.isLoggedIn == true
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: _image != null
                                    ? Image.memory(convertImage(_image)!,
                                        errorBuilder: (ctx, r, c) => Icon(
                                              Icons.account_circle_rounded,
                                              size: 100,
                                              color: AppColors.appGold,
                                            ),
                                        height: 100,
                                        width: 100,
                                        fit: BoxFit.cover)
                                    : Icon(
                                        Icons.account_circle_rounded,
                                        size: 100,
                                        color: AppColors.appGold,
                                      ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _showBtnSht();
                            },
                            child: FittedBox(
                              child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: AppColors.gold100,
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Row(children: [
                                    Icon(Icons.camera_alt_rounded,
                                        size: 12, color: AppColors.appGold),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Upload",
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: AppColors.baseBlack,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                  ])),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Text(
                          "${ResponseData.loginResponse!.user!.lastName} ${ResponseData.loginResponse!.user!.firstName}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColors.black900,
                              fontSize: 14,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Text(
                        "${ResponseData.loginResponse!.user!.userName ?? " "} ",
                        style: TextStyle(
                            color: AppColors.black900,
                            fontSize: 10,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                margin: const EdgeInsets.only(top: 10),
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                color: AppColors.lightGrey,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                  child: Text("General Settings",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                ),
              ),
              ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (ctx, index) {
                    final data = DummyData().profileTiles[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      onTap: () {
                        navigatePush(context, data['gotoPage']);
                      },
                      leading: Icon(
                        data['icon'],
                        size: 18,
                        color: AppColors.black900,
                      ),
                      title: Text(data['title'],
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400)),
                      trailing: Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                        color: AppColors.black900,
                      ),
                    );
                  },
                  separatorBuilder: (ctx, i) =>
                      Divider(height: 1, color: AppColors.lightGrey),
                  itemCount: DummyData().profileTiles.length),
              Divider(height: 1, color: AppColors.lightGrey),
              ListTile(
                onTap: () {
                  // sendErrorMessage(
                  //     "", isSuccess: true, "Login Successful", context);
                  _showLogOutModal();
                },
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                title: Text("Logout",
                    style: TextStyle(
                        color: AppColors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w400)),
              ),
            ])
          ],
        ),
      ),
    );
  }

  void _showLogOutModal() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
        ),
        builder: (BuildContext context) {
          return Wrap(
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 30, left: 20, right: 20, bottom: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.red.shade800,
                      child: const Center(
                        child: Icon(
                          Icons.logout_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 10),
                      child: Text(
                        'Logout',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'OpenSans-Bold'),
                      ),
                    ),
                    SizedBox(
                      child: Text(
                        'Are you sure you want to logout of Resident App?',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w300,
                            fontFamily: 'OpenSans-Bold'),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      onTap: () {
                        ResponseData.loginResponse = null;
                        AuthBackend().setDefaultUser();
                        
                        navigateRemoveAll(context, const LoginScreen());
                        // AuthHelper().clearUserData();
                        // clearAll(context);
                        // Phoenix.rebirth(context);
                        // Navigator.of(context).pushNamedAndRemoveUntil(
                        //     AuthScreen.routeName, (route) => false);
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        decoration: BoxDecoration(
                            color: Colors.red.shade800,
                            borderRadius: BorderRadius.circular(30)),
                        child: const Center(
                          child: Text(
                            'Logout',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(width: .8, color: Colors.grey)),
                        child: const Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          );
        });
  }

  void _showBtnSht() {
    showModalBottomSheet(
        showDragHandle: true,
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) => ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(
                  top: displaySize.height * 0.03,
                  bottom: displaySize.height * 0.05),
              children: [
                const Text(
                  'Pick Profile Picture',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: displaySize.height * 0.02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: const CircleBorder(),
                            fixedSize: Size(
                              displaySize.width * .3,
                              displaySize.height * .15,
                            )),
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();

                          final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery, imageQuality: 80);
                          if (image != null) {
                            // log('Image Path :${image.path}');
                            image.readAsBytes().then((bytes) {
                              String base64String = base64Encode(bytes);
                              AuthBackend().updateProfilePic(context,
                                  profileUrl: base64String);
                              setState(() {
                                _image = base64String;
                              });
                              convertImage(_image);
                            });

                            //  APIs.updateProfilePicture(context, File(_image!));
                            Navigator.pop(context);
                          }
                        },
                        child: Image.asset('assets/images/add_image.png')),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: const CircleBorder(),
                            fixedSize: Size(
                              displaySize.width * .3,
                              displaySize.height * .15,
                            )),
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();

                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera, imageQuality: 80);
                          if (image != null) {
                            image.readAsBytes().then((bytes) {
                              String base64String = base64Encode(bytes);
                              AuthBackend().updateProfilePic(context,
                                  profileUrl: base64String);
                              setState(() {
                                _image = base64String;
                              });
                              convertImage(_image);
                            });
                            Navigator.pop(context);
                          }
                        },
                        child: Image.asset('assets/images/camera.png'))
                  ],
                )
              ],
            ));
  }
}
