import 'package:flutter/painting.dart';

final RegExp _hexDigits = RegExp(r'^[0-9a-fA-F]+$');

/// Parses [input] as a hex color, returning `null` if it is not valid.
Color? _parseHexColor(String input) {
  var hex = input.trim();
  if (hex.startsWith('#')) hex = hex.substring(1);
  if (!_hexDigits.hasMatch(hex)) return null;
  switch (hex.length) {
    case 3: // RGB
    case 4: // ARGB
      hex = hex.split('').map((c) => '$c$c').join();
      if (hex.length == 6) hex = 'FF$hex';
    case 6: // RRGGBB
      hex = 'FF$hex';
    case 8: // AARRGGBB
      break;
    default:
      return null;
  }
  return Color(int.parse(hex, radix: 16));
}

/// Extensions on [String] for parsing hex color codes.
///
/// Accepted forms (the leading `#` is optional, case-insensitive,
/// surrounding whitespace is ignored):
/// `RGB`, `ARGB`, `RRGGBB` and `AARRGGBB`. Note that alpha comes **first**,
/// matching Flutter's `Color(0xAARRGGBB)` and [ColorExtensions.toHex], not
/// CSS's trailing-alpha `#RRGGBBAA`.
extension HexColorStringExtensions on String {
  /// Parses this string as a hex color, or returns `null` if it is invalid.
  ///
  /// Example: `'#FF5733'.toColorOrNull() // Color(0xFFFF5733)`
  Color? toColorOrNull() => _parseHexColor(this);

  /// Parses this string as a hex color.
  ///
  /// Throws a [FormatException] if it is not a valid hex color.
  ///
  /// Example: `'#F53'.toColor() // Color(0xFFFF5533)`
  Color toColor() {
    final color = _parseHexColor(this);
    if (color == null) {
      throw FormatException('Invalid hex color', this);
    }
    return color;
  }
}

/// Extensions on [Color] for hex conversion and shading.
extension ColorExtensions on Color {
  /// Returns the color as an uppercase hex string: `#RRGGBB`, or
  /// `#AARRGGBB` when [includeAlpha] is true.
  ///
  /// Components are converted with [toARGB32], i.e. as 8-bit values in the
  /// color's own color space. Set [leadingHash] to false to omit the `#`.
  ///
  /// Example: `const Color(0xFFFF5733).toHex() // '#FF5733'`
  String toHex({bool includeAlpha = false, bool leadingHash = true}) {
    final argb = toARGB32();
    final hex = includeAlpha
        ? argb.toRadixString(16).padLeft(8, '0')
        : (argb & 0xFFFFFF).toRadixString(16).padLeft(6, '0');
    return '${leadingHash ? '#' : ''}${hex.toUpperCase()}';
  }

  /// Returns a darker color by decreasing the HSL lightness by [amount]
  /// (0.0 to 1.0); the result is clamped to black. Alpha is preserved.
  ///
  /// Throws an [ArgumentError] if [amount] is outside 0.0 to 1.0.
  ///
  /// Example: `Colors.blue.darken(0.2)`
  Color darken([double amount = 0.1]) => _shiftLightness(-amount, amount);

  /// Returns a lighter color by increasing the HSL lightness by [amount]
  /// (0.0 to 1.0); the result is clamped to white. Alpha is preserved.
  ///
  /// Throws an [ArgumentError] if [amount] is outside 0.0 to 1.0.
  ///
  /// Example: `Colors.blue.lighten(0.2)`
  Color lighten([double amount = 0.1]) => _shiftLightness(amount, amount);

  Color _shiftLightness(double delta, double amount) {
    if (amount.isNaN || amount < 0 || amount > 1) {
      throw ArgumentError.value(
          amount, 'amount', 'Must be between 0.0 and 1.0');
    }
    final hsl = HSLColor.fromColor(this);
    return hsl.withLightness((hsl.lightness + delta).clamp(0.0, 1.0)).toColor();
  }
}
