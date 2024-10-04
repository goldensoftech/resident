import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as client;

import 'package:resident/app_export.dart';
import 'package:resident/constants/api.dart';
import 'package:resident/presentation/dashboard/bills/web_screen.dart';

class AuthBackend with ErrorSnackBar, CustomAlerts {
  late SharedPreferences sharedPreferences;
  Future<void> getAuthToken(context) async {
    const url = "$host$baseUrl/api/token/v1/generatetoken";

    try {
      final httpConnectionApi = await client.post(Uri.parse(url),
          body: json.encode({"client_id": apiId, "client_secret": apiSecret}),
          headers: {
            HttpHeaders.contentTypeHeader: headerType,
          }).timeout(const Duration(seconds: 30));
      var resBody = jsonDecode(httpConnectionApi.body.toString());
      logger.i(resBody);
      if (httpConnectionApi.statusCode == 200) {
        if (resBody['code'] == "00") {
          ResponseData.tokenResponseModel =
              TokenResponseModel.fromJson(resBody);
        } else {
          sendErrorMessage("Error", "Session Timeout", context);
        }
      }
    } on TimeoutException catch (_) {
      sendErrorMessage(
          "Network failure", "Please check your internet connection", context);
      //navigateReplace(context, const Dashboard());
    } on NoSuchMethodError catch (_) {
      sendErrorMessage(
          "error", 'please check your credentials and try again.', context);
    } on Exception catch (_) {
      sendErrorMessage(
          "Error Occurred", "An Error Occurred, try again later", context);
      //navigateReplace(context, const Dashboard());
    } catch (e) {
      logger.e(e);

      sendErrorMessage("Error", "Server Timeout", context);
      rethrow;
    }
  }

  Future<void> checkAndUpdateToken(context) async {
    int currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    if (ResponseData.tokenResponseModel == null) {
      await getAuthToken(context);
    }
    num timeLeft =
        ResponseData.tokenResponseModel!.tokenExpiryTime! - currentTimestamp;
    if (timeLeft <= 300) {
      // The token will expire in the next 5 minutes, so update it
      await getAuthToken(context);
    }
  }

  Future<void> updateProfile(context,
      {required String firstName,
      required String lastName,
      required String phoneNumber}) async {
    try {
      await checkAndUpdateToken(context);
    } on SocketException catch (_) {
      sendErrorMessage(
          "Network failure", "Please check your internet connection", context);
    } on NoSuchMethodError catch (_) {
      sendErrorMessage(
          "error", 'please check your credentials and try again.', context);
    } on TimeoutException catch (_) {
      sendErrorMessage(
          "Network failure", "Please check your internet connection", context);
      //navigateReplace(context, const Dashboard());
    } on Exception catch (e) {
      logger.e(e);
    }
  }

