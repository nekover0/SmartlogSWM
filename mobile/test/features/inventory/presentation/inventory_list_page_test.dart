import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:smartlog_swm_mobile/features/inventory/presentation/pages/inventory_list_page.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_theme.dart';

void main() {
  Widget buildSubject() {
    final router = GoRouter(
      initialLocation: '/inventory',
      routes: <RouteBase>[
        GoRoute(
          path: '/inventory',
          builder: (BuildContext context, GoRouterState state) {
            return const InventoryListPage();
          },
        ),
        GoRoute(
          path: '/inventory/:inventoryId',
          builder: (BuildContext context, GoRouterState state) {
            return Scaffold(
              body: Center(
                child: Text('detail-${state.pathParameters['inventoryId']}'),
              ),
            );
          },
        ),
      ],
    );

    return MaterialApp.router(theme: AppTheme.light(), routerConfig: router);
  }

  testWidgets('renders inventory screen sections matching design', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    expect(find.text('Tồn kho hiện tại (142)'), findsOneWidget);
    expect(find.text('Sắp xếp: SKU'), findsOneWidget);
    expect(find.byKey(const Key('inventory_add_new_button')), findsOneWidget);
    expect(find.byKey(const Key('inventory_filter_lowStock')), findsOneWidget);
    expect(find.text('Cảm biến nhiệt Thermal GX-90'), findsOneWidget);
    expect(find.text('Industrial Hub Switch 24-Port'), findsOneWidget);
  });

  testWidgets('filters low stock cards', (WidgetTester tester) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('inventory_filter_lowStock')));
    await tester.pumpAndSettle();

    expect(find.text('Cảm biến nhiệt Thermal GX-90'), findsOneWidget);
    expect(find.text('Cáp Quang Fiber Optic (50m)'), findsOneWidget);
    expect(find.text('Industrial Hub Switch 24-Port'), findsNothing);
    expect(find.text('Lithium Power Module 12V'), findsNothing);
  });

  testWidgets('opens inventory detail when tapping a card', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(buildSubject());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('inventory_card_inv-smt-9022-x')));
    await tester.pumpAndSettle();

    expect(find.text('detail-inv-smt-9022-x'), findsOneWidget);
  });
}
