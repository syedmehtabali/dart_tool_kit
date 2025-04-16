import 'package:dart_tool_kit/src/map.extensions.dart';
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
  });
}
