import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';

class InventoryItemEntity {
  const InventoryItemEntity({
    required this.id,
    required this.itemId,
    required this.skuCode,
    required this.itemName,
    required this.warehouseCode,
    required this.warehouseName,
    required this.locationCode,
    required this.ownerCode,
    this.zoneCode,
    this.shelfCode,
    this.batchNo,
    required this.physicalQty,
    required this.allocatedQty,
    required this.availableQty,
    required this.warningThreshold,
    required this.uomCode,
    required this.inventoryStatusCode,
    required this.inventoryStatusAllocatable,
    required this.syncState,
  });

  final String id;
  final String itemId;
  final String skuCode;
  final String itemName;
  final String warehouseCode;
  final String warehouseName;
  final String locationCode;
  final String ownerCode;
  final String? zoneCode;
  final String? shelfCode;
  final String? batchNo;
  final double physicalQty;
  final double allocatedQty;
  final double availableQty;
  final double warningThreshold;
  final String uomCode;
  final String inventoryStatusCode;
  final bool inventoryStatusAllocatable;
  final SyncState syncState;

  bool get isLowStock {
    final statusLow = inventoryStatusCode.toUpperCase().contains('LOW');
    return statusLow || availableQty <= warningThreshold;
  }
}

class InventoryTimelineEventEntity {
  const InventoryTimelineEventEntity({
    required this.type,
    required this.label,
    required this.occurredAt,
    required this.deltaQty,
  });

  final String type;
  final String label;
  final DateTime occurredAt;
  final double deltaQty;
}

class InventoryDetailEntity {
  const InventoryDetailEntity({
    required this.item,
    required this.priority,
    required this.timelineEvents,
  });

  final InventoryItemEntity item;
  final String priority;
  final List<InventoryTimelineEventEntity> timelineEvents;
}
