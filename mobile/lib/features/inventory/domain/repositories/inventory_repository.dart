import 'package:smartlog_swm_mobile/features/inventory/domain/models/inventory_models.dart';

abstract interface class InventoryRepository {
  Future<List<InventoryItemEntity>> getInventoryItems();

  Future<InventoryDetailEntity> getInventoryDetail(String inventoryId);
}
