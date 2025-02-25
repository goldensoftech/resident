import 'package:resident/app_export.dart';

class TransactionModel {
  DateTime txnDate;
  String? email;
  double amount;
  String? serviceType;
  String? paymentCode;
  String? refId;
  String? txnId;
  String? payerName;
  String? payerPhone;
  String? destinationNum;
  PaymentStatus status;
  TransactionType? type;
  PaymentGateway? gateway;
  Metadata? data;

  TransactionModel({
    required this.amount,
    required this.destinationNum,
    required this.email,
    required this.payerName,
    required this.payerPhone,
    required this.paymentCode,
    this.data,
    required this.refId,
    required this.serviceType,
    required this.status,
    this.gateway,
    required this.txnDate,
    this.txnId,
    required this.type,
  });
  factory TransactionModel.fromJson(dynamic json) {
    return TransactionModel(
        amount: double.parse(json["Amount"] ?? "0") / 100,
        email: json['Email'] ?? "",
        payerName: json["PayerName"] ?? "",
        payerPhone: json["PayerPhone"] ?? "",
        paymentCode: json['PaymentCode'] ?? "",
        
        refId: json['ReferenceID'] ?? "",
        txnId: json['TransactionID'] ?? "",
        serviceType: json['ServiceType'] ?? "",
        txnDate: DateTime.parse(
            json['Transaction Date'] ?? DateTime.now().toString()),
        status: convertPaymentTitle(json["PaymentStatus"] ?? ""),
        type: convertTxType(json["TransactionType"] ?? ""),
        gateway: convertGatewayTitle(json["PaymentGateway"] ?? ""),
        destinationNum: json['DestinationNumber'] ?? "");
  }
}

// ISW, PAYSTACK, REMITA
PaymentGateway? convertGatewayTitle(String platform) {
  switch (platform.toUpperCase()) {
    case "PAYSTACK":
      return PaymentGateway.paystack;
    case "ISW":
      return PaymentGateway.interswitch;
    case "REMITA":
      return PaymentGateway.remita;

    default:
      return null;
  }
}

PaymentStatus convertPaymentTitle(String status) {
  switch (status) {
    case "INITIATED":
      return PaymentStatus.initiated;
    case "PENDING":
      return PaymentStatus.pending;
    case "FAILED":
      return PaymentStatus.failed;
    case "COMPLETED" || "paid":
      return PaymentStatus.completed;
    case "PROCESSING":
      return PaymentStatus.processing;
    default:
      return PaymentStatus.initiated;
  }
}

TransactionType? convertTxType(String type) {
  if (type.contains("Airtime_Data")) {
    return TransactionType.airtime_data;
  } else if (type.contains("CableTv")) {
    return TransactionType.tv;
  } else if (type.contains("Electricity")) {
    return TransactionType.electricity;
  } else if (type.contains("Airlines")) {
    return TransactionType.airline;
  } else if (type.contains("Betting")) {
    return TransactionType.betting;
  } else if (type.contains("Remita")) {
    return TransactionType.remita;
  } else
    return null;
}

String getTxLogo(TransactionType? type) {
  switch (type) {
    // case TransactionType.data:
    // case TransactionType.internet:
    //   return wifiIcon;
    case TransactionType.airtime_data:
      return wifiIcon;
    case TransactionType.tv:
      return cableTvIcon;
    case TransactionType.electricity:
      return electricIcon;
    case TransactionType.airline:
      return flightIcon;
    case TransactionType.remita:
      return remittaImg;
    case TransactionType.betting:
    default:
      return billsInactvIcon;
  }
}
