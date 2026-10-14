import 'package:dart_tool_kit/dart_tool_kit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('IterableExtensions', () {
    test('isNotNullOrEmpty returns correct value', () {
      expect([1].isNotNullOrEmpty, true);
      expect(<int>[].isNotNullOrEmpty, false);
    });

    test('groupBy groups elements correctly', () {
      final list = ['apple', 'ant', 'bat', 'ball'];
      final grouped = list.groupBy((s) => s[0]);
      expect(grouped, {
        'a': ['apple', 'ant'],
        'b': ['bat', 'ball']
      });
    });

    test('sum returns correct result', () {
      expect([1, 2, 3].sum, 6);
    });

    test('sum throws if not numeric', () {
      expect(() => ['a', 'b'].sum, throwsUnsupportedError);
    });

    test('average returns correct value', () {
      expect([2, 4, 6].average, 4.0);
      expect(<int>[].average, 0.0);
    });
    test('sum handles empty, negative, double and mixed num values', () {
      expect(<int>[].sum, 0);
      expect([-1, -2, 3].sum, 0);
      expect([1.5, 2.5].sum, 4.0);
      expect(<num>[1, 2.5].sum, 3.5);
      expect({1, 2, 3}.sum, 6);
    });

    test('sum throws UnsupportedError if any element is not numeric', () {
      expect(() => <Object>[1, 'a'].sum, throwsUnsupportedError);
      expect(() => <Object?>[1, null].sum, throwsUnsupportedError);
    });

    test('average works on non-list iterables and negatives', () {
      expect([1, 2].average, 1.5);
      expect([-2, -4].average, -3.0);
      expect([1, 2, 3].where((e) => e > 1).average, 2.5);
    });

    test('groupBy on empty iterable returns empty map', () {
      expect(<String>[].groupBy((s) => s.length), isEmpty);
    });
  });
}
