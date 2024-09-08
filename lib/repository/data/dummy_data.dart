import 'package:resident/app_export.dart';
import 'package:resident/presentation/dashboard/profile/HelpAndSupport/help_and_support_screen.dart';
import 'package:resident/presentation/dashboard/profile/Legal/legal_screen.dart';

class DummyData {
  static String? userName;
  static String? emailAddress;
  static String? password;
  static bool? firstTimeOnApp;
  List<Map<String, dynamic>> profileTiles = [
    {
      "icon": Icons.account_circle_outlined,
      'title': "Account Settings",
      "gotoPage": AccountScreen()
    },
    {
      "icon": Icons.contact_support_outlined,
      'title': "Help & Support",
      "gotoPage": HelpAndSupportScreen()
    },
    {
      "icon": Icons.playlist_add_check,
      'title': "Legal",
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
      'title': 'Send Money',
      'logoUrl': sendIcon,
      'color': AppColors.cream,
      'pageToGo': const SendMoneyScreen()
    },
   
    {
      'title': 'Virutal Account',
      'logoUrl': pCard,
      'color': AppColors.deepWine,
      'pageToGo': const VirtualAccountScreen()
    },
    {
      'title': 'Virtual Card',
      'logoUrl': cardInactvIcon,
      'color': AppColors.deepBlue,
      'pageToGo': const VirtualAccountScreen()
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
      'title': 'Sport Betting',
      'logoUrl': betIcon,
      'pageToGo': const SportBettingScreen()
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
      'color':false,
      'pageToGo': const RemittaScreen(),
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
  final List<NotificationModel> notifications = [
    NotificationModel(
        description:
            "Congratulation your KYC was succsful.\nYour account is activated.",
        date: DateTime.now().subtract(const Duration(minutes: 3))),
    NotificationModel(
        description:
            "Congratulation your KYC was succsful.\nYour account is activated.",
        date: DateTime.now().subtract(const Duration(minutes: 20))),
    NotificationModel(
        description:
            "Your Airtime transaction was successful you just sent N1000 to 07038941107.",
        date: DateTime.now().subtract(const Duration(days: 2))),
    NotificationModel(
        seen: true,
        description:
            "Congratulation your KYC was succsful.\nYour account is activated.",
        date: DateTime.now().subtract(const Duration(days: 3))),
    NotificationModel(
        seen: true,
        description:
            "Your data transaction was successful you just sent 1.5GB for 1 month at N1000 to 07038941107.",
        date: DateTime.now().subtract(const Duration(minutes: 3))),
  ];

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
