## [0.3.0] - 2026-10-14

This release contains breaking changes. See **Breaking** below before upgrading.

### Added

- **Null-safety helpers** for `String?`, `int?`, `double?`, `num?`, `Iterable?`, `List?`, `Set?` and `Map?`: `isNullOrEmpty`, `isNotNullOrEmpty`, `isNullOrBlank`, `isNotNullOrBlank`, `orEmpty`, `orZero`, and `orElse(fallback)` on any nullable value.
- **JSON reading** on `Map<String, dynamic>`: `getString`, `getInt`, `getDouble`, `getNum`, `getBool`, `getDateTime`, `getList<T>`, `getMap`, each with a non-null `get…Or(key, fallback)` variant. Also `getPath('user.address.city')`, `removeNulls({deep})` and `toQueryString()`. None of them throw on a missing key or a wrong type.
- **Duration helpers**: `toClock()` (`01:02:05`), `toReadable()` (`1h 2m 5s`, long form, `maxUnits`), `delay()`, `inFractionalSeconds`, and `2.seconds` / `1.5.hours` style getters on `num`.
- **Form validators**: the `Validators` class (`required`, `email`, `minLength`, `maxLength`, `pattern`, `numeric`, `integer`, `min`, `max`, `phone`, `url`, `strongPassword`, `match`, `compose`) plugs straight into `TextFormField.validator`.
- **Flutter helpers**: `BuildContext` shortcuts (`context.theme`, `colorScheme`, `screenWidth`, `isDarkMode`, `isMobile` / `isTablet` / `isDesktop`, `showSnackBar`, `hideKeyboard`), spacing (`16.verticalSpace`, `8.allPadding`, `12.circularRadius`), hex colors (`'#FF5733'.toColor()`, `color.toHex()`, `darken` / `lighten`), and `widgets.separatedBy(divider)`. 8-digit hex is `AARRGGBB` (alpha first, like `Color(0xAARRGGBB)`), not CSS `RRGGBBAA`.
- `timeAgo()` handles future dates (`in 3 days`), singular units and `just now`, and accepts a `now:` parameter for testing.
- `bool.timeExecution` accepts an `onElapsed` callback.
- Example app in `example/`, and a CI workflow.

### Fixed

- `package:dart_tool_kit/dart_tool_kit.dart` now exports every extension. Previously only the String extensions were exported, so the bool, DateTime, int, List, Map and Iterable extensions were unreachable through the public import.
- `toSnakeCase` / `toKebabCase` now handle spaces (`'hello world'` → `hello_world`). All case converters understand acronyms and Unicode, and `toCamelCase('')` no longer throws.
- `weekOfYear` returns the correct ISO-8601 week number.
- `addMonths` / `addYears` clamp to the end of the month (Jan 31 + 1 month → Feb 28/29) instead of overflowing into the next month. Adding negative months across a year boundary is also fixed.
- Date helpers keep the UTC flag and count calendar days correctly across daylight-saving changes.
- `reverse` / `isPalindrome` no longer break emoji. `safeSubstring` no longer throws for out-of-range indices. `countOccurrences('')` returns 0.
- `twoDigits`, `toOrdinal` and `reverseDigits` handle negative numbers.

### Breaking

- Removed `String.isNullOrEmpty()`. Use `isNullOrBlank` (works on `String` and `String?`).
- Removed `Iterable.firstWhereOrNull`. It clashed with `package:collection` and caused compile errors in apps that import both. Use `package:collection`.
- Removed `int.isEven`, `isOdd`, `isNegative`, `bitLength`. They were shadowed by the built-in members and never ran.
- Removed `DateTime.firstDayOfWeek` / `lastDayOfWeek`. Use `startOfWeek` / `endOfWeek`, which now return Monday 00:00 and Sunday 23:59:59.999.
- `nextMonday` / `previousMonday` always move to a different Monday.
- `addMonths`, `addYears`, `subtractMonths` clamp to the month end. `addDays`, `subtractDays`, `nextWeek`, `previousWeek` use calendar days.
- `timeAgo()` wording changed (`just now`, `1 minute ago`, `in 2 hours`).
- `factorial` (negative), `percentOf(0)`, `roundToNearest(0)`, `to(step <= 0)`, and negative arguments to `ellipsize` / `mask` now throw `ArgumentError`.
- `isPowerOfTwo` is `false` for negatives. `times` takes `void Function()`.
- `withoutNulls()` now returns a non-nullable `List<T>`.
- Case converters split on more word boundaries, so `'helloWorld'.toCamelCase()` returns `helloWorld` (previously `helloworld`).
- `toBool` trims whitespace. `isValidUrl` accepts ports, queries and fragments.
- Minimum SDK raised to Dart 3.6 / Flutter 3.27 (required by the `crypto` / `intl` dependencies and the new `Color` API).

## [0.2.1]

### Changed

- Documentation and license updates.

## [0.2.0] - 2025-04-16

### Added

- Added `ListExtensions` with methods like `safeFirst`, `safeLast`, `chunked`, and `withoutNulls`.
- Introduced `MapExtensions` with methods for merging maps and transforming keys/values.
- Added `IterableExtensions` for summarizing data (sum, average) and safe access (`firstWhereOrNull`).

### Changed

- Improved date formatting in `DateTimeExtensions`.

## [0.1.0] - 2025-04-16

### Added

- Initial release with `boolean`, `string`, `number`, and `date` extensions.
