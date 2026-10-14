import 'package:dart_tool_kit/dart_tool_kit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DateTimeExtensions Tests', () {
    test('toIsoDate should return date in YYYY-MM-DD format', () {
      DateTime date = DateTime(2024, 2, 14);
      expect(date.toIsoDate, '2024-02-14');
    });

    test('toSlashFormat should return date in DD/MM/YYYY format', () {
      DateTime date = DateTime(2024, 2, 14);
      expect(date.toSlashFormat, '14/02/2024');
    });

    test('toDashedFormat should return date in MM-DD-YYYY format', () {
      DateTime date = DateTime(2024, 2, 14);
      expect(date.toDashedFormat, '02-14-2024');
    });

    test(
        'toFullDateTime should return full date and time in YYYY-MM-DD HH:mm:ss format',
        () {
      DateTime date = DateTime(2024, 2, 14, 13, 30);
      expect(date.toFullDateTime, '2024-02-14 13:30:00');
    });

    test(
        'toReadableFormat should return a readable date format like "Wednesday, 14 Feb 2024"',
        () {
      DateTime date = DateTime(2024, 2, 14);
      expect(date.toReadableFormat, 'Wednesday, 14 Feb 2024');
    });

    test('startOfDay should return start of day at 00:00:00', () {
      DateTime date = DateTime(2024, 2, 14, 13, 30);
      expect(date.startOfDay, DateTime(2024, 2, 14));
    });

    test('endOfDay should return end of day at 23:59:59', () {
      DateTime date = DateTime(2024, 2, 14, 13, 30);
      expect(date.endOfDay, DateTime(2024, 2, 14, 23, 59, 59, 999));
    });

    test('addDays should correctly add days to the date', () {
      DateTime date = DateTime(2024, 2, 14);
      expect(date.addDays(5), DateTime(2024, 2, 19));
    });

    test('subtractDays should correctly subtract days from the date', () {
      DateTime date = DateTime(2024, 2, 14);
      expect(date.subtractDays(5), DateTime(2024, 2, 9));
    });

    test('isToday should return true if the date is today', () {
      DateTime date = DateTime.now();
      expect(date.isToday, true);
    });

    test('isWeekend should return true if the date is a weekend', () {
      DateTime date = DateTime(2024, 2, 17); // Saturday
      expect(date.isWeekend, true);
      date = DateTime(2024, 2, 19); // Monday
      expect(date.isWeekend, false);
    });
    group('weekOfYear (ISO-8601)', () {
      test('mid-year dates', () {
        expect(DateTime(2025, 4, 16).weekOfYear, 16);
        expect(DateTime(2024, 2, 14).weekOfYear, 7);
      });

      test('year boundaries', () {
        expect(DateTime(2021, 1, 1).weekOfYear, 53);
        expect(DateTime(2021, 1, 3).weekOfYear, 53);
        expect(DateTime(2021, 1, 4).weekOfYear, 1);
        expect(DateTime(2024, 12, 30).weekOfYear, 1);
        expect(DateTime(2025, 1, 1).weekOfYear, 1);
        expect(DateTime(2020, 12, 31).weekOfYear, 53);
        expect(DateTime(2022, 1, 1).weekOfYear, 52);
        expect(DateTime(2026, 12, 31).weekOfYear, 53);
        expect(DateTime(2027, 1, 4).weekOfYear, 1);
      });

      test('ignores time of day and UTC flag', () {
        expect(DateTime(2024, 12, 29, 23, 59).weekOfYear, 52);
        expect(DateTime.utc(2024, 12, 30).weekOfYear, 1);
      });
    });

    group('Monday helpers', () {
      final monday = DateTime(2025, 4, 14, 9, 30);
      final wednesday = DateTime(2025, 4, 16, 9, 30);
      final sunday = DateTime(2025, 4, 20, 9, 30);

      test('nextMonday is strictly after and keeps the time', () {
        expect(monday.nextMonday, DateTime(2025, 4, 21, 9, 30));
        expect(wednesday.nextMonday, DateTime(2025, 4, 21, 9, 30));
        expect(sunday.nextMonday, DateTime(2025, 4, 21, 9, 30));
      });

      test('previousMonday is strictly before and keeps the time', () {
        expect(monday.previousMonday, DateTime(2025, 4, 7, 9, 30));
        expect(wednesday.previousMonday, DateTime(2025, 4, 14, 9, 30));
        expect(sunday.previousMonday, DateTime(2025, 4, 14, 9, 30));
      });

      test('crosses month and year boundaries', () {
        expect(DateTime(2024, 12, 30).nextMonday, DateTime(2025, 1, 6));
        expect(DateTime(2025, 1, 1).previousMonday, DateTime(2024, 12, 30));
      });
    });

    group('startOfWeek / endOfWeek', () {
      test('return Monday midnight and Sunday end-of-day', () {
        final date = DateTime(2025, 4, 16, 15, 45, 12, 345);
        expect(date.startOfWeek, DateTime(2025, 4, 14));
        expect(date.endOfWeek, DateTime(2025, 4, 20, 23, 59, 59, 999));
      });

      test('on Monday and Sunday themselves', () {
        expect(DateTime(2025, 4, 14, 8).startOfWeek, DateTime(2025, 4, 14));
        expect(DateTime(2025, 4, 20, 8).endOfWeek,
            DateTime(2025, 4, 20, 23, 59, 59, 999));
        expect(DateTime(2025, 4, 20, 8).startOfWeek, DateTime(2025, 4, 14));
      });

      test('across a year boundary and keep UTC', () {
        expect(DateTime.utc(2025, 1, 1, 12).startOfWeek,
            DateTime.utc(2024, 12, 30));
        expect(DateTime.utc(2024, 12, 30).endOfWeek,
            DateTime.utc(2025, 1, 5, 23, 59, 59, 999));
      });
    });

    group('addMonths / addYears', () {
      test('clamp to the last day of the target month', () {
        expect(DateTime(2024, 1, 31).addMonths(1), DateTime(2024, 2, 29));
        expect(DateTime(2023, 1, 31).addMonths(1), DateTime(2023, 2, 28));
        expect(DateTime(2024, 3, 31).addMonths(1), DateTime(2024, 4, 30));
        expect(DateTime(2024, 1, 15).addMonths(1), DateTime(2024, 2, 15));
      });

      test('handle year rollover in both directions', () {
        expect(DateTime(2024, 11, 30).addMonths(3), DateTime(2025, 2, 28));
        expect(DateTime(2024, 1, 15).addMonths(-1), DateTime(2023, 12, 15));
        expect(
            DateTime(2024, 1, 15).subtractMonths(13), DateTime(2022, 12, 15));
        expect(DateTime(2024, 3, 31).subtractMonths(1), DateTime(2024, 2, 29));
        expect(DateTime(2024, 5, 10).addMonths(24), DateTime(2026, 5, 10));
        expect(DateTime(2024, 5, 10).addMonths(0), DateTime(2024, 5, 10));
      });

      test('preserve time of day and UTC flag', () {
        expect(DateTime(2024, 1, 31, 13, 45, 10, 5, 7).addMonths(1),
            DateTime(2024, 2, 29, 13, 45, 10, 5, 7));
        final utc = DateTime.utc(2024, 1, 31, 8).addMonths(1);
        expect(utc.isUtc, true);
        expect(utc, DateTime.utc(2024, 2, 29, 8));
      });

      test('addYears clamps 29 February', () {
        expect(DateTime(2024, 2, 29).addYears(1), DateTime(2025, 2, 28));
        expect(DateTime(2024, 2, 29).addYears(4), DateTime(2028, 2, 29));
        expect(DateTime(2024, 2, 29, 6, 30).subtractYears(1),
            DateTime(2023, 2, 28, 6, 30));
        expect(DateTime(2024, 6, 1).addYears(-10), DateTime(2014, 6, 1));
      });
    });

    group('timeAgo', () {
      final now = DateTime(2025, 4, 16, 12);

      test('uses singular and plural units', () {
        expect(now.timeAgo(now: now), 'just now');
        expect(now.subtract(const Duration(seconds: 1)).timeAgo(now: now),
            '1 second ago');
        expect(now.subtract(const Duration(seconds: 30)).timeAgo(now: now),
            '30 seconds ago');
        expect(now.subtract(const Duration(minutes: 1)).timeAgo(now: now),
            '1 minute ago');
        expect(now.subtract(const Duration(minutes: 5)).timeAgo(now: now),
            '5 minutes ago');
        expect(now.subtract(const Duration(hours: 1)).timeAgo(now: now),
            '1 hour ago');
        expect(now.subtract(const Duration(days: 1)).timeAgo(now: now),
            '1 day ago');
        expect(now.subtract(const Duration(days: 6)).timeAgo(now: now),
            '6 days ago');
      });

      test('handles future dates', () {
        expect(now.add(const Duration(days: 3)).timeAgo(now: now), 'in 3 days');
        expect(now.add(const Duration(minutes: 1)).timeAgo(now: now),
            'in 1 minute');
        expect(
            now.add(const Duration(hours: 2)).timeAgo(now: now), 'in 2 hours');
      });

      test('falls back to the ISO date after a week', () {
        expect(DateTime(2025, 4, 1).timeAgo(now: now), '2025-04-01');
        expect(DateTime(2025, 5, 1).timeAgo(now: now), '2025-05-01');
      });

      test('defaults to DateTime.now()', () {
        expect(
            DateTime.now()
                .subtract(const Duration(minutes: 2, seconds: 5))
                .timeAgo(),
            '2 minutes ago');
      });
    });

    test('date builders keep the UTC flag', () {
      final utc = DateTime.utc(2024, 2, 14, 13, 30);
      expect(utc.startOfDay, DateTime.utc(2024, 2, 14));
      expect(utc.endOfMonth, DateTime.utc(2024, 2, 29, 23, 59, 59, 999));
      expect(utc.startOfYear.isUtc, true);
      expect(utc.addDays(1), DateTime.utc(2024, 2, 15, 13, 30));
    });

    test('addDays uses calendar days and keeps the time', () {
      expect(DateTime(2024, 2, 28, 10).addDays(2), DateTime(2024, 3, 1, 10));
      expect(
          DateTime(2024, 3, 1, 10).subtractDays(1), DateTime(2024, 2, 29, 10));
      expect(DateTime(2024, 12, 31).addDays(1), DateTime(2025, 1, 1));
    });

    test('nextWeek / previousWeek', () {
      expect(DateTime(2024, 12, 28, 7).nextWeek, DateTime(2025, 1, 4, 7));
      expect(DateTime(2025, 1, 4, 7).previousWeek, DateTime(2024, 12, 28, 7));
    });

    test('isYesterday / isTomorrow', () {
      final now = DateTime.now();
      expect(DateTime(now.year, now.month, now.day - 1, 23).isYesterday, true);
      expect(DateTime(now.year, now.month, now.day + 1).isTomorrow, true);
      expect(now.isYesterday, false);
      expect(now.isTomorrow, false);
    });

    test('month/quarter/leap helpers', () {
      expect(DateTime(2024, 2, 1).daysInMonth, 29);
      expect(DateTime(2023, 2, 1).daysInMonth, 28);
      expect(DateTime(2024, 12, 1).daysInMonth, 31);
      expect(DateTime(2024, 11, 1).quarter, 4);
      expect(DateTime(2000, 1, 1).isLeapYear, true);
      expect(DateTime(1900, 1, 1).isLeapYear, false);
      expect(DateTime(2024, 1, 1).monthName, 'January');
      expect(DateTime(2024, 1, 1).weekdayShortName, 'Mon');
    });

    test('toIsoDate pads years below 1000', () {
      expect(DateTime(987, 3, 4).toIsoDate, '0987-03-04');
    });
  });
}
