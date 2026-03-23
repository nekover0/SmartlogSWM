import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/app/app.dart';

void main() {
  testWidgets('Smartlog app boots from the root widget', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: SmartlogApp()));
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('Đăng nhập hệ thống'), findsOneWidget);
  });
}
