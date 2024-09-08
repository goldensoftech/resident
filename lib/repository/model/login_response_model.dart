import 'user_response_model.dart';

class LoginResponseModel {
  bool? isLoggedIn;
  String? code;
  User? user;
  LoginResponseModel({this.isLoggedIn, this.code, this.user});

  LoginResponseModel.fromJson(dynamic json) {
    code = json['code'];
    user = User.fromJson(json);
  }

  LoginResponseModel copyWith({bool? isLoggedIn, String? code, User? user}) =>
      LoginResponseModel(
        code: code ?? this.code,
        isLoggedIn: isLoggedIn ?? this.isLoggedIn,
        user: user ?? this.user,
      );
}
