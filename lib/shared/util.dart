import 'package:intl/intl.dart';

class Util {

  // Email:
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
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

  // If name == 'Maria Fernanda Garizabalo', returns 'M G'
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
