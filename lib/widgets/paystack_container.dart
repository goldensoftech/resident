// import 'dart:ui';

// import 'package:resident/app_export.dart';
// import 'package:resident/repository/backend/bills_backend.dart';

// mixin PayStack {
//   makePayment(
//     context, {
//     required String email,
//     required String ref,
//     required int amount,
//   }) async {
//     Map data = {
//       // Removing the kobo by multiplying with 100
//       "amount": double.parse('${amount + amount * 0.02}').toInt() * 100,
//       "email": email,
//       "reference": ref,
//       "callback_url": "",
//       "metadata": {"cancel_action": "https://www.google.com/"}
//     };
//     var authUrl =
//         await TransactionBackend().getPaystackUrl(context, details: data);
//     WebViewController _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(const Color(0x00000000))
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (int progress) {
//             // Update loading bar.
//           },
//           onPageStarted: (String url) {},
//           onPageFinished: (String url) {
//             print(url);
//             // if (url.length > 40) {
//             // //  verifyPayment(url);
//             // } else {
//             // Navigator.of(context).pop();

//             // }
//           },
//           onWebResourceError: (WebResourceError error) {},
//           onNavigationRequest: (NavigationRequest request) async {
//             if (request.url.startsWith('https://www.google.com/')) {
//               Navigator.of(context).pop();
//               // Navigator.of(context).pop();

//               return NavigationDecision.prevent;
//             } else if (request.url.startsWith(
//                 "https://storehive.com.ng/retail-app/public/api/")) {
//               Navigator.of(context).pop();
//               //await verifyPayment(url);
//               return NavigationDecision.prevent;
//             }
//             return NavigationDecision.navigate;
//           },
//         ),
//       )
//       ..canGoBack()
//       ..loadRequest(Uri.parse(authUrl));
//     return showDialog(
//         context: context,
//         barrierColor: Colors.transparent.withOpacity(.5),
//         barrierDismissible: false,
//         builder: (ctx) {
//           return BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//             child: AlertDialog(
//               insetPadding: EdgeInsets.zero,
//               contentPadding: EdgeInsets.zero,
//               content: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 20),
//                 decoration: BoxDecoration(
//                     color: AppColors.whiteA700,
//                     borderRadius: BorderRadius.circular(10.r)),
//                 height: displaySize.height * .5,
//                 width: displaySize.width * .6,
//                 child: WebViewWidget(controller: _controller),
//               ),
//               //   children: [],
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10.r)),
//             ),
//           );
//         });
//   }
// }
