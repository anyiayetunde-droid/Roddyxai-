import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app/main.dart';

void main() {
  testWidgets('Claw app basic UI test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ClawApp());

    // Verify that the title is present.
    expect(find.text('Claw AI Assistant'), findsOneWidget);

    // Verify that the initial message is present.
    expect(find.text('Hello! I am Claw. How can I help you today?'), findsOneWidget);

    // Verify that the connect button is present.
    expect(find.byIcon(Icons.link_off), findsOneWidget);
  });
}
