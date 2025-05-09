import 'package:resident/utils/enums.dart';
import 'package:intl/intl.dart';

class DataItem {
  String title;
  String? network;

  double amount;
  String code;

  DataItem(
      {required this.title,
      this.network,
      required this.amount,
      required this.code});

  factory DataItem.fromJson(dynamic json) {
    return DataItem(
        title: json['Name'],
        amount: double.parse(
            (double.parse(json['Amount']) * 0.01).toStringAsFixed(2)),
        code: json['PaymentCode']);
  }
}

class PaymentDetails {
  String customerId;
  String? serviceId;
  String? serviceName;
  String? customerMobile;
  String? customerEmail;
  String? ref;
  int? surcharge;
  double amount;
  String? paymentCode;
  String? payerName;
  TransactionType transactionType;
  PaymentGateway? paymentGateway;
  Metadata? metadata;

  PaymentDetails(
      {required this.customerId,
      required this.customerEmail,
      required this.amount,
      required this.customerMobile,
      required this.payerName,
      required this.surcharge,
      this.ref,
      this.metadata,
      required this.serviceName,
      required this.serviceId,
      required this.paymentCode,
      this.paymentGateway,
      required this.transactionType});


}

class Metadata {
  DateTime? txnDate;

  String? receiptUrl;
  Metadata({this.txnDate, this.receiptUrl});

  factory Metadata.fromJson(dynamic json) {
    String dateString = json['transactionDate'];
    String dateOnly = dateString.split('T')[0];
    return Metadata(
        txnDate: DateTime.parse(dateOnly),
        receiptUrl: json['receiptUrl']);
  }
}

class OrderItem {
  String customerId;
  double amount;
  String code;
  String? customerName;
  int? surcharge;
  OrderItem(
      {required this.customerId,
      required this.customerName,
      required this.amount,
      this.surcharge,
      required this.code});

  factory OrderItem.fromJson(dynamic json) {
    return OrderItem(
        customerName: json["FullName"],
        customerId: json["CustomerId"],
        amount: double.parse(json['Amount']) * 0.01,
        surcharge: json["Surcharge"],
        code: json['PaymentCode']);
  }
}
