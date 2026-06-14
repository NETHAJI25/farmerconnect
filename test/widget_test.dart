import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:farmconnect/main.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: const FarmConnectApp()));
    expect(find.text('FarmConnect'), findsOneWidget);
  });
}
