// Imports Flutter, package:collection and every library under lib/src
// together, then calls each Flutter-layer member. If any name were ambiguous
// this file would fail to compile with `ambiguous_extension_member_access`.
import 'package:dart_tool_kit/dart_tool_kit.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('core and Flutter extensions coexist', () {
    // bool: core members and Flutter members on the same receiver.
    expect(true.toggle(), isFalse);
    expect(true.toColor(), Colors.green);
    expect(false.toStatusColor(), Colors.red);
    expect(true.toIcon(), Icons.check);

    // String: core toInt/toBool next to toColor/toColorOrNull.
    expect('12'.toInt(), 12);
    expect('#FF5733'.toColor(), const Color(0xFFFF5733));
    expect('x'.toColorOrNull(), isNull);
    expect('x'.isNullOrEmpty, isFalse);

    // int: core toHex (radix) vs Color.toHex.
    expect(255.toHex(), 'ff');
    expect(const Color(0xFF00FF00).toHex(), '#00FF00');
    expect(Colors.blue.darken(0.1), isA<Color>());
    expect(Colors.blue.lighten(0.1), isA<Color>());

    // num: duration getters next to spacing getters.
    expect(2.seconds, const Duration(seconds: 2));
    expect(2.toSeconds, const Duration(seconds: 2));
    expect(8.verticalSpace.height, 8);
    expect(8.horizontalSpace.width, 8);
    expect(8.circularRadius, BorderRadius.circular(8));
    expect(8.allPadding, const EdgeInsets.all(8));
    expect(8.horizontalPadding.left, 8);
    expect(8.verticalPadding.top, 8);
    expect(1.5.verticalSpace.height, 1.5);
    int? maybe;
    expect(maybe.orZero, 0);

    // Widget iterables: core iterable/list extensions next to separatedBy.
    final widgets = <Widget>[const Text('a'), const Text('b')];
    expect(widgets.separatedBy(const SizedBox()), hasLength(3));
    expect(widgets.safeFirst, isNotNull);
    expect(widgets.isNotNullOrEmpty, isTrue);
    expect(widgets.where((_) => true).isNotNullOrEmpty, isTrue);
    expect(widgets.firstOrNull, isNotNull);

    // Touch the remaining libraries so every import is used.
    expect(DateTime(2024, 1, 1).isLeapYear, isTrue);
    expect(const Duration(seconds: 5).toClock(), '00:05');
    expect(<String, Object?>{'a': 1}.getInt('a'), 1);
    expect({'a': 1}.merge({'b': 2}), {'a': 1, 'b': 2});
    expect(Validators.required()(''), isNotNull);
  });

  testWidgets('BuildContext extensions coexist', (tester) async {
    late BuildContext ctx;
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: Builder(builder: (c) {
        ctx = c;
        return const SizedBox();
      })),
    ));
    expect(ctx.theme, isA<ThemeData>());
    expect(ctx.textTheme, isA<TextTheme>());
    expect(ctx.colorScheme, isA<ColorScheme>());
    expect(ctx.isDarkMode, isFalse);
    expect(ctx.screenSize, isA<Size>());
    expect(ctx.screenWidth, greaterThan(0));
    expect(ctx.screenHeight, greaterThan(0));
    expect(ctx.screenPadding, isA<EdgeInsets>());
    expect(ctx.viewInsets, isA<EdgeInsets>());
    expect(
        [ctx.isMobile, ctx.isTablet, ctx.isDesktop].where((b) => b).length, 1);
    ctx.hideKeyboard();
    expect(ctx.showSnackBar('hi'), isNotNull);
  });
}
