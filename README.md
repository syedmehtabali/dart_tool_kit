[![Stand With Palestine](https://raw.githubusercontent.com/TheBSD/StandWithPalestine/main/banner-no-action.svg)](https://thebsd.github.io/StandWithPalestine)

# Dart Tool Kit

Everyday extension methods for Flutter and Dart: null-safety helpers, safe JSON parsing, form validators, date and duration formatting, string case conversion, and `BuildContext` shortcuts. One import, fully tested, and no clashes with `package:collection`.

[![Pub Version](https://img.shields.io/pub/v/dart_tool_kit.svg)](https://pub.dev/packages/dart_tool_kit)
[![CI](https://github.com/syedmehtabali/dart_tool_kit/actions/workflows/ci.yml/badge.svg)](https://github.com/syedmehtabali/dart_tool_kit/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Installation

```bash
flutter pub add dart_tool_kit
```

```dart
import 'package:dart_tool_kit/dart_tool_kit.dart';
```

## Contents

- [Null-safety helpers](#null-safety-helpers)
- [Safe JSON parsing](#safe-json-parsing)
- [Form validators for TextFormField](#form-validators-for-textformfield)
- [Duration formatting](#duration-formatting)
- [DateTime helpers](#datetime-helpers)
- [String helpers](#string-helpers)
- [Number helpers](#number-helpers)
- [List, Iterable and Map helpers](#list-iterable-and-map-helpers)
- [Boolean helpers](#boolean-helpers)
- [Flutter: BuildContext, spacing, colors](#flutter-buildcontext-spacing-colors)

## Null-safety helpers

Check and default nullable values without `?? ''` everywhere.

```dart
String? name;
name.isNullOrEmpty;    // true
'   '.isNullOrBlank;   // true (whitespace-only counts as blank)
name.orEmpty;          // ''

int? count;            count.orZero;   // 0
List<int>? items;      items.orEmpty;  // []
Map<String, int>? m;   m.isNullOrEmpty; // true

String? city;          city.orElse('Unknown'); // 'Unknown'
```

## Safe JSON parsing

Read values from `jsonDecode` output without casts or crashes. A missing key or wrong type returns `null`, or the fallback with the `…Or` variants.

```dart
final json = jsonDecode(response.body) as Map<String, dynamic>;

json.getString('name');               // String?
json.getInt('age');                   // int? (also accepts "25" and 25.0)
json.getIntOr('age', 0);              // int
json.getBool('active');               // accepts true, "true", 1, "1"
json.getDateTime('createdAt');        // ISO-8601 string or epoch milliseconds
json.getList<String>('tags');         // List<String>? (non-strings dropped)
json.getMap('address')?.getString('city');
json.getPath('user.address.city');    // nested access; 'items.0.name' for lists

json.removeNulls(deep: true);         // clean a payload before sending
{'q': 'flutter dart', 'page': 2}.toQueryString(); // 'q=flutter+dart&page=2'
```

## Form validators for TextFormField

Composable validators that plug straight into `TextFormField.validator`.

```dart
TextFormField(
  validator: Validators.compose([
    Validators.required('Email is required'),
    Validators.email(),
  ]),
);

TextFormField(
  validator: Validators.compose([
    Validators.required(),
    Validators.strongPassword(minLength: 8),
  ]),
);

// Confirm password
Validators.match(() => passwordController.text, 'Passwords do not match');
```

Also available: `minLength`, `maxLength`, `pattern`, `numeric`, `integer`, `min`, `max`, `phone`, `url`.

> Every validator except `required` accepts empty input, so optional fields work. Combine it with `Validators.required()` to make a field mandatory.

## Duration formatting

Useful for media players, countdowns and OTP timers.

```dart
const d = Duration(seconds: 3725);
d.toClock();                       // '01:02:05'
d.toReadable();                    // '1h 2m 5s'
d.toReadable(longForm: true);      // '1 hour 2 minutes 5 seconds'
d.toReadable(maxUnits: 2);         // '1h 2m'

2.seconds;                         // Duration(seconds: 2)
1.5.hours;                         // Duration(hours: 1, minutes: 30)
await 300.milliseconds.delay();
```

## DateTime helpers

```dart
final date = DateTime(2025, 4, 16);

// Formatting
date.toIsoDate;          // '2025-04-16'
date.toSlashFormat;      // '16/04/2025'
date.toReadableFormat;   // 'Wednesday, 16 Apr 2025'
date.format('MMM d, y'); // 'Apr 16, 2025' (intl pattern)

// Calculations
date.startOfDay;         // 2025-04-16 00:00:00
date.endOfMonth;         // 2025-04-30 23:59:59.999
date.startOfWeek;        // Monday 00:00
DateTime(2025, 1, 31).addMonths(1); // 2025-02-28 (clamped to month end)
date.weekOfYear;         // 16 (ISO-8601)
date.quarter;            // 2

// Checks
date.isToday; date.isYesterday; date.isWeekend; date.isLeapYear;
date.isSameDate(other);

// Relative time
past.timeAgo();          // 'just now', '1 minute ago', '3 days ago'
future.timeAgo();        // 'in 2 hours'
birthDate.age;           // age in years
```

## String helpers

```dart
// Case conversion (handles spaces, camelCase and acronyms)
'hello world'.toSnakeCase();      // 'hello_world'
'parseHTTPRequest'.toKebabCase(); // 'parse-http-request'
'hello world'.toCamelCase();      // 'helloWorld'
'hello world'.toPascalCase();     // 'HelloWorld'
'hello world'.toTitleCase();      // 'Hello World'
'helloWorld'.camelToWords();      // 'Hello World'

// Validation
'example@email.com'.isValidEmail(); // true
'https://example.com'.isValidUrl(); // true
'12345'.isNumeric();                // true

// Manipulation
'Hello World'.mask(start: 2, end: 2); // 'He*******ld'
'Hello World'.ellipsize(5);           // 'Hello...'
'John Doe'.getInitials();             // 'JD'
'abc'.safeSubstring(1, 10);           // 'bc' (no RangeError)

// Hashing
'password'.toSHA256();
```

## Number helpers

```dart
1000.toCurrency(symbol: '\$', decimalDigits: 2); // '$1,000.00'
1200000.toCompactString(); // '1.2M'
23.toOrdinal();            // '23rd'
7.twoDigits;               // '07'
5.to(10);                  // [5, 6, 7, 8, 9, 10]
3.times(() => print('Hi'));
16.isPowerOfTwo;           // true
```

## List, Iterable and Map helpers

```dart
[1, 2, 3].safeFirst;                // 1 ([] gives null)
[1, 2, 3, 4, 5].chunked(2);         // [[1, 2], [3, 4], [5]]
[1, null, 3].withoutNulls();        // [1, 3] as List<int>

[1, 2, 3, 4].sum;                   // 10
[1, 2, 3, 4].average;               // 2.5
users.groupBy((u) => u.country);    // Map<String, List<User>>

{'a': 1}.merge({'b': 2});           // {a: 1, b: 2}
prices.mapValues((p) => p * 1.2);
map.filter((key, value) => value > 0);
```

## Boolean helpers

```dart
true.toYesNo();                       // 'Yes'
false.toOnOff();                      // 'Off'
isDarkMode.choose(darkTheme, lightTheme);
isLoaded.whenTrue(() => showContent());
bool? flag;  flag.orFalse();          // false
```

## Flutter: BuildContext, spacing, colors

```dart
// BuildContext
context.theme; context.textTheme; context.colorScheme;
context.screenWidth; context.isDarkMode;
context.isMobile; context.isTablet; context.isDesktop; // <600, <1024, >=1024
context.showSnackBar('Saved!');
context.hideKeyboard();

// Spacing
Column(children: [title, 16.verticalSpace, body]);
Padding(padding: 16.allPadding, child: child);
BoxDecoration(borderRadius: 12.circularRadius);

// Separators between widgets
Column(children: items.separatedBy(const Divider()));

// Colors
'#FF5733'.toColor();          // Color(0xFFFF5733)
'#F53'.toColorOrNull();       // supports RGB, RRGGBB, AARRGGBB
color.toHex();                // '#FF5733'
color.darken(0.1); color.lighten(0.2);

// Status UI
isActive.toColor();           // green / red
isValid.toIcon();             // Icons.check / Icons.close
```

## Works with package:collection

`dart_tool_kit` never defines a member that would be ambiguous alongside `package:collection`, so both can be imported in the same file. For `firstWhereOrNull`, use `package:collection`.

## Contributing

Contributions are welcome! Open an issue or a pull request. Please add tests for any new extension and run:

```bash
dart format . && flutter analyze && flutter test
```

## License

MIT. See [LICENSE](LICENSE).
