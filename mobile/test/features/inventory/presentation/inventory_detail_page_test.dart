import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:smartlog_swm_mobile/features/inventory/presentation/pages/inventory_detail_page.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_theme.dart';

void main() {
  Widget buildSubject(String id) {
    return MaterialApp(
      theme: AppTheme.light(),
      home: InventoryDetailPage(inventoryId: id),
    );
  }

  testWidgets('renders inventory detail sections for known inventory id', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildSubject('inv-smt-9022-x'));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('inventory_detail_back_button')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('inventory_detail_header')), findsOneWidget);
    expect(find.byKey(const Key('inventory_detail_summary')), findsOneWidget);
    expect(find.byKey(const Key('inventory_detail_location')), findsOneWidget);
    expect(find.byKey(const Key('inventory_detail_timeline')), findsOneWidget);
    expect(find.text('Cảm biến nhiệt Thermal GX-90'), findsOneWidget);
    expect(find.text('SKU: SMT-9022-X'), findsOneWidget);
  });

  testWidgets('shows empty history state when timeline is absent', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildSubject('inv-net-4402-b'));
    await tester.pumpAndSettle();

    expect(find.text('Chưa có lịch sử thay đổi'), findsOneWidget);
    expect(find.byKey(const Key('inventory_detail_timeline')), findsNothing);
  });

  testWidgets('shows error state for unknown inventory id', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildSubject('missing-id'));
    await tester.pumpAndSettle();

    expect(find.text('Không tìm thấy hàng hóa'), findsOneWidget);
    expect(find.textContaining('missing-id'), findsOneWidget);
  });

  testWidgets('back button pops route when stack can pop', (
    WidgetTester tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/a',
      routes: <RouteBase>[
        GoRoute(
          path: '/a',
          builder: (BuildContext context, GoRouterState state) {
            return Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => context.push('/b'),
                  child: const Text('open'),
                ),
              ),
            );
          },
        ),
        GoRoute(
          path: '/b',
          builder: (BuildContext context, GoRouterState state) {
            return const InventoryDetailPage(inventoryId: 'inv-smt-9022-x');
          },
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(theme: AppTheme.light(), routerConfig: router),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.byType(InventoryDetailPage), findsOneWidget);

    await tester.tap(find.byKey(const Key('inventory_detail_back_button')));
    await tester.pumpAndSettle();

    expect(find.byType(InventoryDetailPage), findsNothing);
    expect(find.text('open'), findsOneWidget);
  });
}
