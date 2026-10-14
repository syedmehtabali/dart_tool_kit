// Imports flutter/material.dart alongside validators.dart on purpose: this
// proves `Validator` / `Validators` do not collide with Flutter exports.
import 'package:dart_tool_kit/dart_tool_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('optional-field behaviour', () {
    final nonRequired = <String, Validator>{
      'email': Validators.email(),
      'minLength': Validators.minLength(3),
      'maxLength': Validators.maxLength(3),
      'pattern': Validators.pattern(RegExp(r'^\d+$')),
      'numeric': Validators.numeric(),
      'integer': Validators.integer(),
      'min': Validators.min(10),
      'max': Validators.max(10),
      'phone': Validators.phone(),
      'url': Validators.url(),
      'strongPassword': Validators.strongPassword(),
      'match': Validators.match(() => 'x'),
    };

    nonRequired.forEach((name, validator) {
      test('$name returns null for null, empty and whitespace-only', () {
        expect(validator(null), isNull);
        expect(validator(''), isNull);
        expect(validator('   '), isNull);
      });
    });
  });

  group('required', () {
    test('fails on null, empty and whitespace-only', () {
      final v = Validators.required();
      expect(v(null), 'This field is required');
      expect(v(''), 'This field is required');
      expect(v(' \t\n'), 'This field is required');
    });

    test('passes on non-blank', () {
      expect(Validators.required()('a'), isNull);
      expect(Validators.required()(' a '), isNull);
    });

    test('custom message', () {
      expect(Validators.required('Name needed')(''), 'Name needed');
    });
  });

  group('email', () {
    test('valid addresses', () {
      final v = Validators.email();
      expect(v('user@example.com'), isNull);
      expect(v('first.last+tag@sub.domain.io'), isNull);
      expect(v('  user@example.com  '), isNull, reason: 'trimmed');
    });

    test('invalid addresses', () {
      final v = Validators.email();
      expect(v('plainaddress'), 'Please enter a valid email address');
      expect(v('user@'), isNotNull);
      expect(v('user@domain'), isNotNull);
      expect(v('@domain.com'), isNotNull);
      expect(v('user@domain.c'), isNotNull);
      expect(v('us er@domain.com'), isNotNull);
    });

    test('custom message', () {
      expect(Validators.email('Bad email')('x'), 'Bad email');
    });
  });

  group('minLength / maxLength', () {
    test('minLength boundaries', () {
      final v = Validators.minLength(3);
      expect(v('ab'), 'Must be at least 3 characters');
      expect(v('abc'), isNull);
      expect(v('abcd'), isNull);
    });

    test('maxLength boundaries', () {
      final v = Validators.maxLength(3);
      expect(v('abc'), isNull);
      expect(v('abcd'), 'Must be at most 3 characters');
    });

    test('lengths are untrimmed', () {
      expect(Validators.minLength(3)(' a '), isNull);
      expect(Validators.maxLength(3)(' ab '), isNotNull);
    });

    test('custom messages', () {
      expect(Validators.minLength(5, 'Too short')('abc'), 'Too short');
      expect(Validators.maxLength(1, 'Too long')('abc'), 'Too long');
    });
  });

  group('pattern', () {
    test('matches / fails', () {
      final v = Validators.pattern(RegExp(r'^[A-Z]{3}$'), 'Three caps');
      expect(v('ABC'), isNull);
      expect(v('abc'), 'Three caps');
      expect(v('ABCD'), 'Three caps');
    });

    test('default message', () {
      expect(Validators.pattern(RegExp(r'^\d$'))('a'), 'Invalid format');
    });

    test('unanchored pattern matches substrings', () {
      expect(Validators.pattern(RegExp(r'\d'))('abc1'), isNull);
    });
  });

  group('numeric', () {
    test('accepts plain decimals', () {
      final v = Validators.numeric();
      for (final s in [
        '0',
        '42',
        '-3',
        '+3',
        '3.14',
        '-0.5',
        '.5',
        '5.',
        ' 7 '
      ]) {
        expect(v(s), isNull, reason: s);
      }
    });

    test('rejects non-numbers and exotic formats', () {
      final v = Validators.numeric();
      for (final s in [
        'abc',
        '1,000',
        '1e3',
        '0x10',
        'NaN',
        'Infinity',
        '-',
        '.',
        '1.2.3'
      ]) {
        expect(v(s), 'Please enter a valid number', reason: s);
      }
    });

    test('custom message', () {
      expect(Validators.numeric('Numbers only')('x'), 'Numbers only');
    });
  });

  group('integer', () {
    test('accepts whole numbers', () {
      final v = Validators.integer();
      expect(v('0'), isNull);
      expect(v('-12'), isNull);
      expect(v('+12'), isNull);
      expect(v(' 12 '), isNull);
    });

    test('rejects decimals and text', () {
      final v = Validators.integer();
      expect(v('1.0'), 'Please enter a whole number');
      expect(v('1.5'), isNotNull);
      expect(v('abc'), isNotNull);
      expect(v('0x10'), isNotNull);
    });

    test('custom message', () {
      expect(Validators.integer('Int!')('1.5'), 'Int!');
    });
  });

  group('min / max', () {
    test('min boundaries', () {
      final v = Validators.min(18);
      expect(v('17'), 'Must be at least 18');
      expect(v('17.99'), isNotNull);
      expect(v('18'), isNull);
      expect(v('100'), isNull);
    });

    test('max boundaries', () {
      final v = Validators.max(100);
      expect(v('100'), isNull);
      expect(v('100.01'), 'Must be at most 100');
      expect(v('-5'), isNull);
    });

    test('decimal bounds', () {
      expect(Validators.min(0.5)('0.4'), 'Must be at least 0.5');
      expect(Validators.max(0.5)('0.5'), isNull);
    });

    test('non-numeric input fails', () {
      expect(Validators.min(1)('abc'), 'Must be at least 1');
      expect(Validators.max(1)('abc'), 'Must be at most 1');
    });

    test('custom messages', () {
      expect(Validators.min(18, 'Adults only')('10'), 'Adults only');
      expect(Validators.max(5, 'Max 5')('6'), 'Max 5');
    });
  });

  group('phone', () {
    test('accepts lenient international formats', () {
      final v = Validators.phone();
      for (final s in [
        '+1 (555) 123-4567',
        '+44 20 7946 0958',
        '0300-1234567',
        '1234567',
        '123456789012345',
      ]) {
        expect(v(s), isNull, reason: s);
      }
    });

    test('rejects bad characters and digit counts', () {
      final v = Validators.phone();
      for (final s in [
        '123456', // 6 digits
        '1234567890123456', // 16 digits
        '555-CALL-NOW',
        '12+34567890',
        '+ ( ) - ',
        '123.456.7890',
      ]) {
        expect(v(s), 'Please enter a valid phone number', reason: s);
      }
    });

    test('custom message', () {
      expect(Validators.phone('Bad phone')('1'), 'Bad phone');
    });
  });

  group('url', () {
    test('accepts web addresses', () {
      final v = Validators.url();
      for (final s in [
        'https://dart.dev',
        'http://example.com/path?q=1#frag',
        'example.com',
        'sub.example.co.uk/a/b',
        'https://example.com:8080/x',
        'http://localhost:3000',
        'HTTPS://EXAMPLE.COM',
      ]) {
        expect(v(s), isNull, reason: s);
      }
    });

    test('rejects invalid addresses', () {
      final v = Validators.url();
      for (final s in [
        'not a url',
        'ftp://example.com',
        'example',
        'http://',
        'https://exa mple.com',
        '-bad.com',
      ]) {
        expect(v(s), 'Please enter a valid URL', reason: s);
      }
    });

    test('custom message', () {
      expect(Validators.url('Bad link')('x'), 'Bad link');
    });
  });

  group('strongPassword', () {
    test('defaults require all rules and 8 chars', () {
      final v = Validators.strongPassword();
      expect(v('Abcdef1!'), isNull);
      expect(v('Abcde1!'), isNotNull, reason: 'too short');
      expect(v('abcdef1!'), isNotNull, reason: 'no upper');
      expect(v('ABCDEF1!'), isNotNull, reason: 'no lower');
      expect(v('Abcdefg!'), isNotNull, reason: 'no digit');
      expect(v('Abcdefg1'), isNotNull, reason: 'no special');
    });

    test('whitespace does not count as special', () {
      expect(Validators.strongPassword()('Abcdef 1'), isNotNull);
    });

    test('default message lists enabled rules', () {
      expect(
        Validators.strongPassword()('x'),
        'Password must be at least 8 characters and include an uppercase '
        'letter, a lowercase letter, a digit and a special character',
      );
      expect(
        Validators.strongPassword(
          minLength: 6,
          requireUppercase: false,
          requireLowercase: false,
          requireSpecial: false,
        )('x'),
        'Password must be at least 6 characters and include a digit',
      );
      expect(
        Validators.strongPassword(
          minLength: 4,
          requireUppercase: false,
          requireLowercase: false,
          requireDigit: false,
          requireSpecial: false,
        )('x'),
        'Password must be at least 4 characters',
      );
    });

    test('configurable rules', () {
      final v = Validators.strongPassword(
        minLength: 4,
        requireUppercase: false,
        requireSpecial: false,
      );
      expect(v('abc1'), isNull);
      expect(v('abcd'), isNotNull);
    });

    test('custom message', () {
      expect(Validators.strongPassword(message: 'Weak')('a'), 'Weak');
    });
  });

  group('match', () {
    test('compares against the current value of other', () {
      var password = 'secret';
      final v = Validators.match(() => password);
      expect(v('secret'), isNull);
      expect(v('Secret'), 'Values do not match');
      password = 'changed';
      expect(v('secret'), 'Values do not match');
      expect(v('changed'), isNull);
    });

    test('compares raw (untrimmed) values', () {
      expect(Validators.match(() => 'a')(' a'), isNotNull);
    });

    test('custom message', () {
      expect(
        Validators.match(() => 'a', 'Passwords differ')('b'),
        'Passwords differ',
      );
    });
  });

  group('compose', () {
    test('returns the first error in order', () {
      final v = Validators.compose([
        Validators.required('req'),
        Validators.minLength(5, 'short'),
        Validators.email('email'),
      ]);
      expect(v(''), 'req');
      expect(v('ab'), 'short');
      expect(v('abcdef'), 'email');
      expect(v('a@b.co'), isNull);
    });

    test('order matters', () {
      final a = Validators.compose([
        Validators.email('email'),
        Validators.minLength(10, 'short'),
      ]);
      final b = Validators.compose([
        Validators.minLength(10, 'short'),
        Validators.email('email'),
      ]);
      expect(a('x'), 'email');
      expect(b('x'), 'short');
    });

    test('stops at the first error', () {
      var calls = 0;
      String? counting(String? _) {
        calls++;
        return null;
      }

      Validators.compose([(_) => 'fail', counting])('x');
      expect(calls, 0);
      Validators.compose([counting, counting])('x');
      expect(calls, 2);
    });

    test('without required, blank input passes', () {
      final v =
          Validators.compose([Validators.email(), Validators.minLength(3)]);
      expect(v(null), isNull);
      expect(v(''), isNull);
    });

    test('empty list always passes', () {
      expect(Validators.compose([])('anything'), isNull);
    });

    test('is unaffected by later mutation of the input list', () {
      final list = <Validator>[Validators.required('req')];
      final v = Validators.compose(list);
      list.add((_) => 'added');
      expect(v('x'), isNull);
    });

    test('nested compose', () {
      final v = Validators.compose([
        Validators.compose([Validators.required('req')]),
        Validators.integer('int'),
      ]);
      expect(v(''), 'req');
      expect(v('1.5'), 'int');
      expect(v('3'), isNull);
    });
  });

  group('Flutter integration', () {
    test('Validator is assignable to FormFieldValidator<String>', () {
      final FormFieldValidator<String> v = Validators.required();
      expect(v(''), isNotNull);
    });

    testWidgets('works as TextFormField.validator', (tester) async {
      final formKey = GlobalKey<FormState>();
      final controller = TextEditingController();
      addTearDown(controller.dispose);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: TextFormField(
                controller: controller,
                validator: Validators.compose([
                  Validators.required(),
                  Validators.email(),
                ]),
              ),
            ),
          ),
        ),
      );

      expect(formKey.currentState!.validate(), isFalse);
      await tester.pump();
      expect(find.text('This field is required'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), 'nope');
      expect(formKey.currentState!.validate(), isFalse);
      await tester.pump();
      expect(find.text('Please enter a valid email address'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), 'a@b.co');
      expect(formKey.currentState!.validate(), isTrue);
    });
  });
}
