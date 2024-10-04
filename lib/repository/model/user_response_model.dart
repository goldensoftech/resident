class User {
  String? userName;
  String? firstName;
  String? lastName;
  String? customerId;
  String? phoneNumber;
  String? photo;
  String? bvn;
  bool? bvnStatus;
  User(
      {this.phoneNumber,
      this.userName,
      this.firstName,
      this.lastName,
      this.photo,
      this.bvn,
      this.bvnStatus,
      this.customerId});

  User.fromJson(dynamic json) {
    userName = json['Username'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    photo = json['photo'];
    bvn = json['bvn'];
    bvnStatus = json['bvnStatus'] == "VERIFIED" ? true : false;
    customerId = json['customerId'];
    phoneNumber = json['phoneNumber'];
  }
}

class UserAccountDetails {
  String? name;
  String? bvn;
  String? accountNumber;
  String? bankName;

  UserAccountDetails({this.name, this.bvn, this.accountNumber, this.bankName});
}

class UserLocation {
  String longitude;
  String latitude;
  UserLocation({required this.longitude, required this.latitude});
}

class UserBankDetails {
  String accountNumber;
  String accountName;
  String bankCode;
  String bvn;
  String kycLevel;
  String channelCode;

  UserBankDetails(
      {required this.accountNumber,
      required this.accountName,
      required this.bankCode,
      required this.bvn,
      required this.kycLevel,
      required this.channelCode});
  factory UserBankDetails.fromJson(dynamic json) {
    return UserBankDetails(
        accountNumber: json['AccountNumber'],
        accountName: json['Account Name'],
        kycLevel: json['KYCLevel'],
        bvn: json['BankVerificationNumber'],
        bankCode: json['Bank Code'],
        channelCode: json['Channel Code']);
  }
}