  Future<void> bvnVerification(context) async {
    WebViewController _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          // onHttpError: (error) {
          //   sendErrorMessage("Error", "Kindly check your connection.", context);
          // },
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {
            // navigateBack(context);
            // sendErrorMessage("Error", "An Error Occurred", context);
          },
          onNavigationRequest: (NavigationRequest request) async {
            if (request.url.contains('failed')) {
              print("Processing Request ${request.url}");

              sendErrorMessage("Error",
                  "Verification not successful, kindly try again", context);
              // Navigator.of(context).pop();
              // Navigator.of(context).pop();

              return NavigationDecision.navigate;
            } else if (request.url.contains("success") ||
                request.url.contains("verified")) {
              print("Url Finished ${request.url}");
              sendErrorMessage(
                  isSuccess: true,
                  "Success",
                  "Verification Successful",
                  context);

              await AuthBackend().signInAuto(context,
                  email: DummyData.emailAddress.toString(),
                  pwd: DummyData.password.toString());
              Navigator.of(context).pop();
              //navigateRemoveAll(context, const LoginScreen());

              // showSuccessAlert(context,
              //     title: "Successful",
              //     description: "Kindly, login again.",
              //     goToPage: const Dashboard());
              return NavigationDecision.navigate;
            } else if (request.url.contains("login)") ||
                request.url.contains("signin")) {
              // sendErrorMessage(
              //     isSuccess: true,
              //     "Success",
              //     "Verification Successful",
              //     context);
              Navigator.of(context).pop();
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..canGoBack()
      ..loadRequest(Uri.parse(verificationURL));
    navigatePush(context,
        WebScreen(webTitle: "KYC Verification", controller: _controller));
  }

  Future<void> login(context,
      {required String email, required String pwd}) async {
    const url = "$host$baseUrl${appPathUrl}login";

    try {
      await checkAndUpdateToken(context);
      final httpConnectionApi = await client.post(Uri.parse(url),
          body: json.encode({"email": email, "password": pwd}),
          headers: {
            HttpHeaders.contentTypeHeader: headerType,
            HttpHeaders.authorizationHeader: headerAuthorization
          }).timeout(const Duration(seconds: 60));

      if (httpConnectionApi.statusCode == 200) {
        var resBody = jsonDecode(httpConnectionApi.body.toString());
        logger.i(resBody);
        if (resBody['code'] == "00") {
          ResponseData.loginResponse = LoginResponseModel.fromJson(resBody);

          ResponseData.loginResponse!.isLoggedIn = true;
          saveUserData(email: email, pwd: pwd);
          ResponseData.txHistory = await TransactionBackend()
              .getTransactionHistory(context,
                  email: email,
                  startDate: DateTime.now().subtract(const Duration(days: 30)),
                  endDate: DateTime.now());
          await TransactionBackend().getUserBanks(context);
          navigateRemoveAll(context, const Dashboard());
        } else {
          sendErrorMessage("Error", resBody['description'], context);
          // navigateRemoveAll(context, const LoginScreen());
        }
      } else {
        sendErrorMessage("Error", "Unable to Login", context);
      }
    } on SocketException catch (_) {
      sendErrorMessage(
          "Network failure", "Please check your internet connection", context);
    } on NoSuchMethodError catch (_) {
      sendErrorMessage(
          "error", 'please check your credentials and try again.', context);
    } on TimeoutException catch (_) {
      sendErrorMessage(
          "Network failure", "Please check your internet connection", context);
      //navigateReplace(context, const Dashboard());
    } on Exception catch (e) {
      logger.e(e);
    }
  }

  Future<void> signInAuto(context,
      {required String email, required String pwd}) async {
    const url = "$host$baseUrl${appPathUrl}login";

    try {
      await checkAndUpdateToken(context);
      final httpConnectionApi = await client.post(Uri.parse(url),
          body: json.encode({"email": email, "password": pwd}),
          headers: {
            HttpHeaders.contentTypeHeader: headerType,
            HttpHeaders.authorizationHeader: headerAuthorization
          }).timeout(const Duration(seconds: 60));
      print(httpConnectionApi);
      if (httpConnectionApi.statusCode == 200) {
        var resBody = jsonDecode(httpConnectionApi.body.toString());
        logger.i("Code ${resBody['code']}");
        if (resBody['code'] == "00") {
          ResponseData.loginResponse = LoginResponseModel.fromJson(resBody);

          ResponseData.loginResponse!.isLoggedIn = true;
          saveUserData(email: email, pwd: pwd);
          ResponseData.txHistory = await TransactionBackend()
              .getTransactionHistory(context,
                  email: email,
                  startDate: DateTime.now().subtract(const Duration(days: 30)),
                  endDate: DateTime.now());
          await TransactionBackend().getUserBanks(context);
          navigateRemoveAll(context, const Dashboard());
        } else {
          sendErrorMessage("Error", resBody['description'], context);
          navigateRemoveAll(context, const LoginScreen());
        }
      } else {
        sendErrorMessage("Error", "Unable to Login", context);
      }
    } on SocketException catch (_) {
      sendErrorMessage(
          "Network failure", "Please check your internet connection", context);
    } on NoSuchMethodError catch (_) {
      sendErrorMessage(
          "error", 'please check your credentials and try again.', context);
    } on TimeoutException catch (_) {
      sendErrorMessage(
          "Network failure", "Please check your internet connection", context);
      //navigateReplace(context, const Dashboard());
    } on Exception catch (e) {
      logger.e(e);
    }
  }

  Future<void> updateProfilePic(context, {required String profileUrl}) async {
    const url = "$host$baseUrl${appPathUrl}updateprofile";
    try {
      await checkAndUpdateToken(context);
      final httpConnectionApi = await client
          .post(Uri.parse(url),
              body: json.encode({
                "firstName": ResponseData.loginResponse?.user?.firstName,
                "lastName": ResponseData.loginResponse?.user?.lastName,
                "email": ResponseData.loginResponse?.user?.userName,
                "phone": ResponseData.loginResponse?.user?.phoneNumber,
                "photo": profileUrl, //base64 image
              }),
              headers: headersContent)
          .timeout(const Duration(seconds: 60));
      if (httpConnectionApi.statusCode == 200) {
        var resBody = jsonDecode(httpConnectionApi.body.toString());
        print(resBody);
        if (resBody['code'] == "00") {
          sendErrorMessage(
              isSuccess: true,
              "Success",
              "Profile photo updated successfully",
              context);
          ResponseData.loginResponse!.user!.photo = profileUrl;
        } else {
          sendErrorMessage("Error", resBody['description'], context);
        }
      }
    } on TimeoutException catch (_) {
      sendErrorMessage(
          "Network failure", "Please check your internet connection", context);
      //navigateReplace(context, const Dashboard());
    } on NoSuchMethodError catch (_) {
      sendErrorMessage(
          "error", 'please check your credentials and try again.', context);
    } on Exception catch (_) {
      sendErrorMessage(
          "Error Occurred", "An Error Occurred, try again later", context);
      //navigateReplace(context, const Dashboard());
    } catch (e) {
      logger.e(e);

      sendErrorMessage(
          "Error Occurred", "An Error Occurred, try again later", context);
      rethrow;
      //navigateReplace(context, const Dashboard());
    }
  }

  Future<void> signUp(context,
      {required String email,
      required String pwd,
      required String phoneNumber,
      required String firstName,
      required String bvn,
      required String lastName}) async {
    const url = "$host$baseUrl${appPathUrl}signup";
    try {
      //print(UtilFunctions().generateDemoNumber());
      await checkAndUpdateToken(context);
      final httpConnectionApi = await client
          .post(Uri.parse(url),
              body: json.encode({
                "firstName": firstName,
                "lastName": lastName,
                "email": email,
                "phone": phoneNumber,
                "password": pwd,
                "bvn": bvn
              }),
              headers: headersContent)
          .timeout(const Duration(seconds: 60));
      if (httpConnectionApi.statusCode == 200) {
        var resBody = jsonDecode(httpConnectionApi.body.toString());
        if (resBody['code'] == "00") {
          showSuccessAlert(context,
              title: "Registration",
              description: resBody['description'],
              goToPage: const LoginScreen());
          // await signInAuto(context, email: email, pwd: pwd);
        } else {
          sendErrorMessage("Error", resBody['description'], context);
        }
      }
    } on TimeoutException catch (_) {
      sendErrorMessage(
          "Network failure", "Please check your internet connection", context);
      //navigateReplace(context, const Dashboard());
    } on NoSuchMethodError catch (_) {
      sendErrorMessage(
          "error", 'please check your credentials and try again.', context);
    } on Exception catch (_) {
      sendErrorMessage(
          "Error Occurred", "An Error Occurred, try again later", context);
      //navigateReplace(context, const Dashboard());
    } catch (e) {
      logger.e(e);

      sendErrorMessage(
          "Error Occurred", "An Error Occurred, try again later", context);
      rethrow;
      //navigateReplace(context, const Dashboard());
    }
  }

  Future<void> getOtpForPasswordReset(context, {required String email}) async {
    const url = "$host$baseUrl${appPathUrl}resetpassword";
    try {
      await checkAndUpdateToken(context);
      final httpConnectionApi = await client
          .post(Uri.parse(url),
              body: json.encode({"email": email}), headers: headersContent)
          .timeout(const Duration(seconds: 60));
      if (httpConnectionApi.statusCode == 200) {
        var resBody = jsonDecode(httpConnectionApi.body.toString());
        if (resBody['code'] == "00") {
          sendErrorMessage(
              "", isSuccess: true, resBody['description'], context);
          navigatePush(
              context,
              ForgotPwdEmailVerificationScreen(
                email: email,
              ));
        } else {
          sendErrorMessage("Error", resBody['description'], context);
        }
      } else {
        sendErrorMessage("Error", "Unable to complete request", context);
      }
    } on SocketException catch (_) {
      sendErrorMessage(
          "Network failure", "Please check your internet connection", context);
    } on NoSuchMethodError catch (_) {
      sendErrorMessage(
          "error", 'please check your credentials and try again.', context);
    } on TimeoutException catch (_) {
      sendErrorMessage(
          "Network failure", "Please check your internet connection", context);
      //navigateReplace(context, const Dashboard());
    } on Exception catch (e) {
      logger.e(e);
    }
  }

  Future<void> updatePassword(context,
      {required String oldPassword, required String newPassword}) async {
    const url = "$host$baseUrl${appPathUrl}updatepassword";
    try {
      await checkAndUpdateToken(context);
      final httpConnectionApi = await client
          .post(Uri.parse(url),
              body: json.encode({
                "email": ResponseData.loginResponse!.user!.userName!,
                "oldPassword": oldPassword,
                "newPassword": newPassword,
              }),
              headers: headersContent)
          .timeout(const Duration(seconds: 60));
      if (httpConnectionApi.statusCode == 200) {
        var resBody = jsonDecode(httpConnectionApi.body.toString());
        print(resBody);
        if (resBody['code'] == "00") {
          sendErrorMessage(
              isSuccess: true, "Success", resBody['description'], context);
          saveUserData(
              email: ResponseData.loginResponse!.user!.userName!,
              pwd: newPassword);
          navigateBack(context);
        } else {
          sendErrorMessage("Error", resBody['description'], context);
        }
      }
    } on SocketException catch (_) {
      sendErrorMessage(
          "Network failure", "Please check your internet connection", context);
    } on NoSuchMethodError catch (_) {
      sendErrorMessage(
          "error", 'please check your credentials and try again.', context);
    } on TimeoutException catch (_) {
      sendErrorMessage(
          "Network failure", "Please check your internet connection", context);
      //navigateReplace(context, const Dashboard());
    } on Exception catch (e) {
      logger.e(e);
    }
  }

  Future<void> resetPassword(context,
      {required String token,
      required String email,
      required String password}) async {
    const url = "$host$baseUrl${appPathUrl}createpassword";
    try {
      await checkAndUpdateToken(context);
      final httpConnectionApi = await client
          .post(Uri.parse(url),
              body: json.encode(
                  {"email": email, "token": token, "password": password}),
              headers: headersContent)
          .timeout(const Duration(seconds: 60));
      if (httpConnectionApi.statusCode == 200) {
        var resBody = jsonDecode(httpConnectionApi.body.toString());
        if (resBody['code'] == "00") {
          showSuccessAlert(context,
              description: resBody['description'],
              title: "Password Reset",
              goToPage: const LoginScreen());
        }
      }
    } on SocketException catch (_) {
      sendErrorMessage(
          "Network failure", "Please check your internet connection", context);
    } on NoSuchMethodError catch (_) {
      sendErrorMessage(
          "error", 'please check your credentials and try again.', context);
    } on TimeoutException catch (_) {
      sendErrorMessage(
          "Network failure", "Please check your internet connection", context);
      //navigateReplace(context, const Dashboard());
    } on Exception catch (e) {
      logger.e(e);
    }
  }

  saveUserData({required String email, required String pwd}) async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("Email", email);
    sharedPreferences.setString("Password", pwd);

    DummyData.emailAddress = email;
    DummyData.password = pwd;
  }

  Future<void> setFirstTimeOnAppFalse() async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setBool("firstTimeOnApp", false);
  }

  Future<void> setDefaultUser() async {
    sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("Email", "");
    sharedPreferences.setString("Password", "");
    final loginResponse = LoginResponseModel(isLoggedIn: false, user: null);

    ResponseData.loginResponse = loginResponse;
    await UtilFunctions().getLocation();
  }

  static bool isLoggedIn() {
    if (ResponseData.loginResponse!.isLoggedIn == null ||
        ResponseData.loginResponse!.isLoggedIn == false) {
      return false;
    }
    return true;
  }
}

class UtilFunction {}
