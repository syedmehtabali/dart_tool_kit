// Import every extension file in the package together with the nullable
// extensions to prove that no member access is ambiguous.
// ignore_for_file: unused_import
import 'package:dart_tool_kit/dart_tool_kit.dart';
import 'package:flutter_test/flutter_test.dart';

/// Returns `null` typed as [T]? without triggering flow-analysis promotion.
T? nil<T>() => null;

/// Returns [value] typed as nullable.
T? some<T>(T value) => value;

void main() {
  group('NullableStringExtensions', () {
    test('isNullOrEmpty / isNotNullOrEmpty', () {
      expect(nil<String>().isNullOrEmpty, isTrue);
      expect(some('').isNullOrEmpty, isTrue);
      expect(some('  ').isNullOrEmpty, isFalse);
      expect(some('a').isNullOrEmpty, isFalse);
      expect(nil<String>().isNotNullOrEmpty, isFalse);
      expect(some('a').isNotNullOrEmpty, isTrue);
    });

    test('isNullOrBlank / isNotNullOrBlank', () {
      expect(nil<String>().isNullOrBlank, isTrue);
      expect(some('').isNullOrBlank, isTrue);
      expect(some(' \t\n').isNullOrBlank, isTrue);
      expect(some(' a ').isNullOrBlank, isFalse);
      expect(nil<String>().isNotNullOrBlank, isFalse);
      expect(some(' a ').isNotNullOrBlank, isTrue);
    });

    test('orEmpty', () {
      expect(nil<String>().orEmpty, '');
      expect(some('abc').orEmpty, 'abc');
    });
  });

  group('Nullable number orZero', () {
    test('int? -> int', () {
      final int a = nil<int>().orZero;
      final int b = some(5).orZero;
      expect(a, 0);
      expect(b, 5);
    });

    test('double? -> double', () {
      final double a = nil<double>().orZero;
      final double b = some(2.5).orZero;
      expect(a, 0.0);
      expect(a, isA<double>());
      expect(b, 2.5);
    });

    test('num? -> num', () {
      final num a = nil<num>().orZero;
      final num b = some<num>(3).orZero;
      expect(a, 0);
      expect(b, 3);
    });
  });

  group('NullableIterable/List/Set extensions', () {
    test('isNullOrEmpty / isNotNullOrEmpty', () {
      expect(nil<List<int>>().isNullOrEmpty, isTrue);
      expect(some(<int>[]).isNullOrEmpty, isTrue);
      expect(some([1]).isNullOrEmpty, isFalse);
      expect(nil<Set<int>>().isNotNullOrEmpty, isFalse);
      expect(some({1}).isNotNullOrEmpty, isTrue);
      expect(nil<Iterable<int>>().isNullOrEmpty, isTrue);
      expect(some<Iterable<int>>([1].map((e) => e)).isNotNullOrEmpty, isTrue);
    });

    test('orEmpty keeps precise types', () {
      final List<int> list = nil<List<int>>().orEmpty;
      final Set<int> set = nil<Set<int>>().orEmpty;
      final Iterable<int> iterable = nil<Iterable<int>>().orEmpty;
      expect(list, isEmpty);
      expect(set, isEmpty);
      expect(iterable, isEmpty);

      // The returned empty list is growable.
      list.add(1);
      expect(list, [1]);

      final original = [1, 2];
      expect(some(original).orEmpty, same(original));
    });
  });

  group('NullableMapExtensions', () {
    test('isNullOrEmpty / isNotNullOrEmpty / orEmpty', () {
      expect(nil<Map<String, int>>().isNullOrEmpty, isTrue);
      expect(some(<String, int>{}).isNullOrEmpty, isTrue);
      expect(some({'a': 1}).isNotNullOrEmpty, isTrue);
      final Map<String, int> map = nil<Map<String, int>>().orEmpty;
      expect(map, isEmpty);
      final original = {'a': 1};
      expect(some(original).orEmpty, same(original));
    });
  });

  group('NullableObjectExtensions.orElse', () {
    test('returns fallback only for null', () {
      final String name = nil<String>().orElse('guest');
      final int count = some(3).orElse(0);
      final DateTime date = nil<DateTime>().orElse(DateTime(2020));
      expect(name, 'guest');
      expect(count, 3);
      expect(date, DateTime(2020));
    });
  });

  group('No ambiguity with other package extensions', () {
    test('nullable receivers', () {
      final String? s = some('x');
      final int? i = some(1);
      final double? d = some(1.5);
      final num? n = some<num>(1);
      final List<int>? l = some([1]);
      final Set<int>? st = some({1});
      final Iterable<int>? it = some<Iterable<int>>([1]);
      final Map<String, int>? m = some({'a': 1});
      final bool? b = some(true);

      expect(s.isNullOrEmpty, isFalse);
      expect(s.isNotNullOrEmpty, isTrue);
      expect(s.isNullOrBlank, isFalse);
      expect(s.isNotNullOrBlank, isTrue);
      expect(s.orEmpty, 'x');
      expect(s.orElse('y'), 'x');
      expect(i.orZero, 1);
      expect(d.orZero, 1.5);
      expect(n.orZero, 1);
      expect(i.orElse(0), 1);
      expect(l.isNullOrEmpty, isFalse);
      expect(l.isNotNullOrEmpty, isTrue);
      expect(l.orEmpty, [1]);
      expect(st.isNullOrEmpty, isFalse);
      expect(st.isNotNullOrEmpty, isTrue);
      expect(st.orEmpty, {1});
      expect(it.isNullOrEmpty, isFalse);
      expect(it.isNotNullOrEmpty, isTrue);
      expect(it.orEmpty, [1]);
      expect(m.isNullOrEmpty, isFalse);
      expect(m.isNotNullOrEmpty, isTrue);
      expect(m.orEmpty, {'a': 1});
      expect(b.orElse(false), isTrue);
      expect(b.orFalse(), isTrue); // NullableBoolUtils still resolves.
    });

    test('non-nullable receivers', () {
      const String s = 'x';
      const int i = 1;
      const double d = 1.5;
      const num n = 1;
      final List<int> l = [1];
      final Set<int> st = {1};
      final Iterable<int> it = [1].map((e) => e);
      final Map<String, int> m = {'a': 1};
      final Map<String, Object?> json = {'a': 1};

      // NOTE: on a non-nullable String, `isNullOrEmpty` currently resolves to
      // the more specific `StringExtensions.isNullOrEmpty()` method in
      // string.extension.dart. Assigning to Object compiles whether it is that
      // method's tear-off or this package's getter, proving no ambiguity.
      final Object stringIsNullOrEmpty = s.isNullOrEmpty;
      expect(stringIsNullOrEmpty, isNotNull);
      expect(s.isNotNullOrEmpty, isTrue);
      expect(s.isNullOrBlank, isFalse);
      expect(s.isNotNullOrBlank, isTrue);
      expect(s.orEmpty, 'x');
      expect(i.orZero, 1);
      expect(d.orZero, 1.5);
      expect(n.orZero, 1);
      expect(l.isNullOrEmpty, isFalse);
      expect(l.isNotNullOrEmpty, isTrue); // ListExtensions wins.
      expect(l.orEmpty, [1]);
      expect(st.isNullOrEmpty, isFalse);
      expect(st.isNotNullOrEmpty, isTrue); // IterableExtensions wins.
      expect(st.orEmpty, {1});
      expect(it.isNullOrEmpty, isFalse);
      expect(it.isNotNullOrEmpty, isTrue); // IterableExtensions wins.
      expect(it.orEmpty, [1]);
      expect(m.isNullOrEmpty, isFalse);
      expect(m.isNotNullOrEmpty, isTrue);
      expect(m.orEmpty, {'a': 1});
      expect(json.isNotNullOrEmpty, isTrue);
      expect(json.orEmpty, {'a': 1});
    });
  });
}
