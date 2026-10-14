import 'package:dart_tool_kit/dart_tool_kit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ListExtensions', () {
    test('safeFirst returns first element or null', () {
      expect([1, 2, 3].safeFirst, 1);
      expect(<int>[].safeFirst, isNull);
    });

    test('safeLast returns last element or null', () {
      expect([1, 2, 3].safeLast, 3);
      expect(<int>[].safeLast, isNull);
    });

    test('isNotNullOrEmpty returns correct boolean', () {
      expect([1].isNotNullOrEmpty, true);
      expect(<int>[].isNotNullOrEmpty, false);
    });

    test('chunked returns correct chunks', () {
      expect([1, 2, 3, 4, 5].chunked(2), [
        [1, 2],
        [3, 4],
        [5]
      ]);
    });

    test('chunked throws on invalid size', () {
      expect(() => [1, 2].chunked(0), throwsArgumentError);
    });

    test('withoutNulls removes nulls', () {
      expect([1, null, 3].withoutNulls(), [1, 3]);
    });
    test('chunked edge cases', () {
      expect(<int>[].chunked(3), isEmpty);
      expect([1, 2].chunked(5), [
        [1, 2]
      ]);
      expect([1, 2, 3, 4].chunked(2), [
        [1, 2],
        [3, 4]
      ]);
      expect(() => [1].chunked(-1), throwsArgumentError);
    });

    test('withoutNulls returns a non-nullable list', () {
      final List<int> result = <int?>[null, 1, null, 2].withoutNulls();
      expect(result, [1, 2]);
      expect(<int?>[null].withoutNulls(), isEmpty);
      expect(<String>['a'].withoutNulls(), ['a']);
    });

    test('safeFirst / safeLast on nullable element lists', () {
      expect(<int?>[null, 1].safeFirst, isNull);
      expect(<int?>[null, 1].safeLast, 1);
    });
  });
}
