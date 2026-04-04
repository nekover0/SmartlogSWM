import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/core/network/app_http_client.dart';
import 'package:smartlog_swm_mobile/features/ocr/data/contracts/ocr_record_contract.dart';
import 'package:smartlog_swm_mobile/features/ocr/data/datasources/ocr_api_data_source.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';

void main() {
  group('OcrApiDataSource', () {
    late _FakeAppHttpClient httpClient;
    late OcrApiDataSource dataSource;

    setUp(() {
      httpClient = _FakeAppHttpClient();
      dataSource = OcrApiDataSource(httpClient: httpClient);
    });

    test('getRecords maps OCR list payload', () async {
      httpClient.listResponse = <dynamic>[
        <String, dynamic>{
          'id': 'ocr-001',
          'direction': 'INBOUND',
          'status': 'REVIEW_REQUIRED',
          'confidenceScore': 0.72,
          'extractedFields': <String, dynamic>{
            'documentNo': 'RCP-001',
            'vehiclePlate': '51D-12345',
          },
          'imagePath': '/uploads/ocr/ocr-001.jpg',
          'createdAt': '2026-04-04T12:00:00.000Z',
          'updatedAt': '2026-04-04T12:01:00.000Z',
        },
      ];

      final records = await dataSource.getRecords();

      expect(httpClient.requests, hasLength(1));
      expect(httpClient.requests.single.method, 'GET_LIST');
      expect(
        httpClient.requests.single.path,
        '/api/v1/integration/ocr/results',
      );

      expect(records, hasLength(1));
      final record = records.single;
      expect(record.id, 'ocr-001');
      expect(record.direction, DocumentDirection.inbound);
      expect(record.status, OcrRecordStatus.reviewRequired);
      expect(record.confidenceScore, 0.72);
      expect(record.extractedFields.documentNo, 'RCP-001');
      expect(record.sourceImageUrl, '/uploads/ocr/ocr-001.jpg');
      expect(record.syncState, SyncState.pending);
    });

    test('confirm posts payload and maps response', () async {
      httpClient.mapResponse = <String, dynamic>{
        'data': <String, dynamic>{
          'id': 'ocr-002',
          'direction': 'OUTBOUND',
          'status': 'CONFIRMED',
          'confidenceScore': 0.91,
          'extractedFields': <String, dynamic>{
            'documentNo': 'SHP-002',
            'vehiclePlate': '61H-99999',
          },
          'sourceImageUrl': '/uploads/ocr/ocr-002.jpg',
          'createdAt': '2026-04-04T12:10:00.000Z',
          'updatedAt': '2026-04-04T12:11:00.000Z',
          'syncState': 'synced',
        },
      };

      final record = await dataSource.confirm(
        recordId: 'ocr-002',
        extractedFields: const OcrExtractedFieldsEntity(
          documentNo: 'SHP-002',
          vehiclePlate: '61H-99999',
          itemName: 'Steel Coil',
          netWeightKg: 1200,
        ),
        reviewFlags: const <FieldReviewFlag>[],
        remarks: 'confirmed from test',
      );

      expect(httpClient.requests, hasLength(1));
      expect(httpClient.requests.single.method, 'POST_MAP');
      expect(
        httpClient.requests.single.path,
        '/api/v1/integration/ocr/results/ocr-002/confirm',
      );

      final requestData =
          httpClient.requests.single.data as Map<String, dynamic>;
      expect(requestData['confirmedBlNumber'], 'SHP-002');
      expect(requestData['confirmedVehicleNumber'], '61H-99999');
      expect(requestData['confirmedQty'], 1200);

      expect(record.id, 'ocr-002');
      expect(record.direction, DocumentDirection.outbound);
      expect(record.status, OcrRecordStatus.confirmed);
      expect(record.extractedFields.documentNo, 'SHP-002');
      expect(record.syncState, SyncState.synced);
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
