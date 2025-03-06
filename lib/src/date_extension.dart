import 'package:dart_tool_kit/src/number.extension.dart';
import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime {
  // ============================
  // 🕒 BASIC FORMATTING EXTENSIONS
  // ============================

  // 1. Format as YYYY-MM-DD
  String get toIsoDate => "$year-${month.twoDigits}-${day.twoDigits}";

  // 2. Format as DD/MM/YYYY
  String get toSlashFormat => "${day.twoDigits}/${month.twoDigits}/$year";

  // 3. Format as MM-DD-YYYY
  String get toDashedFormat => "${month.twoDigits}-${day.twoDigits}-$year";

  // 4. Format as YYYY/MM/DD HH:mm:ss
  String get toFullDateTime =>
      "$toIsoDate ${hour.twoDigits}:${minute.twoDigits}:${second.twoDigits}";

  // 5. Format as "Wednesday, 14 Feb 2024"
  String get toReadableFormat => "$weekdayName, $day $monthShortName $year";

  // ============================
  // 📅 DATE CALCULATIONS
  // ============================

  // 6. Start of Day (00:00:00)
  DateTime get startOfDay => DateTime(year, month, day);

  // 7. End of Day (23:59:59)
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59, 999);

  // 8. Start of Month
  DateTime get startOfMonth => DateTime(year, month, 1);

  // 9. End of Month
  DateTime get endOfMonth => DateTime(year, month + 1, 0, 23, 59, 59, 999);

  // 10. Start of the Year
  DateTime get startOfYear => DateTime(year, 1, 1);

  // 11. End of the Year
  DateTime get endOfYear => DateTime(year, 12, 31, 23, 59, 59, 999);

  // 12. Add Days
  DateTime addDays(int days) => add(Duration(days: days));

  // 13. Subtract Days
  DateTime subtractDays(int days) => subtract(Duration(days: days));

  // 14. Add Months (Handling overflow)
  DateTime addMonths(int months) {
    int newMonth = (month + months - 1) % 12 + 1;
    int newYear = year + (month + months - 1) ~/ 12;
    return DateTime(newYear, newMonth, day);
  }

  // 15. Subtract Months
  DateTime subtractMonths(int months) => addMonths(-months);

  // 16. Add Years
  DateTime addYears(int years) => DateTime(year + years, month, day);

  // 17. Subtract Years
  DateTime subtractYears(int years) => addYears(-years);

  // 18. Get Quarter of the Year (1-4)
  int get quarter => ((month - 1) ~/ 3) + 1;

  // ============================
  // 📅 WEEK & WEEKDAY HELPERS
  // ============================

  // 19. Is Today?
  bool get isToday => isSameDate(DateTime.now());

  // 20. Is Weekend?
  bool get isWeekend =>
      weekday == DateTime.saturday || weekday == DateTime.sunday;

  // 21. Is Weekday?
  bool get isWeekday => !isWeekend;

  // 22. Get Next Monday
  DateTime get nextMonday => add(Duration(days: (8 - weekday) % 7));

  // 23. Get Previous Monday
  DateTime get previousMonday => subtract(Duration(days: (weekday - 1) % 7));

  // 24. Start of the Week (Monday)
  DateTime get startOfWeek => subtract(Duration(days: weekday - 1));

  // 25. End of the Week (Sunday)
  DateTime get endOfWeek => add(Duration(days: 7 - weekday));

  // ============================
  // 🔄 CONVERSIONS & PARSING
  // ============================

  // 26. Convert to UTC
  DateTime get toUtcDate => toUtc();

  // 27. Convert to Local
  DateTime get toLocalDate => toLocal();

  // 28. Convert to Epoch Milliseconds
  int get toEpochMilliseconds => millisecondsSinceEpoch;

  // 29. Convert to Epoch Seconds
  int get secondsSinceEpoch => millisecondsSinceEpoch ~/ 1000;

  // 30. Convert from Epoch Milliseconds
  static DateTime fromEpochMilliseconds(int milliseconds) =>
      DateTime.fromMillisecondsSinceEpoch(milliseconds);

  // 31. Convert from Epoch Seconds
  static DateTime fromEpochSeconds(int seconds) =>
      DateTime.fromMillisecondsSinceEpoch(seconds * 1000);

  // ============================
  // ⏳ DATE DIFFERENCE HELPERS
  // ============================

  // 32. Difference in Days
  int daysBetween(DateTime other) => other.difference(this).inDays.abs();

  // 33. Difference in Hours
  int hoursBetween(DateTime other) => other.difference(this).inHours.abs();

  // 34. Difference in Minutes
  int minutesBetween(DateTime other) => other.difference(this).inMinutes.abs();

  // 35. Difference in Seconds
  int secondsBetween(DateTime other) => other.difference(this).inSeconds.abs();

  // ============================
  // 🏷️ DATE REPRESENTATIONS
  // ============================

  // 36. Get Month Name (January, February, etc.)
  String get monthName => _months[month - 1];

  // 37. Get Short Month Name (Jan, Feb, etc.)
  String get monthShortName => _monthsShort[month - 1];

  // 38. Get Weekday Name (Monday, Tuesday, etc.)
  String get weekdayName => _weekdays[weekday - 1];

  // 39. Get Short Weekday Name (Mon, Tue, etc.)
  String get weekdayShortName => _weekdaysShort[weekday - 1];

  // 40. Check if Leap Year
  bool get isLeapYear =>
      (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);

  // 41. Get Days in Month
  int get daysInMonth => DateTime(year, month + 1, 0).day;

  // 42. Get Week of the Year
  int get weekOfYear {
    int dayOfYear =
        int.parse(toIso8601String().substring(5, 10).replaceAll("-", ""));
    return ((dayOfYear - weekday + 10) ~/ 7);
  }

  // ============================
  // ⏳ HUMAN READABLE TIME
  // ============================

  // 43. Convert Date to Human Readable String (e.g., "2 hours ago")
  String timeAgo() {
    final duration = DateTime.now().difference(this);
    if (duration.inSeconds < 60) return "${duration.inSeconds} seconds ago";
    if (duration.inMinutes < 60) return "${duration.inMinutes} minutes ago";
    if (duration.inHours < 24) return "${duration.inHours} hours ago";
    if (duration.inDays < 7) return "${duration.inDays} days ago";
    return toIsoDate;
  }

  // ============================
  // 🛠️ PRIVATE HELPER METHODS
  // ============================
  static const List<String> _months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];

  static const List<String> _monthsShort = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  static const List<String> _weekdays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  static const List<String> _weekdaysShort = [
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat",
    "Sun"
  ];

  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  bool get isYesterday {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  bool get isTomorrow {
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));
    return year == tomorrow.year &&
        month == tomorrow.month &&
        day == tomorrow.day;
  }

  int monthsBetween(DateTime other) {
    return (other.year - year) * 12 + (other.month - month);
  }

  int yearsBetween(DateTime other) {
    return other.year - year;
  }

  DateTime get firstDayOfWeek {
    int weekdayIndex = weekday; // 1 (Monday) to 7 (Sunday)
    return subtract(Duration(days: weekdayIndex - 1));
  }

  /// Returns the last day (Sunday) of the current week.
  DateTime get lastDayOfWeek {
    int daysUntilSunday = 7 - weekday;
    return add(Duration(days: daysUntilSunday));
  }

  /// Returns the same day of the next week.
  DateTime get nextWeek => add(const Duration(days: 7));

  /// Returns the same day of the previous week.
  DateTime get previousWeek => subtract(const Duration(days: 7));

  /// Calculates the age from the current date.
  int get age {
    final today = DateTime.now();
    int age = today.year - year;

    if (today.month < month || (today.month == month && today.day < day)) {
      age--; // Adjust if birthday hasn't occurred yet this year.
    }
    return age;
  }

  /// Formats the date using the given pattern.
  String format(String pattern) {
    return DateFormat(pattern).format(this);
  }
}
