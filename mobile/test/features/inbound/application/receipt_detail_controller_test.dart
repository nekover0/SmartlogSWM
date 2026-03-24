import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/features/inbound/application/controllers/receipt_action_controller.dart';
import 'package:smartlog_swm_mobile/features/inbound/application/controllers/receipt_detail_controller.dart';
import 'package:smartlog_swm_mobile/features/inbound/data/contracts/receipt_contract.dart';
import 'package:smartlog_swm_mobile/features/inbound/data/repositories/receipt_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/inbound/domain/repositories/receipt_repository.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';

void main() {
  group('ReceiptDetailController', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer(
        overrides: [
          receiptRepositoryProvider.overrideWithValue(_FakeReceiptRepository()),
        ],
      );
      addTearDown(container.dispose);
    });

    test('loads a single receipt detail from the requested id', () async {
      final receipt = await container.read(
        receiptDetailControllerProvider('rcp-20260323-001').future,
      );

      expect(receipt.receiptNo, 'RCP-240323-001');
      expect(receipt.lines, hasLength(2));
      expect(receipt.availableActions, hasLength(4));
    });

    test('derives footer actions from receipt available actions', () async {
      await container.read(
        receiptDetailControllerProvider('rcp-20260323-001').future,
      );

      final actionState = container.read(
        receiptActionControllerProvider('rcp-20260323-001'),
      );

      expect(
        actionState.primaryActions.map((action) => action.label).toList(),
        <String>['Bắt đầu quét nhận', 'Xác nhận nhập'],
      );
      expect(
        actionState.secondaryActions.map((action) => action.label).toList(),
        <String>['Báo lỗi', 'Liên kết OCR'],
      );
      expect(actionState.hasActions, isTrue);
      expect(actionState.hasEnabledActions, isTrue);
      expect(actionState.featuredAction?.type, TaskActionType.startWeighing);
    });
  });
}

class _FakeReceiptRepository implements ReceiptRepository {
  @override
  Future<ReceiptEntity> getReceiptById(String receiptId) async {
    if (receiptId == _receiptDetail.id) {
      return _receiptDetail;
    }

    throw StateError('Receipt not found: $receiptId');
  }

  @override
  Future<List<ReceiptEntity>> getReceipts() async {
    return <ReceiptEntity>[_receiptDetail];
  }

  static final ReceiptEntity _receiptDetail = ReceiptEntity(
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
      vesselName: 'MV Mekong Star',
    ),
    purchaseOrderNo: 'PO-240323-001',
    billOfLadingNo: 'BL-240323-001',
    vesselName: 'MV Mekong Star',
    expectedWeightKg: 18250.0,
    receivedWeightKg: 0.0,
    portWeightKg: 18300.0,
    varianceWeightKg: 0.0,
    sourceOcrRecordId: 'ocr-20260323-001',
    syncState: SyncState.synced,
    availableActions: const <ActionCapability>[
      ActionCapability(
        type: TaskActionType.startWeighing,
        label: 'Bắt đầu cân',
      ),
      ActionCapability(
        type: TaskActionType.approve,
        label: 'Xác nhận nhập',
        enabled: false,
      ),
      ActionCapability(type: TaskActionType.dismiss, label: 'Báo lỗi'),
      ActionCapability(type: TaskActionType.reviewOcr, label: 'Liên kết OCR'),
    ],
    lines: const <ReceiptLineEntity>[
      ReceiptLineEntity(
        id: 'receipt-line-001',
        itemCode: 'SKU-MILK-18L',
        itemName: 'Sữa tươi tiệt trùng 18L',
        uomCode: 'CAN',
        expectedQty: 320,
        receivedQty: 0,
        varianceQty: 0,
      ),
      ReceiptLineEntity(
        id: 'receipt-line-002',
        itemCode: 'SKU-CREAM-05L',
        itemName: 'Kem sữa nguyên liệu 5L',
        uomCode: 'BOX',
        expectedQty: 180,
        receivedQty: 0,
        varianceQty: 0,
      ),
    ],
    note: 'Tài xế đã xác nhận số seal, chờ bắt đầu cân tại trạm số 1.',
    createdAt: DateTime.utc(2026, 3, 24, 6, 40),
    updatedAt: DateTime.utc(2026, 3, 24, 8, 10),
  );
}
