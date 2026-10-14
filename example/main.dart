// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:dart_tool_kit/dart_tool_kit.dart';
import 'package:flutter/material.dart';

void main() {
  // Null safety
  String? nickname;
  print(nickname.isNullOrBlank); // true
  print(nickname.orElse('Guest')); // Guest

  // Safe JSON parsing
  final json = jsonDecode('{"age": "25", "user": {"city": "Karachi"}}')
      as Map<String, dynamic>;
  print(json.getInt('age')); // 25
  print(json.getIntOr('missing', 0)); // 0
  print(json.getPath('user.city')); // Karachi

  // Validators
  final emailValidator = Validators.compose([
    Validators.required(),
    Validators.email(),
  ]);
  print(emailValidator('not-an-email')); // Please enter a valid email address

  // Duration
  print(const Duration(seconds: 3725).toClock()); // 01:02:05
  print(90.seconds.toReadable(longForm: true)); // 1 minute 30 seconds

  // DateTime
  final date = DateTime(2025, 1, 31);
  print(date.toReadableFormat); // Friday, 31 Jan 2025
  print(date.addMonths(1).toIsoDate); // 2025-02-28

  // String
  print('hello world'.toSnakeCase()); // hello_world
  print('John Doe'.getInitials()); // JD

  // Numbers and collections
  print(1000.toCurrency(decimalDigits: 2)); // $1,000.00
  print([1, 2, 3, 4, 5].chunked(2)); // [[1, 2], [3, 4], [5]]

  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          body: Padding(
            padding: 16.allPadding,
            child: Column(
              children: [
                Text('Width: ${context.screenWidth}'),
                Text('Tablet: ${context.isTablet.toYesNo()}'),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: '#FF5733'.toColor(),
                    borderRadius: 12.circularRadius,
                  ),
                ),
              ].separatedBy(16.verticalSpace),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => context.showSnackBar('Saved!'),
            child: const Icon(Icons.check),
          ),
        ),
      ),
    );
  }
}
