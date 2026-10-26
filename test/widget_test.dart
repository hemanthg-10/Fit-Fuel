import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_first_app/main.dart';

void main() {
  testWidgets('start page renders on a compact mobile viewport', (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MyApp());

    expect(find.text('FitFuel'), findsOneWidget);
    expect(find.text('Start'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('login validation blocks empty credentials', (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Start'));
    await tester.pumpAndSettle();
    expect(find.widgetWithText(ElevatedButton, 'Login'), findsOneWidget);

    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.text('Please enter your name.'), findsOneWidget);
    expect(find.text('Please enter your password.'), findsOneWidget);
  });

  testWidgets('login validation rejects short and numeric names and short password',
      (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Start'));
    await tester.pumpAndSettle();

    final loginButton = find.widgetWithText(ElevatedButton, 'Login');
    final nameField = find.byType(TextFormField).at(0);
    final passwordField = find.byType(TextFormField).at(1);

    await tester.enterText(nameField, 'A');
    await tester.enterText(passwordField, 'secret');
    await tester.tap(loginButton);
    await tester.pumpAndSettle();
    expect(find.text('Name must be at least 2 characters.'), findsOneWidget);

    await tester.enterText(nameField, 'Alex1');
    await tester.pumpAndSettle();
    expect(find.text('Name cannot contain numbers.'), findsOneWidget);

    await tester.enterText(nameField, 'Alex');
    await tester.enterText(passwordField, '123');
    await tester.pumpAndSettle();
    expect(find.text('Password must be at least 6 characters.'), findsOneWidget);
  });

  testWidgets('valid credentials open dashboard and logout returns home',
      (tester) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.text('Start'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'Alex');
    await tester.enterText(find.byType(TextFormField).at(1), 'secret1');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.text('Hi, Alex'), findsOneWidget);
    expect(find.text('Macros today'), findsOneWidget);
    expect(find.text('750 kcal left to reach today\'s goal.'), findsOneWidget);

    await tester.ensureVisible(find.text('Logout'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();
    expect(find.text('FitFuel'), findsOneWidget);
    expect(find.text('Start'), findsOneWidget);
  });
}

