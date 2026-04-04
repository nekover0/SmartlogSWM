import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/core/network/app_http_client.dart';
import 'package:smartlog_swm_mobile/features/outbound/data/datasources/shipment_api_data_source.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';

void main() {
  group('ShipmentApiDataSource', () {
    late _FakeAppHttpClient httpClient;
    late ShipmentApiDataSource dataSource;

    setUp(() {
      httpClient = _FakeAppHttpClient();
      dataSource = ShipmentApiDataSource(httpClient: httpClient);
    });

    test('getShipmentList maps outbound shipment payload', () async {
      httpClient.listResponse = <dynamic>[
        <String, dynamic>{
          'id': 'shp-001',
          'shipmentNumber': 'SHP-001',
          'status': 'LOADING',
          'ownerId': 'owner-1',
          'ownerCode': 'OWN-1',
          'ownerName': 'Owner 1',
          'warehouseId': 'wh-1',
          'warehouseCode': 'WH1',
          'warehouseName': 'Warehouse 1',
          'vehicleNumber': '51A-12345',
          'soNumber': 'SO-001',
          'expectedQtyKg': 1200,
          'loadedWeightKg': 800,
          'syncState': 'pending',
          'createdAt': '2026-04-04T10:00:00.000Z',
          'updatedAt': '2026-04-04T10:05:00.000Z',
          'lines': <Map<String, dynamic>>[
            <String, dynamic>{
              'lineId': 'line-1',
              'itemCode': 'SKU-1',
              'itemName': 'Sugar',
              'uomCode': 'BAG',
              'expectedQty': 100,
              'shippedQty': 80,
              'locationCode': 'A-01',
            },
          ],
        },
      ];

      final shipments = await dataSource.getShipmentList();

      expect(httpClient.requests, hasLength(1));
      expect(httpClient.requests.single.method, 'GET_LIST');
      expect(httpClient.requests.single.path, '/api/v1/outbound/shipments');
      expect(httpClient.requests.single.requiresAuth, isTrue);

      expect(shipments, hasLength(1));
      final shipment = shipments.single;
      expect(shipment.id, 'shp-001');
      expect(shipment.shipmentNo, 'SHP-001');
      expect(shipment.status, ShipmentStatus.loading);
      expect(shipment.owner.code, 'OWN-1');
      expect(shipment.warehouse.code, 'WH1');
      expect(shipment.vehicle.plateNumber, '51A-12345');
      expect(shipment.salesOrderNo, 'SO-001');
      expect(shipment.expectedWeightKg, 1200);
      expect(shipment.shippedWeightKg, 800);
      expect(shipment.syncState, SyncState.pending);
      expect(shipment.lines, hasLength(1));
      expect(shipment.lines.single.itemCode, 'SKU-1');
      expect(shipment.lines.single.sourceLocation?.code, 'A-01');
    });

    test('getShipmentDetail unwraps nested data payload', () async {
      httpClient.mapResponse = <String, dynamic>{
        'data': <String, dynamic>{
          'data': <String, dynamic>{
            'id': 'shp-002',
            'shipmentNumber': 'SHP-002',
            'status': 'SHIPPED',
            'owner': <String, dynamic>{
              'id': 'owner-2',
              'code': 'OWN-2',
              'name': 'Owner 2',
            },
            'warehouse': <String, dynamic>{
              'id': 'wh-2',
              'code': 'WH2',
              'name': 'Warehouse 2',
            },
            'vehicle': <String, dynamic>{'plateNumber': '61H-12345'},
            'expectedWeightKg': 900,
            'shippedWeightKg': 910,
            'syncState': 'synced',
            'createdAt': '2026-04-04T11:00:00.000Z',
            'updatedAt': '2026-04-04T11:05:00.000Z',
          },
        },
      };

      final shipment = await dataSource.getShipmentDetail('shp-002');

      expect(httpClient.requests, hasLength(1));
      expect(httpClient.requests.single.method, 'GET_MAP');
      expect(
        httpClient.requests.single.path,
        '/api/v1/outbound/shipments/shp-002',
      );
      expect(shipment.id, 'shp-002');
      expect(shipment.status, ShipmentStatus.shipped);
      expect(shipment.owner.code, 'OWN-2');
      expect(shipment.warehouse.code, 'WH2');
      expect(shipment.vehicle.plateNumber, '61H-12345');
      expect(shipment.syncState, SyncState.synced);
    });
  });
}

class _FakeAppHttpClient implements AppHttpClient {
  final List<_RecordedRequest> requests = <_RecordedRequest>[];
  Map<String, dynamic> mapResponse = <String, dynamic>{};
  List<dynamic> listResponse = const <dynamic>[];

  @override
  Future<Map<String, dynamic>> getMap(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    requests.add(
      _RecordedRequest(
        method: 'GET_MAP',
        path: path,
        data: null,
        queryParameters: queryParameters,
        requiresAuth: requiresAuth,
      ),
    );

    return mapResponse;
  }

  @override
  Future<List<dynamic>> getList(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    requests.add(
      _RecordedRequest(
        method: 'GET_LIST',
        path: path,
        data: null,
        queryParameters: queryParameters,
        requiresAuth: requiresAuth,
      ),
    );

    return listResponse;
  }

  @override
  Future<Map<String, dynamic>> postMap(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    requests.add(
      _RecordedRequest(
        method: 'POST_MAP',
        path: path,
        data: data,
        queryParameters: queryParameters,
        requiresAuth: requiresAuth,
      ),
    );

    return mapResponse;
  }

  @override
  Future<void> postVoid(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) async {
    requests.add(
      _RecordedRequest(
        method: 'POST_VOID',
        path: path,
        data: data,
        queryParameters: queryParameters,
        requiresAuth: requiresAuth,
      ),
    );
  }
}

class _RecordedRequest {
  const _RecordedRequest({
    required this.method,
    required this.path,
    required this.data,
    required this.queryParameters,
    required this.requiresAuth,
  });

  final String method;
  final String path;
  final Object? data;
  final Map<String, dynamic>? queryParameters;
  final bool requiresAuth;
}
