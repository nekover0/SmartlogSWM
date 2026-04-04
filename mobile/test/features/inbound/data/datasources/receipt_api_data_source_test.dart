import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/core/network/app_http_client.dart';
import 'package:smartlog_swm_mobile/features/inbound/data/datasources/receipt_api_data_source.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';

void main() {
  group('ReceiptApiDataSource', () {
    late _FakeAppHttpClient httpClient;
    late ReceiptApiDataSource dataSource;

    setUp(() {
      httpClient = _FakeAppHttpClient();
      dataSource = ReceiptApiDataSource(httpClient: httpClient);
    });

    test('getReceiptList calls endpoint and maps payload list', () async {
      httpClient.listResponse = <dynamic>[
        <String, dynamic>{
          'id': 'rcp-001',
          'receiptNumber': 'RCP-240325-001',
          'status': 'WEIGHING_2',
          'ownerId': 'owner-1',
          'ownerCode': 'OWN-1',
          'ownerName': 'Owner 1',
          'warehouseId': 'wh-1',
          'warehouseCode': 'WH1',
          'warehouseName': 'Warehouse 1',
          'vehicleNumber': '51A-12345',
          'expectedQty': 1000.5,
          'received_weight_kg': 980.0,
          'syncState': 'pending',
          'createdAt': '2026-04-04T00:00:00.000Z',
          'updatedAt': '2026-04-04T00:10:00.000Z',
        },
      ];

      final receipts = await dataSource.getReceiptList();

      expect(httpClient.requests, hasLength(1));
      expect(httpClient.requests.single.method, 'GET_LIST');
      expect(httpClient.requests.single.path, '/api/v1/inbound/receipts');
      expect(httpClient.requests.single.requiresAuth, isTrue);

      expect(receipts, hasLength(1));
      expect(receipts.single.id, 'rcp-001');
      expect(receipts.single.receiptNo, 'RCP-240325-001');
      expect(receipts.single.status, ReceiptStatus.weighing2);
      expect(receipts.single.owner.code, 'OWN-1');
      expect(receipts.single.vehicle.plateNumber, '51A-12345');
      expect(receipts.single.expectedWeightKg, 1000.5);
      expect(receipts.single.syncState, SyncState.pending);
    });

    test(
      'getReceiptDetail calls endpoint and unwraps receipt payload',
      () async {
        httpClient.mapResponse = <String, dynamic>{
          'data': <String, dynamic>{
            'data': <String, dynamic>{
              'id': 'rcp-002',
              'receiptNumber': 'RCP-240325-002',
              'status': 'confirmed',
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
              'vehicle': <String, dynamic>{'plate_number': '51A-22222'},
              'expectedWeightKg': 1200.0,
              'receivedWeightKg': 1200.0,
              'varianceWeightKg': 0.0,
              'syncState': 'synced',
              'createdAt': '2026-04-04T01:00:00.000Z',
              'updatedAt': '2026-04-04T01:05:00.000Z',
              'lines': <Map<String, dynamic>>[
                <String, dynamic>{
                  'id': 'line-1',
                  'itemCode': 'SKU-001',
                  'itemName': 'Milk Powder',
                  'uomCode': 'BAG',
                  'expectedQty': 100,
                  'receivedQty': 98,
                },
              ],
            },
          },
        };

        final receipt = await dataSource.getReceiptDetail('rcp-002');

        expect(httpClient.requests, hasLength(1));
        expect(httpClient.requests.single.method, 'GET_MAP');
        expect(
          httpClient.requests.single.path,
          '/api/v1/inbound/receipts/rcp-002',
        );
        expect(httpClient.requests.single.requiresAuth, isTrue);

        expect(receipt.id, 'rcp-002');
        expect(receipt.receiptNo, 'RCP-240325-002');
        expect(receipt.status, ReceiptStatus.confirmed);
        expect(receipt.owner.code, 'OWN-2');
        expect(receipt.warehouse.code, 'WH2');
        expect(receipt.vehicle.plateNumber, '51A-22222');
        expect(receipt.lines, hasLength(1));
        expect(receipt.lines.single.itemCode, 'SKU-001');
      },
    );
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
  }) {
    throw UnimplementedError();
  }

  @override
  Future<void> postVoid(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool requiresAuth = true,
  }) {
    throw UnimplementedError();
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
