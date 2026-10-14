import 'package:dart_tool_kit/dart_tool_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HexColorStringExtensions', () {
    test('parses 6-digit hex with and without #', () {
      expect('#FF5733'.toColorOrNull(), const Color(0xFFFF5733));
      expect('ff5733'.toColorOrNull(), const Color(0xFFFF5733));
      expect('  #ff5733 '.toColorOrNull(), const Color(0xFFFF5733));
    });

    test('parses 3-digit shorthand', () {
      expect('#F53'.toColorOrNull(), const Color(0xFFFF5533));
      expect('000'.toColorOrNull(), const Color(0xFF000000));
    });

    test('parses 4- and 8-digit hex with leading alpha', () {
      expect('#80FF5733'.toColorOrNull(), const Color(0x80FF5733));
      expect('#8F53'.toColorOrNull(), const Color(0x88FF5533));
      expect('00000000'.toColorOrNull(), const Color(0x00000000));
    });

    test('returns null for invalid input', () {
      for (final input in [
        '',
        '#',
        '#12',
        '#12345',
        '#1234567',
        '#123456789',
        '#GGGGGG',
        '##FF5733',
        '0xFF5733',
        '-12345',
        'FF 573',
      ]) {
        expect(input.toColorOrNull(), isNull, reason: input);
      }
    });

    test('toColor() parses or throws FormatException', () {
      expect('#00FF00'.toColor(), const Color(0xFF00FF00));
      expect(() => 'nope'.toColor(), throwsFormatException);
    });
  });

  group('ColorExtensions.toHex', () {
    test('formats without alpha by default', () {
      expect(const Color(0xFFFF5733).toHex(), '#FF5733');
      expect(const Color(0x80000A0B).toHex(), '#000A0B');
    });

    test('includes alpha and omits hash when asked', () {
      expect(const Color(0x80FF5733).toHex(includeAlpha: true), '#80FF5733');
      expect(const Color(0x05000000).toHex(includeAlpha: true), '#05000000');
      expect(const Color(0xFFFF5733).toHex(leadingHash: false), 'FF5733');
    });

    test('round-trips through toColor()', () {
      const color = Color(0x12345678);
      expect(color.toHex(includeAlpha: true).toColor(), color);
    });
  });

  group('ColorExtensions darken/lighten', () {
    const base = Color(0xFF3366CC);

    double lightness(Color c) => HSLColor.fromColor(c).lightness;

    test('darken() decreases lightness and lighten() increases it', () {
      final l = lightness(base);
      expect(lightness(base.darken(0.2)), closeTo(l - 0.2, 0.01));
      expect(lightness(base.lighten(0.2)), closeTo(l + 0.2, 0.01));
      expect(lightness(base.darken()), closeTo(l - 0.1, 0.01));
    });

    test('clamps to black and white', () {
      expect(base.darken(1).toHex(), '#000000');
      expect(base.lighten(1).toHex(), '#FFFFFF');
    });

    test('amount 0 leaves the color unchanged (within rounding)', () {
      expect(base.darken(0).toHex(), base.toHex());
      expect(base.lighten(0).toHex(), base.toHex());
    });

    test('preserves alpha', () {
      const translucent = Color(0x803366CC);
      expect(translucent.darken(0.1).a, closeTo(translucent.a, 1e-9));
      expect(translucent.lighten(0.1).a, closeTo(translucent.a, 1e-9));
    });

    test('rejects out-of-range amounts', () {
      expect(() => base.darken(-0.1), throwsArgumentError);
      expect(() => base.lighten(1.1), throwsArgumentError);
      expect(() => base.darken(double.nan), throwsArgumentError);
    });
  });
}
