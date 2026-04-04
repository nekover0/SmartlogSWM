import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:smartlog_swm_mobile/features/inventory/data/repositories/inventory_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/inventory/domain/models/inventory_models.dart';
import 'package:smartlog_swm_mobile/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:smartlog_swm_mobile/features/inventory/presentation/pages/inventory_list_page.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_theme.dart';

void main() {
  Widget buildSubject({required InventoryRepository inventoryRepository}) {
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

    return ProviderScope(
      overrides: [
        inventoryRepositoryProvider.overrideWithValue(inventoryRepository),
      ],
      child: MaterialApp.router(theme: AppTheme.light(), routerConfig: router),
    );
  }

  testWidgets('renders inventory screen sections matching design', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(inventoryRepository: _FakeInventoryRepository()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tồn kho hiện tại (4)'), findsOneWidget);
    expect(find.text('Sắp xếp: SKU'), findsOneWidget);
    expect(find.byKey(const Key('inventory_add_new_button')), findsOneWidget);
    expect(find.byKey(const Key('inventory_filter_lowStock')), findsOneWidget);
    expect(find.text('Cảm biến nhiệt Thermal GX-90'), findsOneWidget);
    expect(find.text('Industrial Hub Switch 24-Port'), findsOneWidget);
  });

  testWidgets('filters low stock cards', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildSubject(inventoryRepository: _FakeInventoryRepository()),
    );
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
    await tester.pumpWidget(
      buildSubject(inventoryRepository: _FakeInventoryRepository()),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('inventory_card_inv-smt-9022-x')));
    await tester.pumpAndSettle();

    expect(find.text('detail-inv-smt-9022-x'), findsOneWidget);
  });
}

class _FakeInventoryRepository implements InventoryRepository {
  @override
  Future<InventoryDetailEntity> getInventoryDetail(String inventoryId) async {
    final item = (await getInventoryItems()).firstWhere(
      (entry) => entry.id == inventoryId,
    );

    return InventoryDetailEntity(
      item: item,
      priority: item.isLowStock ? 'Cao' : 'Binh thuong',
      timelineEvents: const <InventoryTimelineEventEntity>[],
    );
  }

  @override
  Future<List<InventoryItemEntity>> getInventoryItems() async {
    return <InventoryItemEntity>[
      _buildItem(
        id: 'inv-smt-9022-x',
        skuCode: 'SMT-9022-X',
        itemName: 'Cảm biến nhiệt Thermal GX-90',
        locationCode: 'Aisle 4, Bin B-12',
        availableQty: 12,
        warningThreshold: 15,
      ),
      _buildItem(
        id: 'inv-net-4402-b',
        skuCode: 'NET-4402-B',
        itemName: 'Industrial Hub Switch 24-Port',
        locationCode: 'Zone C, Shelf 09',
        availableQty: 450,
        warningThreshold: 40,
      ),
      _buildItem(
        id: 'inv-cbl-50-fbr',
        skuCode: 'CBL-50-FBR',
        itemName: 'Cáp Quang Fiber Optic (50m)',
        locationCode: 'Bulk Storage, Row 2',
        availableQty: 5,
        warningThreshold: 10,
      ),
      _buildItem(
        id: 'inv-pwr-mod-88',
        skuCode: 'PWR-MOD-88',
        itemName: 'Lithium Power Module 12V',
        locationCode: 'Aisle 2, Bin A-04',
        availableQty: 84,
        warningThreshold: 20,
      ),
    ];
  }
}

InventoryItemEntity _buildItem({
  required String id,
  required String skuCode,
  required String itemName,
  required String locationCode,
  required double availableQty,
  required double warningThreshold,
}) {
  return InventoryItemEntity(
    id: id,
    itemId: id,
    skuCode: skuCode,
    itemName: itemName,
    warehouseCode: 'WH-01',
    warehouseName: 'Sai Gon Distribution Center',
    locationCode: locationCode,
    ownerCode: 'OWNER-01',
    zoneCode: locationCode,
    shelfCode: locationCode,
    batchNo: 'LOT-01',
    physicalQty: availableQty,
    allocatedQty: 0,
    availableQty: availableQty,
    warningThreshold: warningThreshold,
    uomCode: 'PCS',
    inventoryStatusCode: 'AVAILABLE',
    inventoryStatusAllocatable: true,
    syncState: SyncState.synced,
  );
}
