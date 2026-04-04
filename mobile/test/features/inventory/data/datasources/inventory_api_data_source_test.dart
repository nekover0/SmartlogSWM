import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/core/network/app_http_client.dart';
import 'package:smartlog_swm_mobile/features/inventory/data/datasources/inventory_api_data_source.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';

void main() {
  group('InventoryApiDataSource', () {
    late _FakeAppHttpClient httpClient;
    late InventoryApiDataSource dataSource;

    setUp(() {
      httpClient = _FakeAppHttpClient();
      dataSource = InventoryApiDataSource(httpClient: httpClient);
    });

    test('maps inventory onhand list payload', () async {
      httpClient.listByPath['/api/v1/inventory/onhand'] = <dynamic>[
        <String, dynamic>{
          'id': 'inv-001',
          'itemId': 'item-001',
          'item': <String, dynamic>{
            'itemCode': 'SMT-1',
            'itemName': 'Thermal Sensor',
          },
          'inventDim': <String, dynamic>{
            'warehouse': <String, dynamic>{
              'warehouseCode': 'WH-A',
              'warehouseName': 'Kho A',
            },
            'location': <String, dynamic>{'locationCode': 'A1-B2'},
            'owner': <String, dynamic>{'ownerCode': 'OWNER-1'},
            'inventoryStatus': <String, dynamic>{
              'statusCode': 'AVAILABLE',
              'isAllocatable': true,
            },
            'zoneCode': 'ZONE-A',
            'shelfCode': 'SHELF-2',
            'batchNo': 'LOT-001',
          },
          'physicalQty': '12.0',
          'allocatedQty': '2.0',
          'availableQty': '10.0',
          'warningThreshold': '15',
          'uom': <String, dynamic>{'uomCode': 'PCS'},
          'syncState': 'pending',
        },
      ];

      final items = await dataSource.getInventoryList();

      expect(items, hasLength(1));
      expect(items.single.id, 'inv-001');
      expect(items.single.itemId, 'item-001');
      expect(items.single.skuCode, 'SMT-1');
      expect(items.single.itemName, 'Thermal Sensor');
      expect(items.single.warehouseCode, 'WH-A');
      expect(items.single.locationCode, 'A1-B2');
      expect(items.single.availableQty, 10.0);
      expect(items.single.warningThreshold, 15.0);
      expect(items.single.isLowStock, isTrue);
      expect(items.single.syncState, SyncState.pending);

      expect(httpClient.requests, hasLength(1));
      expect(httpClient.requests.single.path, '/api/v1/inventory/onhand');
      expect(httpClient.requests.single.method, 'GET_LIST');
      expect(httpClient.requests.single.queryParameters?['hasStock'], isTrue);
    });

    test('maps inventory detail with timeline transactions', () async {
      httpClient.listByPath['/api/v1/inventory/onhand'] = <dynamic>[
        <String, dynamic>{
          'id': 'inv-002',
          'itemId': 'item-002',
          'item': <String, dynamic>{
            'itemCode': 'NET-2',
            'itemName': 'Network Switch',
          },
          'inventDim': <String, dynamic>{
            'warehouse': <String, dynamic>{'warehouseCode': 'WH-B'},
            'location': <String, dynamic>{'locationCode': 'C3-D1'},
            'owner': <String, dynamic>{'ownerCode': 'OWNER-2'},
            'inventoryStatus': <String, dynamic>{
              'statusCode': 'AVAILABLE',
              'isAllocatable': true,
            },
          },
          'physicalQty': '100',
          'allocatedQty': '10',
          'availableQty': '90',
          'warningThreshold': '20',
          'uom': <String, dynamic>{'uomCode': 'PCS'},
        },
      ];
      httpClient.listByPath['/api/v1/inventory/transactions'] = <dynamic>[
        <String, dynamic>{
          'transType': 'ISSUE',
          'qty': '-8',
          'postedAt': '2026-03-25T08:40:00.000Z',
          'refType': 'SHIPMENT',
        },
        <String, dynamic>{
          'transType': 'RECEIPT',
          'qty': '20',
          'postedAt': '2026-03-24T10:15:00.000Z',
          'refType': 'RECEIPT',
        },
      ];

      final detail = await dataSource.getInventoryDetail('inv-002');

      expect(detail.item.id, 'inv-002');
      expect(detail.item.skuCode, 'NET-2');
      expect(detail.timelineEvents, hasLength(2));
      expect(detail.timelineEvents.first.label, 'Xuat kho gan nhat');
      expect(detail.timelineEvents.first.deltaQty, -8.0);
      expect(detail.timelineEvents.last.label, 'Nhap kho gan nhat');
      expect(detail.timelineEvents.last.deltaQty, 20.0);

      expect(httpClient.requests, hasLength(2));
      expect(httpClient.requests.first.path, '/api/v1/inventory/onhand');
      expect(httpClient.requests.last.path, '/api/v1/inventory/transactions');
      expect(httpClient.requests.last.queryParameters?['itemId'], 'item-002');
    });
  });
}

class _FakeAppHttpClient implements AppHttpClient {
  final Map<String, List<dynamic>> listByPath = <String, List<dynamic>>{};
  final List<_RecordedRequest> requests = <_RecordedRequest>[];

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
        queryParameters: queryParameters,
      ),
    );

    return listByPath[path] ?? const <dynamic>[];
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

class _RecordedRequest {
  const _RecordedRequest({
    required this.method,
    required this.path,
    required this.queryParameters,
  });

  final String method;
  final String path;
  final Map<String, dynamic>? queryParameters;
}
