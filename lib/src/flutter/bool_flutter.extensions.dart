import 'package:flutter/material.dart';

/// Flutter-specific extensions on [bool] for mapping a flag to a color or icon.
extension BoolFlutterExtensions on bool {
  /// Returns [trueColor] or [falseColor].
  ///
  /// Example: `true.toColor() // Colors.green`
  Color toColor(
      {Color trueColor = Colors.green, Color falseColor = Colors.red}) {
    return this ? trueColor : falseColor;
  }

  /// Returns [successColor] or [errorColor].
  ///
  /// Example: `false.toStatusColor() // Colors.red`
  Color toStatusColor(
      {Color successColor = Colors.green, Color errorColor = Colors.red}) {
    return this ? successColor : errorColor;
  }

  /// Returns [trueIcon] or [falseIcon].
  ///
  /// Example: `true.toIcon() // Icons.check`
  IconData toIcon(
      {IconData trueIcon = Icons.check, IconData falseIcon = Icons.close}) {
    return this ? trueIcon : falseIcon;
  }
}
