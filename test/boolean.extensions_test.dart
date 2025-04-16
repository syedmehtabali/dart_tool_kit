import 'package:dart_tool_kit/src/boolean.extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BoolUtils Tests', () {
    test('toggle() should flip the boolean value', () {
      bool value = true;
      expect(value.toggle(), false);
      value = false;
      expect(value.toggle(), true);
    });

    test('toInt() should convert boolean to 1 or 0', () {
      bool value = true;
      expect(value.toInt(), 1);
      value = false;
      expect(value.toInt(), 0);
    });

    test('toYesNo() should return "Yes" or "No"', () {
      bool value = true;
      expect(value.toYesNo(), 'Yes');
      value = false;
      expect(value.toYesNo(), 'No');
    });

    test('toOnOff() should return "On" or "Off"', () {
      bool value = true;
      expect(value.toOnOff(), 'On');
      value = false;
      expect(value.toOnOff(), 'Off');
    });

    test('and() should return the logical AND of two booleans', () {
      bool value = true;
      expect(value.and(true), true);
      expect(value.and(false), false);
    });

    test('or() should return the logical OR of two booleans', () {
      bool value = false;
      expect(value.or(true), true);
      expect(value.or(false), false);
    });

    test('xor() should return the logical XOR of two booleans', () {
      bool value = true;
      expect(value.xor(false), true);
      expect(value.xor(true), false);
    });

    test('isFalse should return the inverse of the boolean value', () {
      bool value = false;
      expect(value.isFalse, true);
      value = true;
      expect(value.isFalse, false);
    });

    test('whenTrue() should execute action if true', () {
      bool value = true;
      var actionExecuted = false;
      value.whenTrue(() => actionExecuted = true);
      expect(actionExecuted, true);
    });

    test('whenFalse() should execute action if false', () {
      bool value = false;
      var actionExecuted = false;
      value.whenFalse(() => actionExecuted = true);
      expect(actionExecuted, true);
    });

    test('when() should execute the correct action based on the boolean value',
        () {
      bool value = true;
      var trueActionExecuted = false;
      var falseActionExecuted = false;
      value.when(
        ifTrue: () => trueActionExecuted = true,
        ifFalse: () => falseActionExecuted = true,
      );
      expect(trueActionExecuted, true);
      expect(falseActionExecuted, false);

      value = false;
      trueActionExecuted = false;
      falseActionExecuted = false;
      value.when(
        ifTrue: () => trueActionExecuted = true,
        ifFalse: () => falseActionExecuted = true,
      );
      expect(trueActionExecuted, false);
      expect(falseActionExecuted, true);
    });

    test('toCustomString() should return custom strings based on boolean value',
        () {
      bool value = true;
      expect(value.toCustomString(trueValue: 'Active', falseValue: 'Inactive'),
          'Active');
      value = false;
      expect(value.toCustomString(trueValue: 'Active', falseValue: 'Inactive'),
          'Inactive');
    });

    test('choose() should return the correct value based on boolean', () {
      bool value = true;
      expect(value.choose('Success', 'Failure'), 'Success');
      value = false;
      expect(value.choose('Success', 'Failure'), 'Failure');
    });

    test('toColor() should return the correct color based on boolean value',
        () {
      bool value = true;
      expect(value.toColor(), Colors.green);
      value = false;
      expect(value.toColor(), Colors.red);
    });

    test(
        'toStatusColor() should return success or error color based on boolean',
        () {
      bool value = true;
      expect(value.toStatusColor(), Colors.green);
      value = false;
      expect(value.toStatusColor(), Colors.red);
    });

    test('toIcon() should return correct icon based on boolean', () {
      bool value = true;
      expect(value.toIcon(), Icons.check);
      value = false;
      expect(value.toIcon(), Icons.close);
    });

    test(
        'timeExecution() should return the result of the action and log execution time',
        () {
      bool value = true;
      int? result = value.timeExecution(() {
        return 42;
      });
      expect(result, 42);
    });
  });

  group('NullableBoolUtils Tests', () {
    test('isTrue should return true if the boolean is true', () {
      bool? value = true;
      expect(value.isTrue, true);
      value = false;
      expect(value.isTrue, false);
      value = null;
      expect(value.isTrue, false);
    });

    test('isFalse should return true if the boolean is false', () {
      bool? value = false;
      expect(value.isFalse, true);
      value = true;
      expect(value.isFalse, false);
      value = null;
      expect(value.isFalse, false);
    });

    test('isNullOrFalse should return true if the boolean is null or false',
        () {
      bool? value = false;
      expect(value.isNullOrFalse, true);
      value = null;
      expect(value.isNullOrFalse, true);
      value = true;
      expect(value.isNullOrFalse, false);
    });

    test('isNullOrTrue should return true if the boolean is null or true', () {
      bool? value = true;
      expect(value.isNullOrTrue, true);
      value = null;
      expect(value.isNullOrTrue, true);
      value = false;
      expect(value.isNullOrTrue, false);
    });

    test('orFalse should return false if null or false', () {
      bool? value;
      expect(value.orFalse(), false);
      value = false;
      expect(value.orFalse(), false);
      value = true;
      expect(value.orFalse(), true);
    });

    test('orTrue should return true if null or true', () {
      bool? value;
      expect(value.orTrue(), true);
      value = true;
      expect(value.orTrue(), true);
      value = false;
      expect(value.orTrue(), false);
    });
  });
}
