import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'dart:math';
import 'package:intl/intl.dart';

import 'package:resident/app_export.dart';
import 'package:resident/constants/api.dart';
import 'package:resident/presentation/dashboard/bills/web_screen.dart';

class PaymentGateways with ErrorSnackBar, CustomAlerts {
  // messages to SDK are asynchronous, so we initialize in an async method.
  Future<void> initializeISW(context) async {
    try {
      // currencyCode = "566"; // e.g  566 for NGN

      //var config = IswSdkConfig(merchantId, secretKey, merchantCode, "566");

      // initialize the sdk
      // await IswMobileSdk.initialize(config, Environment.TEST);
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
}

// Client ID	IKIA3B827951EA3EC2E193C51DA1D22988F055FD27DE
// Secret	ajkdpGiF6PHVrwK
// Merchant code	MX21696
// PayItemId	4177785

class Pay with ErrorSnackBar, CustomAlerts {
  String getReference() {
    String constantDigit = "2184";
    String currentDate = DateFormat('yyyyMMdd').format(DateTime.now());
    String uniqueRandomNumber =
        Random().nextInt(1000000).toString().padLeft(6, '0');
    // Generates 6 identical digits
    return constantDigit + currentDate + uniqueRandomNumber;
  }

  Future<void> withPaystack(context, {required PaymentDetails details}) async {
    var authUrl =
        await TransactionBackend().getPaystackUrl(context, details: details);
    WebViewController _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onHttpError: (error) {
            sendErrorMessage("Error", "Kindly check your connection.", context);
          },
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {
            navigateBack(context);
            sendErrorMessage("Error", error.description, context);
          },
          onNavigationRequest: (NavigationRequest request) async {
            if (request.url.startsWith('https://www.google.com/')) {
              print("Processing Request ${request.url}");
              Navigator.of(context).pop();

              sendErrorMessage("Error", "Payment not successful", context);

              // Navigator.of(context).pop();

              return NavigationDecision.prevent;
            } else if (request.url
                .startsWith("https://www.residentfintech.com/")) {
              print("Url Finished ${request.url}");

              Navigator.of(context).pop();
              showSuccessAlert(context,
                  title: getTxTitle(details.transactionType),
                  description: "Payment Successful",
                  goToPage: const Dashboard());
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..canGoBack()
      ..loadRequest(Uri.parse(authUrl));
    navigatePush(
        context, WebScreen(webTitle: "Payment", controller: _controller));
  }

  Future<void> withISW(context, {required PaymentDetails details}) async {
    String ref = getReference();
    details.ref = ref;

    WebViewController _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onHttpError: (error) {
            sendErrorMessage("Error", "Kindly check your connection.", context);
          },
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {
            //  navigateBack(context);
            logger.i(error.url);
          },
          onNavigationRequest: (NavigationRequest request) async {
            if (request.url.startsWith('https://www.google.com/')) {
              print("Processing Request ${request.url}");
              Navigator.of(context).pop();

              sendErrorMessage("Error", "Payment not successful", context);

              // Navigator.of(context).pop();

              return NavigationDecision.prevent;
            } else if (request.url
                .startsWith("https://www.residentfintech.com/")) {
              print("Url Finished ${request.url}");
              //await TransactionBackend().makePayment(context, details: details);

              //Navigator.of(context).pop();
              //await verifyPayment(url);
              return NavigationDecision.prevent;
            } else {
              Navigator.of(context).pop();
              sendErrorMessage("Error", "Payment not successful", context);
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..canGoBack()
      ..loadHtmlString("""
 


""");
    return showDialog(
        context: context,
        barrierColor: Colors.transparent.withOpacity(.5),
        barrierDismissible: false,
        builder: (ctx) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AlertDialog(
              insetPadding: EdgeInsets.zero,
              contentPadding: EdgeInsets.zero,
              content: Container(
                padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 20),
                decoration: BoxDecoration(
                    color: AppColors.whiteA700,
                    borderRadius: BorderRadius.circular(10.r)),
                height: displaySize.height * .7,
                width: displaySize.width * .9,
                child: WebViewWidget(controller: _controller),
              ),
              //   children: [],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r)),
            ),
          );
        });
    // Merchant merchant = Merchant(iswMerchantCode, domainId);

    // Payment payment = Payment(
    //     (double.parse('${details.amount + ((details.surcharge ?? 0) / 100)}') *
    //             100)
    //         .round()
    //         .toInt(),
    //     ref,
    //     details.paymentCode ?? "",
    //     details.serviceName ?? "",
    //     "NGN",
    //     getTxTitle(details.transactionType));
    // Customer customer = Customer(
    //     details.customerId,
    //     details.payerName ?? "",
    //     "",
    //     details.customerEmail ?? "",
    //     details.customerMobile ?? "",
    //     "",
    //     "",
    //     "",
    //     "",
    //     "");
    // Config config = Config(iconUrl: iconUrl, primaryAccentColor: "#C17B31");
    // Mobpay mobpay = new Mobpay(merchant: merchant, live: true);
    // mobpay.pay(
    //   payment: payment,
    //   customer: customer,
    //   transactionSuccessfullCallback: (payload) {
    //     transactionSuccessfullCallback(payload, context);
    //   },
    //   transactionFailureCallback: (payload) {
    //     transactionFailureCallback(payload, context);
    //   },
    //   config: config,
    // );
//     int amountInKobo =
//         (double.parse('${details.amount + ((details.surcharge ?? 0) / 100)}') *
//                 100)
//             .round()
//             .toInt();

//     // create payment info
//     var iswPaymentInfo = IswPaymentInfo(
//         details.customerId,
//         details.payerName ?? "",
//         details.customerEmail ?? "",
//         details.customerMobile ?? "",
//         ref,
//         amountInKobo);

//     // trigger payment
//     var result = await IswMobileSdk.pay(iswPaymentInfo);

// //    process result
//     if (result.hasValue) {
//       print(result);
//       await TransactionBackend().makePayment(context, details: details);

//       showSuccessAlert(context,
//           title: getTxTitle(details.transactionType), goToPage: Dashboard());
//     } else {
//       sendErrorMessage("Network failure", "Payment not successful", context);
//     }
  }

  Future<void> withRemita(context,
      {required PaymentDetails details, required RemitaDetails rrrData}) async {
    // String ref = getReference();
    // details.ref = ref;

    WebViewController _controller = WebViewController()
      ..addJavaScriptChannel("FlutterChannel",
          onMessageReceived: (message) async {
        if (message.message == 'successful') {
          showSuccessAlert(context,
              title: "Successful",
              description: "Your Remita payment was successful.",
              goToPage: const Dashboard());
          // await TransactionBackend()
          //     .processRemitaPayment(context, details: rrrData);
        } else if (message.message == 'error') {
          sendErrorMessage("Error", "Payment not successful", context);
          navigateBack(context);
        }
      })
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onHttpError: (error) {
            // sendErrorMessage("Error", "Kindly check your connection.", context);
          },
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {
            //  navigateBack(context);
            logger.i(error.url);
          },
          onNavigationRequest: (NavigationRequest request) async {
            if (request.url.startsWith('https://www.google.com/')) {
              print("Processing Request ${request.url}");
              Navigator.of(context).pop();

              sendErrorMessage("Error", "Payment not successful", context);

              return NavigationDecision.prevent;
            }
            if (request.url.startsWith("https://www.residentfintech.com/")) {
              print("Url Finished ${request.url}");

              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..canGoBack()
      ..loadHtmlString("""
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<title> Remita - Inline Sample</title>
    <style type="text/css">
        .form-style-1 {
            margin: 10px auto;
            max-width: 400px;
            padding: 20px 12px 10px 20px;
            font: 13px "Lucida Sans Unicode", "Lucida Grande", sans-serif;
        }
        .form-style-1 li {
            padding: 0;
            display: block;
            list-style: none;
            margin: 10px 0 0 0;
        }
        .form-style-1 label {
            margin: 0 0 3px 0;
            padding: 0px;
            display: block;
            font-weight: bold;
        }
        .form-style-1 input[type=text],
        .form-style-1 input[type=date],
        .form-style-1 input[type=datetime],
        .form-style-1 input[type=number],
        .form-style-1 input[type=search],
        .form-style-1 input[type=time],
        .form-style-1 input[type=url],
        .form-style-1 input[type=email],
        textarea,
        select {
            box-sizing: border-box;
            -webkit-box-sizing: border-box;
            -moz-box-sizing: border-box;
            border: 1px solid #BEBEBE;
            padding: 7px;
            margin: 0px;
            -webkit-transition: all 0.30s ease-in-out;
            -moz-transition: all 0.30s ease-in-out;
            -ms-transition: all 0.30s ease-in-out;
            -o-transition: all 0.30s ease-in-out;
            outline: none;
        }
        .form-style-1 input[type=text]:focus,
        .form-style-1 input[type=date]:focus,
        .form-style-1 input[type=datetime]:focus,
        .form-style-1 input[type=number]:focus,
        .form-style-1 input[type=search]:focus,
        .form-style-1 input[type=time]:focus,
        .form-style-1 input[type=url]:focus,
        .form-style-1 input[type=email]:focus,
        .form-style-1 textarea:focus,
        .form-style-1 select:focus {
            -moz-box-shadow: 0 0 8px #88D5E9;
            -webkit-box-shadow: 0 0 8px #88D5E9;
            box-shadow: 0 0 8px #88D5E9;
            border: 1px solid #88D5E9;
        }
        .form-style-1 .field-divided {
            width: 49%;
        }
        .form-style-1 .field-long {
            width: 100%;
        }
        .form-style-1 .field-select {
            width: 100%;
        }
        .form-style-1 .field-textarea {
            height: 100px;
        }
        .form-style-1 input[type=submit], .form-style-1 input[type=button] {
            background: #f44336;
            padding: 8px 15px 8px 15px;
            border: none;
            color: #fff;
        }
        .form-style-1 input[type=submit]:hover, .form-style-1 input[type=button]:hover {
            background: #e0372b;
            box-shadow: none;
            -moz-box-shadow: none;
            -webkit-box-shadow: none;
        }
        .form-style-1 .required {
            color: red;
        }
    </style>
</head>
<body >
<form onsubmit="makePayment()" id="payment-form">
    <ul class="form-style-1">
       
        <li>
            <label>RRR <span class="required">*</span></label>
            <input hidden type="text" id="js-rrr" name="rrr" class="field-long" disabled/>
        </li>
        
        <li>
            <input type="button" onclick="makePayment()" value="Continue Payment"/>
        </li>
    </ul>
</form>

<script>
   function setDemoData() {
        var obj = {
            rrr: "${rrrData.rrr}"
        };
        for (var propName in obj) {
            document.querySelector('#js-' + propName).setAttribute('value', obj[propName]);
        }
    }
    function makePayment() {
        var form = document.querySelector("#payment-form");
        var paymentEngine = RmPaymentEngine.init({
			key:
			"U09MRHw0MDgxOTUzOHw2ZDU4NGRhMmJhNzVlOTRiYmYyZjBlMmM1YzUyNzYwZTM0YzRjNGI4ZTgyNzJjY2NjYTBkMDM0ZDUyYjZhZWI2ODJlZTZjMjU0MDNiODBlMzI4YWNmZGY2OWQ2YjhiYzM2N2RhMmI1YWEwYTlmMTFiYWI2OWQxNTc5N2YyZDk4NA==",
			processRrr: true,
		
			email: "${details.customerEmail}",
			narration: "${details.serviceName}",
			merchantName: '${details.payerName}',
             
			extendedData: { 
				customFields: [ 
					{ 
						name: "rrr", 
						value: ${rrrData.rrr}
						
					} 
				 ]
			},
            onSuccess: function (response) {
                FlutterChannel.postMessage('successful');
            },
            onError: function (response) {
                FlutterChannel.postMessage('error');
             
            },
            onClose: function () {
                 FlutterChannel.postMessage('close');
            }
        });
         paymentEngine.showPaymentWidget();
    }
    window.onload = function () {
        setDemoData();
        makePayment();
    };
</script>
<script type="text/javascript" src="https://demo.remita.net/payment/v1/remita-pay-inline.bundle.js"></script>
</body>
</html>

""");
    navigatePush(context,
        WebScreen(webTitle: "Remita Payment", controller: _controller));
  }

//   Future<void> withRemitta(context, {required RemitaDetails details}) async {
//     PaymentRequest request = PaymentRequest(
//       environment: RemitaEnvironment.demo,
//       rrr: details.rrr,
//       key: remitaKey,
//     );
//     print("gotten here 2");
//     RemitaPayment remita = RemitaInlinePayment(
//       buildContext: context,
//       paymentRequest: request,
//       customizer: Customizer(),
//     );

//     print("gotten here befpre");
//     PaymentResponse response = await remita.initiatePayment();
//     print("gotten here");
//     print(response.toJson());
//     if (response.code != null && response.code == '00') {
//       print(response.message);
//       showSuccessAlert(context,
//           title: "Payment Successful", goToPage: Dashboard());
//     } else {
//       sendErrorMessage(
//           "Payment Not  Successful", response.message ?? "", context);
//     }
//   }
// }

  void transactionSuccessfullCallback(payload, context) {
    Clipboard.setData(ClipboardData(text: payload.toString()));
    final snackBar = SnackBar(
      content: Text("transaction success" + payload.toString()),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void transactionFailureCallback(payload, context) {
    {
      final snackBar = SnackBar(
        content: Text("transaction failure" + payload.toString()),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
