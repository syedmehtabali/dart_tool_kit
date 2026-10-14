import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Matches any run of characters that is not a letter or digit.
final RegExp _wordSeparator = RegExp(r'[^\p{L}\p{N}]+', unicode: true);

/// Matches a lower-case letter or digit followed by an upper-case letter
/// (`helloWorld` -> `hello|World`).
final RegExp _lowerUpperBoundary =
    RegExp(r'(?<=[\p{Ll}\p{N}])(?=\p{Lu})', unicode: true);

/// Matches the end of an acronym followed by a capitalised word
/// (`HTTPRequest` -> `HTTP|Request`).
final RegExp _acronymBoundary =
    RegExp(r'(?<=\p{Lu})(?=\p{Lu}\p{Ll})', unicode: true);

/// Extensions on [String] for formatting, validation and case conversion.
extension StringExtensions on String {
  /// Splits the string into words on whitespace, punctuation (`_`, `-`, ...)
  /// and camelCase / PascalCase / acronym boundaries.
  List<String> _words() {
    return replaceAll(_wordSeparator, ' ')
        .replaceAll(_lowerUpperBoundary, ' ')
        .replaceAll(_acronymBoundary, ' ')
        .split(' ')
        .where((word) => word.isNotEmpty)
        .toList();
  }

  /// Converts camelCase or PascalCase to a readable sentence by inserting
  /// spaces at case boundaries and capitalising the first letter.
  ///
  /// Example: `'parseHTTPRequest'.camelToWords() // 'Parse HTTP Request'`
  String camelToWords() {
    return replaceAll(_lowerUpperBoundary, ' ')
        .replaceAll(_acronymBoundary, ' ')
        .capitalize();
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

  /// Checks if the string is a valid URL (optional `http(s)://` scheme,
  /// a dotted host name, an optional port, then an optional path, query or
  /// fragment).
  ///
  /// Example: `'https://example.com:8080/a?b=1'.isValidUrl() // true`
  bool isValidUrl() {
    final regex = RegExp(
      r'^(https?:\/\/)?([a-zA-Z0-9.-]+)\.([a-zA-Z]{2,})(:\d{1,5})?([\/?#][^\s]*)?$',
    );
    return regex.hasMatch(this);
  }

  /// Checks if the string consists only of ASCII digits (`0-9`).
  ///
  /// Signs, decimal points and the empty string are rejected.
  ///
  /// Example: `'12345'.isNumeric() // true`, `'-1'.isNumeric() // false`
  bool isNumeric() => RegExp(r'^\d+$').hasMatch(this);

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

  /// Capitalises the first letter of every space-separated word.
  ///
  /// The rest of each word is left unchanged, so acronyms are preserved.
  ///
  /// Example: `'hello NASA world'.toTitleCase() // 'Hello NASA World'`
  String toTitleCase() {
    return split(' ')
        .map((word) => word.isNotEmpty ? word.capitalize() : word)
        .join(' ');
  }

  /// Returns the reversed string.
  ///
  /// Reverses by Unicode code point, so characters outside the Basic
  /// Multilingual Plane (e.g. emoji) are kept intact.
  ///
  /// Example: `'abc😀'.reverse() // '😀cba'`
  String reverse() => String.fromCharCodes(runes.toList().reversed);

  /// Shortens the string to [maxLength] UTF-16 code units and appends
  /// [ellipsis] if it is longer than [maxLength].
  ///
  /// Throws an [ArgumentError] if [maxLength] is negative.
  ///
  /// Example: `'Hello World'.ellipsize(5) // 'Hello...'`
  String ellipsize(int maxLength, {String ellipsis = '...'}) {
    if (maxLength < 0) {
      throw ArgumentError.value(maxLength, 'maxLength', 'Must not be negative');
    }
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

  /// Masks part of the string with a given character (useful for hiding
  /// passwords), keeping [start] characters at the front and [end] at the back.
  ///
  /// Returns the string unchanged if it is too short to mask. Throws an
  /// [ArgumentError] if [start] or [end] is negative.
  ///
  /// Example: `'12345678'.mask() // '12****78'`
  String mask({int start = 2, int end = 2, String maskChar = '*'}) {
    if (start < 0) {
      throw ArgumentError.value(start, 'start', 'Must not be negative');
    }
    if (end < 0) throw ArgumentError.value(end, 'end', 'Must not be negative');
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

  /// Converts a string to a boolean: `'true'` (any case) and `'1'` are
  /// `true`, everything else is `false`. Surrounding whitespace is ignored.
  ///
  /// Example: `' TRUE '.toBool() // true`
  bool toBool() {
    final value = trim().toLowerCase();
    return value == 'true' || value == '1';
  }

  /// Returns a substring without throwing for out-of-range indices.
  ///
  /// [start] and [end] are clamped to `0..length`, and an [end] before
  /// [start] yields an empty string.
  ///
  /// Example: `'hello'.safeSubstring(-3, 99) // 'hello'`
  String safeSubstring(int start, [int? end]) {
    final from = start.clamp(0, length);
    final to = (end ?? length).clamp(from, length);
    return substring(from, to);
  }

  /// Checks if the string contains only alphabetic characters.
  bool isAlphabetic() => RegExp(r'^[a-zA-Z]+$').hasMatch(this);

  /// Checks if the string is a palindrome.
  bool isPalindrome() => this == reverse();

  /// Counts non-overlapping occurrences of [sub] in the string.
  ///
  /// Returns 0 if [sub] is empty.
  ///
  /// Example: `'hello hello'.countOccurrences('hello') // 2`
  int countOccurrences(String sub) {
    if (sub.isEmpty) return 0;
    return sub.allMatches(this).length;
  }

  /// Extracts the upper-cased first character of each whitespace-separated
  /// word.
  ///
  /// Example: `'John  Doe'.getInitials() // 'JD'`
  String getInitials() {
    return trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .map((word) => String.fromCharCode(word.runes.first).toUpperCase())
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
  ///
  /// Words are split on whitespace, punctuation (`_`, `-`, ...) and
  /// camelCase / PascalCase / acronym boundaries; repeated separators collapse.
  ///
  /// Example: `'Hello World'.toSnakeCase() // 'hello_world'`,
  /// `'parseHTTPRequest'.toSnakeCase() // 'parse_http_request'`
  String toSnakeCase() => _words().map((w) => w.toLowerCase()).join('_');

  /// Converts the string to kebab-case.
  ///
  /// Uses the same word splitting as [toSnakeCase].
  ///
  /// Example: `'hello_world'.toKebabCase() // 'hello-world'`
  String toKebabCase() => _words().map((w) => w.toLowerCase()).join('-');

  /// Converts the string to camelCase.
  ///
  /// Uses the same word splitting as [toSnakeCase]. Returns `''` for a string
  /// without letters or digits.
  ///
  /// Example: `'hello_world'.toCamelCase() // 'helloWorld'`,
  /// `'HTTPRequest'.toCamelCase() // 'httpRequest'`
  String toCamelCase() {
    final words = _words();
    if (words.isEmpty) return '';
    return words.first.toLowerCase() +
        words.skip(1).map((w) => w.toLowerCase().capitalize()).join();
  }

  /// Converts the string to PascalCase.
  ///
  /// Uses the same word splitting as [toSnakeCase].
  ///
  /// Example: `'hello world'.toPascalCase() // 'HelloWorld'`
  String toPascalCase() =>
      _words().map((w) => w.toLowerCase().capitalize()).join();

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
