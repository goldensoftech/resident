import 'package:resident/app_export.dart';

class TokenResponseModel {
  String? code;
  String? description;
  num? tokenExpiryTime;
  String? token;

  TokenResponseModel(
      {this.code, this.token, this.tokenExpiryTime, this.description});
  TokenResponseModel.fromJson(dynamic json) {
    code = json['code'];
    token = json['Bearer']['token'];
    tokenExpiryTime = json['tokenExpiryTime'];
    description = json['description'];
  }
  TokenResponseModel copyWith(
          {String? code,
          String? description,
          num? tokenExpiryTime,
          String? token}) =>
      TokenResponseModel(
          tokenExpiryTime: tokenExpiryTime,
          code: this.code ?? this.code,
          token: token ?? token,
          description: description ?? description);
}

class ISWAuthToken {
  String token;
  int expiryTime;
  ISWAuthToken({required this.token, required this.expiryTime});

  factory ISWAuthToken.fromJson(dynamic json) {
    return ISWAuthToken(
        token: json['access_token'], expiryTime: json['expires_in']);
  }
}
