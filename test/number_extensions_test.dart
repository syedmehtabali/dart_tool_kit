import 'package:dart_tool_kit/dart_tool_kit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('IntegerExtensions Tests', () {
    test('isPositive should return true for positive numbers', () {
      int value = 2;
      expect(value.isPositive, true);
      value = -1;
      expect(value.isPositive, false);
    });

    test('toCurrency should format the number as currency with \$ symbol', () {
      final result = 1000.toCurrency(symbol: '\$', decimalDigits: 0);
      expect(result, equals('\$1,000'));
    });

    test('toCurrency should format the number as currency with € symbol', () {
      final result = 1000.toCurrency(symbol: '€', decimalDigits: 0);
      expect(result, equals('€1,000'));
    });

    test('toCurrency should format the number as currency with ₹ symbol', () {
      final result = 1000.toCurrency(symbol: '₹', decimalDigits: 0);
      expect(result, equals('₹1,000'));
    });

    test('toCurrency should format the number with decimals', () {
      final result = 1000.toCurrency(symbol: '\$', decimalDigits: 2);
      expect(result, equals('\$1,000.00'));
    });

    test('toBinary should convert number to binary format', () {
      int value = 10;
      expect(value.toBinary(), '1010');
    });

    test('toHex should convert number to hexadecimal format', () {
      int value = 255;
      expect(value.toHex(), 'ff');
    });

    test('toOctal should convert number to octal format', () {
      int value = 8;
      expect(value.toOctal(), '10');
    });
    test('twoDigits pads and keeps the sign in front', () {
      expect(5.twoDigits, '05');
      expect(0.twoDigits, '00');
      expect(12.twoDigits, '12');
      expect(123.twoDigits, '123');
      expect((-5).twoDigits, '-05');
      expect((-12).twoDigits, '-12');
    });

    test('isZero', () {
      expect(0.isZero, true);
      expect(1.isZero, false);
    });

    test('toOrdinal handles teens, large and negative numbers', () {
      expect(1.toOrdinal(), '1st');
      expect(2.toOrdinal(), '2nd');
      expect(3.toOrdinal(), '3rd');
      expect(4.toOrdinal(), '4th');
      expect(0.toOrdinal(), '0th');
      expect(11.toOrdinal(), '11th');
      expect(12.toOrdinal(), '12th');
      expect(13.toOrdinal(), '13th');
      expect(21.toOrdinal(), '21st');
      expect(111.toOrdinal(), '111th');
      expect(122.toOrdinal(), '122nd');
      expect((-1).toOrdinal(), '-1st');
      expect((-2).toOrdinal(), '-2nd');
      expect((-11).toOrdinal(), '-11th');
    });

    test('factorial', () {
      expect(0.factorial(), 1);
      expect(1.factorial(), 1);
      expect(5.factorial(), 120);
      expect(20.factorial(), 2432902008176640000);
      expect(() => (-1).factorial(), throwsArgumentError);
    });

    test('roundToNearest', () {
      expect(17.roundToNearest(5), 15);
      expect(18.roundToNearest(5), 20);
      expect(() => 17.roundToNearest(0), throwsArgumentError);
    });

    test('math helpers', () {
      expect(3.square(), 9);
      expect(3.cube(), 27);
      expect((-3).absValue(), 3);
      expect(16.sqrt(), 4.0);
      expect(2.pow(3), 8.0);
      expect(2.powInt(10), 1024);
      expect(100.log10, closeTo(2.0, 1e-12));
    });

    test('times runs the action n times, never for n <= 0', () {
      var count = 0;
      3.times(() => count++);
      expect(count, 3);
      0.times(() => count++);
      (-2).times(() => count++);
      expect(count, 3);
    });

    test('to builds inclusive ascending ranges', () {
      expect(1.to(5), [1, 2, 3, 4, 5]);
      expect(1.to(9, step: 3), [1, 4, 7]);
      expect(5.to(1), isEmpty);
      expect((-2).to(1), [-2, -1, 0, 1]);
      expect(() => 1.to(5, step: 0), throwsArgumentError);
      expect(() => 1.to(5, step: -1), throwsArgumentError);
    });

    test('isBetween and isDivisibleBy', () {
      expect(5.isBetween(1, 5), true);
      expect(6.isBetween(1, 5), false);
      expect(10.isDivisibleBy(5), true);
      expect(10.isDivisibleBy(3), false);
    });

    test('isPowerOfTwo', () {
      expect(1.isPowerOfTwo, true);
      expect(8.isPowerOfTwo, true);
      expect(6.isPowerOfTwo, false);
      expect(0.isPowerOfTwo, false);
      expect((-8).isPowerOfTwo, false);
    });

    test('percentOf', () {
      expect(25.percentOf(200), 12.5);
      expect(0.percentOf(5), 0.0);
      expect((-1).percentOf(4), -25.0);
      expect(() => 5.percentOf(0), throwsArgumentError);
    });

    test('reverseDigits keeps the sign in front', () {
      expect(123.reverseDigits(), '321');
      expect(0.reverseDigits(), '0');
      expect((-123).reverseDigits(), '-321');
      expect((-120).reverseDigits(), '-021');
    });

    test('randomBetween stays within bounds', () {
      for (var i = 0; i < 50; i++) {
        expect(IntegerExtensions.randomBetween(1, 3), inInclusiveRange(1, 3));
      }
    });

    test('duration getters', () {
      expect(2.toWeeks, const Duration(days: 14));
      expect(90.toSeconds, const Duration(minutes: 1, seconds: 30));
    });
  });
}
