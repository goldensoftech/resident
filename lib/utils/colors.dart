import 'package:resident/app_export.dart';

class AppColors {
  static Color whiteA700 = fromHex('#ffffff');
  static Color whiteA70066 = fromHex('#66ffffff');
  static Color black900 = fromHex('#000000');
  static Color grey500 = fromHex('#BABABA');
  static Color lightGrey = fromHex('#F7F7F7');
  static Color greyF9 = fromHex("#F9F9F9");
  static Color green500 = fromHex("#21BEB7");
  static Color grey200 = fromHex("#E2E2E2");
  static Color grey400 = fromHex("#B7B7B7");
  static Color darkGrey = fromHex("#404040");
  static Color grey5002 = fromHex("#A2A2A2");
  static Color baseBlack = fromHex('#0B0A0A');
  static Color formGrey = fromHex('#D9D9D9');
  static Color iconGrey = fromHex('#292D32');
  static Color yellowIcon = fromHex("#FDB813");
  static Color grey32 = fromHex("#323232");
  // static Color lightGrey = const Color.fromARGB(255, 1, 1, 1);
  static Color appGold = fromHex("#C17B31");
  static Color schemeColor = fromHex("#49454F");
  static Color baseWhite = fromHex("#FAFAFA");
  static Color gold100 = fromHex("#F7ECE0");
  static Color error = fromHex("#C03744");
  static Color cream = fromHex("#F5F5DC");
  static Color cardColor = fromHex("#F9F9F9");
  static Color deepGreen = fromHex("#004225");
  static Color neutralGrey = fromHex("#E4E4E4");
  static Color deepWine = fromHex("#9A031E");
  static Color deepBlue = fromHex("#102C57");
  static Color grey700 = fromHex("#777777");
  static Color greyBG = fromHex("#F2F2F2");
  static Color grey50 = Colors.grey.shade50;
  static Color iconlightGrey = fromHex("#B0B0B0");
//  static Color lightPurple = appPurple.withOpacity(.5);
  static Color red = Colors.red;
  static Color transparent = Colors.transparent;

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
