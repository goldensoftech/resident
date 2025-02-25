import 'package:resident/app_export.dart';
import 'package:resident/presentation/dashboard/profile/HelpAndSupport/help_and_support_screen.dart';
import 'package:resident/presentation/dashboard/profile/Legal/legal_screen.dart';

class DummyData {
  static String? userName;
  static String? emailAddress;
  static String? password;
  static bool? firstTimeOnApp;
  // List<dynamic> bankList = [
  //   {
  //     "id": 302,
  //     "name": "9mobile 9Payment Service Bank",
  //     "slug": "9mobile-9payment-service-bank-ng",
  //     "code": "120001",
  //     "longcode": "120001",
  //     "gateway": "",
  //     "pay_with_bank": false,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url":
  //         "https://dx5hjq79g3jmp.cloudfront.net/banklogo/62909PSB-9mobile.png"
  //   },
  //   {
  //     "id": 1,
  //     "name": "Access Bank",
  //     "slug": "access-bank",
  //     "code": "044",
  //     "longcode": "044150149",
  //     "gateway": "emandate",
  //     "pay_with_bank": false,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url": "https://dx5hjq79g3jmp.cloudfront.net/banklogo/6474accessbank.png"
  //   },
  //   {
  //     "id": 3,
  //     "name": "Access Bank (Diamond)",
  //     "slug": "access-bank-diamond",
  //     "code": "063",
  //     "longcode": "063150162",
  //     "gateway": "emandate",
  //     "pay_with_bank": false,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url": "https://dx5hjq79g3jmp.cloudfront.net/banklogo/6474accessbank.png"
  //   },
  //   {
  //     "id": 300,
  //     "name": "Airtel Smartcash PSB",
  //     "slug": "airtel-smartcash-psb-ng",
  //     "code": "120004",
  //     "longcode": "120004",
  //     "gateway": "",
  //     "pay_with_bank": false,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url": "https://dx5hjq79g3jmp.cloudfront.net/banklogo/5750airtel.png"
  //   },
  //   {
  //     "id": 27,
  //     "name": "ALAT by WEMA",
  //     "slug": "alat-by-wema",
  //     "code": "035A",
  //     "longcode": "035150103",
  //     "gateway": "emandate",
  //     "pay_with_bank": false,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url": "https://dx5hjq79g3jmp.cloudfront.net/banklogo/5397alat.png"
  //   },
  //   {
  //     "id": 697,
  //     "name": "Branch International Financial Services Limited",
  //     "slug": "branch",
  //     "code": "FC40163",
  //     "longcode": "",
  //     "gateway": null,
  //     "pay_with_bank": false,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url": "https://dx5hjq79g3jmp.cloudfront.net/banklogo/4207Branch.png"
  //   },
  //   {
  //     "id": 82,
  //     "name": "Carbon",
  //     "slug": "carbon",
  //     "code": "565",
  //     "longcode": "",
  //     "gateway": null,
  //     "pay_with_bank": false,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url": "https://dx5hjq79g3jmp.cloudfront.net/banklogo/6754carbon.png"
  //   },
  //   {
  //     "id": 2,
  //     "name": "Citibank Nigeria",
  //     "slug": "citibank-nigeria",
  //     "code": "023",
  //     "longcode": "023150005",
  //     "gateway": null,
  //     "pay_with_bank": false,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url": "https://dx5hjq79g3jmp.cloudfront.net/banklogo/8542citi.png"
  //   },
  //   {
  //     "id": 4,
  //     "name": "Ecobank Nigeria",
  //     "slug": "ecobank-nigeria",
  //     "code": "050",
  //     "longcode": "050150010",
  //     "gateway": null,
  //     "pay_with_bank": false,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url": "https://dx5hjq79g3jmp.cloudfront.net/banklogo/9775eco.jpg"
  //   },
  //   {
  //     "id": 677,
  //     "name": "Fairmoney Microfinance Bank",
  //     "slug": "fairmoney-microfinance-bank-ng",
  //     "code": "51318",
  //     "longcode": "",
  //     "gateway": null,
  //     "pay_with_bank": false,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url": "https://dx5hjq79g3jmp.cloudfront.net/banklogo/6732fair money.webp"
  //   },
  //   {
  //     "id": 6,
  //     "name": "Fidelity Bank",
  //     "slug": "fidelity-bank",
  //     "code": "070",
  //     "longcode": "070150003",
  //     "gateway": "emandate",
  //     "pay_with_bank": false,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url": "https://dx5hjq79g3jmp.cloudfront.net/banklogo/6162Fidelity.png"
  //   },
  //   {
  //     "id": 7,
  //     "name": "First Bank of Nigeria",
  //     "slug": "first-bank-of-nigeria",
  //     "code": "011",
  //     "longcode": "011151003",
  //     "gateway": "ibank",
  //     "pay_with_bank": false,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url":
  //         "https://dx5hjq79g3jmp.cloudfront.net/banklogo/5910First_Bank_of_Nigeria_logo.png"
  //   },
  //   {
  //     "id": 8,
  //     "name": "First City Monument Bank",
  //     "slug": "first-city-monument-bank",
  //     "code": "214",
  //     "longcode": "214150018",
  //     "gateway": "emandate",
  //     "pay_with_bank": false,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url": "https://dx5hjq79g3jmp.cloudfront.net/banklogo/9345FCMB_Logo.png"
  //   },
  //   {
  //     "id": 70,
  //     "name": "Globus Bank",
  //     "slug": "globus-bank",
  //     "code": "00103",
  //     "longcode": "103015001",
  //     "gateway": null,
  //     "pay_with_bank": false,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url": "https://dx5hjq79g3jmp.cloudfront.net/banklogo/3768globus.png"
  //   },
  //   {
  //     "id": 183,
  //     "name": "GoMoney",
  //     "slug": "gomoney",
  //     "code": "100022",
  //     "longcode": "",
  //     "gateway": null,
  //     "pay_with_bank": false,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url": "https://dx5hjq79g3jmp.cloudfront.net/banklogo/1476gomoney.png"
  //   },
  //   {
  //     "id": 9,
  //     "name": "Guaranty Trust Bank",
  //     "slug": "guaranty-trust-bank",
  //     "code": "058",
  //     "longcode": "058152036",
  //     "gateway": "ibank",
  //     "pay_with_bank": true,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url": "https://dx5hjq79g3jmp.cloudfront.net/banklogo/1579gtb.png.webp"
  //   },
  //   {
  //     "id": 10,
  //     "name": "Heritage Bank",
  //     "slug": "heritage-bank",
  //     "code": "030",
  //     "longcode": "030159992",
  //     "gateway": null,
  //     "pay_with_bank": false,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url": "https://dx5hjq79g3jmp.cloudfront.net/banklogo/2053heritage.png"
  //   },
  //   {
  //     "id": 22,
  //     "name": "Jaiz Bank",
  //     "slug": "jaiz-bank",
  //     "code": "301",
  //     "longcode": "301080020",
  //     "gateway": null,
  //     "pay_with_bank": false,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url":
  //         "https://dx5hjq79g3jmp.cloudfront.net/banklogo/6188Jaiz_New_Logo.jpg"
  //   },
  //   {
  //     "id": 11,
  //     "name": "Keystone Bank",
  //     "slug": "keystone-bank",
  //     "code": "082",
  //     "longcode": "082150017",
  //     "gateway": null,
  //     "pay_with_bank": false,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url":
  //         "https://dx5hjq79g3jmp.cloudfront.net/banklogo/8455keysone-bank-logo.png"
  //   },
  //   {
  //     "id": 67,
  //     "name": "Kuda Bank",
  //     "slug": "kuda-bank",
  //     "code": "50211",
  //     "longcode": "",
  //     "gateway": "digitalbankmandate",
  //     "pay_with_bank": true,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url": "https://dx5hjq79g3jmp.cloudfront.net/banklogo/6559kuda.png"
  //   },
  //   {
  //     "id": 233,
  //     "name": "Lotus Bank",
  //     "slug": "lotus-bank",
  //     "code": "303",
  //     "longcode": "",
  //     "gateway": null,
  //     "pay_with_bank": false,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url": "https://dx5hjq79g3jmp.cloudfront.net/banklogo/2501lotus.png"
  //   },
  //   {
  //     "id": 688,
  //     "name": "Moniepoint MFB",
  //     "slug": "moniepoint-mfb-ng",
  //     "code": "50515",
  //     "longcode": "null",
  //     "gateway": null,
  //     "pay_with_bank": false,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url":
  //         "https://dx5hjq79g3jmp.cloudfront.net/banklogo/1322Moniepoint-Incorporated.webp"
  //   },
  //   {
  //     "id": 303,
  //     "name": "MTN Momo PSB",
  //     "slug": "mtn-momo-psb-ng",
  //     "code": "120003",
  //     "longcode": "120003",
  //     "gateway": "",
  //     "pay_with_bank": false,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url": "https://dx5hjq79g3jmp.cloudfront.net/banklogo/6920MTN-1.jpg"
  //   },
  //   {
  //     "id": 699,
  //     "name": "Optimus Bank Limited",
  //     "slug": "optimus-bank-ltd",
  //     "code": "00107",
  //     "longcode": "",
  //     "gateway": null,
  //     "pay_with_bank": false,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url": "https://dx5hjq79g3jmp.cloudfront.net/banklogo/6565optimus.png"
  //   },
  //   {
  //     "id": 185,
  //     "name": "Paga",
  //     "slug": "paga",
  //     "code": "100002",
  //     "longcode": "",
  //     "gateway": null,
  //     "pay_with_bank": false,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url":
  //         "https://dx5hjq79g3jmp.cloudfront.net/banklogo/2106paga-nigeria.webp"
  //   },
  //   {
  //     "id": 169,
  //     "name": "PalmPay",
  //     "slug": "palmpay",
  //     "code": "999991",
  //     "longcode": "",
  //     "gateway": null,
  //     "pay_with_bank": false,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url": "https://dx5hjq79g3jmp.cloudfront.net/banklogo/4363palmpay.png"
  //   },
  //   {
  //     "id": 26,
  //     "name": "Parallex Bank",
  //     "slug": "parallex-bank",
  //     "code": "104",
  //     "longcode": "",
  //     "gateway": null,
  //     "pay_with_bank": false,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url":
  //         "https://dx5hjq79g3jmp.cloudfront.net/banklogo/4792Parallex-bak.png"
  //   },
  //   {
  //     "id": 110,
  //     "name": "Parkway - ReadyCash",
  //     "slug": "parkway-ready-cash",
  //     "code": "311",
  //     "longcode": "",
  //     "gateway": null,
  //     "pay_with_bank": false,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url": "https://dx5hjq79g3jmp.cloudfront.net/banklogo/8340readycash.png"
  //   },
  //   {
  //     "id": 171,
  //     "name": "Paycom",
  //     "slug": "paycom",
  //     "code": "999992",
  //     "longcode": "",
  //     "gateway": null,
  //     "pay_with_bank": false,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url":
  //         "https://dx5hjq79g3jmp.cloudfront.net/banklogo/3933paycom-logo.webp"
  //   },
  //   {
  //     "id": 13,
  //     "name": "Polaris Bank",
  //     "slug": "polaris-bank",
  //     "code": "076",
  //     "longcode": "076151006",
  //     "gateway": null,
  //     "pay_with_bank": false,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url":
  //         "https://dx5hjq79g3jmp.cloudfront.net/banklogo/8436Polaris-Bank-Limited.png"
  //   },
  //   {
  //     "id": 25,
  //     "name": "Providus Bank",
  //     "slug": "providus-bank",
  //     "code": "101",
  //     "longcode": "",
  //     "gateway": null,
  //     "pay_with_bank": false,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url":
  //         "https://dx5hjq79g3jmp.cloudfront.net/banklogo/4866Providus_Bank_logo.png"
  //   },
  //   {
  //     "id": 69,
  //     "name": "Rubies MFB",
  //     "slug": "rubies-mfb",
  //     "code": "125",
  //     "longcode": "",
  //     "gateway": null,
  //     "pay_with_bank": false,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url": "https://dx5hjq79g3jmp.cloudfront.net/banklogo/2836rubies.jpg"
  //   },
  //   {
  //     "id": 632,
  //     "name": "Shield MFB",
  //     "slug": "shield-mfb-ng",
  //     "code": "50582",
  //     "longcode": "",
  //     "gateway": null,
  //     "pay_with_bank": false,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url": "https://dx5hjq79g3jmp.cloudfront.net/banklogo/2396shild.png"
  //   },
  //   {
  //     "id": 14,
  //     "name": "Stanbic IBTC Bank",
  //     "slug": "stanbic-ibtc-bank",
  //     "code": "221",
  //     "longcode": "221159522",
  //     "gateway": null,
  //     "pay_with_bank": false,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url":
  //         "https://dx5hjq79g3jmp.cloudfront.net/banklogo/251044116259-stanbic-ibtc.webp"
  //   },
  //   {
  //     "id": 15,
  //     "name": "Standard Chartered Bank",
  //     "slug": "standard-chartered-bank",
  //     "code": "068",
  //     "longcode": "068150015",
  //     "gateway": null,
  //     "pay_with_bank": false,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url": "https://dx5hjq79g3jmp.cloudfront.net/banklogo/1859standard.png"
  //   },
  //   {
  //     "id": 16,
  //     "name": "Sterling Bank",
  //     "slug": "sterling-bank",
  //     "code": "232",
  //     "longcode": "232150016",
  //     "gateway": "emandate",
  //     "pay_with_bank": false,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url":
  //         "https://dx5hjq79g3jmp.cloudfront.net/banklogo/5595sterling-bank.png"
  //   },
  //   {
  //     "id": 23,
  //     "name": "Suntrust Bank",
  //     "slug": "suntrust-bank",
  //     "code": "100",
  //     "longcode": "",
  //     "gateway": null,
  //     "pay_with_bank": false,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url": "https://dx5hjq79g3jmp.cloudfront.net/banklogo/5849sun.jpg"
  //   },
  //   {
  //     "id": 68,
  //     "name": "TAJ Bank",
  //     "slug": "taj-bank",
  //     "code": "302",
  //     "longcode": "",
  //     "gateway": null,
  //     "pay_with_bank": false,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url": "https://dx5hjq79g3jmp.cloudfront.net/banklogo/1423tajbank.jpg"
  //   },
  //   {
  //     "id": 73,
  //     "name": "Titan Bank",
  //     "slug": "titan-bank",
  //     "code": "102",
  //     "longcode": "",
  //     "gateway": null,
  //     "pay_with_bank": false,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url": "https://dx5hjq79g3jmp.cloudfront.net/banklogo/6300titan.png"
  //   },
  //   {
  //     "id": 17,
  //     "name": "Union Bank of Nigeria",
  //     "slug": "union-bank-of-nigeria",
  //     "code": "032",
  //     "longcode": "032080474",
  //     "gateway": "emandate",
  //     "pay_with_bank": false,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url": "https://dx5hjq79g3jmp.cloudfront.net/banklogo/1430union.png"
  //   },
  //   {
  //     "id": 18,
  //     "name": "United Bank For Africa",
  //     "slug": "united-bank-for-africa",
  //     "code": "033",
  //     "longcode": "033153513",
  //     "gateway": "emandate",
  //     "pay_with_bank": false,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url": "https://dx5hjq79g3jmp.cloudfront.net/banklogo/7615uba.png"
  //   },
  //   {
  //     "id": 19,
  //     "name": "Unity Bank",
  //     "slug": "unity-bank",
  //     "code": "215",
  //     "longcode": "215154097",
  //     "gateway": "emandate",
  //     "pay_with_bank": false,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url": "https://dx5hjq79g3jmp.cloudfront.net/banklogo/7012unity-bank.jpg"
  //   },
  //   {
  //     "id": 20,
  //     "name": "Wema Bank",
  //     "slug": "wema-bank",
  //     "code": "035",
  //     "longcode": "035150103",
  //     "gateway": null,
  //     "pay_with_bank": false,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url": "https://dx5hjq79g3jmp.cloudfront.net/banklogo/4220Wema-Bank.jpg"
  //   },
  //   {
  //     "id": 21,
  //     "name": "Zenith Bank",
  //     "slug": "zenith-bank",
  //     "code": "057",
  //     "longcode": "057150013",
  //     "gateway": "emandate",
  //     "pay_with_bank": false,
  //     "active": true,
  //     "country": "Nigeria",
  //     "currency": "NGN",
  //     "type": "nuban",
  //     "is_deleted": false,
  //     "url":
  //         "https://dx5hjq79g3jmp.cloudfront.net/banklogo/8286zenith-bank-1.jpg"
  //   }
  // ];

