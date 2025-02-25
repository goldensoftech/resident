import 'package:intl/intl.dart';

import 'package:resident/app_export.dart';


copyText(String text) async {
  await Clipboard.setData(new ClipboardData(text: text));
}

class UtilFunctions with ErrorSnackBar, CustomAlerts {
  /// The function `formatDate` takes a string representation of a date and an optional pattern, and
  /// returns the formatted date according to the specified pattern and date pattern can be modified.
  /// Returns:
  ///   The formatted date string is being returned.
  static String formatDate(String? date,
      {String pattern = 'dd/M/yy', bool isServerTime = true}) {
    if (date != null) {
      final stringDateToDatetime =
          DateTime.parse(date).add(Duration(hours: isServerTime ? 1 : 0));
      final formattedDate = DateFormat(pattern).format(stringDateToDatetime);
      return formattedDate;
    } else {
      return '';
    }
  }

  Future<void> getLocation(context) async {
    // Check if location permission is granted
    ResponseData.userLocation =
        UserLocation(latitude: "9.55679", longitude: "9.692809");

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      sendErrorMessage("Error", "Location services are disabled", context);
      throw Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      sendErrorMessage("Error", "Location access is disabled", context);
      throw Future.error('Location permissions are permanently denied.');
    }

 // Get the current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

ResponseData.userLocation?.latitude = position.latitude.abs().toStringAsFixed(5);
ResponseData.userLocation?.longitude = position.longitude.abs().toStringAsFixed(5);

  }

  String generateDemoNumber() {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    String digitString =
        timestamp.toString().substring(timestamp.toString().length - 6);
    return "00000$digitString";
  }

  String getDateHeader(DateTime date) {
    final now = DateTime.now();

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    } else {
      return '${getDayName(date.weekday)} ${date.day} ${getMonthName(date.month)}';
    }
  }

  String getDashboardDate() {
    final now = DateTime.now();
    return '${getDayName(now.weekday)}, ${now.day} ${getMonthName(now.month)}';
  }

  String getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }

  String getDayName(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'Mon';
      case DateTime.tuesday:
        return 'Tue';
      case DateTime.wednesday:
        return 'Wed';
      case DateTime.thursday:
        return 'Thur';
      case DateTime.friday:
        return 'Fri';
      case DateTime.saturday:
        return 'Sat';
      case DateTime.sunday:
        return 'Sun';
      default:
        return '';
    }
  }

  static String getCurrentDate() {
    final now = DateTime.now();
    return "${now.day}";
  }

  String getTxDate(DateTime date) {
    DateTime now = DateTime.now();
    if (date.year == now.year) {
      return DateFormat('d MMM, h:mma').format(date);
    } else {
      return DateFormat('d MMM, yyyy. h:mma').format(date);
    }
  }

  static String formatAppointmentDate(String? date,
      {String pattern = 'EEEE, d MMMM'}) {
    final now = DateTime.now();
    if (date != null) {
      final stringDateToDatetime =
          DateTime.parse(date).add(const Duration(hours: 1));
      final formattedDate = DateFormat(pattern).format(stringDateToDatetime);

      if (isSameDay(stringDateToDatetime, now)) {
        return "Today, ${formatDate(stringDateToDatetime.toString(), pattern: 'd MMMM')}";
      } else if (isSameDay(
          stringDateToDatetime, now.subtract(const Duration(days: 1)))) {
        return "Yesterday, ${formatDate(stringDateToDatetime.toString(), pattern: 'd MMMM')}";
      } else {
        return formattedDate;
      }
    } else {
      return '';
    }
  }

  static String formatTime(String? date, {String pattern = 'h:mm a'}) {
    if (date != null) {
      final stringDateToDatetime =
          DateTime.parse(date).add(const Duration(hours: 1));
      final formattedDate = DateFormat().add_jm().format(stringDateToDatetime);
      return formattedDate.toLowerCase();
    } else {
      return '';
    }
  }

  static String appointmentTime(
    String? date,
  ) {
    if (date != null) {
      final stringDateToDatetime = DateTime.parse(date);
      final formattedDate = DateFormat().add_jm().format(stringDateToDatetime);
      return formattedDate.toLowerCase();
    } else {
      return '';
    }
  }

  String convertToAgo(String input) {
    //  Duration diff = DateTime.now().difference(DateTime.parse(input));

    var now = DateTime.now();
    var nextMinute =
        DateTime(now.year, now.month, now.day, now.hour, now.minute + 1);

    Stream.periodic(const Duration(seconds: 1), (int count) {
      Timer(nextMinute.difference(now), () {
        Timer.periodic(const Duration(minutes: 1), (timer) {
          callback(input);
        });

        // Execute the callback on the first minute after the initial time.
        //
        // This should be done *after* registering the periodic [Timer] so that it
        // is unaffected by how long [callback] takes to execute.
        callback(input);
      });
    });

    return callback(input);
  }

  static String formatTxDate(DateTime date) {
    return DateFormat("yyyy-MM-dd").format(date);
  }

  static String formatAmount(double amount) {
    if (amount >= 1000000) {
      return NumberFormat.compact().format(amount);
    } else {
      return NumberFormat('#,##0').format(amount);
      // return NumberFormat('#,##0.00').format(amount);
    }
  }

  static String convertTo12HourFormat(String time24Hour) {
    final inputFormat = DateFormat("HH:mm");
    final outputFormat = DateFormat("h:mma");

    final dateTime = inputFormat.parse(time24Hour);
    return outputFormat.format(dateTime).toLowerCase();
  }

  static String capitalizeAllWord(String value) {
    var result = value[0].toUpperCase();
    for (var i = 1; i < value.length; i++) {
      if (value[i - 1] == ' ') {
        result = result + value[i].toUpperCase();
      } else {
        result = result + value[i];
      }
    }
    return result;
  }

  static String convertTimeString(String timeString, type) {
    // Split the time string into hours and minutes
    List<String> timeParts = timeString.split(':');
    int hours = int.parse(timeParts[0]);
    int minutes = int.parse(timeParts[1]);

    // Create a Duration object with the given hours and minutes
    Duration duration = Duration(hours: hours, minutes: minutes);

    // Extract the hours and minutes from the Duration object
    int totalMinutes = duration.inMinutes;
    int convertedHours = totalMinutes ~/ 60;
    int convertedMinutes = totalMinutes % 60;

    // Construct the resulting string
    String result = '';
    if (convertedHours > 0) {
      result += '$convertedHours hr${convertedHours > 1 ? 's' : ''}';
    }
    if (convertedMinutes > 0) {
      if (result.isNotEmpty) {
        result += ' ';
      }
      result += '$convertedMinutes min${convertedMinutes > 1 ? 's' : ''}';
    }

    var finalResult = result.isEmpty ? "No $type" : result;

    return finalResult;
  }

  String callback(input) {
    Duration difference = DateTime.now().difference(DateTime.parse(input));
    final now = DateTime.now();

    if (difference.inSeconds < 5) {
      return 'Just now';
    } else if (difference.inSeconds < 60) {
      return '${difference.inSeconds}s ago';
    } else if (difference.inMinutes == 1) {
      return '1 min ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours == 1) {
      return '1 hr ago';
    } else if (isSameDay(DateTime.parse(input), now)) {
      return "Today, ${formatTime(input.toString())}";
    } else if (isSameDay(
        DateTime.parse(input), now.subtract(const Duration(days: 1)))) {
      return "Yesterday, ${formatTime(input.toString())}";
    } else {
      return formatDate(
          input.toString()); // Customize the format for older dates
    }
  }
}

bool isSameDay(DateTime date1, DateTime date2) {
  return date1.year == date2.year &&
      date1.month == date2.month &&
      date1.day == date2.day;
}

String formatNumber(double number) {
  return NumberFormat.decimalPattern().format(number);
}

String? getFieldValue(String data, String tag) {
  int index = data.indexOf(tag);
  if (index != -1 && index + 4 < data.length) {
    // Extract the length of the field from the data (2 digits after the tag)
    int length = int.parse(data.substring(index + 2, index + 4));
    // Return the value based on the tag and length
    return data.substring(index + 4, index + 4 + length);
  }
  return null;
}
