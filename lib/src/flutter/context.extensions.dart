import 'package:flutter/material.dart';

/// Extensions on [BuildContext] for theme, media query and common UI actions.
///
/// The media query getters use the aspect-specific `MediaQuery.*Of` APIs
/// (e.g. [MediaQuery.sizeOf]), so a widget only rebuilds when the aspect it
/// reads changes.
extension ContextExtensions on BuildContext {
  /// Screen widths below this value are considered mobile.
  static const double mobileBreakpoint = 600;

  /// Screen widths below this value (and at least [mobileBreakpoint]) are
  /// considered tablet; anything wider is desktop.
  static const double tabletBreakpoint = 1024;

  /// The nearest [ThemeData].
  ///
  /// Example: `context.theme.primaryColor`
  ThemeData get theme => Theme.of(this);

  /// The [TextTheme] of the nearest theme.
  ///
  /// Example: `Text('Hi', style: context.textTheme.titleLarge)`
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// The [ColorScheme] of the nearest theme.
  ///
  /// Example: `Container(color: context.colorScheme.primary)`
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Whether the nearest theme has a dark [Brightness].
  ///
  /// Example: `context.isDarkMode ? Colors.white : Colors.black`
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// The logical size of the screen, from [MediaQuery.sizeOf].
  ///
  /// Example: `context.screenSize // Size(390.0, 844.0)`
  Size get screenSize => MediaQuery.sizeOf(this);

  /// The logical width of the screen.
  ///
  /// Example: `SizedBox(width: context.screenWidth * 0.5)`
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// The logical height of the screen.
  ///
  /// Example: `SizedBox(height: context.screenHeight / 3)`
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// The safe-area insets not covered by system UI or the keyboard, from
  /// [MediaQuery.paddingOf].
  ///
  /// Example: `Padding(padding: context.screenPadding)`
  EdgeInsets get screenPadding => MediaQuery.paddingOf(this);

  /// The parts of the screen obscured by system UI such as the keyboard,
  /// from [MediaQuery.viewInsetsOf].
  ///
  /// Example: `context.viewInsets.bottom // keyboard height`
  EdgeInsets get viewInsets => MediaQuery.viewInsetsOf(this);

  /// Whether [screenWidth] is below [mobileBreakpoint] (600).
  ///
  /// Example: `context.isMobile ? Column(...) : Row(...)`
  bool get isMobile => screenWidth < mobileBreakpoint;

  /// Whether [screenWidth] is at least [mobileBreakpoint] (600) and below
  /// [tabletBreakpoint] (1024).
  ///
  /// Example: `if (context.isTablet) showSidePanel()`
  bool get isTablet {
    final width = screenWidth;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  /// Whether [screenWidth] is at least [tabletBreakpoint] (1024).
  ///
  /// Example: `if (context.isDesktop) showNavigationRail()`
  bool get isDesktop => screenWidth >= tabletBreakpoint;

  /// Shows a [SnackBar] with [message] via the nearest [ScaffoldMessenger]
  /// and returns its controller.
  ///
  /// If [hideCurrent] is true (the default) the currently visible snack bar
  /// is hidden first instead of queueing behind it.
  ///
  /// Example: `context.showSnackBar('Saved')`
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 4),
    SnackBarAction? action,
    SnackBarBehavior? behavior,
    Color? backgroundColor,
    bool hideCurrent = true,
  }) {
    final messenger = ScaffoldMessenger.of(this);
    if (hideCurrent) messenger.hideCurrentSnackBar();
    return messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
        behavior: behavior,
        backgroundColor: backgroundColor,
      ),
    );
  }

  /// Removes focus from the current text field, dismissing the keyboard.
  ///
  /// Example: `GestureDetector(onTap: context.hideKeyboard, child: ...)`
  void hideKeyboard() => FocusScope.of(this).unfocus();
}