  List<Map<String, dynamic>> profileTiles = [
    {
      "icon": Icons.account_circle_outlined,
      'title': "Account Settings",
      "gotoPage": AccountScreen()
    },
    {
      "icon": Icons.contact_support_outlined,
      'title': "Help & Support",
      "gotoPage": ComingSoonScreen()
    },
    {
      "icon": Icons.playlist_add_check,
      'title': "Privacy Policy",
      "gotoPage": LegalScreen()
    },
  ];

  final List<Map<String, String>> slides = [
    {
      'title': 'Sign Up',
      'description': 'Find new opportunity to make your payment better',
      'image': '${assetsUrl}/OnSlide1.png',
    },
    {
      'title': 'Make Payment',
      'description': 'Find new opportunity to make your payment better',
      'image': '${assetsUrl}/ObSlide2.png',
    },
    {
      'title': 'Make Payment ',
      'description': 'Find new opportunity to make your payment better',
      'image': '${assetsUrl}/ObSlide3.png',
    }
  ];
  final List<Map<String, dynamic>> shortcutItems = [
    {
      'title': 'Generate RRR',
      'logoUrl': billsInactvIcon,
      'color': AppColors.cream,
      'pageToGo': const GenerateRRRScreen()
    },
    {
      'title': 'Book Flight',
      'logoUrl': flightIcon,
      'color': AppColors.deepWine,
      'pageToGo': const FlightTicketScreen()
    },
    {
      'title': 'QR Scan',
      'logoUrl': scanIcon,
      'color': AppColors.deepGreen,
      'pageToGo': const QRScanScreen()
    },
  ];
  final List<Map<String, dynamic>> rrrItems = [
    {'title': 'Generate RRR', 'pageToGo': const GenerateRRRScreen()},
    {'title': 'RRR Payment', 'pageToGo': const RRRPaymentScreen()},
    {'title': 'Payment Status', 'pageToGo': const PaymentStatusScreen()},
    {'title': 'Transaction History', 'pageToGo': const RRRTxHistoryScreen()},
  ];
  final List<Map<String, dynamic>> billItems = [
    {
      'title': 'Buy Airtime',
      'logoUrl': callIcon,
      'pageToGo': const BuyAirtimeScreen()
    },
    {
      'title': 'Buy Data',
      'logoUrl': wifiIcon,
      'pageToGo': const BuyDataScreen()
    },
    {
      'title': 'Buy Electricity',
      'logoUrl': electricIcon,
      'pageToGo': const BuyElectricityScreen(),
    },
    {
      'title': 'Cable TV',
      'logoUrl': cableTvIcon,
      'pageToGo': const CableTvScreen()
    },
    {
      'title': 'Internet Services',
      'logoUrl': wifiIcon,
      'pageToGo': const InternetServiceScreen()
    },
    {
      'title': 'Flight Ticket',
      'logoUrl': flightIcon,
      'pageToGo': const FlightTicketScreen(),
    },
    {
      'title': 'Remitta',
      'logoUrl': remitaIcon,
      'color': false,
      'pageToGo': const RemittaScreen(),
    },
    {
      'title': 'Sport Betting',
      'logoUrl': betIcon,
      'pageToGo': const SportBettingScreen()
    },
  ];
  final List<Map<String, dynamic>> virtualAccountsList = [
    {
      "bankLogo": gloIcon,
      "bank_name": "Wema Bank",
      "acc_number": "123456379",
      "acc_name": "Adubuola Oluwafemi Jacob"
    },
    {
      "bankLogo": airtelIcon,
      "bank_name": "GTB Bank",
      "acc_number": "334293789",
      "acc_name": "Adubuola Oluwafemi Jacob"
    },
    {
      "bankLogo": mobile9,
      "bank_name": "Access Bank",
      "acc_number": "3873456789",
      "acc_name": "Adubuola Oluwafemi Jacob"
    }
  ];
  final List<NotificationModel> notifications = [];

