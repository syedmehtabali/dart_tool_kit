import 'dart:math' as math;

import 'package:intl/intl.dart';

/// Extensions on [int] for formatting, math, time and iteration helpers.
///
/// Note: parity and sign checks use the built-in [int.isEven], [int.isOdd]
/// and [int.isNegative].
extension IntegerExtensions on int {
  /// Pads the number to at least two digits, keeping the sign in front.
  ///
  /// Example: `5.twoDigits // '05'`, `(-5).twoDigits // '-05'`
  String get twoDigits {
    final digits = abs().toString().padLeft(2, '0');
    return this < 0 ? '-$digits' : digits;
  }

  /// Returns true if the number is greater than zero.
  bool get isPositive => this > 0;

  /// Returns true if the number is zero.
  bool get isZero => this == 0;

  // Formatting & Display

  /// Formats the number as currency.
  ///
  /// Example: `1000.toCurrency() // '\$1,000'`
  String toCurrency({String symbol = '\$', int decimalDigits = 0}) {
    final format =
        NumberFormat.currency(symbol: symbol, decimalDigits: decimalDigits);
    return format.format(this);
  }

  /// Treats the number as a ratio and formats it as a percentage.
  ///
  /// Example: `1.toPercentage() // '100.00%'`
  String toPercentage({int decimalPlaces = 2}) =>
      '${(this * 100).toStringAsFixed(decimalPlaces)}%';

  /// Formats the number in compact form.
  ///
  /// Example: `1200.toCompactString() // '1.2K'`
  String toCompactString() => NumberFormat.compact().format(this);

  /// Returns the number with its English ordinal suffix.
  ///
  /// Example: `1.toOrdinal() // '1st'`, `112.toOrdinal() // '112th'`,
  /// `(-2).toOrdinal() // '-2nd'`
  String toOrdinal() {
    final lastTwo = abs() % 100;
    if (lastTwo >= 11 && lastTwo <= 13) return '${this}th';
    switch (abs() % 10) {
      case 1:
        return '${this}st';
      case 2:
        return '${this}nd';
      case 3:
        return '${this}rd';
      default:
        return '${this}th';
    }
  }

  /// Returns the binary representation. Example: `10.toBinary() // '1010'`
  String toBinary() => toRadixString(2);

  /// Returns the hexadecimal representation. Example: `255.toHex() // 'ff'`
  String toHex() => toRadixString(16);

  /// Returns the octal representation. Example: `8.toOctal() // '10'`
  String toOctal() => toRadixString(8);

  // Mathematical Operations

  /// Returns `n!`.
  ///
  /// Throws an [ArgumentError] for negative numbers. Results above `20!`
  /// overflow a 64-bit integer.
  ///
  /// Example: `5.factorial() // 120`
  int factorial() {
    if (this < 0) {
      throw ArgumentError.value(
          this, 'this', 'Factorial is not defined for negative numbers');
    }
    var result = 1;
    for (var i = 2; i <= this; i++) {
      result *= i;
    }
    return result;
  }

  /// Returns the number squared. Example: `3.square() // 9`
  int square() => this * this;

  /// Returns the number cubed. Example: `3.cube() // 27`
  int cube() => this * this * this;

  /// Returns the absolute value. Example: `(-3).absValue() // 3`
  int absValue() => abs();

  /// Rounds to the nearest multiple of [value].
  ///
  /// Throws an [ArgumentError] if [value] is zero.
  ///
  /// Example: `17.roundToNearest(5) // 15`
  int roundToNearest(int value) {
    if (value == 0) throw ArgumentError.value(value, 'value', 'Must not be 0');
    return (this / value).round() * value;
  }

  /// Returns the square root. Example: `16.sqrt() // 4.0`
  double sqrt() => math.sqrt(toDouble());

  /// Raises the number to [exponent]. Example: `2.pow(3) // 8.0`
  double pow(num exponent) => math.pow(toDouble(), exponent).toDouble();

  /// Raises the number to the integer [exponent]. Example: `2.powInt(3) // 8`
  int powInt(int exponent) => math.pow(this, exponent).toInt();

  // Time-Related Extensions

  /// This many milliseconds as a [Duration].
  Duration get toMilliseconds => Duration(milliseconds: this);

  /// This many seconds as a [Duration].
  Duration get toSeconds => Duration(seconds: this);

  /// This many minutes as a [Duration].
  Duration get toMinutes => Duration(minutes: this);

  /// This many hours as a [Duration].
  Duration get toHours => Duration(hours: this);

  /// This many days as a [Duration].
  Duration get toDays => Duration(days: this);

  /// This many weeks as a [Duration].
  Duration get toWeeks => Duration(days: this * 7);

  // Range & Iteration

  /// Returns true if `min <= this <= max`. Example: `5.isBetween(1, 10)`
  bool isBetween(int min, int max) => this >= min && this <= max;

  /// Calls [action] this many times. Does nothing for zero or negatives.
  ///
  /// Example: `3.times(() => print('hi'))`
  void times(void Function() action) {
    for (int i = 0; i < this; i++) {
      action();
    }
  }

  /// Returns the ascending list `this, this + step, ...` up to and including
  /// [end]. Returns an empty list if [end] is less than this number.
  ///
  /// Throws an [ArgumentError] if [step] is not positive.
  ///
  /// Example: `1.to(9, step: 3) // [1, 4, 7]`
  List<int> to(int end, {int step = 1}) {
    if (step <= 0) {
      throw ArgumentError.value(step, 'step', 'Must be greater than 0');
    }
    final list = <int>[];
    for (int i = this; i <= end; i += step) {
      list.add(i);
    }
    return list;
  }

  /// Returns true if the number is a multiple of [divisor].
  ///
  /// Example: `10.isDivisibleBy(5) // true`
  bool isDivisibleBy(int divisor) => this % divisor == 0;

  // Trigonometry & Logarithms

  /// Sine of this number in radians.
  double get toSin => math.sin(toDouble());

  /// Cosine of this number in radians.
  double get toCos => math.cos(toDouble());

  /// Tangent of this number in radians.
  double get toTan => math.tan(toDouble());

  /// Natural logarithm.
  double get toLog => math.log(toDouble());

  /// Base-10 logarithm. Example: `100.log10 // 2.0`
  double get log10 => math.log(toDouble()) / math.ln10;

  /// `e` raised to this number.
  double get toExp => math.exp(toDouble());

  // Random & Noise

  /// Returns a random integer in `min..max` (inclusive).
  ///
  /// Example: `IntegerExtensions.randomBetween(1, 6)`
  static int randomBetween(int min, int max) =>
      math.Random().nextInt(max - min + 1) + min;

  // Bitwise Operations

  /// Returns true if the number is a positive power of two.
  ///
  /// Example: `8.isPowerOfTwo // true`
  bool get isPowerOfTwo => this > 0 && (this & (this - 1)) == 0;

  // Statistics & Probability

  /// Returns what percentage this number is of [total].
  ///
  /// Throws an [ArgumentError] if [total] is zero.
  ///
  /// Example: `25.percentOf(200) // 12.5`
  double percentOf(int total) {
    if (total == 0) throw ArgumentError.value(total, 'total', 'Must not be 0');
    return (this / total) * 100;
  }

  /// Reverses the decimal digits, keeping the sign in front.
  ///
  /// Example: `123.reverseDigits() // '321'`, `(-120).reverseDigits() // '-021'`
  String reverseDigits() {
    final digits = abs().toString().split('').reversed.join();
    return this < 0 ? '-$digits' : digits;
  }
}
