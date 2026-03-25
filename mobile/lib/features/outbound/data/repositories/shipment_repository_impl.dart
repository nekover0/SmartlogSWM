import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/features/outbound/data/contracts/shipment_contract.dart';
import 'package:smartlog_swm_mobile/features/outbound/data/datasources/shipment_fixture_data_source.dart';
import 'package:smartlog_swm_mobile/features/outbound/domain/repositories/shipment_repository.dart';

final shipmentFixtureDataSourceProvider = Provider<ShipmentFixtureDataSource>((
  Ref<Object?> ref,
) {
  return ShipmentFixtureDataSource();
});

final shipmentRepositoryProvider = Provider<ShipmentRepository>((
  Ref<Object?> ref,
) {
  return ShipmentRepositoryImpl(
    fixtureDataSource: ref.watch(shipmentFixtureDataSourceProvider),
  );
});

class ShipmentRepositoryImpl implements ShipmentRepository {
  ShipmentRepositoryImpl({required ShipmentFixtureDataSource fixtureDataSource})
    : _fixtureDataSource = fixtureDataSource;

  final ShipmentFixtureDataSource _fixtureDataSource;

  @override
  Future<List<ShipmentEntity>> getShipments() async {
    final shipments = await _fixtureDataSource.getShipmentList();
    return shipments
        .map((shipment) => shipment.toEntity())
        .toList(growable: false);
  }

  @override
  Future<ShipmentEntity> getShipmentById(String shipmentId) async {
    final shipment = await _fixtureDataSource.getShipmentDetail(shipmentId);
    return shipment.toEntity();
  }
}
