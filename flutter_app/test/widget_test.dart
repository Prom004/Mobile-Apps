// This is a basic Flutter widget test for the Todo App.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_app/main.dart';

void main() {
  testWidgets('Todo App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyAppState());
    await tester.pumpAndSettle();

    // Verify that the login page is displayed initially
    expect(find.text('Todo App'), findsAtLeast(1));
    expect(find.text('Sign in to manage your tasks'), findsOneWidget);

    // Verify that email and password fields are present
    expect(find.byType(TextFormField), findsAtLeast(2));

    // Verify that the Sign In button is present
    expect(find.byType(ElevatedButton), findsAtLeast(1));

    // Verify that the app icon is present
    expect(find.byIcon(Icons.checklist_rounded), findsOneWidget);
  });

  testWidgets('Login page demo credentials test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyAppState());

    // Wait for the widget to settle
    await tester.pumpAndSettle();

    // Tap the Quick Demo button
    await tester.tap(find.text('Quick Demo'));
    await tester.pumpAndSettle();

    // Verify that demo credentials are filled in the text fields
    final emailField = find.byType(TextFormField).first;
    final emailWidget = tester.widget<TextFormField>(emailField);
    expect(emailWidget.controller?.text, 'demo@todo.com');
  });
}
