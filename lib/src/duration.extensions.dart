/// Extensions on [Duration] for formatting (clocks, human-readable text)
/// and simple async helpers — useful for media players, countdowns and
/// OTP timers.
extension DurationExtensions on Duration {
  /// Formats the duration as a clock string, truncating sub-second parts.
  ///
  /// Hours are only shown when non-zero unless [alwaysShowHours] is `true`.
  /// Days are folded into hours, and negative durations get a leading `-`.
  ///
  /// Example: `Duration(hours: 1, minutes: 2, seconds: 5).toClock()` → `'01:02:05'`.
  String toClock({bool alwaysShowHours = false}) {
    final totalSeconds = inSeconds.abs();
    final hours = totalSeconds ~/ Duration.secondsPerHour;
    final minutes =
        (totalSeconds ~/ Duration.secondsPerMinute) % Duration.minutesPerHour;
    final seconds = totalSeconds % Duration.secondsPerMinute;

    final buffer = StringBuffer();
    if (totalSeconds > 0 && isNegative) buffer.write('-');
    if (hours > 0 || alwaysShowHours) {
      buffer
        ..write(_pad2(hours))
        ..write(':');
    }
    buffer
      ..write(_pad2(minutes))
      ..write(':')
      ..write(_pad2(seconds));
    return buffer.toString();
  }

  /// Formats the duration as human-readable text using days, hours, minutes
  /// and seconds (and milliseconds when [includeMilliseconds] is `true`).
  ///
  /// - [showZeroUnits]: also emit zero-valued units between the largest and
  ///   smallest non-zero unit (`'1h 0m 5s'` instead of `'1h 5s'`).
  /// - [maxUnits]: keep at most this many units, starting from the largest;
  ///   the remainder is truncated, not rounded.
  /// - [longForm]: use words with correct singular/plural (`'1 hour 2 minutes'`).
  /// - [separator]: placed between units.
  ///
  /// A zero (or entirely sub-unit) duration renders as `'0s'` / `'0 seconds'`
  /// (`'0ms'` / `'0 milliseconds'` with [includeMilliseconds]). Negative
  /// durations get a leading `-`.
  ///
  /// Example: `Duration(hours: 1, minutes: 2, seconds: 5).toReadable()` → `'1h 2m 5s'`.
  String toReadable({
    bool showZeroUnits = false,
    int? maxUnits,
    bool longForm = false,
    bool includeMilliseconds = false,
    String separator = ' ',
  }) {
    if (maxUnits != null && maxUnits < 1) {
      throw ArgumentError.value(maxUnits, 'maxUnits', 'Must be at least 1.');
    }

    final totalMs = inMilliseconds.abs();
    final values = <int>[
      totalMs ~/ Duration.millisecondsPerDay,
      (totalMs ~/ Duration.millisecondsPerHour) % Duration.hoursPerDay,
      (totalMs ~/ Duration.millisecondsPerMinute) % Duration.minutesPerHour,
      (totalMs ~/ Duration.millisecondsPerSecond) % Duration.secondsPerMinute,
      if (includeMilliseconds) totalMs % Duration.millisecondsPerSecond,
    ];

    final first = values.indexWhere((v) => v != 0);
    if (first == -1) {
      return _formatUnit(0, values.length - 1, longForm);
    }
    final last = values.lastIndexWhere((v) => v != 0);

    final parts = <String>[];
    for (var i = first; i <= last; i++) {
      if (values[i] == 0 && !showZeroUnits) continue;
      parts.add(_formatUnit(values[i], i, longForm));
      if (maxUnits != null && parts.length >= maxUnits) break;
    }

    final text = parts.join(separator);
    return isNegative ? '-$text' : text;
  }

  /// Returns a future that completes after this duration has elapsed.
  ///
  /// Example: `await 300.milliseconds.delay();`
  Future<void> delay() => Future<void>.delayed(this);

  /// The total duration in seconds, including the fractional part.
  ///
  /// Example: `Duration(milliseconds: 1500).inFractionalSeconds` → `1.5`.
  double get inFractionalSeconds =>
      inMicroseconds / Duration.microsecondsPerSecond;
}

/// Extensions on [num] (and therefore [int] and [double]) for creating
/// [Duration]s fluently, e.g. `2.seconds` or `1.5.hours`.
///
/// Fractional values are rounded to the nearest microsecond. Non-finite
/// values (`NaN`, infinity) throw an [UnsupportedError].
extension NumDurationExtensions on num {
  /// A [Duration] of this many milliseconds.
  ///
  /// Example: `250.milliseconds` → `Duration(milliseconds: 250)`.
  Duration get milliseconds => _toDuration(Duration.microsecondsPerMillisecond);

  /// A [Duration] of this many seconds.
  ///
  /// Example: `2.seconds` → `Duration(seconds: 2)`.
  Duration get seconds => _toDuration(Duration.microsecondsPerSecond);

  /// A [Duration] of this many minutes.
  ///
  /// Example: `0.5.minutes` → `Duration(seconds: 30)`.
  Duration get minutes => _toDuration(Duration.microsecondsPerMinute);

  /// A [Duration] of this many hours.
  ///
  /// Example: `1.5.hours` → `Duration(hours: 1, minutes: 30)`.
  Duration get hours => _toDuration(Duration.microsecondsPerHour);

  /// A [Duration] of this many days.
  ///
  /// Example: `3.days` → `Duration(days: 3)`.
  Duration get days => _toDuration(Duration.microsecondsPerDay);

  Duration _toDuration(int microsecondsPerUnit) {
    final self = this;
    if (self is int) {
      return Duration(microseconds: self * microsecondsPerUnit);
    }
    return Duration(microseconds: (self * microsecondsPerUnit).round());
  }
}

String _pad2(int value) => value.toString().padLeft(2, '0');

const _shortUnits = ['d', 'h', 'm', 's', 'ms'];
const _longUnits = ['day', 'hour', 'minute', 'second', 'millisecond'];

String _formatUnit(int value, int unitIndex, bool longForm) {
  if (!longForm) return '$value${_shortUnits[unitIndex]}';
  final name = _longUnits[unitIndex];
  return '$value ${value == 1 ? name : '${name}s'}';
}
