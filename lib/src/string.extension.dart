import 'dart:convert';

import 'package:crypto/crypto.dart';

extension StringExtensions on String {
  /// Converts camelCase or PascalCase to a readable sentence.
  String camelToWords() {
    return replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) {
      return '${match.group(1)} ${match.group(2)}';
    }).capitalize();
  }

  /// Capitalizes the first letter of a string.
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  /// Converts a string to lowercase.
  String toLower() => toLowerCase();

  /// Converts a string to uppercase.
  String toUpper() => toUpperCase();

  /// Checks if the string is a valid email.
  bool isValidEmail() {
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return regex.hasMatch(this);
  }

  /// Checks if the string is a valid URL.
  bool isValidUrl() {
    final regex = RegExp(
      r'^(https?:\/\/)?([a-zA-Z0-9.-]+)\.([a-zA-Z]{2,})(\/[^\s]*)?$',
    );
    return regex.hasMatch(this);
  }

  /// Checks if the string contains only numbers.
  bool isNumeric() => RegExp(r'^\d+$').hasMatch(this);

  /// Checks if the string is empty or contains only whitespace.
  bool isNullOrEmpty() => trim().isEmpty;

  /// Ensures a string has a trailing slash.
  String ensureTrailingSlash() => endsWith('/') ? this : '$this/';

  /// Removes all whitespace from a string.
  String removeWhitespace() => replaceAll(RegExp(r'\s+'), '');

  /// Extracts numbers from a string.
  String extractNumbers() {
    return replaceAll(RegExp(r'[^0-9]'), '');
  }

  /// Extracts alphabets from a string.
  String extractAlphabets() {
    return replaceAll(RegExp(r'[^a-zA-Z]'), '');
  }

  /// Converts a string to title case.
  String toTitleCase() {
    return split(' ')
        .map((word) => word.isNotEmpty ? word.capitalize() : word)
        .join(' ');
  }

  /// Returns the reversed string.
  String reverse() => split('').reversed.join();

  /// Shortens the string with an ellipsis if it's too long.
  String ellipsize(int maxLength, {String ellipsis = '...'}) {
    return length > maxLength ? substring(0, maxLength) + ellipsis : this;
  }

  /// Counts vowels in the string.
  int countVowels() {
    return RegExp(r'[aeiouAEIOU]').allMatches(this).length;
  }

  /// Counts consonants in the string.
  int countConsonants() {
    return RegExp(r'[bcdfghjklmnpqrstvwxyzBCDFGHJKLMNPQRSTVWXYZ]')
        .allMatches(this)
        .length;
  }

  /// Converts a string into an integer, returns null if not possible.
  int? toInt() => int.tryParse(this);

  /// Converts a string into a double, returns null if not possible.
  double? toDouble() => double.tryParse(this);

  /// Removes leading and trailing spaces.
  String trimSpaces() => trim();

  /// Masks part of the string with a given character (useful for hiding passwords).
  String mask({int start = 2, int end = 2, String maskChar = '*'}) {
    if (length <= start + end) {
      return this; // Return the original string if masking isn't possible
    }

    int maskLength =
        length - start - end; // Calculate the number of masked characters
    return substring(0, start) +
        maskChar * maskLength + // Correct number of masked characters
        substring(length - end);
  }

  /// Replaces all instances of a given character with another.
  String replaceAllChars(String from, String to) => replaceAll(from, to);

  /// Converts a string to a boolean.
  bool toBool() {
    return toLowerCase() == 'true' || this == '1';
  }

  /// Returns a substring safely (without errors if out of bounds).
  String safeSubstring(int start, [int? end]) {
    if (start >= length) return '';
    return substring(start, end ?? length);
  }

  /// Checks if the string contains only alphabetic characters.
  bool isAlphabetic() => RegExp(r'^[a-zA-Z]+$').hasMatch(this);

  /// Checks if the string is a palindrome.
  bool isPalindrome() => this == reverse();

  /// Counts occurrences of a character or substring in the string.
  int countOccurrences(String sub) {
    return RegExp(RegExp.escape(sub)).allMatches(this).length;
  }

  /// Extracts initials from a name.
  String getInitials() {
    return split(' ')
        .where((word) => word.isNotEmpty)
        .map((word) => word[0].toUpperCase())
        .join();
  }

  /// Wraps the string with given characters.
  String wrapWith(String wrapper) => '$wrapper$this$wrapper';

  /// Splits a string into chunks of a given size.
  List<String> chunk(int size) {
    if (size <= 0) throw ArgumentError('Size must be greater than 0');
    List<String> chunks = [];
    for (int i = 0; i < length; i += size) {
      chunks.add(substring(i, (i + size) > length ? length : (i + size)));
    }
    return chunks;
  }

  /// Converts the string to snake_case.
  String toSnakeCase() {
    return replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) {
      return '${match.group(1)}_${match.group(2)}';
    }).toLowerCase();
  }

  /// Converts the string to kebab-case.
  String toKebabCase() {
    return replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (match) {
      return '${match.group(1)}-${match.group(2)}';
    }).toLowerCase();
  }

  /// Converts the string to camelCase.
  String toCamelCase() {
    List<String> words = split(RegExp(r'[\s_\-]+')).map((word) {
      return word.toLowerCase().capitalize();
    }).toList();
    return words.first.toLowerCase() + words.skip(1).join();
  }

  /// Converts the string to PascalCase.
  String toPascalCase() {
    return split(RegExp(r'[\s_\-]+'))
        .map((word) => word.toLowerCase().capitalize())
        .join();
  }

  /// Converts the string to a secure hash (SHA-256).
  String toSHA256() {
    var bytes = utf8.encode(this);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Converts the string to a secure hash (MD5).
  String toMD5() {
    var bytes = utf8.encode(this);
    var digest = md5.convert(bytes);
    return digest.toString();
  }
}
