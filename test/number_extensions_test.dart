import 'package:dart_tool_kit/src/number.extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('IntegerExtensions Tests', () {
    test('isEven should return true for even numbers', () {
      int value = 2;
      expect(value.isEven, true);
      value = 3;
      expect(value.isEven, false);
    });

    test('isOdd should return true for odd numbers', () {
      int value = 2;
      expect(value.isOdd, false);
      value = 3;
      expect(value.isOdd, true);
    });

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
  });
}
