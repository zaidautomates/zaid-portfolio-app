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
  testWidgets('login enters the portfolio app', (WidgetTester tester) async {
    await tester.pumpWidget(const ZaidPortfolioApp());

    expect(find.text('Enter Portfolio'), findsOneWidget);

    await tester.tap(find.text('Enter Portfolio'));
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
    expect(find.text('Projects'), findsOneWidget);
    expect(find.text('Contact'), findsOneWidget);
  });
}
