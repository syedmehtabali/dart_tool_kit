/// Extensions on [Map] for merging and transforming keys/values.
extension MapExtensions<K, V> on Map<K, V> {
  /// Returns a new map by merging [other] into the current map; values in
  /// [other] win on key conflicts.
  ///
  /// Example: `{'a': 1}.merge({'a': 2, 'b': 3}) // {'a': 2, 'b': 3}`
  Map<K, V> merge(Map<K, V> other) => {...this, ...other};

  /// Transforms all values using [transform] and returns a new map.
  ///
  /// Example: `{'a': 2}.mapValues((v) => v * 2) // {'a': 4}`
  Map<K, T> mapValues<T>(T Function(V value) transform) {
    return map((key, value) => MapEntry(key, transform(value)));
  }

  /// Transforms all keys using [transform] and returns a new map.
  ///
  /// If two keys map to the same new key, the later entry wins.
  ///
  /// Example: `{'a': 1}.mapKeys((k) => k.toUpperCase()) // {'A': 1}`
  Map<T, V> mapKeys<T>(T Function(K key) transform) {
    return map((key, value) => MapEntry(transform(key), value));
  }

  /// Returns a new map containing only the entries that satisfy [test].
  ///
  /// Example: `{'a': 1, 'b': 2}.filter((k, v) => v.isEven) // {'b': 2}`
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
