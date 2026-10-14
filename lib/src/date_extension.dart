import 'package:dart_tool_kit/src/number.extension.dart';
import 'package:intl/intl.dart';

/// Extensions on [DateTime] for formatting, calendar arithmetic and
/// human-readable output.
///
/// Members that build a new date keep the receiver's UTC/local flag. Calendar
/// arithmetic ([addDays], [addMonths], [nextMonday], ...) works on calendar
/// fields rather than fixed 24-hour durations, so it is not shifted by
/// daylight-saving transitions.
extension DateTimeExtensions on DateTime {
  // ============================
  // 🕒 BASIC FORMATTING EXTENSIONS
  // ============================

  /// Formats as `YYYY-MM-DD`. Example: `'2024-02-14'`
  String get toIsoDate =>
      "${year.toString().padLeft(4, '0')}-${month.twoDigits}-${day.twoDigits}";

  /// Formats as `DD/MM/YYYY`. Example: `'14/02/2024'`
  String get toSlashFormat => "${day.twoDigits}/${month.twoDigits}/$year";

  /// Formats as `MM-DD-YYYY`. Example: `'02-14-2024'`
  String get toDashedFormat => "${month.twoDigits}-${day.twoDigits}-$year";

  /// Formats as `YYYY-MM-DD HH:mm:ss`. Example: `'2024-02-14 13:30:00'`
  String get toFullDateTime =>
      "$toIsoDate ${hour.twoDigits}:${minute.twoDigits}:${second.twoDigits}";

  /// Formats as e.g. `'Wednesday, 14 Feb 2024'`.
  String get toReadableFormat => "$weekdayName, $day $monthShortName $year";

  // ============================
  // 📅 DATE CALCULATIONS
  // ============================

  /// Builds a date with the same UTC/local flag as this one. Out-of-range
  /// fields (e.g. day 0 or month 13) are normalised by [DateTime].
  DateTime _build(int year,
      [int month = 1,
      int day = 1,
      int hour = 0,
      int minute = 0,
      int second = 0,
      int millisecond = 0,
      int microsecond = 0]) {
    return isUtc
        ? DateTime.utc(
            year, month, day, hour, minute, second, millisecond, microsecond)
        : DateTime(
            year, month, day, hour, minute, second, millisecond, microsecond);
  }

  /// Returns the date at [year]/[month]/[day] keeping this time of day.
  DateTime _withDate(int year, int month, int day) =>
      _build(year, month, day, hour, minute, second, millisecond, microsecond);

  /// Midnight (00:00:00.000) of this day.
  DateTime get startOfDay => _build(year, month, day);

  /// The last millisecond (23:59:59.999) of this day.
  DateTime get endOfDay => _build(year, month, day, 23, 59, 59, 999);

  /// Midnight of the first day of this month.
  DateTime get startOfMonth => _build(year, month, 1);

  /// 23:59:59.999 on the last day of this month.
  DateTime get endOfMonth => _build(year, month + 1, 0, 23, 59, 59, 999);

  /// Midnight on 1 January of this year.
  DateTime get startOfYear => _build(year, 1, 1);

  /// 23:59:59.999 on 31 December of this year.
  DateTime get endOfYear => _build(year, 12, 31, 23, 59, 59, 999);

  /// Adds [days] calendar days, keeping the time of day.
  ///
  /// Example: `DateTime(2024, 2, 28).addDays(2) // 2024-03-01`
  DateTime addDays(int days) => _withDate(year, month, day + days);

  /// Subtracts [days] calendar days, keeping the time of day.
  ///
  /// Example: `DateTime(2024, 3, 1).subtractDays(1) // 2024-02-29`
  DateTime subtractDays(int days) => addDays(-days);

  /// Adds [months] calendar months, keeping the time of day.
  ///
  /// If the day does not exist in the target month it is clamped to that
  /// month's last day. [months] may be negative.
  ///
  /// Example: `DateTime(2024, 1, 31).addMonths(1) // 2024-02-29`
  DateTime addMonths(int months) {
    final target = DateTime.utc(year, month + months, 1);
    final lastDay = DateTime.utc(target.year, target.month + 1, 0).day;
    return _withDate(target.year, target.month, day > lastDay ? lastDay : day);
  }

