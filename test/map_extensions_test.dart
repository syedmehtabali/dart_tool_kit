import 'package:dart_tool_kit/dart_tool_kit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MapExtensions', () {
    test('merge combines two maps', () {
      final a = {'a': 1, 'b': 2};
      final b = {'b': 3, 'c': 4};
      expect(a.merge(b), {'a': 1, 'b': 3, 'c': 4});
    });

    test('mapValues transforms values', () {
      final map = {'a': 2, 'b': 3};
      final result = map.mapValues((v) => v * 2);
      expect(result, {'a': 4, 'b': 6});
    });

    test('mapKeys transforms keys', () {
      final map = {'a': 1, 'b': 2};
      final result = map.mapKeys((k) => k.toUpperCase());
      expect(result, {'A': 1, 'B': 2});
    });

    test('filter returns only matching pairs', () {
      final map = {'a': 1, 'b': 2, 'c': 3};
      final result = map.filter((k, v) => v.isEven);
      expect(result, {'b': 2});
    });
    test('merge does not modify the originals', () {
      final a = {'a': 1};
      final b = {'b': 2};
      final merged = a.merge(b);
      merged['c'] = 3;
      expect(a, {'a': 1});
      expect(b, {'b': 2});
    });

    test('mapKeys keeps the last value on key collisions', () {
      final map = {'a': 1, 'A': 2};
      expect(map.mapKeys((k) => k.toLowerCase()), {'a': 2});
    });

    test('operations on empty maps', () {
      final empty = <String, int>{};
      expect(empty.merge({}), isEmpty);
      expect(empty.mapValues((v) => v), isEmpty);
      expect(empty.filter((k, v) => true), isEmpty);
    });
  });
}
