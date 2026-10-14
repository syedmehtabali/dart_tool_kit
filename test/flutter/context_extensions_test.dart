import 'package:dart_tool_kit/dart_tool_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pumps a [MaterialApp] with the given surface [size] and captures the
/// [BuildContext] below the [Scaffold].
Future<BuildContext> _pump(
  WidgetTester tester, {
  Size size = const Size(400, 800),
  ThemeData? theme,
  Widget Function(BuildContext context)? body,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  late BuildContext captured;
  await tester.pumpWidget(
    MaterialApp(
      theme: theme,
      home: Scaffold(
        body: Builder(builder: (context) {
          captured = context;
          return body?.call(context) ?? const SizedBox();
        }),
      ),
    ),
  );
  return captured;
}

void main() {
  group('ContextExtensions theme', () {
    testWidgets('exposes theme, textTheme, colorScheme', (tester) async {
      final theme = ThemeData(colorSchemeSeed: Colors.teal);
      final context = await _pump(tester, theme: theme);
      expect(context.theme, Theme.of(context));
      expect(context.textTheme, Theme.of(context).textTheme);
      expect(context.colorScheme, Theme.of(context).colorScheme);
      expect(context.isDarkMode, isFalse);
    });

    testWidgets('isDarkMode follows theme brightness', (tester) async {
      final context =
          await _pump(tester, theme: ThemeData(brightness: Brightness.dark));
      expect(context.isDarkMode, isTrue);
    });
  });

  group('ContextExtensions media query', () {
    testWidgets('screen size, padding and insets', (tester) async {
      tester.view.padding = const FakeViewPadding(top: 24);
      final context = await _pump(tester, size: const Size(400, 800));
      expect(context.screenSize, const Size(400, 800));
      expect(context.screenWidth, 400);
      expect(context.screenHeight, 800);
      expect(context.viewInsets, EdgeInsets.zero);
      // The Scaffold body removes the top padding, so read it above it.
      final appContext = tester.element(find.byType(Scaffold));
      expect(appContext.screenPadding.top, 24);
    });

    for (final (width, mobile, tablet, desktop) in [
      (599.0, true, false, false),
      (600.0, false, true, false),
      (1023.0, false, true, false),
      (1024.0, false, false, true),
    ]) {
      testWidgets('breakpoints at width $width', (tester) async {
        final context = await _pump(tester, size: Size(width, 800));
        expect(context.isMobile, mobile);
        expect(context.isTablet, tablet);
        expect(context.isDesktop, desktop);
      });
    }

    test('breakpoint constants', () {
      expect(ContextExtensions.mobileBreakpoint, 600);
      expect(ContextExtensions.tabletBreakpoint, 1024);
    });
  });

  group('ContextExtensions actions', () {
    testWidgets('showSnackBar shows the message and returns controller',
        (tester) async {
      final context = await _pump(tester);
      final controller = context.showSnackBar('Saved');
      await tester.pump();
      expect(find.text('Saved'), findsOneWidget);

      SnackBarClosedReason? reason;
      controller.closed.then((r) => reason = r);
      controller.close();
      await tester.pumpAndSettle();
      expect(find.text('Saved'), findsNothing);
      expect(reason, SnackBarClosedReason.hide);
    });

    testWidgets('showSnackBar replaces the current snack bar by default',
        (tester) async {
      final context = await _pump(tester);
      context.showSnackBar('First');
      await tester.pump();
      context.showSnackBar('Second',
          action: SnackBarAction(label: 'Undo', onPressed: () {}));
      await tester.pumpAndSettle();
      expect(find.text('First'), findsNothing);
      expect(find.text('Second'), findsOneWidget);
      expect(find.text('Undo'), findsOneWidget);
    });

    testWidgets('showSnackBar queues when hideCurrent is false',
        (tester) async {
      final context = await _pump(tester);
      context.showSnackBar('First');
      await tester.pump();
      context.showSnackBar('Second', hideCurrent: false);
      await tester.pumpAndSettle();
      expect(find.text('First'), findsOneWidget);
      expect(find.text('Second'), findsNothing);
    });

    testWidgets('hideKeyboard unfocuses the focused text field',
        (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      final context = await _pump(
        tester,
        body: (_) => TextField(focusNode: focusNode),
      );
      await tester.tap(find.byType(TextField));
      await tester.pump();
      expect(focusNode.hasFocus, isTrue);
      expect(tester.testTextInput.isVisible, isTrue);

      context.hideKeyboard();
      await tester.pump();
      expect(focusNode.hasFocus, isFalse);
      expect(tester.testTextInput.isVisible, isFalse);
    });
  });
}