  final List<RRRTxModel> rrrPayments = [
    RRRTxModel(
      rrr: '1973-6726-8374-9830',
      txId: 'trxn123748746484940',
      amount: "2000",
      date: DateTime.now().subtract(const Duration(days: 3)),
    ),
    RRRTxModel(
      rrr: '1903-6726-8374-9830',
      txId: 'trxn123748746484940',
      amount: "2000",
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    RRRTxModel(
      rrr: '1228-6726-8374-9830',
      txId: 'trxn123748746484940',
      amount: "2000",
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    RRRTxModel(
      rrr: '1073-6726-8374-9830',
      txId: 'trxn123748746484940',
      amount: "2000",
      date: DateTime.now().subtract(const Duration(days: 3)),
    ),
    RRRTxModel(
      rrr: '1290-6726-8374-9830',
      txId: 'trxn123748746484940',
      amount: "2000",
      date: DateTime.now().subtract(const Duration(days: 9)),
    ),
    RRRTxModel(
      rrr: '1273-6726-8224-9830',
      txId: 'trxn123748746484940',
      amount: "2000",
      date: DateTime.now(),
    ),
  ];
  final List<Map<String, dynamic>> pGateway = [
    {
      "name": "Paystack",
      "logo": paystackImg,
      'url': "",
      "gateway_type": PaymentGateway.paystack
    },
    {
      "name": "Remitta",
      "logo": remittaImg,
      'url': "",
      "gateway_type": PaymentGateway.remita
    },
    {
      "name": "Interswitch",
      "logo": iSWImg,
      'url': "",
      "gateway_type": PaymentGateway.interswitch
    }
  ];
  final List<Map<String, dynamic>> internetItems = [
    // {
    //   'type': 'Airtel CLEP',
    //   'url': airtelIcon,
    //   'ids': 1009,
    // },
    // {
    //   'type': 'Airtel MyPlan',
    //   'url': airtelIcon,
    //   'ids': 1971,
    // },
    // {
    //   'type': 'Airtel WiFi',
    //   'url': airtelIcon,
    //   'ids': 1942,
    // },
    {
      'type': 'iPNx Subscription Payments',
      'url': ipNX,
      'ids': 110,
    },
    {
      'type': 'Mobitel Payments',
      'url': mobitel,
      'ids': 311,
    },
    {
      'type': 'Mtn Fixed Internet',
      'url': mtnIcon,
      'ids': 1017,
    },
    {
      'type': 'Mtn HyNetflex Data Plan',
      'url': mtnIcon,
      'ids': 3825,
    },
    {
      'type': 'Smart SMS Solutions',
      'url': smartSMS,
      'ids': 1264,
    },
    {
      'type': 'Smile Bundle',
      'url': smile,
      'ids': 857,
    },
    {
      'type': 'Spectranet Limited',
      'url': spectranet,
      'ids': 991,
    },
    {
      'type': 'Spectranet Limited MAIN',
      'url': spectranet,
      'ids': 3913,
    },
    {
      'type': 'Zuku Fiber',
      'url': zuku,
      'ids': 3030,
    },
  ];
  final List<Map<String, dynamic>> networkItems = [
    {
      'type': 'Mtn',
      'url': mtnIcon,
      'airtimeCode': "90304",
      'ids': {'data': 348, 'airtime': 109}
    },
    {
      'type': 'Airtel',
      'url': airtelIcon,
      'airtimeCode': "10201",
      'ids': {'data': 2775, 'airtime': 901},
    },
    {
      'type': 'Glo',
      'url': gloIcon,
      'airtimeCode': "04260801",
      'ids': {'data': 3070, 'airtime': 913},
    },
    {
      'type': '9Mobile',
      'url': mobile9,
      'airtimeCode': "04334103",
      'ids': {'data': 3961, 'airtime': 3341},
    },
  ];
  final List<Map<String, dynamic>> bettingItems = [
    {
      'type': 'Bet 9ja',
      'url': bet9JaLogo,
      'ids': 2262,
    },
    {
      'type': 'Bet 9ja II',
      'url': bet9JaLogo,
      'ids': 3697,
    },
    {
      'type': 'SportyBet',
      'url': sportybet,
      'ids': 3472,
    },
    {
      'type': 'MSport',
      'url': msport,
      'ids': 33892,
    },
    {
      'type': 'BetKing',
      'url': betking,
      'ids': 3148,
    },
    {
      'type': '1xBET',
      'url': xbetLogo,
      'ids': 2968,
    },
    {
      'type': '22BET',
      'url': bet22Logo,
      'ids': 3801,
    },
    {
      'type': '1960BET',
      'url': bet1960Logo,
      'ids': 856,
    },
    {
      'type': 'AccessBET',
      'url': accessBetLogo,
      'ids': 2871,
    },
    {
      'type': '360 BET',
      'url': bet360,
      'ids': 2609,
    },
    {
      'type': 'MYBETCITY',
      'url': mybetcity,
      'ids': 317,
    },
    {
      'type': 'betBonanza',
      'url': betbonaza,
      'ids': 3647,
    },
    {
      'type': 'Merrybet',
      'url': merrybet,
      'ids': 508,
    },
    {
      'type': 'Bangbet',
      'url': betbang,
      'ids': 3850,
    },
    {
      'type': 'BETBIGA',
      'url': betbiga,
      'ids': 3590,
    },
    {
      'type': 'BETFARM',
      'url': betfarm,
      'ids': 3850,
    },
    {
      'type': 'BetLand',
      'url': betland,
      'ids': 3850,
    },
    {
      'type': 'BETWAY',
      'url': betway,
      'ids': 3233,
    },
  ];
  final List<Map<String, dynamic>> airlineItems = [
    {
      'type': "AERO Book On Hold",
      'url': aeroLogo,
      'ids': 215,
    },
    {
      'type': "Africa World Airlines",
      'url': afiricaWorldAirlineLogo,
      'ids': 1202,
    },
    {
      'type': "Air Peace Payments",
      'url': airPeace,
      'ids': 1277,
    },
    {
      'type': "Arik Air Book On Hold",
      'url': arik,
      'ids': 667,
    },
    {
      'type': "Asky Air Mobile Book On Hold",
      'url': asky,
      'ids': 1170,
    },
    {
      'type': "AZMAN Airline",
      'url': azman,
      'ids': 1675,
    },
    {
      'type': "Discovery Air Book on hold",
      'url': discoveryAir,
      'ids': 643,
    },
    {
      'type': "Emirates Airline",
      'url': emirates,
      'ids': 2234,
    },
    {
      'type': "Hak Air",
      'url': harik,
      'ids': 290,
    },
    {
      'type': "Ibom Air",
      'url': ibom,
      'ids': 3860,
    },
    {
      'type': "Medview Airlines",
      'url': medview,
      'ids': 281,
    },
    {
      'type': "RwandAir",
      'url': rwand,
      'ids': 1171,
    },
  ];
  final List<Map<String, dynamic>> cableTvItems = [
    {
      'type': 'DSTV',
      'logo': dstv,
      'id': 104,
    },
    {
      'type': 'Gotv',
      'logo': gotv,
      'id': 459,
    }
  ];
  final List<Map<String, dynamic>> electricityItems = [
    {
      'name': "Abuja Electricity",
      "logo": abujaLogo,
      "types": {"Prepaid": 33948, "Postpaid": 3624}
    },
    {
      'name': "Eko Electricity",
      "types": {"Prepaid": 1473, "Postpaid": 1316},
      "logo": ekoLogo,
    },
    {
      'name': "Enugu Electricity",
      "types": {"Prepaid": 783, "Postpaid": 785},
      "logo": enuguLogo,
    },
    {
      'name': "Ibadan Electricity",
      "types": {"Prepaid": 784, "Postpaid": 792},
      "logo": ibLogo,
    },
    {
      'name': "Ikeja Electricity",
      "types": {"Prepaid": 766, "Postpaid": 848},
      "logo": ikjLogo,
    },
    {
      'name': "Ikeja Electricity II",
      "types": {"Prepaid": 33962, "Postpaid": 33963},
      "logo": ikjLogo,
    },
    {
      'name': "Jos Electricity",
      "types": {"Prepaid": 2979, "Postpaid": 2978},
      "logo": josLogo,
    },
    {
      'name': "Kaduna Electricity",
      "types": {"Prepaid": 2969, "Postpaid": 2970},
      "logo": kadunaLogo,
    },
    {
      'name': "Yola Electricity",
      "types": {"Prepaid": 34063, "Postpaid": 1753},
      "logo": yolaLogo,
    },
  ];
}
