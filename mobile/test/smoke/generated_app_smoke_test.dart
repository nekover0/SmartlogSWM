import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/main.dart';

void main() {
  testWidgets('generated app renders a MaterialApp', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
