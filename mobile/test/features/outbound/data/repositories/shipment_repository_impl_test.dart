import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/core/network/app_http_client.dart';
import 'package:smartlog_swm_mobile/features/outbound/data/contracts/shipment_contract.dart';
import 'package:smartlog_swm_mobile/features/outbound/data/datasources/shipment_api_data_source.dart';
import 'package:smartlog_swm_mobile/features/outbound/data/repositories/shipment_repository_impl.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';

void main() {
  group('ShipmentRepositoryImpl', () {
    test('maps api datasource list/detail to entities', () async {
      final apiDataSource = _FakeShipmentApiDataSource(
        listResponse: <ShipmentDto>[
          _shipmentDto(id: 'shp-001', shipmentNo: 'SHP-001'),
        ],
        detailResponse: _shipmentDto(id: 'shp-002', shipmentNo: 'SHP-002'),
      );
      final repository = ShipmentRepositoryImpl(apiDataSource: apiDataSource);

      final list = await repository.getShipments();
      final detail = await repository.getShipmentById('shp-002');

      expect(apiDataSource.listCallCount, 1);
      expect(apiDataSource.detailCallCount, 1);
      expect(list, hasLength(1));
      expect(list.single.id, 'shp-001');
      expect(detail.id, 'shp-002');
      expect(detail.shipmentNo, 'SHP-002');
    });

    test('rethrows api datasource errors', () async {
      final apiDataSource = _FakeShipmentApiDataSource(
        listError: StateError('list failed'),
        detailError: StateError('detail failed'),
      );
      final repository = ShipmentRepositoryImpl(apiDataSource: apiDataSource);

      await expectLater(
        () => repository.getShipments(),
        throwsA(isA<StateError>()),
      );
      await expectLater(
        () => repository.getShipmentById('shp-003'),
        throwsA(isA<StateError>()),
      );
    });
  });
}

ShipmentDto _shipmentDto({required String id, required String shipmentNo}) {
  return ShipmentDto(
    id: id,
    shipmentNo: shipmentNo,
    status: ShipmentStatus.confirmed,
    owner: const OwnerSummary(id: 'owner-1', code: 'OWN-1', name: 'Owner 1'),
    warehouse: const WarehouseSummary(
      id: 'wh-1',
      code: 'WH1',
      name: 'Warehouse 1',
    ),
    vehicle: const VehicleInfo(plateNumber: '51A-11111'),
    expectedWeightKg: 1000,
    shippedWeightKg: 900,
    varianceWeightKg: -100,
    syncState: SyncState.pending,
    createdAt: DateTime.utc(2026, 4, 4, 10, 0),
    updatedAt: DateTime.utc(2026, 4, 4, 10, 5),
  );
}

class _FakeShipmentApiDataSource extends ShipmentApiDataSource {
  _FakeShipmentApiDataSource({
    this.listResponse,
    this.detailResponse,
    this.listError,
    this.detailError,
  }) : super(httpClient: _NoopAppHttpClient());

  final List<ShipmentDto>? listResponse;
  final ShipmentDto? detailResponse;
  final Object? listError;
  final Object? detailError;

  int listCallCount = 0;
  int detailCallCount = 0;

  @override
  Future<List<ShipmentDto>> getShipmentList() async {
    listCallCount += 1;
    if (listError != null) {
      throw listError!;
    }

    return listResponse ?? const <ShipmentDto>[];
  }

  @override
  Future<ShipmentDto> getShipmentDetail(String shipmentId) async {
    detailCallCount += 1;
    if (detailError != null) {
      throw detailError!;
    }

    return detailResponse ??
        _shipmentDto(id: shipmentId, shipmentNo: 'SHP-DEFAULT');
  }
}

class _NoopAppHttpClient implements AppHttpClient {
  @override
  Future<List<dynamic>> getList(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getMap(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> postMap(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> postVoid(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    throw UnimplementedError();
  }
}
