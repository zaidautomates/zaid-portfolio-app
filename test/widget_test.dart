// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:zaid_portfolio_app/main.dart';

void main() {
  testWidgets('valid credentials enter portfolio and open project details', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ZaidPortfolioApp());

    expect(find.text('Enter Portfolio'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'wrong@test.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'wrongpass');
    await tester.ensureVisible(find.text('Enter Portfolio'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Enter Portfolio'));
    await tester.pumpAndSettle();

    expect(find.text('Invalid email or password.'), findsOneWidget);
    expect(find.text('Enter Portfolio'), findsOneWidget);

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'zaidautomates@gmail.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'Zaid@2026');
    await tester.ensureVisible(find.text('Enter Portfolio'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Enter Portfolio'));
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsWidgets);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Projects'), findsWidgets);
    expect(find.text('Contact'), findsWidgets);

    await tester.tap(find.text('Projects').last);
    await tester.pumpAndSettle();

    expect(find.text('Personal Portfolio Mobile App'), findsOneWidget);

    await tester.ensureVisible(find.text('View Project').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('View Project').first);
    await tester.pumpAndSettle();

    expect(find.text('Project Details'), findsOneWidget);
    expect(find.text('Technologies Used'), findsOneWidget);
  });
}
