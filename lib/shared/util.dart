import 'package:intl/intl.dart';

class Util {

  // Email Regex
  static final RegExp _emailRegExp = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
  );

  /// Validate email
  static isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  /// Returns time in which favor was created (hour and minute)
  static String readFavorTimestamp(int timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var formattedDate = DateFormat.Hm().format(date);
    return formattedDate;
  }

  ///Returns first letter of first and last name ('M G' is returned from 'Mafe Garizábalo').
  static String lettersForHeader(String name) {
    try {
      List<String> words = name.trim().split(' ');
      if (words.length > 1)
        return (words[0][0] + words[words.length - 1][0]).toUpperCase();
      return words[0][0].toUpperCase();
    }catch(e){
      return "";
    }
  }
}
