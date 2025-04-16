[![Stand With Palestine](https://raw.githubusercontent.com/TheBSD/StandWithPalestine/main/banner-no-action.svg)](https://thebsd.github.io/StandWithPalestine)

# Dart Tool Kit

A comprehensive collection of extension methods for Flutter and Dart to boost your productivity with everyday tasks.

[![Pub Version](https://img.shields.io/pub/v/dart_tool_kit.svg)](https://pub.dev/packages/dart_tool_kit)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Overview

Dart Tool Kit provides useful extension methods for common Dart types like String, DateTime, int, and bool. These extensions eliminate boilerplate code and enhance readability, making your Flutter code more concise and expressive.

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  dart_tool_kit: ^0.1.0
```

Then run:

```bash
flutter pub get
```

## Features

### String Extensions

Enhance string manipulation with useful methods:

```dart
import 'package:dart_tool_kit/dart_tool_kit.dart';

// Case conversions
'helloWorld'.camelToWords();      // 'Hello World'
'hello world'.toTitleCase();      // 'Hello World'
'hello world'.toCamelCase();      // 'helloWorld'
'hello world'.toPascalCase();     // 'HelloWorld'
'hello world'.toSnakeCase();      // 'hello_world'
'hello world'.toKebabCase();      // 'hello-world'

// Validation
'example@email.com'.isValidEmail();  // true
'https://example.com'.isValidUrl();  // true
'12345'.isNumeric();                 // true

// Manipulation
'Hello World'.mask(start: 2, end: 2);  // 'He*** ***ld'
'Hello'.ellipsize(3);                  // 'Hel...'
'John Doe'.getInitials();              // 'JD'
```

### DateTime Extensions

Work with dates more efficiently:

```dart
import 'package:dart_tool_kit/dart_tool_kit.dart';

final now = DateTime.now();

// Formatting
now.toIsoDate;         // '2025-04-16'
now.toSlashFormat;     // '16/04/2025'
now.toReadableFormat;  // 'Wednesday, 16 Apr 2025'

// Date Calculations
now.startOfDay;        // beginning of today
now.endOfMonth;        // last moment of the current month
now.addDays(5);        // date 5 days from now
now.subtractMonths(1); // date 1 month ago

// Date Comparisons
now.isToday;       // true
now.isWeekend;     // false
now.isLeapYear;    // false
now.isSameDate(DateTime(2025, 4, 16)); // true

// Human Readable
now.timeAgo();     // e.g., '2 hours ago'
now.age;           // age in years from now
```

### Integer Extensions

Enhance numeric operations:

```dart
import 'package:dart_tool_kit/dart_tool_kit.dart';

// Formatting
// Usage
1000.toCurrency(symbol: '\$', decimalDigits: 0);  // '$1,000'
1000.toCurrency(symbol: '€', decimalDigits: 0);   // '€1,000'
1000.toCurrency(symbol: '₹', decimalDigits: 0);   // '₹1,000'
1000.toCurrency(symbol: '\$', decimalDigits: 2);  // '$1,000.00'
1000.toCurrency(symbol: 'Rs.', decimalDigits: 2);  // 'Rs.1,000.00'
123.toPercentage();      // '12300.00%'
123.toCompactString();   // '123'
123.toOrdinal();         // '123rd'
123.toBinary();          // '1111011'

// Time Conversion
5.toMinutes;         // Duration of 5 minutes
2.toDays;            // Duration of 2 days

// Range Operations
5.to(10);            // [5, 6, 7, 8, 9, 10]
10.times(() => print('Hello')); // Prints 'Hello' 10 times
```

### Boolean Extensions

Streamline boolean operations:

```dart
import 'package:dart_tool_kit/dart_tool_kit.dart';

// Conversions
true.toInt();        // 1
false.toYesNo();     // 'No'
true.toOnOff();      // 'On'

// Conditional Execution
isLoaded.whenTrue(() => showContent());
isError.whenFalse(() => hideErrorMessage());

// Choose between values
isDarkMode.choose(darkTheme, lightTheme);

// UI Helpers
isActive.toColor();  // Returns Colors.green if true, Colors.red if false
isValid.toIcon();    // Returns Icons.check if true, Icons.close if false
```

## Example

```dart
import 'package:flutter/material.dart';
import 'package:dart_tool_kit/dart_tool_kit.dart';

class UserProfile extends StatelessWidget {
  final String name;
  final String email;
  final DateTime birthDate;
  final bool isPremium;

  const UserProfile({
    required this.name,
    required this.email,
    required this.birthDate,
    required this.isPremium,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${name.toTitleCase()}'),
            Text('Email: ${email.isValidEmail() ? email : 'Invalid email'}'),
            Text('Age: ${birthDate.age}'),
            Text('Joined: ${birthDate.timeAgo()}'),
            Text('Status: ${isPremium.toCustomString(trueValue: 'Premium', falseValue: 'Standard')}'),
            Icon(isPremium.toIcon()),
          ],
        ),
      ),
    );
  }
}
```

### List Extensions

Streamline List operations:

```dart
import 'package:dart_tool_kit/dart_tool_kit.dart';

// Safe Access
list.safeFirst;    // Returns first element or null if empty
list.safeLast;     // Returns last element or null if empty
list.isNotNullOrEmpty; // Returns true if list is not empty

// List Utilities
list.chunked(3);   // Splits list into chunks of 3
list.withoutNulls(); // Removes all nulls from the list
```

### Map Extensions

Streamline Map operations:

```dart
import 'package:dart_tool_kit/dart_tool_kit.dart';

// Merging Maps
map.merge(otherMap);  // Merges another map into the current one

// Transforming Keys and Values
map.mapValues((value) => value.toString());  // Transforms values
map.mapKeys((key) => key.toString());  // Transforms keys

// Filtering Maps
map.filter((key, value) => key == 'desiredKey');  // Filters map based on condition
```

### Iterable Extensions

Streamline Iterable operations:

```dart
import 'package:dart_tool_kit/dart_tool_kit.dart';

// Safe Access
iterable.isNotNullOrEmpty; // Returns true if iterable is not empty

// Grouping and Summarizing
iterable.groupBy((element) => element.toString()); // Groups elements by key
iterable.sum; // Returns the sum of all numeric elements
iterable.average; // Returns the average of all numeric elements

// Safe Access to First Matching Element
iterable.firstWhereOrNull((element) => element == 'desiredValue');  // Returns first match or null
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
