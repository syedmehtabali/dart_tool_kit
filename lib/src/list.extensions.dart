/// Extensions on [List] for safe access and utilities.
extension ListExtensions<T> on List<T> {
  /// Returns the first element or `null` if the list is empty.
  ///
  /// Example: `<int>[].safeFirst // null`
  T? get safeFirst => isEmpty ? null : first;

  /// Returns the last element or `null` if the list is empty.
  ///
  /// Example: `[1, 2].safeLast // 2`
  T? get safeLast => isEmpty ? null : last;

  /// Returns true if the list has elements.
  ///
  /// Example: `[1].isNotNullOrEmpty // true`
  bool get isNotNullOrEmpty => isNotEmpty;

  /// Splits the list into chunks of [size]; the last chunk may be shorter.
  ///
  /// Throws an [ArgumentError] if [size] is not positive.
  ///
  /// Example: `[1, 2, 3].chunked(2) // [[1, 2], [3]]`
  List<List<T>> chunked(int size) {
    if (size <= 0) throw ArgumentError('Chunk size must be greater than 0.');
    final chunks = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      chunks.add(sublist(i, i + size > length ? length : i + size));
    }
    return chunks;
  }
}

/// Extensions on lists with nullable elements.
extension ListOfNullableExtensions<T extends Object> on List<T?> {
  /// Returns a new list with all `null` values removed, typed as non-nullable.
  ///
  /// Example: `[1, null, 3].withoutNulls() // <int>[1, 3]`
  List<T> withoutNulls() => [
        for (final element in this)
          if (element != null) element,
      ];
}
