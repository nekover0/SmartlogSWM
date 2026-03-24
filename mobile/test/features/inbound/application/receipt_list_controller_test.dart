import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/features/inbound/application/controllers/receipt_list_controller.dart';
import 'package:smartlog_swm_mobile/features/inbound/data/contracts/receipt_contract.dart';
import 'package:smartlog_swm_mobile/features/inbound/data/repositories/receipt_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/inbound/domain/repositories/receipt_repository.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';

void main() {
  group('ReceiptListController', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          receiptRepositoryProvider.overrideWithValue(_FakeReceiptRepository()),
        ],
      );
      addTearDown(container.dispose);
    });

    test(
      'loads receipts, exposes status chips, and sorts active work first',
      () async {
        final state = await container.read(
          receiptListControllerProvider.future,
        );

        expect(state.totalCount, 4);
        expect(state.activeCount, 3);
        expect(state.availableStatuses, <ReceiptStatus>[
          ReceiptStatus.confirmed,
          ReceiptStatus.waitingForWeighing,
          ReceiptStatus.weighing1,
          ReceiptStatus.completed,
        ]);
        expect(
          state.visibleItems.map((receipt) => receipt.id).toList(),
          <String>[
            'rcp-20260323-001',
            'rcp-20260323-003',
            'rcp-20260323-002',
            'rcp-20260323-004',
          ],
        );
      },
    );

    test(
      'filters by status and search query without mutating source data',
      () async {
        await container.read(receiptListControllerProvider.future);

        container
            .read(receiptListControllerProvider.notifier)
            .setStatusFilter(ReceiptStatus.waitingForWeighing);

        expect(
          container
              .read(receiptListControllerProvider)
              .valueOrNull
              ?.visibleItems
              .map((receipt) => receipt.id)
              .toList(),
          <String>['rcp-20260323-001'],
        );

        container
            .read(receiptListControllerProvider.notifier)
            .setSearchQuery('8899');

        expect(
          container
              .read(receiptListControllerProvider)
              .valueOrNull
              ?.visibleItems,
          isEmpty,
        );

        container.read(receiptListControllerProvider.notifier).clearFilters();
        container
            .read(receiptListControllerProvider.notifier)
            .setSearchQuery('61h-55088');

        expect(
          container
              .read(receiptListControllerProvider)
              .valueOrNull
              ?.visibleItems
              .map((receipt) => receipt.id)
              .toList(),
          <String>['rcp-20260323-002'],
        );
      },
    );
  });
}

class _FakeReceiptRepository implements ReceiptRepository {
  @override
  Future<ReceiptEntity> getReceiptById(String receiptId) async {
    return _receipts.firstWhere((receipt) => receipt.id == receiptId);
  }

  @override
  Future<List<ReceiptEntity>> getReceipts() async {
    return _receipts;
  }

  static final List<ReceiptEntity> _receipts = <ReceiptEntity>[
    ReceiptEntity(
      id: 'rcp-20260323-001',
      receiptNo: 'RCP-240323-001',
      status: ReceiptStatus.waitingForWeighing,
      owner: const OwnerSummary(
        id: 'owner-001',
        code: 'VINAMILK',
        name: 'Vinamilk Logistics',
      ),
      warehouse: const WarehouseSummary(
        id: 'warehouse-001',
        code: 'BDG-WH-02',
        name: 'Binh Duong Overflow Warehouse',
      ),
      vehicle: const VehicleInfo(
        plateNumber: '51D-12345',
        driverName: 'Nguyen Minh Quan',
      ),
      purchaseOrderNo: 'PO-240323-001',
      billOfLadingNo: 'BL-240323-001',
      vesselName: 'MV Mekong Star',
      expectedWeightKg: 18250.0,
      receivedWeightKg: 0.0,
      portWeightKg: 18300.0,
      varianceWeightKg: 0.0,
      syncState: SyncState.synced,
      availableActions: const <ActionCapability>[
        ActionCapability(
          type: TaskActionType.startWeighing,
          label: 'Bắt đầu cân',
        ),
      ],
      createdAt: DateTime.utc(2026, 3, 24, 6, 40),
      updatedAt: DateTime.utc(2026, 3, 24, 8, 5),
    ),
    ReceiptEntity(
      id: 'rcp-20260323-002',
      receiptNo: 'RCP-240323-002',
      status: ReceiptStatus.confirmed,
      owner: const OwnerSummary(
        id: 'owner-002',
        code: 'MASAN',
        name: 'Masan Consumer',
      ),
      warehouse: const WarehouseSummary(
        id: 'warehouse-001',
        code: 'BDG-WH-02',
        name: 'Binh Duong Overflow Warehouse',
      ),
      vehicle: const VehicleInfo(
        plateNumber: '61H-55088',
        driverName: 'Tran Dinh Bao',
      ),
      purchaseOrderNo: 'PO-240323-002',
      billOfLadingNo: 'BL-240323-002',
      expectedWeightKg: 16000.0,
      receivedWeightKg: 0.0,
      varianceWeightKg: 0.0,
      syncState: SyncState.pending,
      createdAt: DateTime.utc(2026, 3, 24, 7, 15),
      updatedAt: DateTime.utc(2026, 3, 24, 7, 55),
    ),
    ReceiptEntity(
      id: 'rcp-20260323-003',
      receiptNo: 'RCP-240323-003',
      status: ReceiptStatus.weighing1,
      owner: const OwnerSummary(
        id: 'owner-003',
        code: 'NESTLE',
        name: 'Nestle Vietnam',
      ),
      warehouse: const WarehouseSummary(
        id: 'warehouse-002',
        code: 'SGN-DC-01',
        name: 'Sai Gon Distribution Center',
      ),
      vehicle: const VehicleInfo(
        plateNumber: '50H-22114',
        driverName: 'Le Van Tuan',
      ),
      purchaseOrderNo: 'PO-240323-003',
      billOfLadingNo: 'BL-8899-003',
      expectedWeightKg: 12400.0,
      receivedWeightKg: 12180.0,
      varianceWeightKg: -220.0,
      syncState: SyncState.synced,
      createdAt: DateTime.utc(2026, 3, 24, 5, 30),
      updatedAt: DateTime.utc(2026, 3, 24, 7, 20),
    ),
    ReceiptEntity(
      id: 'rcp-20260323-004',
      receiptNo: 'RCP-240323-004',
      status: ReceiptStatus.completed,
      owner: const OwnerSummary(
        id: 'owner-004',
        code: 'AJINOMOTO',
        name: 'Ajinomoto Vietnam',
      ),
      warehouse: const WarehouseSummary(
        id: 'warehouse-002',
        code: 'SGN-DC-01',
        name: 'Sai Gon Distribution Center',
      ),
      vehicle: const VehicleInfo(
        plateNumber: '51C-90909',
        driverName: 'Pham Duc Thang',
      ),
      purchaseOrderNo: 'PO-240322-014',
      billOfLadingNo: 'BL-240322-014',
      expectedWeightKg: 9800.0,
      receivedWeightKg: 9810.0,
      varianceWeightKg: 10.0,
      syncState: SyncState.synced,
      createdAt: DateTime.utc(2026, 3, 23, 14, 20),
      updatedAt: DateTime.utc(2026, 3, 23, 16, 50),
    ),
  ];
}
