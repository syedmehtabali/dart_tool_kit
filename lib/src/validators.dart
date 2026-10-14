/// A form-field validator: returns an error message, or `null` when valid.
///
/// Structurally identical to Flutter's `FormFieldValidator<String>`, so any
/// [Validator] can be passed straight to `TextFormField.validator`.
///
/// ```dart
/// TextFormField(validator: Validators.email());
/// ```
typedef Validator = String? Function(String? value);

/// Ready-made, composable [Validator]s for text input.
///
/// **Optional-field rule (main gotcha):** every validator except [required]
/// returns `null` (valid) for *blank* input — `null`, `''` or whitespace-only.
/// This lets the same validators be used on optional fields. To make a field
/// mandatory, combine with [required]:
///
/// ```dart
/// Validators.compose([Validators.required(), Validators.email()]);
/// ```
///
/// **Trimming:** [required] treats whitespace-only input as empty. Format
/// validators ([email], [numeric], [integer], [min], [max], [phone], [url])
/// check the trimmed value, so `' 42 '` is numeric. Length-, pattern- and
/// password-based validators ([minLength], [maxLength], [pattern],
/// [strongPassword], [match]) check the raw value, since spaces are
/// significant there.
///
/// Every validator accepts an optional custom error message; a sensible
/// English default is used otherwise.
abstract final class Validators {
  static bool _isBlank(String? value) => value == null || value.trim().isEmpty;

  static final RegExp _emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  static final RegExp _numericRegex = RegExp(r'^[+-]?(\d+(\.\d*)?|\.\d+)$');
  static final RegExp _integerRegex = RegExp(r'^[+-]?\d+$');
  static final RegExp _phoneRegex = RegExp(r'^\+?[\d\s\-()]+$');
  static final RegExp _urlRegex = RegExp(
    r'^(https?:\/\/)?(localhost|([a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?\.)+'
    r'[a-zA-Z]{2,})(:\d{1,5})?([\/?#][^\s]*)?$',
    caseSensitive: false,
  );
  static final RegExp _upperRegex = RegExp(r'[A-Z]');
  static final RegExp _lowerRegex = RegExp(r'[a-z]');
  static final RegExp _digitRegex = RegExp(r'\d');
  static final RegExp _specialRegex = RegExp(r'[^A-Za-z0-9\s]');

  static num? _parseNum(String value) {
    final trimmed = value.trim();
    return _numericRegex.hasMatch(trimmed) ? num.parse(trimmed) : null;
  }

  /// Fails when the value is `null`, empty or whitespace-only.
  ///
  /// Example: `Validators.required()('  ') // 'This field is required'`
  static Validator required([String? message]) =>
      (value) => _isBlank(value) ? (message ?? 'This field is required') : null;

  /// Fails when the trimmed value is not a valid email address.
  /// Blank input is valid.
  ///
  /// Example: `Validators.email()('a@b.co') // null`
  static Validator email([String? message]) => (value) {
        if (_isBlank(value)) return null;
        return _emailRegex.hasMatch(value!.trim())
            ? null
            : (message ?? 'Please enter a valid email address');
      };

  /// Fails when the value has fewer than [length] characters (untrimmed).
  /// Blank input is valid.
  ///
  /// Example: `Validators.minLength(3)('ab') // 'Must be at least 3 characters'`
  static Validator minLength(int length, [String? message]) => (value) {
        if (_isBlank(value)) return null;
        return value!.length < length
            ? (message ?? 'Must be at least $length characters')
            : null;
      };

  /// Fails when the value has more than [length] characters (untrimmed).
  /// Blank input is valid.
  ///
  /// Example: `Validators.maxLength(3)('abcd') // 'Must be at most 3 characters'`
  static Validator maxLength(int length, [String? message]) => (value) {
        if (_isBlank(value)) return null;
        return value!.length > length
            ? (message ?? 'Must be at most $length characters')
            : null;
      };

  /// Fails when [regex] has no match in the raw value. Anchor the pattern
  /// (`^...$`) to require a full match. Blank input is valid.
  ///
  /// Example: `Validators.pattern(RegExp(r'^[A-Z]+$'), 'Caps only')('abc') // 'Caps only'`
  static Validator pattern(RegExp regex, [String? message]) => (value) {
        if (_isBlank(value)) return null;
        return regex.hasMatch(value!) ? null : (message ?? 'Invalid format');
      };

  /// Fails unless the trimmed value is a plain decimal number such as `42`,
  /// `-3.5` or `.5` (no exponents, hex, `NaN` or `Infinity`).
  /// Blank input is valid.
  ///
  /// Example: `Validators.numeric()('12.5') // null`
  static Validator numeric([String? message]) => (value) {
        if (_isBlank(value)) return null;
        return _parseNum(value!) != null
            ? null
            : (message ?? 'Please enter a valid number');
      };

