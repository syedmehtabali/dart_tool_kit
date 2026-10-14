import 'package:dart_tool_kit/dart_tool_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BoolFlutterExtensions', () {
    test('toColor() returns the matching default or custom color', () {
      expect(true.toColor(), Colors.green);
      expect(false.toColor(), Colors.red);
      expect(true.toColor(trueColor: Colors.blue), Colors.blue);
      expect(false.toColor(falseColor: Colors.grey), Colors.grey);
    });

    test('toStatusColor() returns success or error color', () {
      expect(true.toStatusColor(), Colors.green);
      expect(false.toStatusColor(), Colors.red);
      expect(false.toStatusColor(errorColor: Colors.orange), Colors.orange);
    });

    test('toIcon() returns the matching icon', () {
      expect(true.toIcon(), Icons.check);
      expect(false.toIcon(), Icons.close);
      expect(true.toIcon(trueIcon: Icons.done), Icons.done);
    });
  });
}
