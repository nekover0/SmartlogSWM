import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/features/outbound/data/contracts/shipment_contract.dart';
import 'package:smartlog_swm_mobile/features/outbound/data/repositories/shipment_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/outbound/domain/repositories/shipment_repository.dart';

final shipmentDetailControllerProvider =
    AsyncNotifierProviderFamily<
      ShipmentDetailController,
      ShipmentEntity,
      String
    >(ShipmentDetailController.new);

class ShipmentDetailController
    extends FamilyAsyncNotifier<ShipmentEntity, String> {
  ShipmentRepository get _repository => ref.read(shipmentRepositoryProvider);

  @override
  Future<ShipmentEntity> build(String shipmentId) async {
    return _repository.getShipmentById(shipmentId);
  }

  Future<void> refresh() async {
    state = const AsyncLoading<ShipmentEntity>().copyWithPrevious(state);
    state = await AsyncValue.guard(() async {
      return _repository.getShipmentById(arg);
    });
  }
}
