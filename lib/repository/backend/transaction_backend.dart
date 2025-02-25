import 'dart:convert';
import 'dart:io';

import 'package:resident/app_export.dart';
import 'package:http/http.dart' as client;
import 'package:resident/constants/api.dart';
import 'package:crypto/crypto.dart';
import 'payment_gateways.backend.dart';

class TransactionBackend with ErrorSnackBar, CustomAlerts {
  Future<List<DataItem>> getNetworkDataPlans(context,
      {required id, required network}) async {
    const url = "$host$baseUrl${iswPathUrl}iswgetbillerpaymentitem";

    try {
      await AuthBackend().checkAndUpdateToken(context);
      final httpConnectionApi = await client
          .post(Uri.parse(url),
              body: json.encode({"serviceid": id}), headers: headersContent)
          .timeout(const Duration(seconds: 60));

      if (httpConnectionApi.statusCode == 200) {
        var resBody = jsonDecode(httpConnectionApi.body.toString());
        print(resBody);
        if (resBody["ResponseCode"] == "90000") {
          final items = resBody['PaymentItems'] as List<dynamic>;
          final dataItems = items.map((data) {
            return DataItem(
                network: network,
                title: data['Name'],
                amount: double.parse(data["Amount"]) * 0.01,
                code: data["PaymentCode"]);
          }).toList();
          return dataItems;
        } else {
          sendErrorMessage("Error", resBody["error"], context);
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
    return [];
  }

  Future<DataItem?> getBillInfo(context,
      {required id, required network}) async {
    const url = "$host$baseUrl${iswPathUrl}iswgetbillerpaymentitem";
    try {
      await AuthBackend().checkAndUpdateToken(context);
      final httpConnectionApi = await client
          .post(Uri.parse(url),
              body: json.encode({"serviceid": id}), headers: headersContent)
          .timeout(const Duration(seconds: 60));
      if (httpConnectionApi.statusCode == 200) {
        var resBody = json.decode(httpConnectionApi.body);

        final items = resBody["PaymentItems"] as List<dynamic>;

        if (resBody["ResponseCode"] == "90000") {
          return DataItem.fromJson(items.first);
        } else {
          sendErrorMessage(
              "Error", items.first['ResponseDescription'], context);
        }
      }
    } on SocketException catch (_) {
      sendErrorMessage(
          "Network failure", "Please check your internet connection", context);
    } on NoSuchMethodError catch (_) {
      sendErrorMessage(
          "error", 'please check your credentials and try again.', context);
    } on TimeoutException catch (_) {
      sendErrorMessage("Network failure", "Network Timeout", context);
      //navigateReplace(context, const Dashboard());
    } on Exception catch (e) {
      logger.e(e);
    }
    return null;
  }

  Future<BettingDataItem?> getBettingPlatformDetails(context,
      {required int id}) async {
    const url = "$host$baseUrl${iswPathUrl}iswgetbillerpaymentitem";
    try {
      await AuthBackend().checkAndUpdateToken(context);
      final httpConnectionApi = await client
          .post(Uri.parse(url),
              headers: headersContent, body: json.encode({"serviceid": id}))
          .timeout(const Duration(seconds: 60));

      if (httpConnectionApi.statusCode == 200) {
        var resBody = json.decode(httpConnectionApi.body);

        final items = resBody["PaymentItems"] as List<dynamic>;

        if (resBody["ResponseCode"] == "90000") {
          return BettingDataItem.fromJson(items.first);
        } else {
          sendErrorMessage(
              "Error", items.first['ResponseDescription'], context);
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
    return null;
  }

  Future<void> payWithDynamicNQR(context,
      {required NqrCodeData data,
      required String orderSn,
      required UserBankDetails bankDetails}) async {
    String timeStamp = "${DateTime.now().millisecondsSinceEpoch ~/ 1000}";
    String latitude = ResponseData.userLocation!.latitude;
    String longitude = ResponseData.userLocation!.longitude;

    const url = "$host$baseUrl${nqrUrl}nqr_createdynamicqr_transaction";
    String signTemp =
        "institution_number=${data.institutionNumber}&order_amount=${data.orderAmount}&order_sn=$orderSn&" +
            "timestamp=$timeStamp&user_account_name=${bankDetails.accountName}&user_account_number=${bankDetails.accountNumber}&" +
            "user_bank_no=${bankDetails.bankCode}&user_bank_verification_number=${bankDetails.bvn}&" +
            "user_gps=$latitude,$longitude&user_kyc_level=${bankDetails.kycLevel}$apiKey";
    print("Sign Details");
    print(signTemp);
    var bytes = utf8.encode(signTemp);
    var digest = md5.convert(bytes);
    String authSign = digest.toString().toUpperCase();

    print(authSign);
    try {
      await AuthBackend().checkAndUpdateToken(context);
      final httpConnnectionApi = await client.post(Uri.parse(url),
          headers: headersContent,
          body: json.encode({
            "institution_number": data.institutionNumber,
            "order_amount": data.orderAmount,
            "order_sn": orderSn,
            "timestamp": timeStamp,
            "user_account_name": bankDetails.accountName,
            "user_account_number": bankDetails.accountNumber,
            "user_bank_no": bankDetails.bankCode,
            "user_bank_verification_number": bankDetails.bvn,
            "user_gps": "$latitude,$longitude",
            "user_kyc_level": bankDetails.kycLevel,
            "sign": authSign
          }));

      if (httpConnnectionApi.statusCode == 200) {
        var resBody = json.decode(httpConnnectionApi.body);
        logger.i(resBody);
        if (resBody['error'] == "Service Unavailable") {
          sendErrorMessage("Error", "Service Unavailable", context);
        } else if (resBody["ReturnCode"] == "Fail") {
          sendErrorMessage("Error", resBody['ReturnMsg'], context);
        } else if (resBody["code"] == "91") {
          sendErrorMessage("Error", resBody["description"], context);
        } else if (resBody["ReturnCode"] == "Success") {
          showSuccessAlert(context,
              title: "Payment",
              description:
                  "Your transaction is currently being processed transaction",
              goToPage: const Dashboard());
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
    // return false;
  }

  Future<List<Bank>> getBankList(context) async {
    const url = "$host$baseUrl${nqrUrl}nqr_getbanklist";
    try {
      await AuthBackend().checkAndUpdateToken(context);
      final httpConnectionApi = await client
          .post(Uri.parse(url),
              headers: headersContent,
              body: json.encode({"userEmail": DummyData.emailAddress}))
          .timeout(const Duration(seconds: 60));
      if (httpConnectionApi.statusCode == 200) {
        var resBody = json.decode(httpConnectionApi.body);
        print(resBody);
        if (resBody["code"] == "00") {
          final banks = resBody['bankList'] as Map<String, dynamic>;
          logger.i(banks);
          ResponseData.bankList = banks.values
              .map<Bank>((json) =>
                  Bank(name: json['Bank Name'], code: json['Bank Code']))
              .toList();
          print("Banks Done");
          return ResponseData.bankList;
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
    return [];
  }

  Future<MerchantResponse?> createMerchant(context,
      {required NqrCodeData data, required UserBankDetails bankDetails}) async {
    String timeStamp = "${DateTime.now().millisecondsSinceEpoch ~/ 1000}";
    const url = "$host$baseUrl${nqrUrl}nqr_createmerchant";
    String signTemp =
        "account_name=${bankDetails.accountName}&account_number=${bankDetails.accountNumber}&address=add&bank_no=${bankDetails.bankCode}&" +
            "contact=${ResponseData.loginResponse!.user!.lastName}&email=${ResponseData.loginResponse!.user!.userName}" +
            "&institution_number=${data.institutionNumber}&m_fee_bearer=0&name=${data.merchantName}&phone=${ResponseData.loginResponse!.user!.phoneNumber}&timestamp=$timeStamp&tin=999177001$apiKey";

    print("Sign Details");
    print(signTemp);
    var bytes = utf8.encode(signTemp);
    var digest = md5.convert(bytes);
    String authSign = digest.toString().toUpperCase();

    print(authSign);
    try {
      await AuthBackend().checkAndUpdateToken(context);

      final httpConnnectionApi = await client
          .post(Uri.parse(url),
              headers: headersContent,
              body: json.encode({
                "account_name": bankDetails.accountName,
                "account_number": bankDetails.accountNumber,
                "address": "add",
                "bank_no": bankDetails.bankCode,
                "contact": ResponseData.loginResponse!.user!.lastName,
                "email": ResponseData.loginResponse!.user!.userName,
                "institution_number": institutionNumber,
                "m_fee_bearer": "0",
                "name": data.merchantName,
                "phone": "${ResponseData.loginResponse!.user!.phoneNumber}",
                "timestamp": timeStamp,
                "tin": "999177001",
                "sign": authSign
              }))
          .timeout(const Duration(seconds: 60));
      if (httpConnnectionApi.statusCode == 200) {
        var resBody = json.decode(httpConnnectionApi.body);
        print("******Creating Merchant***********");
        logger.i(resBody);
        if (resBody['error'] == "Service Unavailable") {
          sendErrorMessage("Error", "Service Unavailable", context);
        } else if (resBody["ReturnCode"] == "Fail") {
          sendErrorMessage("Error", resBody['ReturnMsg'], context);
        } else if (resBody["code"] == "91") {
          sendErrorMessage("Error", resBody["description"], context);
        } else if (resBody["ReturnCode"] == "Success") {
          return MerchantResponse(
              institutionNumber: resBody["InstitutionNumber"],
              mchNo: resBody["Mch_no"],
              merchantName: resBody["MerchantName"],
              merchantAddress: resBody["MerchantAddress"],
              merchantContantName: resBody["MerchantContactName"],
              merchantEmail: resBody["MerchantEmail"],
              merchantPhoneNumber: resBody["MerchantPhoneNumber"],
              merchantTin: resBody["MerchantTIN"]);
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
    return null;
  }

  Future<BindMchResponse?> bindMerchant(context,
      {required String merchantNo,
      required NqrCodeData data,
      required UserBankDetails bankDetails}) async {
    String timeStamp = "${DateTime.now().millisecondsSinceEpoch ~/ 1000}";
    const url = "$host$baseUrl${nqrUrl}nqr_bindmerchant";
    String signTemp =
        "account_name=${bankDetails.accountName}&account_number=${bankDetails.accountNumber}&" +
            "bank_no=${bankDetails.bankCode}&institution_number=${data.institutionNumber}&mch_no=${data.merchantNo}&" +
            "timestamp=$timeStamp$apiKey";
    var bytes = utf8.encode(signTemp);
    var digest = md5.convert(bytes);
    String authSign = digest.toString().toUpperCase();

    try {
      await AuthBackend().checkAndUpdateToken(context);
      final httpConnnectionApi = await client
          .post(Uri.parse(url),
              headers: headersContent,
              body: json.encode({
                "account_name": bankDetails.accountName,
                "account_number": bankDetails.accountNumber,
                "bank_no": bankDetails.bankCode,
                "institution_number": data.institutionNumber,
                "mch_no": data.merchantNo,
                "timestamp": timeStamp,
                "sign": authSign
              }))
          .timeout(const Duration(seconds: 60));
      if (httpConnnectionApi.statusCode == 200) {
        var resBody = json.decode(httpConnnectionApi.body);
        logger.i(resBody);
        if (resBody['error'] == "Service Unavailable") {
          sendErrorMessage("Error", "Service Unavailable", context);
        } else if (resBody["ReturnCode"] == "Fail") {
          sendErrorMessage("Error", resBody['ReturnMsg'], context);
        } else if (resBody["code"] == "91") {
          sendErrorMessage("Error", resBody["description"], context);
        } else if (resBody["ReturnCode"] == "Success") {
          return BindMchResponse(
            institutionNumber: resBody["InstitutionNumber"],
            mchNo: resBody["Mch_no"],
          );
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
    return null;
  }

  Future<SubMchResponse?> createSubMerchant(context,
      {required String merchantNo,
      required NqrCodeData data,
      required UserBankDetails bankDetails}) async {
    String timeStamp = "${DateTime.now().millisecondsSinceEpoch ~/ 1000}";
    const url = "$host$baseUrl${nqrUrl}nqr_createsubmerchant";
    String signTemp =
        "email=${ResponseData.loginResponse!.user!.userName}&institution_number=${data.institutionNumber}&mch_no=${data.merchantNo}&" +
            "name=${data.merchantName}sub&phone_number=${ResponseData.loginResponse!.user!.phoneNumber}&" +
            "sub_amount=588&sub_fixed=1&timestamp=$timeStamp$apiKey";
    print("Sign Details");
    print(signTemp);
    var bytes = utf8.encode(signTemp);
    var digest = md5.convert(bytes);
    String authSign = digest.toString().toUpperCase();
    try {
      await AuthBackend().checkAndUpdateToken(context);
      final httpConnnectionApi = await client
          .post(Uri.parse(url),
              headers: headersContent,
              body: json.encode({
                "email": ResponseData.loginResponse!.user!.userName,
                "institution_number": data.institutionNumber,
                "mch_no": data.merchantNo,
                "name": "${data.merchantName}sub",
                "phone_number": ResponseData.loginResponse!.user!.phoneNumber,
                "sub_amount": "588",
                "sub_fixed": "1",
                "timestamp": timeStamp,
                "sign": authSign
              }))
          .timeout(const Duration(seconds: 60));
      if (httpConnnectionApi.statusCode == 200) {
        var resBody = json.decode(httpConnnectionApi.body);
        logger.i(resBody);
        if (resBody['error'] == "Service Unavailable") {
          sendErrorMessage("Error", "Service Unavailable", context);
        } else if (resBody["ReturnCode"] == "Fail") {
          sendErrorMessage("Error", resBody['ReturnMsg'], context);
        } else if (resBody["code"] == "91") {
          sendErrorMessage("Error", resBody["description"], context);
        } else if (resBody["ReturnCode"] == "Success") {
          return SubMchResponse(
              institutionNumber: resBody["InstitutionNumber"],
              mchNo: resBody['Mch_no'],
              envcoCode: resBody['Emvco_code'],
              subMchNo: resBody['Sub_mch_no'],
              subName: resBody['Sub_name']);
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
    return null;
  }

  Future<DynamicQRResponse?> createDynamicQR(context,
      {required String merchantNo,
      required String orderNo,
      required NqrCodeData data,
      required String subMchNo,
      required UserBankDetails bankDetails}) async {
    String timeStamp = "${DateTime.now().millisecondsSinceEpoch ~/ 1000}";
    const url = "$host$baseUrl${nqrUrl}nqr_createdynamicqr";
    String signTemp =
        "amount=${data.orderAmount}&channel=1&code_type=1&institution_number=${data.institutionNumber}&mch_no=${data.merchantNo}&" +
            "order_no=$orderNo&order_type=4&sub_mch_no=${data.subMerchantNo}&timestamp=$timeStamp&unique_id=KRD1234$apiKey";
    print("Sign Details");
    print(signTemp);
    var bytes = utf8.encode(signTemp);
    var digest = md5.convert(bytes);
    String authSign = digest.toString().toUpperCase();

    print(authSign);
    print("Payload");

    print({
      "amount": data.orderAmount,
      "channel": "1",
      "code_type": "1",
      "institution_number": data.institutionNumber,
      "mch_no": data.merchantNo,
      "order_no": orderNo,
      "order_type": "4",
      "sub_mch_no": data.subMerchantNo,
      "timestamp": timeStamp,
      "unique_id": "KRD1234",
      "sign": authSign
    });
    try {
      await AuthBackend().checkAndUpdateToken(context);
      final httpConnnectionApi = await client
          .post(Uri.parse(url),
              headers: headersContent,
              body: json.encode({
                "amount": data.orderAmount,
                "channel": "1",
                "code_type": "1",
                "institution_number": data.institutionNumber,
                "mch_no": data.merchantNo,
                "order_no": orderNo,
                "order_type": "4",
                "sub_mch_no": data.subMerchantNo,
                "timestamp": timeStamp,
                "unique_id": "KRD1234",
                "sign": authSign
              }))
          .timeout(const Duration(seconds: 60));
      if (httpConnnectionApi.statusCode == 200) {
        var resBody = json.decode(httpConnnectionApi.body);
        logger.i(resBody);
        if (resBody['error'] == "Service Unavailable") {
          sendErrorMessage("Error", "Service Unavailable", context);
        } else if (resBody["ReturnCode"] == "Fail") {
          sendErrorMessage("Error", resBody['ReturnMsg'], context);
        } else if (resBody["code"] == "91") {
          sendErrorMessage("Error", resBody["description"], context);
        } else if (resBody["ReturnCode"] == "Success") {
          return DynamicQRResponse(
              codeUrl: resBody['CodeUrl'], orderSn: resBody['OrderSn']);
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
    return null;
  }

  Future<void> makeNQRPayment(context,
      {required UserBankDetails bankDetails, required NqrCodeData data}) async {
    data.orderSn = "202410140101492811481193723128";
    data.institutionNumber = institutionNumber;
    data.subMerchantNo = "S0000007261";
    data.orderAmount = "200";
    data.merchantNo = "M0000005463";

    print("Length :${data.orderSn.length}");
    //241016232209006037960828520400
// 241016232209006037960828520400
    final mchRes =
        await createMerchant(context, data: data, bankDetails: bankDetails);
        print("Completed Merchant");
    if (mchRes != null) {
      await bindMerchant(context,
          merchantNo: mchRes.mchNo, data: data, bankDetails: bankDetails);
           print("Completed bind Merchant");
      final subMchRes = await createSubMerchant(context,
          merchantNo: mchRes.mchNo, data: data, bankDetails: bankDetails);
           print("Completed sub Merchant");

      if (subMchRes != null) {
        final dynamicQR = await createDynamicQR(context,
            merchantNo: subMchRes.mchNo,
            orderNo: data.orderSn,
            data: data,
            subMchNo: subMchRes.subMchNo,
            bankDetails: bankDetails); print("Completed Dynamic QR");
        if (dynamicQR != null) {
          if (!data.isDynamic) {
            await payWithDynamicNQR(context,
                data: data,
                orderSn: dynamicQR.orderSn,
                
                bankDetails: bankDetails);
                 print("Completed paywithdynamic ");
          } else {
            await payWithStaticNQR(context,
                merchantNo: subMchRes.mchNo,
                subMchNo: subMchRes.subMchNo,
                data: data,
                bankDetails: bankDetails);
                 print("Completed paywithstatic ");
          }
          // await payWithDynamicNQR(context,
          //     data: data,
          //     orderSn: dynamicQR.orderSn,
          //     bankDetails: bankDetails);
        }
      }
    }
  }

  Future<void> payWithStaticNQR(context,
      {required String merchantNo,
      required String subMchNo,
      required NqrCodeData data,
      required UserBankDetails bankDetails}) async {
    String timeStamp = "${DateTime.now().millisecondsSinceEpoch ~/ 1000}";
    const url = "$host$baseUrl${nqrUrl}nqr_createstaticqr_transaction";
    String latitude = ResponseData.userLocation!.latitude;
    String longitude = ResponseData.userLocation!.longitude;
    String signTemp = "amount=${data.orderAmount}&channel=1&institution_number=${data.institutionNumber}&" +
        "mch_no=${data.merchantNo}&order_no=${data.orderSn}&sub_mch_no=${data.subMerchantNo}&timestamp=$timeStamp&" +
        "user_account_name=${bankDetails.accountName}&user_account_number=${bankDetails.accountNumber}&" +
        "user_bank_no=${bankDetails.bankCode}&user_bank_verification_number=${bankDetails.bvn}&" +
        "user_gps=$latitude,$longitude&user_kyc_level=${bankDetails.kycLevel}$apiKey";
    print("Sign Details");
    print(signTemp);
    var bytes = utf8.encode(signTemp);
    var digest = md5.convert(bytes);
    String authSign = digest.toString().toUpperCase();
    try {
      await AuthBackend().checkAndUpdateToken(context);
      final httpConnnectionApi = await client
          .post(Uri.parse(url),
              headers: headersContent,
              body: json.encode({
                "amount": data.orderAmount,
                "channel": "1",
                "institution_number": data.institutionNumber,
                "mch_no": data.merchantNo,
                "order_no": data.orderSn,
                "sub_mch_no": data.subMerchantNo,
                "timestamp": timeStamp,
                "user_account_name": bankDetails.accountName,
                "user_account_number": bankDetails.accountNumber,
                "user_bank_no": bankDetails.bankCode,
                "user_bank_verification_number": bankDetails.bvn,
                "user_gps": "$latitude,$longitude",
                "user_kyc_level": bankDetails.kycLevel,
                "sign": authSign
              }))
          .timeout(const Duration(seconds: 60));
      if (httpConnnectionApi.statusCode == 200) {
        var resBody = json.decode(httpConnnectionApi.body);
        logger.i(resBody);
        if (resBody['error'] == "Service Unavailable") {
          sendErrorMessage("Error", "Service Unavailable", context);
        } else if (resBody["ReturnCode"] == "Fail") {
          sendErrorMessage("Error", resBody['ReturnMsg'], context);
        } else if (resBody["code"] == "91") {
          sendErrorMessage("Error", resBody["description"], context);
        } else if (resBody["ReturnCode"] == "Success") {
          showSuccessAlert(context,
              title: "Payment",
              description:
                  "Your transaction is currently being processed transaction",
              goToPage: const Dashboard());
        }
        // if (resBody["code"] == "00") {
        //   // final accounts = resBody['Accounts'] as Map<String, dynamic>;
        //   // logger.i(accounts);
        //   // ResponseData.userBanks = accounts.values
        //   //     .map<UserBankDetails>((json) => UserBankDetails.fromJson(json))
        //   //     .toList();
        //   // print("Banks Done");
        // } else {
        //   sendErrorMessage("Error", resBody['description'], context);
        // }
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

  String getPaymentSign(
      {required String timeStamp, required UserBankDetails bankDetails}) {
    String signTemp =
        "account_number=${bankDetails.accountNumber}&bank_number=${bankDetails.bankCode}&channel=1&institution_number=$institutionNumber&timestamp=$timeStamp$apiKey";
    // Convert signTemp to bytes and apply MD5
    var bytes = utf8.encode(signTemp);
    var digest = md5.convert(bytes);

    // Return the MD5 hash as a hexadecimal string
    return digest.toString().toUpperCase();
  }

  Future<void> getUserBanks(
    context,
  ) async {
    const url = "$host$baseUrl${nqrUrl}nqr_getaccount";
    try {
      await AuthBackend().checkAndUpdateToken(context);
      final httpConnectionApi = await client
          .post(Uri.parse(url),
              headers: headersContent,
              body: json.encode({"userEmail": DummyData.emailAddress}))
          .timeout(const Duration(seconds: 60));
      if (httpConnectionApi.statusCode == 200) {
        var resBody = json.decode(httpConnectionApi.body);
        print(resBody);
        if (resBody["code"] == "00") {
          final accounts = resBody['Accounts'] as Map<String, dynamic>;
          logger.i(accounts);
          ResponseData.userBanks = accounts.values
              .map<UserBankDetails>((json) => UserBankDetails.fromJson(json))
              .toList();
          print("Banks Done");
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

  Future<void> deleteAccount(context, {required String accountNumber}) async {
    const url = "$host$baseUrl${nqrUrl}nqr_deleteaccount";
    try {
      await AuthBackend().checkAndUpdateToken(context);
      final httpConnnectionApi = await client
          .post(Uri.parse(url),
              headers: headersContent,
              body: json.encode({
                "accountNumber": accountNumber,
                "userEmail": ResponseData.loginResponse!.user!.userName
              }))
          .timeout(const Duration(seconds: 60));
      if (httpConnnectionApi.statusCode == 200) {
        var resBody = json.decode(httpConnnectionApi.body);
        print(resBody);
        if (resBody["code"] == "00") {
          ResponseData.userBanks
              .removeWhere((details) => details.accountNumber == accountNumber);
          sendErrorMessage(
              "Successful", isSuccess: true, resBody['description'], context);
        } else {
          print("error");
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

  Future<bool> addBankDetails(context,
      {required UserBankDetails userBankDetails,
      required String bankCode}) async {
    const url = "$host$baseUrl${nqrUrl}nqr_addaccount";
    // if (!ResponseData.loginResponse!.user!.bvnStatus! ||
    //     ResponseData.loginResponse!.user!.bvn != userBankDetails.bvn) {
    //   sendErrorMessage("Verification Response",
    //       "Account KYC information does not match bank details", context);
    //   return false;
    // }
    try {
      await AuthBackend().checkAndUpdateToken(context);
      final httpConnnectionApi = await client
          .post(Uri.parse(url),
              headers: headersContent,
              body: json.encode({
                "accountNumber": userBankDetails.accountNumber,
                "bankCode": bankCode,
                "channelCode": userBankDetails.channelCode,
                "accountName": userBankDetails.accountName,
                "BankVerificationNumber": userBankDetails.bvn,
                "KYCLevel": userBankDetails.kycLevel,
                "userEmail": ResponseData.loginResponse!.user!.userName
              }))
          .timeout(const Duration(seconds: 60));
      if (httpConnnectionApi.statusCode == 200) {
        var resBody = json.decode(httpConnnectionApi.body);
        print(resBody);
        if (resBody["code"] == "00") {
          final newBankDetails = UserBankDetails(
              accountNumber: userBankDetails.accountNumber,
              accountName: userBankDetails.accountName,
              bankCode: userBankDetails.bankCode,
              bvn: userBankDetails.bvn,
              kycLevel: userBankDetails.kycLevel,
              channelCode: userBankDetails.channelCode);
          ResponseData.userBanks.add(newBankDetails);
          return true;
        } else {
          print("error");
          sendErrorMessage("Error", resBody['description'], context);
          return false;
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
    return false;
  }

  Future<UserBankDetails?> fetchBankDetails(context,
      {required String accountNumber, required String bankNumber}) async {
    String timeStamp = "${DateTime.now().millisecondsSinceEpoch ~/ 1000}";
    const url = "$host$baseUrl${nqrUrl}nqr_queryaccount";
    String signTemp =
        "account_number=$accountNumber&bank_number=$bankNumber&channel=1&institution_number=$institutionNumber&timestamp=$timeStamp$apiKey";
    // Convert signTemp to bytes and apply MD5
    var bytes = utf8.encode(signTemp);
    var digest = md5.convert(bytes);

    String sign = digest.toString().toUpperCase();
    print("Bank Number $bankNumber");
    print("Account Number $accountNumber");
    print({
      "account_number": accountNumber,
      "bank_number": bankNumber,
      "channel": "1",
      "institution_number": institutionNumber,
      "timestamp": timeStamp,
      "sign": sign
    });
    try {
      await AuthBackend().checkAndUpdateToken(context);
      final httpConnnectionApi = await client.post(Uri.parse(url),
          headers: headersContent,
          body: json.encode({
            "account_number": accountNumber,
            "bank_number": bankNumber,
            "channel": "1",
            "institution_number": "I0000001154",
            "timestamp": timeStamp,
            "sign": sign
          }));
      if (httpConnnectionApi.statusCode == 200) {
        var resBody = json.decode(httpConnnectionApi.body);
        logger.i(resBody);
        if (resBody['ReturnCode'] == "Success") {
          return UserBankDetails(
              accountNumber: resBody['AccountNumber'],
              accountName: resBody['AccountName'],
              bankCode: resBody['DestinationInstitutionCode'],
              bvn: resBody['BankVerificationNumber'],
              kycLevel: resBody['KYCLevel'],
              channelCode: resBody['ChannelCode']);
        } else {
          sendErrorMessage("Error", resBody['ReturnMsg'], context);
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
    return null;
  }

  Future<ElectricityItem?> getElectricityBillerDetails(context,
      {required int id}) async {
    const url = "$host$baseUrl${iswPathUrl}iswgetbillerpaymentitem";
    try {
      await AuthBackend().checkAndUpdateToken(context);
      final httpConnectionApi = await client
          .post(Uri.parse(url),
              headers: headersContent, body: json.encode({"serviceid": id}))
          .timeout(const Duration(seconds: 60));

      if (httpConnectionApi.statusCode == 200) {
        var resBody = json.decode(httpConnectionApi.body);
        print(resBody);
        final items = resBody["PaymentItems"] as List<dynamic>;

        if (resBody["ResponseCode"] == "90000") {
          final data = items.first;
          return ElectricityItem.fromJson(data);
        } else {
          sendErrorMessage(
              "Error", items.first['ResponseDescription'], context);
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
    return null;
  }

  Future<LookupDetails?> lookUpRemitta(context, {required String rrr}) async {
    const url = "$host$baseUrl${isRemitaUrl}rmtlookup";
    try {
      await AuthBackend().checkAndUpdateToken(context);
      final httpConnectionApi = await client
          .post(Uri.parse(url),
              body: json.encode({
                "rrr": rrr,
              }),
              headers: headersContent)
          .timeout(const Duration(seconds: 60));
      var resBody = json.decode(httpConnectionApi.body);
      if (httpConnectionApi.statusCode == 200) {
        print(resBody);
        if (resBody['status'] == "00") {
          final data = resBody['data'];
          final lookUpData = LookupDetails.fromJson(data);
          return lookUpData;
        } else {
          sendErrorMessage("Error", resBody['message'], context);
          return null;
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
    return null;
  }

  Future<RemitaCustomer?> validateRemitaCustomer(context,
      {required String customerId, required String productId}) async {
    const url = "$host$baseUrl${isRemitaUrl}rmtcustomervalidation";
//  {

    try {
      await AuthBackend().checkAndUpdateToken(context);
      final httpConnectionApi = await client
          .post(Uri.parse(url),
              body: json.encode({
                "billPaymentProductId": productId,
                "customerId": customerId
              }),
              headers: headersContent)
          .timeout(const Duration(seconds: 60));
      var resBody = json.decode(httpConnectionApi.body);

      if (httpConnectionApi.statusCode == 200) {
        print(resBody);
        if (resBody['status'] == "00") {
          final data = resBody['data'];
          final customerData = RemitaCustomer.fromJson(data);
          return customerData;
        } else {
          sendErrorMessage("Error", resBody['message'], context);
          return null;
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

  Future<void> processRemitaPayment(context,
      {required RemitaDetails details}) async {
    const url = "$host$baseUrl${isRemitaUrl}rmtprocesspayment";
    try {
      await AuthBackend().checkAndUpdateToken(context);
      final httpConnectionApi = await client
          .post(Uri.parse(url),
              body: json.encode({
                "paymentIdentifier": details.paymentIdentifier,
                "rrr": details.rrr,
                "amount": details.amount,
                "channel": "MOBILE",
                "paymentOption": "CASH",
              }),
              headers: headersContent)
          .timeout(const Duration(seconds: 60));
      print("*****PAYLOAD*******");

      var resBody = json.decode(httpConnectionApi.body);
      logger.i(".......Preprocessing Initiating payment......");
      print(resBody);
      if (httpConnectionApi.statusCode == 200) {
        if (resBody['status'] == "00" || resBody['status'] == "99") {
          showSuccessAlert(context,
              title: "",
              description: resBody['message'],
              goToPage: const Dashboard());
        } else {
          sendErrorMessage("Error", resBody['message'], context);
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

  Future<RemitaDetails?> initiateRemitaPayment(
    context, {
    required String billPaymentProductId,
    required double amount,
    required String name,
    required String email,
    required String phoneNumber,
    required String customerId,
    required List<dynamic> customFieldsMultiSelectWithPrice,
    
    required List<Map<String, dynamic>> customFields,
  }) async {
    const url = "$host$baseUrl${isRemitaUrl}rmtinitiatetransaction";
    final Map<String, dynamic> payload = {
      "billPaymentProductId": billPaymentProductId,
      "amount": amount,
      "name": name,
      "email": email,
      "phoneNumber": phoneNumber,
      "customerId": customerId,
      "transaction_type": 'Remita',
      "payment_gateway": "REMITA",
      "metadata": {
        "customFields": customFields,
        "customFieldsMultiSelectWithPrice": customFieldsMultiSelectWithPrice,
       
      },
    };
    print(payload);
// {
//   {billPaymentProductId: 36528175,
//    amount: 190000.0,
//     name: femi, 
//    email: femi@gmial.com,
//     phoneNumber: 08063288677, 
//    customerId: 11111,
//     transaction_type: Remita,
//     payment_gateway: REMITA,
//      metadata: {
//       customFields: [
//         {
//           variable_name: matric_no, 
//           value: 170404110}, 
//           {
//             variable_name: amount_item_list,
//              value: Items: 1 x ₦100000.00, 1 x ₦90000.00
// : Total: ₦190000.00
// }],
//  customFieldsMultiSelectWithPrice: [
//   {variable_name: amount_item_list, 
//   value: [{
//     unitPrice: 100000.0, 
//     fixedPrice: true, quantity: 1,
//      code: FIRST YEAR, itemName: FIRST YEAR,
//       selectedListId: 36528169, selected: true
//       }, {
//         unitPrice: 90000.0, fixedPrice: true, quantity: 1, 
//         code: FOURTH YEAR, itemName: FOURTH YEAR, 
//         selectedListId: 36528172, selected: true}]}], customFieldsMultiSelect: []}}
// };

    try {
      await AuthBackend().checkAndUpdateToken(context);
      final httpConnectionApi = await client
          .post(Uri.parse(url),
              body: json.encode(payload), headers: headersContent)
          .timeout(const Duration(seconds: 60));
      print("*****PAYLOAD*******");
      print(payload);
      var resBody = json.decode(httpConnectionApi.body);
      logger.i(".......Initiating payment......");
      print(resBody);
      if (httpConnectionApi.statusCode == 200) {
        if (resBody['status'] == "00") {
          final data = resBody['data'];
          final rrrData = RemitaDetails.fromJson(data);
          return rrrData;
        } else {
          sendErrorMessage("Error", resBody['description'], context);
          return null;
        }
      }
    } on SocketException catch (_) {
      sendErrorMessage(
          "Network failure", "Please check your internet connection", context);
    } on NoSuchMethodError catch (_) {
      sendErrorMessage("NoSuchMethodError",
          'please check your credentials and try again.', context);
    } on TimeoutException catch (_) {
      sendErrorMessage(
          "Network failure", "Please check your internet connection", context);
      //navigateReplace(context, const Dashboard());
    } on Exception catch (e) {
      logger.e(e);
    }
  }

  Future<OrderItem?> validateCustomerPayment(context,
      {required String customerId, required String paymentCode}) async {
    const url = "$host$baseUrl${iswPathUrl}iswcustomervalidation";
    try {
      await AuthBackend().checkAndUpdateToken(context);
      final httpConnectionApi = await client
          .post(Uri.parse(url),
              body: json.encode(
                  {"PaymentCode": paymentCode, "CustomerId": customerId}),
              headers: headersContent)
          .timeout(const Duration(seconds: 60));
      if (httpConnectionApi.statusCode == 200) {
        var resBody = json.decode(httpConnectionApi.body);
        print(resBody);
        final items = resBody['Customers'] as List<dynamic>;
        final item = items.first;
        print(item["ResponseCode"]);
        if (item["ResponseCode"] == "90000") {
          print("Goof");
          final dataItems = OrderItem(
              customerId: item['CustomerId'],
              customerName: item['FullName'] ?? "",
              surcharge: item["Surcharge"],
              amount: double.parse(item['Amount'].toString()) * 0.01,
              code: item['PaymentCode']);

          return dataItems;
        } else {
          print("error");
          sendErrorMessage("Error", item['ResponseDescription'], context);
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
    return null;
  }

  Future<List<RemitaBillerProduct>> getBillerProduct(context,
      {required productId}) async {
    const url = "$host$baseUrl${isRemitaUrl}rmtbillerproducts";
    try {
      await AuthBackend().checkAndUpdateToken(context);
      final httpConnectionApi = await client
          .post(Uri.parse(url),
              headers: headersContent,
              body: json.encode({"productId": productId}))
          .timeout(const Duration(seconds: 60));
      var resBody = json.decode(httpConnectionApi.body);

      if (httpConnectionApi.statusCode == 200) {
        if (resBody["status"] == "00") {
          final item = resBody['data']['products'] as List<dynamic>;
          final items =
              item.map((data) => RemitaBillerProduct.fromJson(data)).toList();
          logger.i("******DONE********");
          return items;
        } else {
          sendErrorMessage("Error", resBody['message'], context);
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
    } catch (e) {
      logger.e(e);
    }
    return [];
  }

  Future<List<RemitaCategory>> getRemitaCategories(context) async {
    //USE FOR FILTERIG
    // const url = "$host$baseUrl${isRemitaUrl}rmtbillercategorybyid";

    const url = "$host$baseUrl${isRemitaUrl}rmtbillers";

    try {
      await AuthBackend().checkAndUpdateToken(context);
      final httpConnectionApi = await client
          .post(Uri.parse(url),
              body: json.encode({"categoryId": "7"}), headers: headersContent)
          .timeout(const Duration(seconds: 60));
      //  // var demoData = {
      //     "status": "00",
      //     "message": "Request processed successfully",
      //     "data": [
      //       {
      //         "billerId": "DEMOMDA",
      //         "billerName": "GENESIS GROUP",
      //         "billerShortName": "GENESIS GROUP",
      //         "billerLogoUrl":
      //             "http://cdn.remita.net/biller/images/logo/demomda.png",
      //         "categoryId": "3",
      //         "categoryName": "STATE GOVERNMENT MDAs",
      //         "categoryDescription": null
      //       },
      //       {
      //         "billerId": "JAMB",
      //         "billerName":
      //             "JOINT ADMISSIONS MATRICULATION BOARD -(JAMB) - 051700500100",
      //         "billerShortName":
      //             "JOINT ADMISSIONS MATRICULATION BOARD -(JAMB) - 051700500100",
      //         "billerLogoUrl":
      //             "http://cdn.remita.net/biller/images/logo/jamb.png",
      //         "categoryId": "1",
      //         "categoryName": "EDUCATION",
      //         "categoryDescription": null
      //       },
      //       {
      //         "billerId": "QATEST",
      //         "billerName": "NSITF",
      //         "billerShortName": "NSITF",
      //         "billerLogoUrl":
      //             "http://cdn.remita.net/biller/images/logo/qatest.png",
      //         "categoryId": "4",
      //         "categoryName": "UTILITY BILLS",
      //         "categoryDescription": null
      //       },
      //       {
      //         "billerId": "QADEMO",
      //         "billerName": "QA CORPORATION",
      //         "billerShortName": "QA CORPORATION",
      //         "billerLogoUrl":
      //             "http://cdn.remita.net/biller/images/logo/qademo.png",
      //         "categoryId": "4",
      //         "categoryName": "UTILITY BILLS",
      //         "categoryDescription": null
      //       }
      //     ]
      //   };

      var resBody = json.decode(httpConnectionApi.body);
      //var resBody = demoData;
      print(resBody);
      if (httpConnectionApi.statusCode == 200) {
        if (resBody["status"] == "00") {
          final items = resBody['data'] as List<dynamic>;
          final catItems =
              items.map((data) => RemitaCategory.fromJson(data)).toList();
          return catItems;
        } else {
          sendErrorMessage("Error", resBody['message'], context);
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
    return [];
  }

  Future<TransactionModel?> queryTx(context,
      {required TransactionModel txDetails}) async {
    const url = "$host$baseUrl${iswPathUrl}iswquerytransaction";
    try {
      await AuthBackend().checkAndUpdateToken(context);
      final httpConnectionApi = await client
          .post(Uri.parse(url),
              headers: headersContent,
              body: json.encode({"requestref": txDetails.refId}))
          .timeout(const Duration(seconds: 60));
      var resBody = json.decode(httpConnectionApi.body);
      print(resBody);
      if (httpConnectionApi.statusCode == 200) {
        if (resBody["ResponseCode"] == "90000") {
          TransactionModel txData = TransactionModel(
              amount: double.parse(resBody["Amount"] ?? "0") / 100,
              destinationNum: txDetails.destinationNum,
              email: resBody['CustomerEmail'],
              payerName: txDetails.payerName,
              payerPhone: txDetails.payerPhone,
              gateway: txDetails.gateway,
              txnId: resBody['TransactionId'].toString(),
              paymentCode: txDetails.paymentCode,
              refId: resBody['RequestReference'],
              serviceType: txDetails.serviceType,
              status: convertPaymentTitle(resBody["Status"] ?? ""),
              txnDate: txDetails.txnDate,
              type: txDetails.type);
          return txData;
        } else {
          txDetails.status =
              convertPaymentTitle(resBody["ResponseCodeGrouping"]);
          sendErrorMessage("Transaction Status",
              "TRANSACTION ${resBody["ResponseCodeGrouping"]}", context);

          return txDetails;
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

  Future<void> preProcessPayment(context,
      {required PaymentDetails details}) async {
    String ref = Pay().getReference();
    details.ref = ref;
    const url = "$host$baseUrl${iswPathUrl}pretransaction";
    try {
      await AuthBackend().checkAndUpdateToken(context);
      final httpConnectionApi = await client
          .post(Uri.parse(url),
              body: json.encode({
                "customerId": details.customerId,
                "customerMobile": details.customerMobile,
                "customerEmail": details.customerEmail,
                "amount": details.amount * 100,
                "paymentCode": details.paymentCode,
                "requestReference": details.ref,
                "serviceTypeId": details.serviceId,
                "serviceTypeName": details.serviceName,
                "surcharge": details.surcharge,
                "payerName": details.payerName ?? "",
                "TransactionType": getTxTitle(details.transactionType),
                "payment_gateway": getPaymtGateway(details.paymentGateway!)
              }),
              headers: headersContent)
          .timeout(const Duration(seconds: 60));
      var resBody = jsonDecode(httpConnectionApi.body.toString());
      logger.i("****PREPROCESSING*****");
      print(resBody);

      if (httpConnectionApi.statusCode == 200) {
        if (resBody['code'] == "00" ||
            resBody['description'].contains("Transaction initiated")) {
          return;
        } else {
          sendErrorMessage("", resBody['description'], context);
          throw resBody['description'];
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

  Future<List<BettingPlatform>> getBettingPlatforms(context) async {
    const url = "$host$baseUrl${iswPathUrl}iswgetbillerbycat";
    try {
      await AuthBackend().checkAndUpdateToken(context);
      final httpConnectionApi = await client.post(Uri.parse(url),
          headers: headersContent, body: json.encode({"categoryId": "41"}));
      if (httpConnectionApi.statusCode == 200) {
        var resBody = jsonDecode(httpConnectionApi.body.toString());
        if (resBody["ResponseCode"] == "90000") {
          final items =
              resBody['BillerList']["Category"][0]["Billers"] as List<dynamic>;
          final dataItems =
              items.map((data) => BettingPlatform.fromJson(data)).toList();
          return dataItems;
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
    return [];
  }

  Future<List<ElectricityBillers>> getElectricityCompanies(context) async {
    const url = "$host$baseUrl${iswPathUrl}iswgetbillerbycat";
    try {
      await AuthBackend().checkAndUpdateToken(context);
      final httpConnectionApi = await client.post(Uri.parse(url),
          headers: headersContent, body: json.encode({"categoryId": "1"}));
      if (httpConnectionApi.statusCode == 200) {
        var resBody = jsonDecode(httpConnectionApi.body.toString());
        if (resBody["ResponseCode"] == "90000") {
          final items =
              resBody['BillerList']["Category"][0]["Billers"] as List<dynamic>;

          final filtereddataItems =
              items.where((data) => data['CustomerField1'] != null).toList();

          final dataItems = filtereddataItems.map((data) {
            return ElectricityBillers(
              id: data['Id'],
              narration: data['Narration'],
              name: data['Name'],
            );
          }).toList();

          return dataItems;
        } else {
          sendErrorMessage("Error", "Failed to fetch data", context);
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
    return [];
  }

  Future<ISWAuthToken?> getISWAuthToken(context,
      {required PaymentDetails details}) async {
    const url = "https://apps.qa.interswitchng.com/passport/oauth/token";

    final headers = {
      'Authorization': 'Basic $base64Credentials',
      "accept": "application/json",
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    // Set query parameters
    final params = {
      'grant_type': "client_credentials",
    };

    try {
      await AuthBackend().checkAndUpdateToken(context);
      final response = await client.post(
        Uri.parse(url),
        headers: headers,
        body: params,
      );
      // Check response status code
      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return ISWAuthToken.fromJson(jsonResponse);
      } else {
        print('Request failed with status: ${response.statusCode}.');
        sendErrorMessage(
            "Error", "please check your credentials and try again", context);
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
    return null;
  }

  Future<String> getPaystackUrl(
    context, {
    required PaymentDetails details,
  }) async {
    const url = "https://api.paystack.co/transaction/initialize";
    String result = "";
    try {
      await AuthBackend().checkAndUpdateToken(context);
      final httpConnectionApi = await client
          .post(Uri.parse(url),
              headers: {
                'Authorization': 'Bearer $paystackKey',
                'Content-Type': 'application/json',
              },
              body: json.encode({
                "amount": double.parse(
                            '${details.amount + ((details.surcharge ?? 0) / 100)}')
                        .toInt() *
                    100,
                "email": details.customerEmail.toString(),
                "reference": details.ref,
                "callback_url": "https://www.residentfintech.com/",
                "metadata": {"cancel_action": "https://www.google.com/"}
              }))
          .timeout(const Duration(seconds: 60));
      var resBody = jsonDecode(httpConnectionApi.body.toString());
      logger.i(resBody);
      if (httpConnectionApi.statusCode == 200 && resBody['status'] == true) {
        result = resBody['data']["authorization_url"];
      } else {
        sendErrorMessage("Error", resBody['meta']['nextStep'], context);
        result = resBody['meta']['nextStep'];
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
    return result;
  }

  Future<List<TransactionModel>> getTransactionHistory(context,
      {String? email, required DateTime startDate, required endDate}) async {
    const url = "$host$baseUrl${appPathUrl}transactionhistory";
    print("start ${startDate.toString()}");
    print("end ${endDate.toString()}");
    try {
      await AuthBackend().checkAndUpdateToken(context);
      final httpConnectionApi = await client
          .post(Uri.parse(url),
              headers: headersContent,
              body: json.encode({
                "email": email,
                "from": UtilFunctions.formatTxDate(startDate),
                "to": UtilFunctions.formatTxDate(endDate)
              }))
          .timeout(const Duration(seconds: 60));
      var resBody = json.decode(httpConnectionApi.body);
      print(resBody);
      if (httpConnectionApi.statusCode == 200) {
        if (resBody['code'] == "00") {
          final transactions = resBody['Transactions'] as Map<String, dynamic>;
          return transactions.values
              .map<TransactionModel>((json) => TransactionModel.fromJson(json))
              .toList();
        }
      } else {
        sendErrorMessage("Error", resBody['description'], context);
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
    return [];
  }
}

String getTxTitle(TransactionType? type) {
  switch (type) {
    case TransactionType.airtime_data:
      return "Airtime_Data";

    case TransactionType.tv:
      return "CableTV_Payment";

    case TransactionType.airline:
      return "Airline_Payment";
    case TransactionType.betting:
      return "Betting_Payment";
    case TransactionType.electricity:
      return "Electricity_Payment";
    case TransactionType.remita:
      return "RRR";
    case null:
      return "Unknown";
    // TODO: Handle this case.
  }
}
//EG Airtme_Purchase, Electricity,Cable_TV,Internet, Airline, Betting,

String getPaymtGateway(PaymentGateway? type) {
  switch (type) {
    case PaymentGateway.interswitch:
      return "ISW";
    case PaymentGateway.paystack:
      return "PAYSTACK";
    case PaymentGateway.remita:
      return "REMITA";
    case null:
    default:
      return "UNKNOWN";
  }
}
  //ISW, PAYSTACK, REMITA

