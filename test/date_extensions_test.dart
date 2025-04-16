import 'package:dart_tool_kit/src/date_extension.dart';
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
  });
}
