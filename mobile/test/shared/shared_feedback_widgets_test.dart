import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_theme.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_empty_state.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_error_state.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_forbidden_state.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_loading_view.dart';

void main() {
  Future<void> pumpTestApp(WidgetTester tester, Widget child) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: child),
      ),
    );
  }

  testWidgets('AppLoadingView renders an optional message', (
    WidgetTester tester,
  ) async {
    await pumpTestApp(
      tester,
      const AppLoadingView(message: 'Đang tải dữ liệu...'),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Đang tải dữ liệu...'), findsOneWidget);
  });

  testWidgets('AppErrorState renders retry action and triggers callback', (
    WidgetTester tester,
  ) async {
    var retryTapped = false;

    await pumpTestApp(
      tester,
      AppErrorState(
        onRetry: () {
          retryTapped = true;
        },
      ),
    );

    await tester.tap(find.text('Thử lại'));
    await tester.pump();

    expect(find.text('Đã có lỗi xảy ra'), findsOneWidget);
    expect(retryTapped, isTrue);
  });

  testWidgets('AppEmptyState renders message and optional retry button', (
    WidgetTester tester,
  ) async {
    await pumpTestApp(
      tester,
      const AppEmptyState(
        title: 'Chưa có phiếu nào',
        message: 'Thử đổi bộ lọc để xem dữ liệu khác.',
      ),
    );

    expect(find.text('Chưa có phiếu nào'), findsOneWidget);
    expect(find.text('Thử đổi bộ lọc để xem dữ liệu khác.'), findsOneWidget);
    expect(find.text('Tải lại'), findsNothing);
  });

  testWidgets('AppForbiddenState renders retry button when provided', (
    WidgetTester tester,
  ) async {
    await pumpTestApp(
      tester,
      const AppForbiddenState(
        onRetry: null,
      ),
    );

    expect(find.text('Bạn không có quyền truy cập'), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline_rounded), findsOneWidget);
    expect(find.text('Thử lại'), findsNothing);
  });
}
