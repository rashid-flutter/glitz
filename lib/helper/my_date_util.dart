import 'package:flutter/material.dart';

class MyDateUtil {
  static String getFormattedTime(BuildContext con, String time) {
    final date = DateTime.fromMicrosecondsSinceEpoch(int.parse(time));
    return TimeOfDay.fromDateTime(date).format(con);
  }
}
