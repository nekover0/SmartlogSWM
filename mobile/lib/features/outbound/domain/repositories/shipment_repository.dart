import 'package:smartlog_swm_mobile/features/outbound/data/contracts/shipment_contract.dart';

abstract interface class ShipmentRepository {
  Future<List<ShipmentEntity>> getShipments();

  Future<ShipmentEntity> getShipmentById(String shipmentId);
}
