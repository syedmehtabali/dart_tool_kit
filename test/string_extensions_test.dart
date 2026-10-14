import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dart_tool_kit/dart_tool_kit.dart';
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

    group('case conversion', () {
      test('toSnakeCase handles spaces, separators, camel/Pascal, acronyms',
          () {
        expect('hello world'.toSnakeCase(), 'hello_world');
        expect('Hello World'.toSnakeCase(), 'hello_world');
        expect('hello-world'.toSnakeCase(), 'hello_world');
        expect('HelloWorld'.toSnakeCase(), 'hello_world');
        expect('  hello   __world--again  '.toSnakeCase(), 'hello_world_again');
        expect('HTTPRequest'.toSnakeCase(), 'http_request');
        expect('parseHTTPRequest'.toSnakeCase(), 'parse_http_request');
        expect('userID'.toSnakeCase(), 'user_id');
        expect('base64Encode'.toSnakeCase(), 'base64_encode');
        expect('already_snake'.toSnakeCase(), 'already_snake');
        expect('ÄpfelBirne'.toSnakeCase(), 'äpfel_birne');
        expect(''.toSnakeCase(), '');
        expect('  _- '.toSnakeCase(), '');
      });

      test('toKebabCase handles spaces, separators, camel/Pascal, acronyms',
          () {
        expect('hello world'.toKebabCase(), 'hello-world');
        expect('hello_world'.toKebabCase(), 'hello-world');
        expect('HelloWorld'.toKebabCase(), 'hello-world');
        expect('hello--world'.toKebabCase(), 'hello-world');
        expect('HTTPRequest'.toKebabCase(), 'http-request');
        expect(''.toKebabCase(), '');
      });

      test('toCamelCase edge cases', () {
        expect('hello world'.toCamelCase(), 'helloWorld');
        expect('Hello-World'.toCamelCase(), 'helloWorld');
        expect('helloWorld'.toCamelCase(), 'helloWorld');
        expect('HelloWorld'.toCamelCase(), 'helloWorld');
        expect('HTTPRequest'.toCamelCase(), 'httpRequest');
        expect('HELLO_WORLD'.toCamelCase(), 'helloWorld');
        expect(''.toCamelCase(), '');
        expect('___'.toCamelCase(), '');
      });

      test('toPascalCase edge cases', () {
        expect('hello world'.toPascalCase(), 'HelloWorld');
        expect('helloWorld'.toPascalCase(), 'HelloWorld');
        expect('parse_HTTP_request'.toPascalCase(), 'ParseHttpRequest');
        expect(''.toPascalCase(), '');
      });

      test('camelToWords handles acronyms and empty strings', () {
        expect('HTTPRequest'.camelToWords(), 'HTTP Request');
        expect('parseHTTPRequest'.camelToWords(), 'Parse HTTP Request');
        expect('HelloWorld'.camelToWords(), 'Hello World');
        expect('hello'.camelToWords(), 'Hello');
        expect(''.camelToWords(), '');
      });

      test('toTitleCase edge cases', () {
        expect(''.toTitleCase(), '');
        expect('hello NASA world'.toTitleCase(), 'Hello NASA World');
        expect('a  b'.toTitleCase(), 'A  B');
      });
    });

    test('isValidUrl accepts ports and queries', () {
      expect('https://example.com:8080/path'.isValidUrl(), true);
      expect('https://example.com?q=1'.isValidUrl(), true);
      expect('example.com/#top'.isValidUrl(), true);
      expect('https://exa mple.com'.isValidUrl(), false);
    });

    test('isNumeric rejects empty, signs and decimals', () {
      expect(''.isNumeric(), false);
      expect('-1'.isNumeric(), false);
      expect('1.5'.isNumeric(), false);
    });

    test('reverse keeps surrogate pairs intact', () {
      expect('abc😀'.reverse(), '😀cba');
      expect(''.reverse(), '');
      expect('a😀a'.isPalindrome(), true);
    });

    test('ellipsize edge cases', () {
      expect('Hello'.ellipsize(5), 'Hello');
      expect('Hello'.ellipsize(0), '...');
      expect(() => 'Hello'.ellipsize(-1), throwsArgumentError);
    });

    test('mask edge cases', () {
      expect('1234'.mask(), '1234');
      expect('12345'.mask(start: 0, end: 0, maskChar: '#'), '#####');
      expect(() => '12345'.mask(start: -1), throwsArgumentError);
      expect(() => '12345'.mask(end: -1), throwsArgumentError);
    });

    test('toBool trims and ignores case', () {
      expect(' TRUE '.toBool(), true);
      expect('True'.toBool(), true);
      expect(' 1 '.toBool(), true);
      expect('yes'.toBool(), false);
      expect(''.toBool(), false);
    });

    test('safeSubstring clamps out-of-range indices', () {
      expect('hello'.safeSubstring(2), 'llo');
      expect('hello'.safeSubstring(10), '');
      expect('hello'.safeSubstring(-3, 2), 'he');
      expect('hello'.safeSubstring(1, 99), 'ello');
      expect('hello'.safeSubstring(3, 1), '');
      expect(''.safeSubstring(0, 1), '');
    });

    test('countOccurrences edge cases', () {
      expect('hello'.countOccurrences(''), 0);
      expect('aaaa'.countOccurrences('aa'), 2);
      expect('a.b.c'.countOccurrences('.'), 2);
    });

    test('getInitials handles extra whitespace and emoji', () {
      expect('  john   doe '.getInitials(), 'JD');
      expect('john\tdoe'.getInitials(), 'JD');
      expect('😀 smile'.getInitials(), '😀S');
      expect(''.getInitials(), '');
      expect('   '.getInitials(), '');
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