  /// Subtracts [months] calendar months; see [addMonths].
  ///
  /// Example: `DateTime(2024, 3, 31).subtractMonths(1) // 2024-02-29`
  DateTime subtractMonths(int months) => addMonths(-months);

  /// Adds [years], keeping the time of day. 29 February becomes 28 February
  /// in non-leap years.
  ///
  /// Example: `DateTime(2024, 2, 29).addYears(1) // 2025-02-28`
  DateTime addYears(int years) => addMonths(years * 12);

  /// Subtracts [years]; see [addYears].
  DateTime subtractYears(int years) => addYears(-years);

  /// Quarter of the year (1-4).
  int get quarter => ((month - 1) ~/ 3) + 1;

  // ============================
  // 📅 WEEK & WEEKDAY HELPERS
  // ============================

  /// Returns true if this date is today (local calendar).
  bool get isToday => isSameDate(DateTime.now());

  /// Returns true on Saturday or Sunday.
  bool get isWeekend =>
      weekday == DateTime.saturday || weekday == DateTime.sunday;

  /// Returns true Monday to Friday.
  bool get isWeekday => !isWeekend;

  /// The next Monday strictly after this date (a Monday returns the
  /// following week's Monday), keeping the time of day.
  ///
  /// Example: `DateTime(2025, 4, 14).nextMonday // 2025-04-21` (a Monday)
  DateTime get nextMonday => addDays(8 - weekday);

  /// The most recent Monday strictly before this date (a Monday returns the
  /// previous week's Monday), keeping the time of day.
  ///
  /// Example: `DateTime(2025, 4, 14).previousMonday // 2025-04-07`
  DateTime get previousMonday =>
      addDays(weekday == DateTime.monday ? -7 : -(weekday - 1));

  /// Midnight on the Monday of this ISO week.
  ///
  /// Example: `DateTime(2025, 4, 16, 15).startOfWeek // 2025-04-14 00:00`
  DateTime get startOfWeek => _build(year, month, day - (weekday - 1));

  /// 23:59:59.999 on the Sunday of this ISO week.
  ///
  /// Example: `DateTime(2025, 4, 16).endOfWeek // 2025-04-20 23:59:59.999`
  DateTime get endOfWeek =>
      _build(year, month, day + (7 - weekday), 23, 59, 59, 999);

  // ============================
  // 🔄 CONVERSIONS & PARSING
  // ============================

  /// Same as [toUtc].
  DateTime get toUtcDate => toUtc();

  /// Same as [toLocal].
  DateTime get toLocalDate => toLocal();

  /// Same as [millisecondsSinceEpoch].
  int get toEpochMilliseconds => millisecondsSinceEpoch;

  /// Whole seconds since the Unix epoch.
  int get secondsSinceEpoch => millisecondsSinceEpoch ~/ 1000;

  /// Creates a local [DateTime] from milliseconds since the epoch.
  static DateTime fromEpochMilliseconds(int milliseconds) =>
      DateTime.fromMillisecondsSinceEpoch(milliseconds);

  /// Creates a local [DateTime] from seconds since the epoch.
  static DateTime fromEpochSeconds(int seconds) =>
      DateTime.fromMillisecondsSinceEpoch(seconds * 1000);

  // ============================
  // ⏳ DATE DIFFERENCE HELPERS
  // ============================

  /// Absolute number of whole 24-hour periods between this and [other].
  int daysBetween(DateTime other) => other.difference(this).inDays.abs();

  /// Absolute number of whole hours between this and [other].
  int hoursBetween(DateTime other) => other.difference(this).inHours.abs();

  /// Absolute number of whole minutes between this and [other].
  int minutesBetween(DateTime other) => other.difference(this).inMinutes.abs();

  /// Absolute number of whole seconds between this and [other].
  int secondsBetween(DateTime other) => other.difference(this).inSeconds.abs();

  // ============================
  // 🏷️ DATE REPRESENTATIONS
  // ============================

  /// Full English month name, e.g. `'January'`.
  String get monthName => _months[month - 1];

