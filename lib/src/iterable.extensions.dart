/// Extensions on [Iterable] for grouping and summarizing.
///
/// For `firstWhereOrNull`, `firstOrNull`, `lastOrNull` and similar helpers use
/// `package:collection` (or the Dart SDK's `firstOrNull`), which this package
/// deliberately does not duplicate to avoid ambiguous extension errors.
extension IterableExtensions<T> on Iterable<T> {
  /// Returns true if the iterable has elements.
  ///
  /// Example: `[1].isNotNullOrEmpty // true`
  bool get isNotNullOrEmpty => isNotEmpty;

  /// Returns a map grouping items by [keySelector], preserving order.
  ///
  /// Example: `['ant', 'bat', 'ape'].groupBy((s) => s[0])
  /// // {'a': ['ant', 'ape'], 'b': ['bat']}`
  Map<K, List<T>> groupBy<K>(K Function(T element) keySelector) {
    final map = <K, List<T>>{};
    for (final element in this) {
      final key = keySelector(element);
      map.putIfAbsent(key, () => []).add(element);
    }
    return map;
  }

  /// Returns the sum of all numeric elements, or `0` if empty.
  ///
  /// Throws an [UnsupportedError] if any element is not a [num].
  ///
  /// Note: when `package:collection` is also imported, its more specific
  /// `sum` on `Iterable<num>`/`Iterable<int>`/`Iterable<double>` is used
  /// for statically typed numeric iterables.
  ///
  /// Example: `[1, 2, 3].sum // 6`
  num get sum {
    num total = 0;
    for (final element in this) {
      if (element is! num) {
        throw UnsupportedError('sum only works on Iterable<num>');
      }
      total += element;
    }
    return total;
  }

  /// Returns the average of all numeric elements, or `0.0` if empty.
  ///
  /// Throws an [UnsupportedError] if any element is not a [num].
  ///
  /// Note: when `package:collection` is also imported, its `average` is used
  /// for statically typed numeric iterables, and it throws a [StateError] on
  /// an empty iterable instead of returning `0.0`.
  ///
  /// Example: `[2, 4, 6].average // 4.0`
  double get average {
    if (isEmpty) return 0.0;
    return sum / length;
  }
}
