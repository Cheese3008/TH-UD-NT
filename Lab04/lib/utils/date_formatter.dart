import 'package:intl/intl.dart';

class DateFormatter {
  static String formatFullDate(DateTime dateTime) {
    return DateFormat('EEEE, dd/MM/yyyy').format(dateTime);
  }

  static String formatShortDate(DateTime dateTime) {
    return DateFormat('dd/MM/yyyy').format(dateTime);
  }

  static String formatHour(DateTime dateTime, {bool use12Hour = false}) {
    if (use12Hour) {
      return DateFormat('hh:mm a').format(dateTime);
    }

    return DateFormat('HH:mm').format(dateTime);
  }

  static String formatDay(DateTime dateTime) {
    return DateFormat('EEE, dd/MM').format(dateTime);
  }

  static String formatLastUpdate(DateTime? dateTime) {
    if (dateTime == null) {
      return 'Chưa có thời gian cập nhật';
    }

    return 'Cập nhật lúc ${DateFormat('HH:mm dd/MM/yyyy').format(dateTime)}';
  }
}
