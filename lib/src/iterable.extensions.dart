/// Extensions on [Iterable] for grouping, summarizing, and safe access.
extension IterableExtensions<T> on Iterable<T> {
  /// Returns true if the iterable has elements.
  bool get isNotNullOrEmpty => isNotEmpty;

  /// Returns a map grouping items by [keySelector].
  Map<K, List<T>> groupBy<K>(K Function(T element) keySelector) {
    final map = <K, List<T>>{};
    for (final element in this) {
      final key = keySelector(element);
      map.putIfAbsent(key, () => []).add(element);
    }
    return map;
  }

  /// Returns the sum of all numeric elements.
  num get sum {
    if (isEmpty) return 0;
    if (first is! num) {
      throw UnsupportedError('sum only works on Iterable<num>');
    }
    return fold<num>(0, (prev, el) => prev + (el as num));
  }

  /// Returns the average of all numeric elements.
  double get average {
    if (isEmpty) return 0.0;
    return sum / length;
  }

  /// Returns the first element that satisfies [test] or `null`.
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final item in this) {
      if (test(item)) return item;
    }
    return null;
  }
}
