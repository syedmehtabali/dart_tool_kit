import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dart_tool_kit/src/date_extension.dart';
import 'package:dart_tool_kit/src/string.extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('StringExtensions Tests', () {
    test('camelToWords', () {
      expect('helloWorld'.camelToWords(), 'Hello World');
    });

    test('capitalize', () {
      expect('hello'.capitalize(), 'Hello');
    });

    test('toLower', () {
      expect('HELLO'.toLower(), 'hello');
    });

    test('toUpper', () {
      expect('hello'.toUpper(), 'HELLO');
    });

    test('isValidEmail', () {
      expect('test@example.com'.isValidEmail(), true);
      expect('invalid-email'.isValidEmail(), false);
    });

    test('isValidUrl', () {
      expect('https://example.com'.isValidUrl(), true);
      expect('invalid-url'.isValidUrl(), false);
    });

    test('isNumeric', () {
      expect('12345'.isNumeric(), true);
      expect('12a45'.isNumeric(), false);
    });

    test('isNullOrEmpty', () {
      expect('   '.isNullOrEmpty(), true);
      expect('hello'.isNullOrEmpty(), false);
    });

    test('ensureTrailingSlash', () {
      expect('example.com'.ensureTrailingSlash(), 'example.com/');
      expect('example.com/'.ensureTrailingSlash(), 'example.com/');
    });

    test('removeWhitespace', () {
      expect(' hello world '.removeWhitespace(), 'helloworld');
    });

    test('extractNumbers', () {
      expect('abc123xyz'.extractNumbers(), '123');
    });

    test('extractAlphabets', () {
      expect('abc123xyz'.extractAlphabets(), 'abcxyz');
    });

    test('toTitleCase', () {
      expect('hello world'.toTitleCase(), 'Hello World');
    });

    test('reverse', () {
      expect('hello'.reverse(), 'olleh');
    });

    test('ellipsize', () {
      expect('Hello World'.ellipsize(5), 'Hello...');
    });

    test('countVowels', () {
      expect('hello'.countVowels(), 2);
    });

    test('countConsonants', () {
      expect('hello'.countConsonants(), 3);
    });

    test('toInt', () {
      expect('123'.toInt(), 123);
      expect('abc'.toInt(), null);
    });

    test('toDouble', () {
      expect('123.45'.toDouble(), 123.45);
      expect('abc'.toDouble(), null);
    });

    test('trimSpaces', () {
      expect(' hello '.trimSpaces(), 'hello');
    });

    test('mask', () {
      expect('12345678'.mask(), '12****78');
    });

    test('replaceAllChars', () {
      expect('hello world'.replaceAllChars('o', '0'), 'hell0 w0rld');
    });

    test('toBool', () {
      expect('true'.toBool(), true);
      expect('1'.toBool(), true);
      expect('false'.toBool(), false);
    });

    test('safeSubstring', () {
      expect('hello'.safeSubstring(2, 4), 'll');
    });

    test('isAlphabetic', () {
      expect('hello'.isAlphabetic(), true);
      expect('hello123'.isAlphabetic(), false);
    });

    test('isPalindrome', () {
      expect('madam'.isPalindrome(), true);
      expect('hello'.isPalindrome(), false);
    });

    test('countOccurrences', () {
      expect('hello hello'.countOccurrences('hello'), 2);
    });

    test('getInitials', () {
      expect('John Doe'.getInitials(), 'JD');
    });

    test('wrapWith', () {
      expect('hello'.wrapWith('*'), '*hello*');
    });

    test('chunk', () {
      expect('hello world'.chunk(5), ['hello', ' worl', 'd']);
    });

    test('toSnakeCase', () {
      expect('helloWorld'.toSnakeCase(), 'hello_world');
    });

    test('toKebabCase', () {
      expect('helloWorld'.toKebabCase(), 'hello-world');
    });

    test('toCamelCase', () {
      expect('hello_world'.toCamelCase(), 'helloWorld');
    });

    test('toPascalCase', () {
      expect('hello_world'.toPascalCase(), 'HelloWorld');
    });

    test('toSHA256', () {
      expect(
          'hello'.toSHA256(), sha256.convert(utf8.encode('hello')).toString());
    });

    test('toMD5', () {
      expect('hello'.toMD5(), md5.convert(utf8.encode('hello')).toString());
    });

    test('secondsSinceEpoch returns correct value', () {
      final date = DateTime(2024, 3, 6, 12, 0, 0);
      expect(date.secondsSinceEpoch, date.millisecondsSinceEpoch ~/ 1000);
    });

    test('isSameDate returns true for same day', () {
      final date1 = DateTime(2024, 3, 6);
      final date2 = DateTime(2024, 3, 6, 23, 59, 59);
      expect(date1.isSameDate(date2), isTrue);
    });

    test('isSameDate returns false for different days', () {
      final date1 = DateTime(2024, 3, 6);
      final date2 = DateTime(2024, 3, 7);
      expect(date1.isSameDate(date2), isFalse);
    });

    test('isToday returns true for today’s date', () {
      final today = DateTime.now();
      expect(today.isToday, isTrue);
    });

    test('isToday returns false for a past date', () {
      final pastDate = DateTime.now().subtract(const Duration(days: 1));
      expect(pastDate.isToday, isFalse);
    });

    test('isYesterday returns true for yesterday’s date', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      expect(yesterday.isYesterday, isTrue);
    });

    test('isTomorrow returns true for tomorrow’s date', () {
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      expect(tomorrow.isTomorrow, isTrue);
    });

    test('startOfDay should return 00:00:00 of the same day', () {
      final date = DateTime(2024, 3, 6, 15, 30, 45);
      expect(date.startOfDay, DateTime(2024, 3, 6, 0, 0, 0));
    });

    test('endOfDay should return 23:59:59 of the same day', () {
      final date = DateTime(2024, 3, 6, 15, 30, 45);
      expect(date.endOfDay, DateTime(2024, 3, 6, 23, 59, 59, 999));
    });

    test('addDays should correctly add days', () {
      final date = DateTime(2024, 3, 6);
      expect(date.addDays(5), DateTime(2024, 3, 11));
    });

    test('subtractDays should correctly subtract days', () {
      final date = DateTime(2024, 3, 6);
      expect(date.subtractDays(5), DateTime(2024, 3, 1));
    });

    test('format should return correct date format', () {
      final date = DateTime(2024, 3, 6);
      expect(date.format('yyyy-MM-dd'), '2024-03-06');
    });

    test('format returns empty string for null pattern', () {
      final date = DateTime(2024, 3, 6);
      expect(date.format(''), '');
    });

    test('daysBetween should return correct difference', () {
      final date1 = DateTime(2024, 3, 1);
      final date2 = DateTime(2024, 3, 6);
      expect(date1.daysBetween(date2), 5);
    });

    test('monthsBetween should return correct difference', () {
      final date1 = DateTime(2023, 1, 1);
      final date2 = DateTime(2024, 1, 1);
      expect(date1.monthsBetween(date2), 12);
    });

    test('yearsBetween should return correct difference', () {
      final date1 = DateTime(2000, 1, 1);
      final date2 = DateTime(2024, 1, 1);
      expect(date1.yearsBetween(date2), 24);
    });

    test('weekOfYear should return correct week number', () {
      final date = DateTime(2024, 3, 6);
      expect(date.weekOfYear, greaterThan(0));
    });

    test('firstDayOfWeek should return correct Monday', () {
      final date = DateTime(2024, 3, 6); // Wednesday
      expect(date.firstDayOfWeek, DateTime(2024, 3, 4)); // Monday
    });

    test('lastDayOfWeek should return correct Sunday', () {
      final date = DateTime(2024, 3, 6); // Wednesday
      expect(date.lastDayOfWeek, DateTime(2024, 3, 10)); // Sunday
    });

    test('toIso8601 should return correct ISO string', () {
      final date = DateTime(2024, 3, 6, 15, 30, 45);
      expect(date.toIso8601String(), contains('2024-03-06T15:30:45'));
    });

    test('daysInMonth should return correct number of days', () {
      expect(DateTime(2024, 2, 1).daysInMonth, 29); // Leap year
      expect(DateTime(2023, 2, 1).daysInMonth, 28);
      expect(DateTime(2024, 4, 1).daysInMonth, 30);
    });

    test('nextWeek should return the correct next week date', () {
      final date = DateTime(2024, 3, 6);
      expect(date.nextWeek, DateTime(2024, 3, 13));
    });

    test('previousWeek should return the correct previous week date', () {
      final date = DateTime(2024, 3, 6);
      expect(date.previousWeek, DateTime(2024, 2, 28));
    });

    test('isLeapYear should return true for leap year', () {
      expect(DateTime(2024, 1, 1).isLeapYear, isTrue);
      expect(DateTime(2023, 1, 1).isLeapYear, isFalse);
    });

    test('quarter should return correct quarter', () {
      expect(DateTime(2024, 1, 1).quarter, 1);
      expect(DateTime(2024, 4, 1).quarter, 2);
      expect(DateTime(2024, 7, 1).quarter, 3);
      expect(DateTime(2024, 10, 1).quarter, 4);
    });

    test('age should return correct age', () {
      final birthdate = DateTime(2000, 3, 6);
      expect(birthdate.age, greaterThan(0));
    });
  });
}
