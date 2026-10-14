import 'package:dart_tool_kit/dart_tool_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WidgetIterableExtensions.separatedBy', () {
    const sep = SizedBox(height: 8);

    test('inserts separators only between items', () {
      const a = Text('a'), b = Text('b'), c = Text('c');
      expect([a, b, c].separatedBy(sep), [a, sep, b, sep, c]);
    });

    test('handles empty and single-element inputs', () {
      expect(<Widget>[].separatedBy(sep), isEmpty);
      const a = Text('a');
      expect([a].separatedBy(sep), [a]);
    });

    test('works on any Iterable and returns a new list', () {
      final source = [const Text('a'), const Text('b')];
      final result = source.where((_) => true).separatedBy(sep);
      expect(result, hasLength(3));
      expect(source, hasLength(2));
    });

    testWidgets('renders in a Column with separators between children',
        (tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: Column(
            children: const [Text('a'), Text('b'), Text('c')]
                .separatedBy(const SizedBox(height: 8)),
          ),
        ),
      );
      expect(find.text('a'), findsOneWidget);
      expect(find.text('c'), findsOneWidget);
      expect(find.byType(SizedBox), findsNWidgets(2));
      final aBottom = tester.getBottomLeft(find.text('a')).dy;
      final bTop = tester.getTopLeft(find.text('b')).dy;
      expect(bTop - aBottom, 8);
    });
  });
}
