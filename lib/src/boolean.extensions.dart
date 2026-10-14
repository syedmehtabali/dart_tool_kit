/// Extensions on [bool] for conversion and conditional execution.
extension BoolUtils on bool {
  /// Returns the negated value. Example: `true.toggle() // false`
  bool toggle() => !this;

  /// Returns `1` for true and `0` for false. Example: `true.toInt() // 1`
  int toInt() => this ? 1 : 0;

  /// Returns `'Yes'` or `'No'`. Example: `true.toYesNo() // 'Yes'`
  String toYesNo() => this ? 'Yes' : 'No';

  /// Returns `'On'` or `'Off'`. Example: `false.toOnOff() // 'Off'`
  String toOnOff() => this ? 'On' : 'Off';

  /// Logical AND (both operands are always evaluated).
  bool and(bool other) => this && other;

  /// Logical OR (both operands are always evaluated).
  bool or(bool other) => this || other;

  /// Logical XOR. Example: `true.xor(false) // true`
  bool xor(bool other) => this != other;

  /// Returns true if the value is false.
  bool get isFalse => !this;

  /// Runs [action] only if the value is true.
  void whenTrue(void Function() action) {
    if (this) action();
  }

  /// Runs [action] only if the value is false.
  void whenFalse(void Function() action) {
    if (!this) action();
  }

  /// Runs [ifTrue] or [ifFalse] depending on the value.
  void when(
      {required void Function() ifTrue, required void Function() ifFalse}) {
    this ? ifTrue() : ifFalse();
  }

  /// Returns [trueValue] or [falseValue].
  ///
  /// Example: `true.toCustomString() // 'Enabled'`
  String toCustomString(
      {String trueValue = 'Enabled', String falseValue = 'Disabled'}) {
    return this ? trueValue : falseValue;
  }

  /// Returns [ifTrue] or [ifFalse]. Example: `true.choose(1, 2) // 1`
  T choose<T>(T ifTrue, T ifFalse) => this ? ifTrue : ifFalse;

  /// If the value is true, runs [action], reports how long it took to
  /// [onElapsed] (if given) and returns its result; otherwise returns `null`
  /// without running [action].
  ///
  /// Example:
  /// ```dart
  /// final result = kDebugMode.timeExecution(
  ///   () => expensiveWork(),
  ///   onElapsed: (d) => debugPrint('took $d'),
  /// );
  /// ```
  T? timeExecution<T>(
    T Function() action, {
    void Function(Duration elapsed)? onElapsed,
  }) {
    if (this) {
      final stopwatch = Stopwatch()..start();
      final result = action();
      stopwatch.stop();
      onElapsed?.call(stopwatch.elapsed);
      return result;
    }
    return null;
  }
}

/// Extensions on nullable [bool] values.
extension NullableBoolUtils on bool? {
  /// Returns true only if the value is `true`.
  bool get isTrue => this == true;

  /// Returns true only if the value is `false` (not `null`).
  bool get isFalse => this == false;

  /// Returns true if the value is `null` or `false`.
  bool get isNullOrFalse => this == null || this == false;

  /// Returns true if the value is `null` or `true`.
  bool get isNullOrTrue => this == null || this == true;

  /// Returns the value, or `false` if it is `null`.
  bool orFalse() => this ?? false;

  /// Returns the value, or `true` if it is `null`.
  bool orTrue() => this ?? true;
}
