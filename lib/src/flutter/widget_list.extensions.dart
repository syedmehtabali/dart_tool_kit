import 'package:flutter/widgets.dart';

/// Extensions on iterables of [Widget]s.
extension WidgetIterableExtensions on Iterable<Widget> {
  /// Returns a new list with [separator] inserted between each pair of
  /// widgets (never before the first or after the last).
  ///
  /// The same [separator] instance is reused, so prefer a `const` or
  /// stateless widget without a key.
  ///
  /// Example: `Column(children: [a, b, c].separatedBy(8.verticalSpace))`
  List<Widget> separatedBy(Widget separator) {
    final result = <Widget>[];
    for (final widget in this) {
      if (result.isNotEmpty) result.add(separator);
      result.add(widget);
    }
    return result;
  }
}
