import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:smartlog_swm_mobile/features/inventory/data/repositories/inventory_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/inventory/domain/models/inventory_models.dart';
import 'package:smartlog_swm_mobile/features/inventory/domain/repositories/inventory_repository.dart';
import 'package:smartlog_swm_mobile/features/inventory/presentation/pages/inventory_detail_page.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_theme.dart';

void main() {
  Widget buildSubject(String id, {required InventoryRepository repository}) {
    return ProviderScope(
      overrides: [
        inventoryRepositoryProvider.overrideWithValue(repository),
      ],
      child: MaterialApp(
        theme: AppTheme.light(),
        home: InventoryDetailPage(inventoryId: id),
      ),
    );
  }

  testWidgets('renders inventory detail sections for known inventory id', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(
        'inv-smt-9022-x',
        repository: _FakeInventoryRepository(),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('inventory_detail_back_button')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('inventory_detail_header')), findsOneWidget);
    expect(find.byKey(const Key('inventory_detail_summary')), findsOneWidget);
    expect(find.text('Cảm biến nhiệt Thermal GX-90'), findsOneWidget);
    expect(find.text('SKU SMT-9022-X'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.byKey(const Key('inventory_detail_location')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('inventory_detail_location')), findsOneWidget);

    await tester.scrollUntilVisible(
      find.byKey(const Key('inventory_detail_timeline')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('inventory_detail_timeline')), findsOneWidget);
  });

  testWidgets('shows empty history state when timeline is absent', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildSubject(
        'inv-net-4402-b',
        repository: _FakeInventoryRepository(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.scrollUntilVisible(
      find.byKey(const Key('inventory_detail_timeline')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Chưa có lịch sử thay đổi'), findsOneWidget);
    expect(find.byKey(const Key('inventory_detail_timeline')), findsOneWidget);
  });

  testWidgets('shows error state for unknown inventory id', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      buildSubject('missing-id', repository: _FakeInventoryRepository()),
    );
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
      ProviderScope(
        overrides: [
          inventoryRepositoryProvider.overrideWithValue(_FakeInventoryRepository()),
        ],
        child: MaterialApp.router(theme: AppTheme.light(), routerConfig: router),
      ),
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

class _FakeInventoryRepository implements InventoryRepository {
  @override
  Future<InventoryDetailEntity> getInventoryDetail(String inventoryId) async {
    final item = (await getInventoryItems()).firstWhere(
      (entry) => entry.id == inventoryId,
    );

    final timeline = switch (inventoryId) {
      'inv-smt-9022-x' => <InventoryTimelineEventEntity>[
        InventoryTimelineEventEntity(
          type: 'adjustment',
          label: 'Kiểm kê gần nhất',
          occurredAt: DateTime(2026, 3, 25, 9, 20),
          deltaQty: 0,
        ),
        InventoryTimelineEventEntity(
          type: 'issue',
          label: 'Xuất kho gần nhất',
          occurredAt: DateTime(2026, 3, 25, 8, 40),
          deltaQty: -8,
        ),
        InventoryTimelineEventEntity(
          type: 'receipt',
          label: 'Nhập kho gần nhất',
          occurredAt: DateTime(2026, 3, 24, 10, 15),
          deltaQty: 20,
        ),
      ],
      _ => const <InventoryTimelineEventEntity>[],
    };

    return InventoryDetailEntity(
      item: item,
      priority: item.isLowStock ? 'Cao' : 'Binh thuong',
      timelineEvents: timeline,
    );
  }

  @override
  Future<List<InventoryItemEntity>> getInventoryItems() async {
    return <InventoryItemEntity>[
      _buildItem(
        id: 'inv-smt-9022-x',
        skuCode: 'SMT-9022-X',
        itemName: 'Cảm biến nhiệt Thermal GX-90',
        locationCode: 'Aisle 4 / Bin B-12',
        batchNo: 'LOT-24-03-21',
        zoneCode: 'Khu cảm biến',
        availableQty: 9,
        physicalQty: 12,
        warningThreshold: 15,
      ),
      _buildItem(
        id: 'inv-net-4402-b',
        skuCode: 'NET-4402-B',
        itemName: 'Industrial Hub Switch 24-Port',
        locationCode: 'Zone C / Shelf 09',
        batchNo: 'LOT-24-02-11',
        zoneCode: 'Khu thiết bị mạng',
        availableQty: 432,
        physicalQty: 450,
        warningThreshold: 50,
      ),
    ];
  }
}

InventoryItemEntity _buildItem({
  required String id,
  required String skuCode,
  required String itemName,
  required String locationCode,
  required String batchNo,
  required String zoneCode,
  required double availableQty,
  required double physicalQty,
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
    zoneCode: zoneCode,
    shelfCode: locationCode,
    batchNo: batchNo,
    physicalQty: physicalQty,
    allocatedQty: physicalQty - availableQty,
    availableQty: availableQty,
    warningThreshold: warningThreshold,
    uomCode: 'PCS',
    inventoryStatusCode: 'AVAILABLE',
    inventoryStatusAllocatable: true,
    syncState: SyncState.synced,
  );
}
