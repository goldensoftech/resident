class NqrCodeData {
   String institutionNumber;
   String orderAmount;
  String orderSn; // Full Order SN (Part 1 + Part 2)
   String merchantNo;
   String subMerchantNo;
   String merchantName;
   bool isDynamic;

  NqrCodeData({
    required this.institutionNumber,
    required this.orderAmount,
    required this.orderSn,
    required this.merchantNo,
    required this.subMerchantNo,
    required this.merchantName,
    required this.isDynamic,
  });

  factory NqrCodeData.fromQrString(String qrData) {
    String institutionNumber = '';
    String orderAmount = '';
    String orderSn = '';
    String merchantNo = '';
    String subMerchantNo = '';
    String merchantName = '';
    bool isDynamic = false;

    int i = 0;
    while (i < qrData.length) {
      String tag = qrData.substring(i, i + 2); // Tag is always 2 digits
      String lengthStr = qrData.substring(i + 2, i + 4);
      int length;

      try {
        length = int.parse(lengthStr); // Attempt to parse length
      } catch (e) {
        print("Error parsing length at position $i: $lengthStr");
        break;
      }

      String value =
          qrData.substring(i + 4, i + 4 + length); // Value based on the length

      // Check the tag and assign the value accordingly
      if (tag == "01") {
        isDynamic = value == "12"; // QR Type: Static (11) or Dynamic (12)
      } else if (tag == "15") {
        // Extract Institution Number and Merchant Number
        institutionNumber =
            value.substring(0, 12); // First 12 characters: Institution number

        // Find the position of "M" in the remaining string
        int mIndex = value.indexOf(
            "M", 12); // Start search after the first 12 characters
        if (mIndex != -1 && value.length >= mIndex + 11) {
          merchantNo = value.substring(
              mIndex, mIndex + 11); // Extract 11 characters starting from "M"
        }
      } else if (tag == "26") {
        // Sub-merchant Number + Order SN
        if (value.contains("QR0111")) {
          // Find the position where "QR0111" appears
          int start =
              value.indexOf("QR0111") + 6; // Skip "QR0111" (7 characters)

          // Extract the Sub-Merchant Number (next 11 characters after "QR0111")
          subMerchantNo = value.substring(start, start + 11);

          // Skip the next 4 characters ("0230")
          start += 11 + 4;

          // Extract the Order SN (next 30 characters)
          orderSn = value.substring(start, start + 30);
        }
      } else if (tag == "54") {
        // Extract Order Amount for dynamic QR codes
        orderAmount = value;
        isDynamic =
            orderAmount.isEmpty; // If there's an amount, it's not dynamic
      } else if (tag == "59") {
        // Extract Merchant Name (variable length, up to 99 characters)
        merchantName = value; // Merchant name
      }

      // Move to the next tag (4 + length characters)
      i += 4 + length;
    }

    return NqrCodeData(
      institutionNumber: institutionNumber,
      orderAmount: orderAmount,
      orderSn: orderSn, // Full Order SN
      merchantNo: merchantNo,
      subMerchantNo: subMerchantNo,
      merchantName: merchantName,
      isDynamic: isDynamic,
    );
  }
}

String restructureRawData(String rawData) {
  // Step 1: Clean the data by removing or replacing unnecessary characters
  String formattedData = rawData
      .replaceAll("**999166**999166", "4434056600520446")
      .replaceAll('', ''); // Remove any unwanted control characters

  // Step 2: Ensure proper structure in key areas (if necessary)
  // You may need additional logic here if there are more patterns to replace

  // Step 3: Return the cleaned-up data
  return formattedData;
}
