import 'package:resident/app_export.dart';
import 'package:resident/repository/model/user_response_model.dart';

class ResponseData {
  static LoginResponseModel? loginResponse;
  static TokenResponseModel? tokenResponseModel;
  static List<BillerResponseModel> billersListModel = [];
  static List<BettingPlatform> bettingPlatforms = [];
  static List<ElectricityBillers> electricityPlatforms = [];
  static List<TransactionModel> txHistory = [];
  static List<RemitaCategory> remitaCategories=[];
  static UserAccountDetails? userBankDetails;
  static UserLocation? userLocation;
  
}
