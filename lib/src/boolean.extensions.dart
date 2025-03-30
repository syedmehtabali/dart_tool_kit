import 'package:flutter/material.dart';

extension BoolUtils on bool {
  bool toggle() => !this;
  int toInt() => this ? 1 : 0;
  String toYesNo() => this ? 'Yes' : 'No';
  String toOnOff() => this ? 'On' : 'Off';

  bool and(bool other) => this && other;
  bool or(bool other) => this || other;
  bool xor(bool other) => this != other;
  bool get isFalse => !this;

  void whenTrue(void Function() action) {
    if (this) action();
  }

  void whenFalse(void Function() action) {
    if (!this) action();
  }

  void when(
      {required void Function() ifTrue, required void Function() ifFalse}) {
    this ? ifTrue() : ifFalse();
  }

  String toCustomString(
      {String trueValue = 'Enabled', String falseValue = 'Disabled'}) {
    return this ? trueValue : falseValue;
  }

  T choose<T>(T ifTrue, T ifFalse) => this ? ifTrue : ifFalse;

  Color toColor(
      {Color trueColor = Colors.green, Color falseColor = Colors.red}) {
    return this ? trueColor : falseColor;
  }

  Color toStatusColor(
      {Color successColor = Colors.green, Color errorColor = Colors.red}) {
    return this ? successColor : errorColor;
  }

  IconData toIcon(
      {IconData trueIcon = Icons.check, IconData falseIcon = Icons.close}) {
    return this ? trueIcon : falseIcon;
  }

  T? timeExecution<T>(T Function() action) {
    if (this) {
      final stopwatch = Stopwatch()..start();
      final result = action();
      stopwatch.stop();
      return result;
    }
    return null;
  }
}

extension NullableBoolUtils on bool? {
  bool get isTrue => this == true;
  bool get isFalse => this == false;
  bool get isNullOrFalse => this == null || this == false;
  bool get isNullOrTrue => this == null || this == true;

  bool orFalse() => this ?? false;
  bool orTrue() => this ?? true;
}
