import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/features/inbound/data/contracts/receipt_contract.dart';
import 'package:smartlog_swm_mobile/features/inbound/data/repositories/receipt_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/inventory/data/repositories/inventory_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/inventory/domain/models/inventory_models.dart';
import 'package:smartlog_swm_mobile/features/outbound/data/contracts/shipment_contract.dart';
import 'package:smartlog_swm_mobile/features/outbound/data/repositories/shipment_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/tasks/application/controllers/task_queue_controller.dart';

final homeDashboardSnapshotProvider = FutureProvider<HomeDashboardSnapshot>((
  Ref<Object?> ref,
) async {
  final receiptRepository = ref.watch(receiptRepositoryProvider);
  final shipmentRepository = ref.watch(shipmentRepositoryProvider);
  final inventoryRepository = ref.watch(inventoryRepositoryProvider);

  final results = await Future.wait<Object>([
    receiptRepository.getReceipts(),
    shipmentRepository.getShipments(),
    inventoryRepository.getInventoryItems(),
    ref.watch(taskQueueControllerProvider.future),
  ]);

  final receipts = results[0] as List<ReceiptEntity>;
  final shipments = results[1] as List<ShipmentEntity>;
  final inventoryItems = results[2] as List<InventoryItemEntity>;
  final taskState = results[3] as TaskQueueState;

  final lowStockCount = inventoryItems.where((item) => item.isLowStock).length;

  final totalInventoryQty = inventoryItems.fold<int>(
    0,
    (int sum, InventoryItemEntity item) => sum + item.availableQty.round(),
  );

  final alerts = <HomeAlertEntry>[];

  if (lowStockCount > 0) {
    alerts.add(
      HomeAlertEntry(
        title: 'Canh bao ton thap',
        subtitle: '$lowStockCount SKU dang xuong duoi nguong an toan.',
        isWarning: true,
      ),
    );
  }

  if (taskState.criticalTaskCount > 0) {
    alerts.add(
      HomeAlertEntry(
        title: 'Pending Approval',
        subtitle:
            '${taskState.criticalTaskCount} cong viec critical can xu ly ngay.',
        isWarning: true,
      ),
    );
  }

  if (alerts.isEmpty) {
    alerts.add(
      const HomeAlertEntry(
        title: 'He thong on dinh',
        subtitle: 'Khong co canh bao nghiem trong trong ca hien tai.',
        isWarning: false,
      ),
    );
  }

  final recentActivities = <HomeActivityEntry>[
    ..._buildReceiptActivities(receipts),
    ..._buildShipmentActivities(shipments),
  ]..sort((left, right) => right.occurredAt.compareTo(left.occurredAt));

  if (recentActivities.isEmpty) {
    recentActivities.addAll(HomeDashboardSnapshot.fallback().recentActivities);
  }

  return HomeDashboardSnapshot(
    ordersToday: receipts.length + shipments.length,
    pendingTasks: taskState.pendingTaskCount,
    lowStockCount: lowStockCount,
    totalInventoryQty: totalInventoryQty,
    alerts: alerts,
    recentActivities: recentActivities.take(2).toList(growable: false),
  );
});

class HomeDashboardSnapshot {
  const HomeDashboardSnapshot({
    required this.ordersToday,
    required this.pendingTasks,
    required this.lowStockCount,
    required this.totalInventoryQty,
    required this.alerts,
    required this.recentActivities,
  });

  final int ordersToday;
  final int pendingTasks;
  final int lowStockCount;
  final int totalInventoryQty;
  final List<HomeAlertEntry> alerts;
  final List<HomeActivityEntry> recentActivities;

  factory HomeDashboardSnapshot.fallback() {
    return HomeDashboardSnapshot(
      ordersToday: 1284,
      pendingTasks: 42,
      lowStockCount: 7,
      totalInventoryQty: 45820,
      alerts: const <HomeAlertEntry>[
        HomeAlertEntry(
          title: 'Low Stock: Thermal Sensor',
          subtitle: 'Zone B-4 reached critical level',
          isWarning: true,
        ),
        HomeAlertEntry(
          title: 'Pending Approval',
          subtitle: '3 inbound manifests need signature',
          isWarning: false,
        ),
      ],
      recentActivities: <HomeActivityEntry>[
        HomeActivityEntry(
          title: 'Nhap kho thanh cong',
          detail: 'Batch #774921 - Industrial Pumps (24 units)',
          badge: 'Khu vuc A-4',
          occurredAt: DateTime.now().toUtc().subtract(const Duration(hours: 2)),
          completed: false,
        ),
        HomeActivityEntry(
          title: 'Xuat kho hoan tat',
          detail: 'Carrier: FedEx Express - Manifest #M-9022',
          badge: 'Hoan thanh',
          occurredAt: DateTime.now().toUtc().subtract(const Duration(hours: 4)),
          completed: true,
        ),
      ],
    );
  }
}

class HomeAlertEntry {
  const HomeAlertEntry({
    required this.title,
    required this.subtitle,
    required this.isWarning,
  });

  final String title;
  final String subtitle;
  final bool isWarning;
}

class HomeActivityEntry {
  const HomeActivityEntry({
    required this.title,
    required this.detail,
    required this.badge,
    required this.occurredAt,
    required this.completed,
  });

  final String title;
  final String detail;
  final String badge;
  final DateTime occurredAt;
  final bool completed;
}

List<HomeActivityEntry> _buildReceiptActivities(List<ReceiptEntity> receipts) {
  final sorted = receipts.toList(growable: false)
    ..sort((left, right) => right.updatedAt.compareTo(left.updatedAt));

  return sorted
      .take(1)
      .map(
        (receipt) => HomeActivityEntry(
          title: 'Nhap kho thanh cong',
          detail: '${receipt.receiptNo} - ${receipt.owner.name}',
          badge: receipt.warehouse.code,
          occurredAt: receipt.updatedAt,
          completed: receipt.status == ReceiptStatus.completed,
        ),
      )
      .toList(growable: false);
}

List<HomeActivityEntry> _buildShipmentActivities(
  List<ShipmentEntity> shipments,
) {
  final sorted = shipments.toList(growable: false)
    ..sort((left, right) => right.updatedAt.compareTo(left.updatedAt));

  return sorted
      .take(1)
      .map(
        (shipment) => HomeActivityEntry(
          title: 'Xuat kho hoan tat',
          detail: '${shipment.shipmentNo} - ${shipment.owner.name}',
          badge: shipment.status == ShipmentStatus.closed
              ? 'Hoan thanh'
              : 'Dang xu ly',
          occurredAt: shipment.updatedAt,
          completed: shipment.status == ShipmentStatus.closed,
        ),
      )
      .toList(growable: false);
}
