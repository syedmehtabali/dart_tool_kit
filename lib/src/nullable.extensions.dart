/// Null-safety helpers for nullable values.
///
/// These extensions are declared on nullable types (`String?`, `int?`,
/// `List<T>?`, ...) so they work on both nullable and non-nullable receivers.
/// When a non-nullable extension in this package declares a member with the
/// same name (e.g. `ListExtensions.isNotNullOrEmpty`), Dart picks the more
/// specific non-nullable extension, so there is no ambiguity.
library;

/// Extensions on [String]? for null/empty/blank checks.
extension NullableStringExtensions on String? {
  /// Returns true if the string is `null` or empty.
  ///
  /// Example: `(null as String?).isNullOrEmpty // true`
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Returns true if the string is neither `null` nor empty.
  ///
  /// Example: `'a'.isNotNullOrEmpty // true`
  bool get isNotNullOrEmpty => !isNullOrEmpty;

  /// Returns true if the string is `null`, empty, or whitespace only.
  ///
  /// Example: `'   '.isNullOrBlank // true`
  bool get isNullOrBlank => this == null || this!.trim().isEmpty;

  /// Returns true if the string contains at least one non-whitespace character.
  ///
  /// Example: `' a '.isNotNullOrBlank // true`
  bool get isNotNullOrBlank => !isNullOrBlank;

  /// Returns the string, or `''` if it is `null`.
  ///
  /// Example: `(null as String?).orEmpty // ''`
  String get orEmpty => this ?? '';
}

/// Extensions on [int]? for defaulting to zero.
extension NullableIntExtensions on int? {
  /// Returns the value, or `0` if it is `null`.
  ///
  /// Example: `(null as int?).orZero // 0`
  int get orZero => this ?? 0;
}

/// Extensions on [double]? for defaulting to zero.
extension NullableDoubleExtensions on double? {
  /// Returns the value, or `0.0` if it is `null`.
  ///
  /// Example: `(null as double?).orZero // 0.0`
  double get orZero => this ?? 0.0;
}

/// Extensions on [num]? for defaulting to zero.
extension NullableNumExtensions on num? {
  /// Returns the value, or `0` if it is `null`.
  ///
  /// Example: `(null as num?).orZero // 0`
  num get orZero => this ?? 0;
}

/// Extensions on [Iterable]? for null/empty checks.
extension NullableIterableExtensions<T> on Iterable<T>? {
  /// Returns true if the iterable is `null` or has no elements.
  ///
  /// Example: `(null as Iterable<int>?).isNullOrEmpty // true`
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Returns true if the iterable is non-null and has elements.
  ///
  /// Example: `[1].isNotNullOrEmpty // true`
  bool get isNotNullOrEmpty => !isNullOrEmpty;

  /// Returns the iterable, or an empty iterable if it is `null`.
  ///
  /// Example: `(null as Iterable<int>?).orEmpty // ()`
  Iterable<T> get orEmpty => this ?? Iterable<T>.empty();
}

/// Extensions on [List]? for defaulting to an empty list.
extension NullableListExtensions<T> on List<T>? {
  /// Returns the list, or a new empty growable list if it is `null`.
  ///
  /// Example: `(null as List<int>?).orEmpty // []`
  List<T> get orEmpty => this ?? <T>[];
}

/// Extensions on [Set]? for defaulting to an empty set.
extension NullableSetExtensions<T> on Set<T>? {
  /// Returns the set, or a new empty set if it is `null`.
  ///
  /// Example: `(null as Set<int>?).orEmpty // {}`
  Set<T> get orEmpty => this ?? <T>{};
}

/// Extensions on [Map]? for null/empty checks.
extension NullableMapExtensions<K, V> on Map<K, V>? {
  /// Returns true if the map is `null` or has no entries.
  ///
  /// Example: `(null as Map<String, int>?).isNullOrEmpty // true`
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Returns true if the map is non-null and has entries.
  ///
  /// Example: `{'a': 1}.isNotNullOrEmpty // true`
  bool get isNotNullOrEmpty => !isNullOrEmpty;

  /// Returns the map, or a new empty map if it is `null`.
  ///
  /// Example: `(null as Map<String, int>?).orEmpty // {}`
  Map<K, V> get orEmpty => this ?? <K, V>{};
}

/// Generic fallback helper for any nullable value.
extension NullableObjectExtensions<T extends Object> on T? {
  /// Returns the value, or [fallback] if it is `null`.
  ///
  /// Example: `(null as String?).orElse('guest') // 'guest'`
  T orElse(T fallback) => this ?? fallback;
}
