/// Safe, typed readers for decoded JSON maps.
///
/// Works on the `Map<String, dynamic>` returned by `jsonDecode` and on any
/// `Map<String, Object?>`. None of these members throw for a missing key or
/// a value of the wrong type. The `getX` readers return `null`, and the
/// `getXOr` readers return the fallback you pass in.
///
/// ```dart
/// final json = jsonDecode('{"age": "25", "active": 1}') as Map<String, dynamic>;
/// json.getInt('age');         // 25
/// json.getBoolOr('admin', false); // false
/// ```
extension JsonMapExtensions on Map<String, Object?> {
  // ---------------------------------------------------------------------------
  // String
  // ---------------------------------------------------------------------------

  /// Reads [key] as a [String]. A [num] or [bool] is converted with
  /// `toString()`. Any other type (map, list, missing) gives `null`.
  ///
  /// Example: `{'id': 42}.getString('id') // '42'`
  String? getString(String key) => _asString(this[key]);

  /// Like [getString], but returns [fallback] instead of `null`.
  ///
  /// Example: `json.getStringOr('name', 'Guest') // 'Guest'`
  String getStringOr(String key, String fallback) => getString(key) ?? fallback;

  // ---------------------------------------------------------------------------
  // Numbers
  // ---------------------------------------------------------------------------

  /// Reads [key] as an [int]. Accepts an `int`, a whole `double` (`25.0`)
  /// and a numeric string (`'25'`, `' 25 '`, `'25.0'`). A fractional value
  /// such as `25.5` or `'25.5'` gives `null`; it is not truncated.
  ///
  /// Example: `{'age': '25'}.getInt('age') // 25`
  int? getInt(String key) => _asInt(this[key]);

  /// Like [getInt], but returns [fallback] instead of `null`.
  ///
  /// Example: `{'age': 'n/a'}.getIntOr('age', 0) // 0`
  int getIntOr(String key, int fallback) => getInt(key) ?? fallback;

  /// Reads [key] as a [double]. Accepts an `int`, a `double` and a numeric
  /// string (`'9.99'`).
  ///
  /// Example: `{'price': 10}.getDouble('price') // 10.0`
  double? getDouble(String key) => _asDouble(this[key]);

  /// Like [getDouble], but returns [fallback] instead of `null`.
  ///
  /// Example: `json.getDoubleOr('price', 0.0) // 0.0`
  double getDoubleOr(String key, double fallback) => getDouble(key) ?? fallback;

  /// Reads [key] as a [num], keeping an `int` as `int` and a `double` as
  /// `double`. Numeric strings are parsed with [num.tryParse].
  ///
  /// Example: `{'n': '1.5'}.getNum('n') // 1.5`
  num? getNum(String key) => _asNum(this[key]);

  /// Like [getNum], but returns [fallback] instead of `null`.
  ///
  /// Example: `json.getNumOr('n', 0) // 0`
  num getNumOr(String key, num fallback) => getNum(key) ?? fallback;

  // ---------------------------------------------------------------------------
  // Bool
  // ---------------------------------------------------------------------------

  /// Reads [key] as a [bool]. Accepts `true`/`false`, the strings
  /// `'true'`/`'false'` (any case, surrounding spaces ignored), the numbers
  /// `1`/`0` and the strings `'1'`/`'0'`. Anything else gives `null`.
  ///
  /// Example: `{'active': 'TRUE'}.getBool('active') // true`
  bool? getBool(String key) => _asBool(this[key]);

  /// Like [getBool], but returns [fallback] instead of `null`.
  ///
  /// Example: `json.getBoolOr('active', false) // false`
  bool getBoolOr(String key, bool fallback) => getBool(key) ?? fallback;

  // ---------------------------------------------------------------------------
  // DateTime
  // ---------------------------------------------------------------------------

  /// Reads [key] as a [DateTime].
  ///
  /// - A string is parsed with [DateTime.tryParse], so it accepts ISO-8601
  ///   (`'2024-01-15'`, `'2024-01-15T10:30:00Z'`).
  /// - An `int` (or whole `double`) is taken as **milliseconds** since the
  ///   Unix epoch and returned as a **UTC** [DateTime]. Call `toLocal()` on
  ///   the result if you need local time. Epoch seconds are not detected; for
  ///   those, multiply [getInt] by 1000.
  ///
  /// Example: `{'at': 0}.getDateTime('at') // 1970-01-01 00:00:00.000Z`
  DateTime? getDateTime(String key) => _asDateTime(this[key]);

  /// Like [getDateTime], but returns [fallback] instead of `null`.
  ///
  /// Example: `json.getDateTimeOr('at', DateTime(2000)) // 2000-01-01`
  DateTime getDateTimeOr(String key, DateTime fallback) =>
      getDateTime(key) ?? fallback;

  // ---------------------------------------------------------------------------
  // Collections
  // ---------------------------------------------------------------------------

  /// Reads [key] as a `List<T>`, keeping only the elements that are a [T].
  /// Gives `null` if the value is not a list. Returns a new list.
  ///
  /// Example: `{'tags': ['a', 1, 'b']}.getList<String>('tags') // ['a', 'b']`
  List<T>? getList<T>(String key) {
    final value = this[key];
    return value is List ? value.whereType<T>().toList() : null;
  }

  /// Like [getList], but returns [fallback] instead of `null`.
  ///
  /// Example: `json.getListOr<String>('tags', const []) // []`
  List<T> getListOr<T>(String key, List<T> fallback) =>
      getList<T>(key) ?? fallback;

