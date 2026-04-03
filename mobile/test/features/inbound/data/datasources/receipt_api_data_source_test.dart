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
          'receipt_no': 'RCP-240325-001',
          'status': 'weighing_1',
          'owner': <String, dynamic>{
            'id': 'owner-1',
            'code': 'OWN-1',
            'name': 'Owner 1',
          },
          'warehouse': <String, dynamic>{
            'id': 'wh-1',
            'code': 'WH1',
            'name': 'Warehouse 1',
          },
          'vehicle': <String, dynamic>{'plate_number': '51A-12345'},
          'expected_weight_kg': 1000.5,
          'received_weight_kg': 980.0,
          'variance_weight_kg': -20.5,
          'sync_state': 'synced',
          'created_at': '2026-04-04T00:00:00.000Z',
          'updated_at': '2026-04-04T00:10:00.000Z',
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
      expect(receipts.single.status, ReceiptStatus.weighing1);
      expect(receipts.single.owner.code, 'OWN-1');
    });

    test(
      'getReceiptDetail calls endpoint and unwraps receipt payload',
      () async {
        httpClient.mapResponse = <String, dynamic>{
          'receipt': <String, dynamic>{
            'id': 'rcp-002',
            'receipt_no': 'RCP-240325-002',
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
            'expected_weight_kg': 1200.0,
            'received_weight_kg': 1200.0,
            'variance_weight_kg': 0.0,
            'sync_state': 'synced',
            'created_at': '2026-04-04T01:00:00.000Z',
            'updated_at': '2026-04-04T01:05:00.000Z',
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
