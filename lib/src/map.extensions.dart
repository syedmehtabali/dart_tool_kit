/// Extensions on [Map] for merging and transforming keys/values.
extension MapExtensions<K, V> on Map<K, V> {
  /// Returns a new map by merging [other] into the current map.
  Map<K, V> merge(Map<K, V> other) => {...this, ...other};

  /// Transforms all values using [transform] and returns a new map.
  Map<K, T> mapValues<T>(T Function(V value) transform) {
    return map((key, value) => MapEntry(key, transform(value)));
  }

  /// Transforms all keys using [transform] and returns a new map.
  Map<T, V> mapKeys<T>(T Function(K key) transform) {
    return map((key, value) => MapEntry(transform(key), value));
  }

  /// Returns a new map containing only the entries that satisfy [test].
  Map<K, V> filter(bool Function(K key, V value) test) {
    final filtered = <K, V>{};
    forEach((key, value) {
      if (test(key, value)) {
        filtered[key] = value;
      }
    });
    return filtered;
  }
}
