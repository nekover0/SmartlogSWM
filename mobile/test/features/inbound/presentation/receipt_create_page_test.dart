import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/features/inbound/presentation/pages/receipt_create_page.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_theme.dart';

void main() {
  Future<void> setLargeSurface(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(1440, 2600);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
  }

  testWidgets('renders receipt create form actions', (
    WidgetTester tester,
  ) async {
    await setLargeSurface(tester);
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light(), home: const ReceiptCreatePage()),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('receipt_create_back_button')), findsOneWidget);
    expect(
      find.byKey(const Key('receipt_create_add_line_button')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('receipt_create_submit_button')),
      findsOneWidget,
    );
    expect(find.text('Tao phieu nhap'), findsOneWidget);
  });

  testWidgets('adds new line editor when tapping add line button', (
    WidgetTester tester,
  ) async {
    await setLargeSurface(tester);
    await tester.pumpWidget(
      MaterialApp(theme: AppTheme.light(), home: const ReceiptCreatePage()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Line 1'), findsOneWidget);
    expect(find.text('Line 2'), findsNothing);

    await tester.scrollUntilVisible(
      find.byKey(const Key('receipt_create_add_line_button')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.byKey(const Key('receipt_create_add_line_button')));
    await tester.pumpAndSettle();

    expect(find.text('Line 2'), findsOneWidget);
  });
}
