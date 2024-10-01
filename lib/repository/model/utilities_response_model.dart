import 'package:resident/app_export.dart';

class BettingPlatform {
  String name;
  int id;
  BettingPlatform({required this.name, required this.id});

  factory BettingPlatform.fromJson(dynamic json) {
    return BettingPlatform(name: json["Name"], id: json['Id']);
  }
}

class BettingDataItem {
  String name;
  String code;
  BettingDataItem({required this.name, required this.code});
  factory BettingDataItem.fromJson(dynamic json) {
    return BettingDataItem(
        name: json["BillerName"], code: (json['PaymentCode']));
  }
}

class ElectricityBillers {
  String name;
  String narration;
  int id;

  ElectricityBillers(
      {required this.id, required this.narration, required this.name});
}

class ElectricityItem {
  String name;

  int code;
  ElectricityItem({required this.code, required this.name});
  factory ElectricityItem.fromJson(dynamic json) {
    return ElectricityItem(
        name: json["Name"], code: int.parse(json['PaymentCode']));
  }
}

class RemitaCategory {
  String name;

  String id;
  String? logoUrl;
  RemitaCategory({required this.name, this.logoUrl, required this.id});
  factory RemitaCategory.fromJson(dynamic json) {
    return RemitaCategory(
        name: json["billerName"],
        logoUrl: json['billerLogoUrl'],
        id: json['billerId']);
  }
}

class RemitaCustomer {
  String? customerName;
  String? email;
  String? address;
  double? amount;
  String productId;
  String? customerId;

  RemitaCustomer(
      {this.customerName,
      this.email,
      this.address,
      this.amount,
      this.customerId,
      required this.productId});
  factory RemitaCustomer.fromJson(dynamic json) {
    return RemitaCustomer(
        customerName: json['name'],
        email: json['email'],
        address: json['address'],
        amount: json['amount'],
        productId: json['billPaymentProductId'],
        customerId: json['customerId']);
  }
}

class LookupDetails {
  RemitaDetails rrrData;
  PaymentDetails detials;
  PaymentStatus status;
  DateTime date;
  LookupDetails(
      {required this.detials,
      required this.date,
      required this.status,
      required this.rrrData});
  factory LookupDetails.fromJson(dynamic json) {
    return LookupDetails(
        date: DateTime.parse(
            json['transactionDate'] ?? DateTime.now().toString()),
        detials: PaymentDetails(
            customerId: json["phoneNumber"],
            customerEmail: json['email'],
            amount: double.parse(json['amount'].toString()),
            customerMobile: json['phoneNumber'],
            payerName: json['name'],
            surcharge: (json['fee'] as double).ceil(),
            serviceName: json['billerName'],
            serviceId: json['billerId'],
            paymentCode: json['billerId'],
            paymentGateway: PaymentGateway.remita,
            ref: json['rrr'],
            transactionType: TransactionType.remita),
        status: convertPaymentTitle(json['status']),
        rrrData: RemitaDetails(
            txRef: json['transactionRef'] ?? json['rrr'],
            rrr: json['rrr'],
            amount: double.parse(json['rrrAmount'].toString()),
            commission: double.parse(json['fee'].toString())));
  }
}

class RemitaDetails {
  String txRef;
  String rrr;
  double amount;
  double commission;
  RemitaDetails(
      {required this.txRef,
      required this.rrr,
      required this.amount,
      required this.commission});
  factory RemitaDetails.fromJson(dynamic json) {
    return RemitaDetails(
        txRef: json['transactionRef'],
        rrr: json['rrr'],
        commission: double.parse((json['commission'].toString())),
        amount: double.parse(json['amount'].toString()));
  }
}

class RemitaBillerProduct {
  String productName;
  String productId;
  double amount;
  bool isAmountFixed;

  List<BillerCustomFields> fields;
  RemitaBillerProduct(
      {required this.productName,
      required this.amount,
      required this.fields,
      required this.isAmountFixed,
      required this.productId});
  factory RemitaBillerProduct.fromJson(dynamic json) {
    return RemitaBillerProduct(
        productName: json['billPaymentProductName'],
        amount: json['amount'],
        isAmountFixed: json['isAmountFixed'],
        fields: (json['metadata']['customFields'] as List<dynamic>?)
                ?.map((data) => BillerCustomFields.fromJson(data))
                .toList() ??
            [],
        productId: json['billPaymentProductId']);
  }
}

class BillerCustomFields {
  String displayName;
  String varName;
  FieldType type;
  bool required;
  List<ProductSelectOptions> options;
  BillerCustomFields(
      {required this.displayName,
      required this.varName,
      required this.type,
      required this.required,
      required this.options});
  factory BillerCustomFields.fromJson(dynamic json) {
    return BillerCustomFields(
        displayName: json['display_name'],
        required: json['required'],
        options: (json['selectOptions'] as List<dynamic>?)
                ?.map((data) => ProductSelectOptions.fromJson(data))
                .toList() ??
            [],
        varName: json['variable_name'],
        type: getFieldType(json['type']));
  }
}

class ProductSelectOptions {
  String value;
  String displayName;
  ProductSelectOptions({required this.value, required this.displayName});
  factory ProductSelectOptions.fromJson(dynamic json) {
    return ProductSelectOptions(
        value: json['VALUE'], displayName: json['DISPLAY_NAME']);
  }
}

FieldType getFieldType(String type) {
  if (type == 'number') {
    return FieldType.number;
  } else if (type.contains('select')) {
    return FieldType.singleselect;
  } else
    return FieldType.alphanumeric;
}

class Bank {
  String name;
  String? logoUrl;
  String code;
  Bank({this.logoUrl, required this.name, required this.code});
}