  /// Fails unless the trimmed value is a whole number such as `42` or `-7`.
  /// Blank input is valid.
  ///
  /// Example: `Validators.integer()('4.2') // 'Please enter a whole number'`
  static Validator integer([String? message]) => (value) {
        if (_isBlank(value)) return null;
        return _integerRegex.hasMatch(value!.trim())
            ? null
            : (message ?? 'Please enter a whole number');
      };

  /// Fails when the numeric value is less than [min]. Non-numeric input also
  /// fails (with the same message). Blank input is valid.
  ///
  /// Example: `Validators.min(18)('17') // 'Must be at least 18'`
  static Validator min(num min, [String? message]) => (value) {
        if (_isBlank(value)) return null;
        final number = _parseNum(value!);
        return number == null || number < min
            ? (message ?? 'Must be at least $min')
            : null;
      };

  /// Fails when the numeric value is greater than [max]. Non-numeric input
  /// also fails (with the same message). Blank input is valid.
  ///
  /// Example: `Validators.max(100)('101') // 'Must be at most 100'`
  static Validator max(num max, [String? message]) => (value) {
        if (_isBlank(value)) return null;
        final number = _parseNum(value!);
        return number == null || number > max
            ? (message ?? 'Must be at most $max')
            : null;
      };

  /// Lenient international phone check: digits, spaces, `-`, parentheses and
  /// an optional leading `+`, containing 7–15 digits. Blank input is valid.
  ///
  /// Example: `Validators.phone()('+1 (555) 123-4567') // null`
  static Validator phone([String? message]) => (value) {
        if (_isBlank(value)) return null;
        final trimmed = value!.trim();
        final digits = trimmed.replaceAll(RegExp(r'\D'), '').length;
        return _phoneRegex.hasMatch(trimmed) && digits >= 7 && digits <= 15
            ? null
            : (message ?? 'Please enter a valid phone number');
      };

  /// Fails unless the trimmed value is a web address with an optional
  /// `http://`/`https://` scheme, e.g. `example.com/path`. Blank input is valid.
  ///
  /// Example: `Validators.url()('https://dart.dev') // null`
  static Validator url([String? message]) => (value) {
        if (_isBlank(value)) return null;
        return _urlRegex.hasMatch(value!.trim())
            ? null
            : (message ?? 'Please enter a valid URL');
      };

  /// Fails unless the raw value meets every enabled password rule. A special
  /// character is anything that is not a letter, digit or whitespace.
  /// Blank input is valid. The default message lists the enabled rules.
  ///
  /// Example: `Validators.strongPassword(requireSpecial: false)('Abcdefg1') // null`
  static Validator strongPassword({
    int minLength = 8,
    bool requireUppercase = true,
    bool requireLowercase = true,
    bool requireDigit = true,
    bool requireSpecial = true,
    String? message,
  }) {
    final parts = <String>[
      if (requireUppercase) 'an uppercase letter',
      if (requireLowercase) 'a lowercase letter',
      if (requireDigit) 'a digit',
      if (requireSpecial) 'a special character',
    ];
    final defaultMessage = StringBuffer(
      'Password must be at least $minLength characters',
    );
    if (parts.isNotEmpty) {
      defaultMessage.write(' and include ');
      defaultMessage.write(
        parts.length == 1
            ? parts.first
            : '${parts.sublist(0, parts.length - 1).join(', ')} '
                'and ${parts.last}',
      );
    }
    final error = message ?? defaultMessage.toString();

    return (value) {
      if (_isBlank(value)) return null;
      final v = value!;
      final ok = v.length >= minLength &&
          (!requireUppercase || _upperRegex.hasMatch(v)) &&
          (!requireLowercase || _lowerRegex.hasMatch(v)) &&
          (!requireDigit || _digitRegex.hasMatch(v)) &&
          (!requireSpecial || _specialRegex.hasMatch(v));
      return ok ? null : error;
    };
  }

  /// Fails when the raw value differs from [other]'s current result. [other]
  /// is called at validation time, so it always sees the latest value — ideal
  /// for "confirm password". Blank input is valid.
  ///
  /// Example: `Validators.match(() => passwordCtrl.text)('secret')`
  static Validator match(String Function() other, [String? message]) =>
      (value) {
        if (_isBlank(value)) return null;
        return value == other() ? null : (message ?? 'Values do not match');
      };

  /// Runs [validators] in order and returns the first error, or `null` if all
  /// pass (an empty list always passes).
  ///
  /// Example: `Validators.compose([Validators.required(), Validators.email()])`
  static Validator compose(List<Validator> validators) {
    final list = List<Validator>.unmodifiable(validators);
    return (value) {
      for (final validator in list) {
        final error = validator(value);
        if (error != null) return error;
      }
      return null;
    };
  }
}
