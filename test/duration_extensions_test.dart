// Every lib/src file is imported on purpose: the "no clashes" group proves
// that the num -> Duration getters don't trigger
// `ambiguous_extension_member_access` against any other extension in the
// package (this file would fail to compile if they did).
// ignore_for_file: unused_import
import 'package:dart_tool_kit/dart_tool_kit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const d1h2m5s = Duration(hours: 1, minutes: 2, seconds: 5);

  group('toClock', () {
    test('formats h:m:s with zero padding', () {
      expect(d1h2m5s.toClock(), '01:02:05');
    });

    test('omits hours when zero by default', () {
      expect(const Duration(minutes: 2, seconds: 5).toClock(), '02:05');
      expect(const Duration(seconds: 9).toClock(), '00:09');
    });

    test('alwaysShowHours forces the hour field', () {
      expect(
        const Duration(minutes: 2, seconds: 5).toClock(alwaysShowHours: true),
        '00:02:05',
      );
      expect(Duration.zero.toClock(alwaysShowHours: true), '00:00:00');
    });

    test('zero duration', () {
      expect(Duration.zero.toClock(), '00:00');
    });

    test('truncates sub-second parts', () {
      expect(const Duration(milliseconds: 999).toClock(), '00:00');
      expect(const Duration(seconds: 59, milliseconds: 999).toClock(), '00:59');
    });

    test('folds days into hours beyond 24h', () {
      expect(
          const Duration(days: 1, hours: 1, seconds: 1).toClock(), '25:00:01');
      expect(const Duration(hours: 123, minutes: 4).toClock(), '123:04:00');
    });

    test('negative durations get a leading minus', () {
      expect((-d1h2m5s).toClock(), '-01:02:05');
      expect(const Duration(seconds: -5).toClock(), '-00:05');
      expect(const Duration(seconds: -5).toClock(alwaysShowHours: true),
          '-00:00:05');
    });

    test('negative sub-second duration has no minus sign', () {
      expect(const Duration(milliseconds: -500).toClock(), '00:00');
    });
  });

  group('toReadable', () {
    test('short form by default', () {
      expect(d1h2m5s.toReadable(), '1h 2m 5s');
    });

    test('zero duration', () {
      expect(Duration.zero.toReadable(), '0s');
      expect(Duration.zero.toReadable(longForm: true), '0 seconds');
      expect(Duration.zero.toReadable(includeMilliseconds: true), '0ms');
      expect(
        Duration.zero.toReadable(includeMilliseconds: true, longForm: true),
        '0 milliseconds',
      );
    });

    test('sub-second durations', () {
      const ms = Duration(milliseconds: 250);
      expect(ms.toReadable(), '0s');
      expect(ms.toReadable(includeMilliseconds: true), '250ms');
      expect(
        const Duration(seconds: 1, milliseconds: 1)
            .toReadable(includeMilliseconds: true, longForm: true),
        '1 second 1 millisecond',
      );
    });

    test('hides zero units by default', () {
      expect(const Duration(hours: 1, seconds: 5).toReadable(), '1h 5s');
      expect(const Duration(hours: 2).toReadable(), '2h');
    });

    test('showZeroUnits keeps inner zero units only', () {
      expect(
        const Duration(hours: 1, seconds: 5).toReadable(showZeroUnits: true),
        '1h 0m 5s',
      );
      // No leading or trailing zero units.
      expect(const Duration(hours: 2).toReadable(showZeroUnits: true), '2h');
      expect(
        const Duration(days: 1, minutes: 3).toReadable(showZeroUnits: true),
        '1d 0h 3m',
      );
    });

    test('includes days when >= 24h', () {
      expect(const Duration(hours: 24).toReadable(), '1d');
      expect(
          const Duration(days: 3, hours: 4, minutes: 5, seconds: 6)
              .toReadable(),
          '3d 4h 5m 6s');
      expect(const Duration(hours: 49).toReadable(longForm: true),
          '2 days 1 hour');
    });

    test('maxUnits truncates from the largest unit', () {
      expect(d1h2m5s.toReadable(maxUnits: 2), '1h 2m');
      expect(d1h2m5s.toReadable(maxUnits: 1), '1h');
      expect(d1h2m5s.toReadable(maxUnits: 10), '1h 2m 5s');
      // Zero units are skipped (and not counted) unless showZeroUnits.
      const d = Duration(hours: 1, seconds: 5);
      expect(d.toReadable(maxUnits: 2), '1h 5s');
      expect(d.toReadable(maxUnits: 2, showZeroUnits: true), '1h 0m');
      // Truncated, not rounded.
      expect(
          const Duration(hours: 1, minutes: 59).toReadable(maxUnits: 1), '1h');
    });

    test('maxUnits < 1 throws', () {
      expect(() => d1h2m5s.toReadable(maxUnits: 0), throwsArgumentError);
    });

    test('long form singular/plural', () {
      expect(d1h2m5s.toReadable(longForm: true), '1 hour 2 minutes 5 seconds');
      expect(
        const Duration(days: 1, hours: 1, minutes: 1, seconds: 1)
            .toReadable(longForm: true),
        '1 day 1 hour 1 minute 1 second',
      );
      expect(
        const Duration(days: 2, hours: 2, minutes: 2, seconds: 2)
            .toReadable(longForm: true),
        '2 days 2 hours 2 minutes 2 seconds',
      );
      expect(
        const Duration(hours: 1, seconds: 5)
            .toReadable(longForm: true, showZeroUnits: true),
        '1 hour 0 minutes 5 seconds',
      );
      expect(
        const Duration(milliseconds: 2)
            .toReadable(longForm: true, includeMilliseconds: true),
        '2 milliseconds',
      );
    });

    test('custom separator', () {
      expect(d1h2m5s.toReadable(separator: ', '), '1h, 2m, 5s');
    });

    test('negative durations get a leading minus', () {
      expect((-d1h2m5s).toReadable(), '-1h 2m 5s');
      expect((-d1h2m5s).toReadable(longForm: true, maxUnits: 1), '-1 hour');
      expect(const Duration(milliseconds: -500).toReadable(), '0s');
      expect(
        const Duration(milliseconds: -500)
            .toReadable(includeMilliseconds: true),
        '-500ms',
      );
    });
  });

  group('delay & inFractionalSeconds', () {
    test('delay completes after the duration', () async {
      final sw = Stopwatch()..start();
      await const Duration(milliseconds: 20).delay();
      expect(sw.elapsedMilliseconds, greaterThanOrEqualTo(15));
    });

    test('delay with zero completes', () async {
      await expectLater(Duration.zero.delay(), completes);
    });

    test('inFractionalSeconds', () {
      expect(const Duration(milliseconds: 1500).inFractionalSeconds, 1.5);
      expect(const Duration(microseconds: 1).inFractionalSeconds, 0.000001);
      expect(Duration.zero.inFractionalSeconds, 0.0);
      expect(const Duration(milliseconds: -250).inFractionalSeconds, -0.25);
    });
  });

  group('num -> Duration getters', () {
    test('int receivers', () {
      expect(250.milliseconds, const Duration(milliseconds: 250));
      expect(2.seconds, const Duration(seconds: 2));
      expect(3.minutes, const Duration(minutes: 3));
      expect(4.hours, const Duration(hours: 4));
      expect(5.days, const Duration(days: 5));
      expect(0.seconds, Duration.zero);
      expect((-2).seconds, const Duration(seconds: -2));
    });

    test('double receivers', () {
      expect(1.5.hours, const Duration(hours: 1, minutes: 30));
      expect(0.5.minutes, const Duration(seconds: 30));
      expect(1.5.seconds, const Duration(milliseconds: 1500));
      expect(0.25.milliseconds, const Duration(microseconds: 250));
      expect(0.5.days, const Duration(hours: 12));
      expect((-1.5).seconds, const Duration(milliseconds: -1500));
    });

    test('double rounds to nearest microsecond', () {
      expect(0.0000016.seconds, const Duration(microseconds: 2));
    });

    test('num receivers', () {
      num a = 2;
      num b = 1.5;
      expect(a.seconds, const Duration(seconds: 2));
      expect(b.minutes, const Duration(seconds: 90));
    });

    test('non-finite doubles throw', () {
      expect(() => double.nan.seconds, throwsUnsupportedError);
      expect(() => double.infinity.hours, throwsUnsupportedError);
    });

    test('composes with Duration extensions', () {
      expect((1.hours + 2.minutes + 5.seconds).toClock(), '01:02:05');
      expect(90.seconds.toReadable(longForm: true), '1 minute 30 seconds');
    });
  });

  group('no clashes with other package extensions', () {
    test('members resolve on int, double and num with all files imported', () {
      const int i = 1;
      const double d = 1.0;
      const num n = 1;
      // Existing int helpers from number.extension.dart still work alongside.
      expect(i.toSeconds, i.seconds);
      expect(i.toMinutes, i.minutes);
      expect(i.toHours, i.hours);
      expect(i.toDays, i.days);
      expect(i.toMilliseconds, i.milliseconds);
      expect(d.seconds, n.seconds);
      expect(d.milliseconds, n.milliseconds);
      expect(d.minutes, n.minutes);
      expect(d.hours, n.hours);
      expect(d.days, n.days);
      expect(i.seconds.inFractionalSeconds, 1.0);
    });
  });
}
