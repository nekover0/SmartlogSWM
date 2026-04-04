import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/features/outbound/data/contracts/shipment_contract.dart';
import 'package:smartlog_swm_mobile/features/outbound/data/datasources/shipment_api_data_source.dart';
import 'package:smartlog_swm_mobile/features/outbound/domain/repositories/shipment_repository.dart';

final shipmentRepositoryProvider = Provider<ShipmentRepository>((
  Ref<Object?> ref,
) {
  return ShipmentRepositoryImpl(
    apiDataSource: ref.watch(shipmentApiDataSourceProvider),
  );
});

class ShipmentRepositoryImpl implements ShipmentRepository {
  ShipmentRepositoryImpl({required ShipmentApiDataSource apiDataSource})
    : _apiDataSource = apiDataSource;

  final ShipmentApiDataSource _apiDataSource;

  @override
  Future<List<ShipmentEntity>> getShipments() async {
    final shipments = await _apiDataSource.getShipmentList();
    return shipments
        .map((shipment) => shipment.toEntity())
        .toList(growable: false);
  }

  @override
  Future<ShipmentEntity> getShipmentById(String shipmentId) async {
    final shipment = await _apiDataSource.getShipmentDetail(shipmentId);
    return shipment.toEntity();
  }
}
