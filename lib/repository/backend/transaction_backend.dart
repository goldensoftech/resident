import 'dart:convert';
import 'dart:io';

import 'package:resident/app_export.dart';
import 'package:http/http.dart' as client;
import 'package:resident/constants/api.dart';
import 'package:resident/repository/model/user_response_model.dart';

import '../model/nqr_model.dart';
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

  Future<void> payWithNQR(context, {required NIBSSQRCodeData data}) async {
    String getSign = generateSignature(
        amount: data.amount,
        authCode: authCode,
        institutionNumber: data.institutionNo,
        merchantNumber: data.merchantId,
        merchantName: data.merchantName,
        orderSN: data.orderNo,
        subMerchantNumber: data.subMerchantId,
        timestamp: data.timestamp,
        apiKey: apiKey);
    const url = "https://apitest.nibss-plc.com.ng/nqr/v2/Bank/pay";
    try {
      await AuthBackend().checkAndUpdateToken(context);
      final httpConnectionApi = await client
          .post(Uri.parse(url),
              body: json.encode({
                "channel": "1",
                "institution_number": data.institutionNo,
                "mch_no": data.merchantId,
                "sub_mch_no": data.subMerchantId,
                "user_bank_no":
                    ResponseData.userBankDetails!.accountNumber ?? "",
                "user_account_name": ResponseData.userBankDetails!.name ?? "",
                "user_account_number":
                    ResponseData.userBankDetails!.accountNumber ?? "",
                "user_bank_verification_number":
                    ResponseData.userBankDetails!.bvn ?? "",
                "user_kyc_level": "1",
                "user_gps":
                    "${ResponseData.userLocation?.longitude},${ResponseData.userLocation?.latitude}",
                "amount": data.amount,
                "order_no": data.orderNo,
                "timestamp": data.timestamp,
                "sign": getSign
              }),
              headers: headersContent)
          .timeout(const Duration(seconds: 60));
      if (httpConnectionApi.statusCode == 200) {
        var resBody = json.decode(httpConnectionApi.body);

        if (resBody["ReturnCode"] == "Success") {
          sendErrorMessage(
              isSuccess: true, "Successful", "Payment Successful", context);
        } else {
          sendErrorMessage("Error", resBody["message"], context);
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

  Future<List<UserBankDetails>> getUserBanks(
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
        if (resBody["code"] == "92") {
          sendErrorMessage("Error", resBody['description'], context);
        } else {
          final List<dynamic> items = [resBody];
          return items.map((item) => UserBankDetails.fromJson(item)).toList();
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

  Future<List<Bank>> getBankList(context) async {
    return [];
  }

  Future<void> addBankDetails(context, {required UserBankDetails, }) async {
    
  }

  Future<UserBankDetails?> fetchBankDetails(context,
      {required String accountNumber, required String bankNumber}) async {
    var url =
        "https://api.paystack.co/bank/resolve?account_number=$accountNumber&bank_code=$bankNumber";
    try {
      await AuthBackend().checkAndUpdateToken(context);
      final httpConnectionApi = await client
          .get(Uri.parse(url), headers: pkContent)
          .timeout(Duration(seconds: 60));
     
      if (httpConnectionApi.statusCode == 200) {
        var resBody = json.decode(httpConnectionApi.body);
        print(resBody);
        if (resBody["status"] == true) {
          var data = resBody["data"];
          return UserBankDetails(
              accountNumber: (data['account_number']).toString(),
              accountName: data['account_name'],
              bankCode: bankNumber,
              kycLevel: "1",
              channelCode: "1");
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
                "transactionRef": details.txRef,
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
      "metadata": {
        "customFields": customFields,
      },
    };

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
    const url = "$host$baseUrl${isRemitaUrl}rmtbillercategorybyid";
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