  /// Reads [key] as a `Map<String, dynamic>`. A map with non-string keys
  /// (for example `Map<dynamic, dynamic>`) is copied with every key turned
  /// into a string via `toString()`. Gives `null` if the value is not a map.
  ///
  /// Example: `{'user': {'id': 1}}.getMap('user')?.getInt('id') // 1`
  Map<String, dynamic>? getMap(String key) => _asStringKeyedMap(this[key]);

  /// Like [getMap], but returns [fallback] instead of `null`.
  ///
  /// Example: `json.getMapOr('user', const {}) // {}`
  Map<String, dynamic> getMapOr(String key, Map<String, dynamic> fallback) =>
      getMap(key) ?? fallback;

  // ---------------------------------------------------------------------------
  // Paths
  // ---------------------------------------------------------------------------

  /// Reads a nested value using a dot-separated [path]. A segment that is an
  /// integer indexes into a list (`'items.0.name'`). Gives `null` as soon as
  /// a segment is missing, out of range or the value cannot be walked into.
  /// Keys that contain a `.` cannot be reached this way.
  ///
  /// Example: `json.getPath('user.address.city') // 'Lahore'`
  dynamic getPath(String path) {
    Object? current = this;
    for (final segment in path.split('.')) {
      if (current is Map) {
        if (!current.containsKey(segment)) return null;
        current = current[segment];
      } else if (current is List) {
        final index = int.tryParse(segment);
        if (index == null || index < 0 || index >= current.length) {
          return null;
        }
        current = current[index];
      } else {
        return null;
      }
    }
    return current;
  }

  // ---------------------------------------------------------------------------
  // Transforming
  // ---------------------------------------------------------------------------

  /// Returns a new map without entries whose value is `null`.
  ///
  /// With [deep] set to `true`, nested maps are cleaned too, and `null`
  /// elements are removed from nested lists (recursively). Nested maps in the
  /// result are always `Map<String, dynamic>`. The original is not changed.
  ///
  /// Example: `{'a': 1, 'b': null}.removeNulls() // {'a': 1}`
  Map<String, dynamic> removeNulls({bool deep = false}) {
    final result = <String, dynamic>{};
    forEach((key, value) {
      if (value == null) return;
      result[key] = deep ? _removeNullsDeep(value) : value;
    });
    return result;
  }

  /// Builds a URL query string (without the leading `?`), encoding keys and
  /// values with [Uri.encodeQueryComponent].
  ///
  /// `null` values are skipped. A list value repeats the key once per
  /// non-null element (`tag=a&tag=b`). Every other value uses `toString()`.
  /// An empty map gives an empty string.
  ///
  /// Example: `{'q': 'a b', 'page': 2}.toQueryString() // 'q=a+b&page=2'`
  String toQueryString() {
    final parts = <String>[];
    void add(String key, Object value) => parts.add(
          '${Uri.encodeQueryComponent(key)}='
          '${Uri.encodeQueryComponent(value.toString())}',
        );
    forEach((key, value) {
      if (value == null) return;
      if (value is Iterable) {
        for (final element in value) {
          if (element != null) add(key, element);
        }
      } else {
        add(key, value);
      }
    });
    return parts.join('&');
  }
}

// -----------------------------------------------------------------------------
// Private converters
// -----------------------------------------------------------------------------

String? _asString(Object? value) {
  if (value is String) return value;
  if (value is num || value is bool) return value.toString();
  return null;
}

num? _asNum(Object? value) {
  if (value is num) return value;
  if (value is String) {
    final parsed = num.tryParse(value.trim());
    // Reject 'NaN' / 'Infinity', which JSON itself can never contain.
    return parsed != null && parsed.isFinite ? parsed : null;
  }
  return null;
}

int? _asInt(Object? value) {
  if (value is int) return value;
  final number = value is String ? _asNum(value) : value;
  if (number is int) return number;
  // Doubles beyond 2^53 are not exact integers (and `toInt` would clamp).
  if (number is double &&
      number.abs() <= 9007199254740992 &&
      number == number.truncateToDouble()) {
    return number.toInt();
  }
  return null;
}

double? _asDouble(Object? value) => _asNum(value)?.toDouble();

bool? _asBool(Object? value) {
  if (value is bool) return value;
  if (value is num) {
    if (value == 1) return true;
    if (value == 0) return false;
    return null;
  }
  if (value is String) {
    switch (value.trim().toLowerCase()) {
      case 'true':
      case '1':
        return true;
      case 'false':
      case '0':
        return false;
    }
  }
  return null;
}

DateTime? _asDateTime(Object? value) {
  if (value is String) return DateTime.tryParse(value.trim());
  if (value is num) {
    final millis = _asInt(value);
    // DateTime supports +/- 8.64e15 ms; anything outside would throw.
    if (millis == null || millis.abs() > 8640000000000000) return null;
    return DateTime.fromMillisecondsSinceEpoch(millis, isUtc: true);
  }
  return null;
}

Map<String, dynamic>? _asStringKeyedMap(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return value.map((key, v) => MapEntry(key.toString(), v));
  }
  return null;
}

Object? _removeNullsDeep(Object? value) {
  if (value is Map) {
    final result = <String, dynamic>{};
    value.forEach((key, v) {
      if (v != null) result[key.toString()] = _removeNullsDeep(v);
    });
    return result;
  }
  if (value is List) {
    return [
      for (final element in value)
        if (element != null) _removeNullsDeep(element),
    ];
  }
  return value;
}
