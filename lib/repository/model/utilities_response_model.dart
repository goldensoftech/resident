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
  // DateTime date;

  LookupDetails(
      {required this.detials,
      // required this.date,
      required this.status,
      required this.rrrData});
  factory LookupDetails.fromJson(dynamic json) {
    return LookupDetails(
        // date: DateTime.parse(
        //     json['transactionDate'] ?? DateTime.now().toString()),
        detials: PaymentDetails(
            metadata: Metadata.fromJson(json['metadata']),
            customerId: json["phoneNumber"],
            customerEmail: json['email'] ?? "femiadubuola7@gmail.com",
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
          paymentIdentifier: json['paymentIdentifier'] ?? json['rrr'],
          rrr: json['rrr'],
          amount: double.parse(json['rrrAmount'].toString()),
        ));
  }
}

class RemitaDetails {
  String paymentIdentifier;
  String rrr;
  double amount;

  RemitaDetails({
    required this.paymentIdentifier,
    required this.rrr,
    required this.amount,
  });
  factory RemitaDetails.fromJson(dynamic json) {
    return RemitaDetails(
        paymentIdentifier: json['paymentIdentifier'],
        rrr: json['rrr'],
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
        options: ((json['customFieldDropDown'] ?? json['selectOptions'])
                    as List<dynamic>?)
                ?.map((data) => ProductSelectOptions.fromJson(data))
                .toList() ??
            [],
        varName: json['variable_name'],
        type: getFieldType(json['type']));
  }
}

class ProductSelectOptions {
  String value;
  String? code;
  String? fieldId;
  String displayName;
  bool? isFixed;
  ProductSelectOptions(
      {this.code,
      this.fieldId,
      this.isFixed,
      required this.value,
      required this.displayName});
  factory ProductSelectOptions.fromJson(dynamic json) {
    return ProductSelectOptions(
        code: json['CODE'],
        fieldId: json['ID'],
        isFixed: (json['FIXEDPRICE'] == null || json['FIXEDPRICE'] == 'false')
            ? false
            : true,
        value: json['VALUE'] ?? json['UNITPRICE'].toString(),
        displayName: json['DISPLAY_NAME'] ?? json['DESCRIPTION']);
  }
}

FieldType getFieldType(String type) {
  if (type == 'number') {
    return FieldType.number;
  } else if (type == 'singleselect') {
    return FieldType.singleselect;
  } else if (type == 'multiselect') {
    return FieldType.multiselect;
  } else if (type == 'multiselectwithprice') {
    return FieldType.multiselectwithprice;
  } else if (type.contains('date')) {
    return FieldType.date;
  } else
    return FieldType.alphanumeric;
}

class Bank {
  String name;
  String? logoUrl;
  String code;
  Bank({this.logoUrl, required this.name, required this.code});
}

class MerchantResponse {
  String institutionNumber;
  String mchNo;
  String merchantName;
  String merchantTin;
  String merchantAddress;
  String merchantContantName;
  String merchantPhoneNumber;
  String merchantEmail;
  MerchantResponse({
    required this.institutionNumber,
    required this.mchNo,
    required this.merchantName,
    required this.merchantAddress,
    required this.merchantContantName,
    required this.merchantEmail,
    required this.merchantPhoneNumber,
    required this.merchantTin,
  });
}

class SubMchResponse {
  String institutionNumber;
  String mchNo;
  String subName;
  String subMchNo;
  String envcoCode;
  SubMchResponse(
      {required this.institutionNumber,
      required this.mchNo,
      required this.envcoCode,
      required this.subMchNo,
      required this.subName});
}

class DynamicQRResponse {
  String orderSn;
  String codeUrl;
  DynamicQRResponse({required this.codeUrl, required this.orderSn});
}

class BindMchResponse {
  String institutionNumber;
  String mchNo;
  BindMchResponse({required this.institutionNumber, required this.mchNo});
}
