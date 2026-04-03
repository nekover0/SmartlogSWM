import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/core/network/app_http_client.dart';
import 'package:smartlog_swm_mobile/features/scan/data/contracts/scan_session_contract.dart';
import 'package:smartlog_swm_mobile/features/scan/data/datasources/scan_api_data_source.dart';
import 'package:smartlog_swm_mobile/features/scan/domain/models/scan_launch_context.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';

void main() {
  group('ScanApiDataSource', () {
    late _FakeAppHttpClient httpClient;
    late ScanApiDataSource dataSource;

    setUp(() {
      httpClient = _FakeAppHttpClient();
      dataSource = ScanApiDataSource(httpClient: httpClient);
    });

    test(
      'lookupReceive posts expected payload and maps lookup response',
      () async {
        httpClient.mapResponse = <String, dynamic>{
          'session_id': 'scan-001',
          'state': 'lookup_success',
          'resolved_item_code': 'ITEM-001',
          'resolved_location_code': 'A-01-01',
          'reference_id': 'rcv-001',
          'warehouse_id': 'wh-01',
          'message': 'Matched',
        };

        final draft = await dataSource.lookupReceive(
          context: const ScanLaunchContext(
            mode: ScanMode.receive,
            referenceId: 'rcv-001',
            warehouseId: 'wh-01',
          ),
          lookupCode: ' RCV-240325-001 ',
        );

        expect(httpClient.requests, hasLength(1));
        expect(httpClient.requests.single.method, 'POST_MAP');
        expect(httpClient.requests.single.path, '/api/v1/scan/lookup-receive');
        expect(httpClient.requests.single.requiresAuth, isTrue);
        expect(httpClient.requests.single.data, <String, dynamic>{
          'mode': 'receive',
          'lookup_code': 'RCV-240325-001',
          'warehouse_id': 'wh-01',
          'reference_id': 'rcv-001',
        });

        expect(draft.id, 'scan-001');
        expect(draft.mode, ScanMode.receive);
        expect(draft.state, ScanSessionState.lookupSuccess);
        expect(draft.lookupCode, 'RCV-240325-001');
        expect(draft.resolvedItemCode, 'ITEM-001');
        expect(draft.resolvedLocationCode, 'A-01-01');
        expect(draft.referenceId, 'rcv-001');
        expect(draft.warehouseId, 'wh-01');
      },
    );

    test(
      'submitReceive posts expected payload and keeps request defaults',
      () async {
        httpClient.mapResponse = <String, dynamic>{
          'success': true,
          'message': 'Submitted',
        };

        const request = ScanSubmitRequestDto(
          sessionId: 'scan-002',
          mode: ScanMode.move,
          referenceId: 'ref-002',
          warehouseId: 'wh-02',
          itemCode: 'ITEM-002',
          locationCode: 'B-01-01',
          quantity: 10,
        );

        final result = await dataSource.submitReceive(request: request);

        expect(httpClient.requests, hasLength(1));
        expect(httpClient.requests.single.method, 'POST_MAP');
        expect(httpClient.requests.single.path, '/api/v1/scan/submit-receive');
        expect(httpClient.requests.single.requiresAuth, isTrue);
        expect(httpClient.requests.single.data, request.toJson());

        expect(result.success, isTrue);
        expect(result.mode, ScanMode.move);
        expect(result.sessionId, 'scan-002');
        expect(result.referenceId, 'ref-002');
        expect(result.warehouseId, 'wh-02');
        expect(result.itemCode, 'ITEM-002');
        expect(result.locationCode, 'B-01-01');
        expect(result.quantity, 10);
        expect(result.message, 'Submitted');
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
