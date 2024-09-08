import 'dart:convert';
import 'package:crypto/crypto.dart';
class NIBSSQRCodeData {
  final String merchantId;
  final String institutionNo;
  final String amount;
  final String subMerchantId;
  final String timestamp;
  final String merchantName;
  final String orderNo;

  NIBSSQRCodeData({
    required this.merchantId,
    required this.institutionNo,
    required this.amount,
    required this.subMerchantId,
    required this.timestamp,
    required this.merchantName,
    required this.orderNo,
  });
}

NIBSSQRCodeData decryptNIBSSQRCode(String qrCode) {
  String merchantId = '';
  String institutionNo = '';
  String amount = '';
  String subMerchantId = '';
  String timestamp = '';
  String merchantName = '';
  String orderNo = '';

  // Sample raw data:
  // "0002010102121531**999166**999166****M000388764026710018NG.COM.NIBSSPLC.QR0111S000308541502301100132408202220597679531513345204000053035665406200.005802NG5911MTN NIGERIA6007Nigeria6304EFAE";

  // Extract Merchant ID
  RegExp merchantIdRegex = RegExp(r'\*\*(\d{6})\*\*');
  RegExpMatch? merchantIdMatch = merchantIdRegex.firstMatch(qrCode);
  if (merchantIdMatch != null) {
    merchantId = merchantIdMatch.group(1) ?? '';
  }

  // Extract SubMerchant ID (Assumed to be similar to Merchant ID)
  RegExp subMerchantIdRegex = RegExp(r'\*\*(\d{6})\*\*');
  RegExpMatch? subMerchantIdMatch = subMerchantIdRegex.firstMatch(qrCode);
  if (subMerchantIdMatch != null) {
    subMerchantId = subMerchantIdMatch.group(1) ?? '';
  }

  // Extract Institution No (Based on the structure provided)
  RegExp institutionNoRegex = RegExp(r'M(\d{6})');
  RegExpMatch? institutionNoMatch = institutionNoRegex.firstMatch(qrCode);
  if (institutionNoMatch != null) {
    institutionNo = institutionNoMatch.group(1) ?? '';
  }

  // Extract Amount
  RegExp amountRegex = RegExp(r'5406(\d+\.\d{2})');
  RegExpMatch? amountMatch = amountRegex.firstMatch(qrCode);
  if (amountMatch != null) {
    amount = amountMatch.group(1) ?? '';
  }

  // Extract Timestamp (Assumed position based on provided data)
  RegExp timestampRegex = RegExp(r'(\d{8})');
  RegExpMatch? timestampMatch = timestampRegex.firstMatch(qrCode);
  if (timestampMatch != null) {
    timestamp = timestampMatch.group(1) ?? '';
  }

  // Extract Merchant Name (Assumed to follow the pattern '5911[merchantName]')
  RegExp merchantNameRegex = RegExp(r'5911([A-Z\s]+)');
  RegExpMatch? merchantNameMatch = merchantNameRegex.firstMatch(qrCode);
  if (merchantNameMatch != null) {
    merchantName = merchantNameMatch.group(1) ?? '';
  }

  // Extract Order No (Assumed to be a sequence of digits right after the merchant ID)
  RegExp orderNoRegex = RegExp(r'999166(\d{14})');
  RegExpMatch? orderNoMatch = orderNoRegex.firstMatch(qrCode);
  if (orderNoMatch != null) {
    orderNo = orderNoMatch.group(1) ?? '';
  }

  return NIBSSQRCodeData(
    merchantId: merchantId,
    institutionNo: institutionNo,
    amount: amount,
    subMerchantId: subMerchantId,
    timestamp: timestamp,
    merchantName: merchantName,
    orderNo: orderNo,
  );
}

String generateSignature({
  required String amount,
  required String authCode,
  required String institutionNumber,
  required String merchantNumber,
  required String merchantName,
  required String orderSN,
  required String subMerchantNumber,
  required String timestamp,
  required String apiKey,
}) {
  // Concatenate the parameters according to the required format
  String concatenatedString = 'amount=$amount' +
      '&auth_code=$authCode' +
      '&institution_number=$institutionNumber' +
      '&mch_no=$merchantNumber' +
      '&mer_name=$merchantName' +
      '&order_sn=$orderSN' +
      '&sub_mch_no=$subMerchantNumber' +
      '&timestamp=$timestamp' +
      apiKey;

  // Convert the concatenated string to bytes
  List<int> bytes = utf8.encode(concatenatedString);

  // Generate the SHA-256 hash of the bytes
  Digest sha256Hash = sha256.convert(bytes);

  // Return the hash as a hexadecimal string
  return sha256Hash.toString().toUpperCase();
}
