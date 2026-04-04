import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/features/inventory/data/repositories/inventory_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/inventory/domain/models/inventory_models.dart';

final inventoryListProvider = FutureProvider<List<InventoryItemEntity>>((
  Ref<Object?> ref,
) {
  return ref.watch(inventoryRepositoryProvider).getInventoryItems();
});

final inventoryDetailProvider =
    FutureProvider.family<InventoryDetailEntity, String>((
      Ref<Object?> ref,
      String inventoryId,
    ) {
      return ref
          .watch(inventoryRepositoryProvider)
          .getInventoryDetail(inventoryId);
    });
