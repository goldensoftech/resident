class BillerResponseModel {
  String id;
  int payDirectProductId;
  String name;
  String customerField;
  String surcharge;
  String supportEmail;
  String categoryId;
  String categoryName;
  int amountType;

  BillerResponseModel(
      {required this.id,
      required this.amountType,
      required this.categoryName,
      required this.customerField,
      required this.name,
      required this.surcharge,
      required this.payDirectProductId,
      required this.supportEmail,
      required this.categoryId});

  factory BillerResponseModel.fromJson(dynamic json) {
    return BillerResponseModel(
      id: json['id'],
      payDirectProductId: json['id'],
      name: json['name'],
      customerField: json[''],
      surcharge: json[''],
      supportEmail: json[''],
      categoryName: json[''],
      amountType: int.parse(json['']),
      categoryId: json[''],
    );
  }
}
