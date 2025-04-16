/// Extensions on [List] for safe access and utilities.
extension ListExtensions<T> on List<T> {
  /// Returns the first element or `null` if the list is empty.
  T? get safeFirst => isEmpty ? null : first;

  /// Returns the last element or `null` if the list is empty.
  T? get safeLast => isEmpty ? null : last;

  /// Returns true if the list has elements.
  bool get isNotNullOrEmpty => isNotEmpty;

  /// Splits the list into chunks of [size].
  List<List<T>> chunked(int size) {
    if (size <= 0) throw ArgumentError('Chunk size must be greater than 0.');
    final chunks = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      chunks.add(sublist(i, i + size > length ? length : i + size));
    }
    return chunks;
  }

  /// Returns a new list with all `null` values removed.
  List<T> withoutNulls() => where((element) => element != null).toList();
}