  /// Short English month name, e.g. `'Jan'`.
  String get monthShortName => _monthsShort[month - 1];

  /// Full English weekday name, e.g. `'Monday'`.
  String get weekdayName => _weekdays[weekday - 1];

  /// Short English weekday name, e.g. `'Mon'`.
  String get weekdayShortName => _weekdaysShort[weekday - 1];

  /// Returns true if this year is a leap year.
  bool get isLeapYear =>
      (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);

  /// Number of days in this month.
  int get daysInMonth => DateTime.utc(year, month + 1, 0).day;

  /// ISO-8601 week number (1-53). Weeks start on Monday and week 1 is the
  /// week containing the year's first Thursday, so dates near the new year
  /// can belong to the previous or next year's weeks.
  ///
  /// Example: `DateTime(2021, 1, 1).weekOfYear // 53`,
  /// `DateTime(2024, 12, 30).weekOfYear // 1`
  int get weekOfYear {
    // The Thursday of this ISO week decides which year the week belongs to.
    final thursday = DateTime.utc(year, month, day + (4 - weekday));
    final dayOfYear =
        thursday.difference(DateTime.utc(thursday.year, 1, 1)).inDays;
    return dayOfYear ~/ 7 + 1;
  }

  // ============================
  // ⏳ HUMAN READABLE TIME
  // ============================

  /// Describes this date relative to [now] (defaults to `DateTime.now()`).
  ///
  /// Past dates read `'1 minute ago'`, `'3 days ago'`; future dates read
  /// `'in 2 hours'`; differences under a second are `'just now'`. Differences
  /// of 7 days or more fall back to [toIsoDate].
  String timeAgo({DateTime? now}) {
    final diff = (now ?? DateTime.now()).difference(this);
    final isFuture = diff.isNegative;
    final elapsed = diff.abs();

    String unit(int value, String name) =>
        '$value $name${value == 1 ? '' : 's'}';

    final String text;
    if (elapsed.inSeconds < 1) {
      return 'just now';
    } else if (elapsed.inSeconds < 60) {
      text = unit(elapsed.inSeconds, 'second');
    } else if (elapsed.inMinutes < 60) {
      text = unit(elapsed.inMinutes, 'minute');
    } else if (elapsed.inHours < 24) {
      text = unit(elapsed.inHours, 'hour');
    } else if (elapsed.inDays < 7) {
      text = unit(elapsed.inDays, 'day');
    } else {
      return toIsoDate;
    }
    return isFuture ? 'in $text' : '$text ago';
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

  /// Returns true if [other] falls on the same calendar day (ignores time).
  bool isSameDate(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// Returns true if this date is yesterday (local calendar).
  bool get isYesterday {
    final now = DateTime.now();
    return isSameDate(DateTime(now.year, now.month, now.day - 1));
  }

  /// Returns true if this date is tomorrow (local calendar).
  bool get isTomorrow {
    final now = DateTime.now();
    return isSameDate(DateTime(now.year, now.month, now.day + 1));
  }

  /// Difference in calendar months between this date and [other]
  /// (`other - this`), ignoring the day of month.
  ///
  /// Example: `DateTime(2024, 1, 31).monthsBetween(DateTime(2024, 2, 1)) // 1`
  int monthsBetween(DateTime other) {
    return (other.year - year) * 12 + (other.month - month);
  }

  /// Difference in calendar years between this date and [other]
  /// (`other - this`), ignoring month and day.
  int yearsBetween(DateTime other) {
    return other.year - year;
  }

  /// The same time one calendar week later.
  DateTime get nextWeek => addDays(7);

  /// The same time one calendar week earlier.
  DateTime get previousWeek => addDays(-7);

  /// Age in full years, treating this date as a birth date.
  int get age {
    final today = DateTime.now();
    int age = today.year - year;

    if (today.month < month || (today.month == month && today.day < day)) {
      age--; // Adjust if birthday hasn't occurred yet this year.
    }
    return age;
  }

  /// Formats the date using an `intl` [DateFormat] pattern.
  ///
  /// Example: `date.format('yyyy-MM-dd')`
  String format(String pattern) {
    return DateFormat(pattern).format(this);
  }
}
