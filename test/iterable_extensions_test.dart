import 'package:dart_tool_kit/src/iterable.extensions.dart';
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

    test('firstWhereOrNull returns matching element or null', () {
      expect([1, 2, 3].firstWhereOrNull((e) => e > 1), 2);
      expect([1, 2, 3].firstWhereOrNull((e) => e > 5), isNull);
    });
  });
}
