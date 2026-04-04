import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/features/inventory/data/datasources/inventory_api_data_source.dart';
import 'package:smartlog_swm_mobile/features/inventory/domain/models/inventory_models.dart';
import 'package:smartlog_swm_mobile/features/inventory/domain/repositories/inventory_repository.dart';

final inventoryRepositoryProvider = Provider<InventoryRepository>((
  Ref<Object?> ref,
) {
  return InventoryRepositoryImpl(
    apiDataSource: ref.watch(inventoryApiDataSourceProvider),
  );
});

class InventoryRepositoryImpl implements InventoryRepository {
  InventoryRepositoryImpl({required InventoryApiDataSource apiDataSource})
    : _apiDataSource = apiDataSource;

  final InventoryApiDataSource _apiDataSource;

  @override
  Future<List<InventoryItemEntity>> getInventoryItems() {
    return _apiDataSource.getInventoryList();
  }

  @override
  Future<InventoryDetailEntity> getInventoryDetail(String inventoryId) {
    return _apiDataSource.getInventoryDetail(inventoryId);
  }
}
