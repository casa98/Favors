import 'package:intl/intl.dart';

class Util {
  /*
   * Returns time in which favor was created (hour and minute)
   */
  String readFavorTimestamp(int timestamp) {
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var formattedDate = DateFormat.Hm().format(date);
    return formattedDate;
  }

  // If name == 'Maria Fernanda Garizabalo', returns 'M G'
  String lettersForHeader(String name) {
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
