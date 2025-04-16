import 'package:dart_tool_kit/src/list.extensions.dart';
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
  });
}
