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
}
