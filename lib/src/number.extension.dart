import 'dart:math';

import 'package:intl/intl.dart';

extension IntegerExtensions on int {
  String get twoDigits => this < 10 ? '0$this' : toString();

  // Basic Extensions
  bool get isEven => this % 2 == 0;
  bool get isOdd => this % 2 != 0;
  bool get isPositive => this > 0;
  bool get isNegative => this < 0;
  bool get isZero => this == 0;

  // Formatting & Display
  String toCurrency({String symbol = '\$', int decimalPlaces = 2}) =>
      '$symbol${toStringAsFixed(decimalPlaces)}';

  String toPercentage({int decimalPlaces = 2}) =>
      '${(this * 100).toStringAsFixed(decimalPlaces)}%';

  String toCompactString() => NumberFormat.compact().format(this);

  String toOrdinal() {
    if ((this % 100).abs() >= 11 && (this % 100).abs() <= 13) {
      return '${this}th';
    }
    switch (this % 10) {
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

  String toBinary() => toRadixString(2);
  String toHex() => toRadixString(16);
  String toOctal() => toRadixString(8);

  // Mathematical Operations
  int factorial() => this <= 1 ? 1 : this * (this - 1).factorial();
  int square() => this * this;
  int cube() => this * this * this;
  double sqrt() => sqrt();
  int pow(int exponent) => pow(exponent).toInt();
  int absValue() => abs();
  int roundToNearest(int value) => (this / value).round() * value;

  // Time-Related Extensions
  Duration get toMilliseconds => Duration(milliseconds: this);
  Duration get toSeconds => Duration(seconds: this);
  Duration get toMinutes => Duration(minutes: this);
  Duration get toHours => Duration(hours: this);
  Duration get toDays => Duration(days: this);
  Duration get toWeeks => Duration(days: this * 7);

  // Range & Iteration
  bool isBetween(int min, int max) => this >= min && this <= max;

  void times(Function action) {
    for (int i = 0; i < this; i++) {
      action();
    }
  }

  List<int> to(int end, {int step = 1}) {
    List<int> list = [];
    for (int i = this; i <= end; i += step) {
      list.add(i);
    }
    return list;
  }

  bool isDivisibleBy(int divisor) => this % divisor == 0;

  // Trigonometry & Logarithms
  double get toSin => sin(toDouble());
  double get toCos => cos(toDouble());
  double get toTan => tan(toDouble());
  double get toLog => log(toDouble());
  double get log10 => log(toDouble()) / ln10;
  double get toExp => exp(toDouble());

  // Random & Noise
  static int randomBetween(int min, int max) =>
      Random().nextInt(max - min + 1) + min;

  // Bitwise Operations
  bool get isPowerOfTwo => (this & (this - 1)) == 0 && this != 0;

  int get bitLength {
    if (this == 0) return 0;
    return (abs().toRadixString(2).length);
  }

  // Statistics & Probability
  double percentOf(int total) => (this / total) * 100;

  // Miscellaneous
  bool get isPerfectSquare {
    int sqrtInt = sqrt().toInt();
    return sqrtInt * sqrtInt == this;
  }

  String reverseDigits() => toString().split('').reversed.join();
}
