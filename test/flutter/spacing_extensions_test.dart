import 'package:dart_tool_kit/dart_tool_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NumSpacingExtensions', () {
    test('verticalSpace and horizontalSpace build SizedBoxes', () {
      final v = 16.verticalSpace;
      expect(v.height, 16.0);
      expect(v.width, isNull);
      final h = 8.5.horizontalSpace;
      expect(h.width, 8.5);
      expect(h.height, isNull);
    });

    test('circularRadius builds a uniform BorderRadius', () {
      expect(12.circularRadius, BorderRadius.circular(12));
    });

    test('padding getters build EdgeInsets', () {
      expect(16.allPadding, const EdgeInsets.all(16));
      expect(24.horizontalPadding, const EdgeInsets.symmetric(horizontal: 24));
      expect(4.5.verticalPadding, const EdgeInsets.symmetric(vertical: 4.5));
    });
  });
}
