import 'constants.dart';

extension DateExtension on DateTime {
  String toJson() {
    return jsonFormatter.format(this);
  }

  DateTime get startOfDay {
    return DateTime(year, month, day);
  }

  DateTime get middleOfDay {
    return DateTime(year, month, day, 12);
  }

  DateTime get endOfDay {
    return DateTime(year, month, day, 23, 59, 59, 999);
  }

  DateTime nextDays(int days) {
    return DateTime(year, month, day).add(Duration(days: days));
  }

  DateTime previousDays(int days) {
    return DateTime(year, month, day).subtract(Duration(days: days));
  }

  bool operator <(DateTime other) {
    return isBefore(other);
  }

  bool operator <=(DateTime other) {
    return this == other || isBefore(other);
  }

  bool operator >(DateTime other) {
    return isAfter(other);
  }

  bool operator >=(DateTime other) {
    return this == other || isAfter(other);
  }
}

class DateTimeUtil {
  DateTimeUtil._();

  static DateTime get today {
    return startOfToday;
  }

  static DateTime get startOfToday {
    return DateTime.now().startOfDay;
  }

  static DateTime get endOfToday {
    return DateTime.now().endOfDay;
  }

  static DateTime next(int days) {
    return DateTime.now().nextDays(days);
  }

  static DateTime previous(int days) {
    return DateTime.now().previousDays(days);
  }
}
