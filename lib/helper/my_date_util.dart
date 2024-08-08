import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDateUtil {
  static String getFormattedTime(BuildContext con, String time) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(con);
  }

  //?get last message time(used in a chat user card)
  static String lastMessageTime(
      {required BuildContext con, required String time}) {
    final DateTime sent = DateTime.fromMillisecondsSinceEpoch(int.parse(time));
    final DateTime now = DateTime.now();
    if (now.day == sent.day &&
        now.month == sent.month &&
        now.year == sent.year) {
      return TimeOfDay.fromDateTime(sent).format(con);
    }
    return '${sent.day}${getMonth(sent)}';
  }

  //?get month name from month no. or index
  static String getMonth(DateTime date) {
    switch (date.month) {
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
        return 'Sept';
      case 10:
        return 'Oct';
      case 11:
        return 'Now';
      case 12:
        return 'Dec';
    }
    return 'NA';
  }
}
