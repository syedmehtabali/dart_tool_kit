import 'dart:convert';

import 'package:crypto/crypto.dart';
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
  });
}
