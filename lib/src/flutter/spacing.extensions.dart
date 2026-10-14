import 'package:flutter/widgets.dart';

/// Extensions on [num] for building spacing, padding and radius values.
extension NumSpacingExtensions on num {
  /// A [SizedBox] with this value as its height.
  ///
  /// Example: `Column(children: [a, 16.verticalSpace, b])`
  SizedBox get verticalSpace => SizedBox(height: toDouble());

  /// A [SizedBox] with this value as its width.
  ///
  /// Example: `Row(children: [a, 8.horizontalSpace, b])`
  SizedBox get horizontalSpace => SizedBox(width: toDouble());

  /// A [BorderRadius] with this value as the radius of every corner.
  ///
  /// Example: `BoxDecoration(borderRadius: 12.circularRadius)`
  BorderRadius get circularRadius => BorderRadius.circular(toDouble());

  /// [EdgeInsets] with this value on every side.
  ///
  /// Example: `Padding(padding: 16.allPadding, child: child)`
  EdgeInsets get allPadding => EdgeInsets.all(toDouble());

  /// [EdgeInsets] with this value on the left and right only.
  ///
  /// Example: `Padding(padding: 24.horizontalPadding, child: child)`
  EdgeInsets get horizontalPadding =>
      EdgeInsets.symmetric(horizontal: toDouble());

  /// [EdgeInsets] with this value on the top and bottom only.
  ///
  /// Example: `Padding(padding: 8.verticalPadding, child: child)`
  EdgeInsets get verticalPadding => EdgeInsets.symmetric(vertical: toDouble());
}
