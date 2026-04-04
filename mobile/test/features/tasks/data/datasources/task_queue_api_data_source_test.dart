import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/core/network/app_http_client.dart';
import 'package:smartlog_swm_mobile/features/tasks/data/datasources/task_queue_api_data_source.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';

void main() {
  group('TaskQueueApiDataSource', () {
    late _FakeAppHttpClient httpClient;
    late TaskQueueApiDataSource dataSource;

    setUp(() {
      httpClient = _FakeAppHttpClient();
      dataSource = TaskQueueApiDataSource(httpClient: httpClient);
    });

    test('calls mobile works endpoint and maps work payload', () async {
      httpClient.listResponse = <dynamic>[
        <String, dynamic>{
          'data': <String, dynamic>{
            'workId': 'WRK-001',
            'workType': 'PUTAWAY',
            'status': 'IN_PROGRESS',
            'priorityNo': 15,
            'sourceModule': 'M4',
            'sourceRefId': 'rcp-001',
            'createdAt': '2026-04-04T00:00:00.000Z',
          },
        },
      ];

      final items = await dataSource.getTaskQueue();

      expect(httpClient.requests, hasLength(1));
      expect(httpClient.requests.single.method, 'GET_LIST');
      expect(httpClient.requests.single.path, '/api/v1/mobile/works/my');
      expect(httpClient.requests.single.requiresAuth, isTrue);

      expect(items, hasLength(1));
      final item = items.single;
      expect(item.id, 'WRK-001');
      expect(item.type, TaskItemType.receipt);
      expect(item.status, TaskItemStatus.acknowledged);
      expect(item.severity, Severity.high);
      expect(item.sourceModule, 'M4');
      expect(item.sourceEntityId, 'rcp-001');
      expect(item.sourceEntityNo, 'WRK-001');
      expect(item.routeName, 'receipt_detail');
      expect(item.routeParams, <String, String>{'receiptId': 'rcp-001'});
      expect(item.primaryAction.type, TaskActionType.startWeighing);
      expect(item.syncState, SyncState.synced);
    });

    test(
      'accepts task-native payload and preserves explicit actions',
      () async {
        httpClient.listResponse = <dynamic>[
          <String, dynamic>{
            'id': 'task-ocr-001',
            'type': 'ocr',
            'status': 'open',
            'severity': 'critical',
            'title': 'Review OCR mismatch',
            'source_module': 'ocr',
            'source_entity_type': 'ocr_record',
            'source_entity_id': 'ocr-001',
            'source_entity_no': 'OCR-001',
            'route_name': 'ocr_review',
            'route_params': <String, dynamic>{'ocrId': 'ocr-001'},
            'created_at': '2026-04-04T10:00:00.000Z',
            'sync_state': 'pending',
            'primary_action': <String, dynamic>{
              'type': 'review_ocr',
              'label': 'Review now',
              'routeName': 'ocr_review',
              'routeParams': <String, dynamic>{'ocrId': 'ocr-001'},
              'enabled': true,
            },
          },
        ];

        final items = await dataSource.getTaskQueue();

        expect(items, hasLength(1));
        final item = items.single;
        expect(item.id, 'task-ocr-001');
        expect(item.type, TaskItemType.ocr);
        expect(item.status, TaskItemStatus.open);
        expect(item.severity, Severity.critical);
        expect(item.title, 'Review OCR mismatch');
        expect(item.routeName, 'ocr_review');
        expect(item.routeParams, <String, String>{'ocrId': 'ocr-001'});
        expect(item.primaryAction.type, TaskActionType.reviewOcr);
        expect(item.primaryAction.label, 'Review now');
        expect(item.syncState, SyncState.pending);
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
