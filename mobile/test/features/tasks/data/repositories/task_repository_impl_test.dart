import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/core/network/app_http_client.dart';
import 'package:smartlog_swm_mobile/features/tasks/data/contracts/task_item_contract.dart';
import 'package:smartlog_swm_mobile/features/tasks/data/datasources/task_queue_api_data_source.dart';
import 'package:smartlog_swm_mobile/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';

void main() {
  group('TaskRepositoryImpl', () {
    test('maps api datasource dto list to entities', () async {
      final apiDataSource = _FakeTaskQueueApiDataSource(
        response: <TaskItemDto>[
          TaskItemDto(
            id: 'task-001',
            type: TaskItemType.receipt,
            status: TaskItemStatus.open,
            severity: Severity.high,
            title: 'Inbound receipt pending',
            sourceModule: 'inbound',
            sourceEntityType: 'receipt',
            sourceEntityId: 'rcp-001',
            sourceEntityNo: 'RCP-001',
            routeName: 'receipt_detail',
            routeParams: const <String, String>{'receiptId': 'rcp-001'},
            createdAt: DateTime.utc(2026, 4, 4, 10, 0),
            primaryAction: const ActionCapability(
              type: TaskActionType.startWeighing,
              label: 'Start weighing',
            ),
            syncState: SyncState.synced,
          ),
        ],
      );
      final repository = TaskRepositoryImpl(apiDataSource: apiDataSource);

      final entities = await repository.getTaskQueue();

      expect(apiDataSource.callCount, 1);
      expect(entities, hasLength(1));
      expect(entities.single.id, 'task-001');
      expect(entities.single.type, TaskItemType.receipt);
      expect(entities.single.status, TaskItemStatus.open);
      expect(entities.single.sourceEntityId, 'rcp-001');
      expect(entities.single.primaryAction.type, TaskActionType.startWeighing);
    });

    test('rethrows datasource errors', () async {
      final apiDataSource = _FakeTaskQueueApiDataSource(
        error: StateError('works endpoint unavailable'),
      );
      final repository = TaskRepositoryImpl(apiDataSource: apiDataSource);

      await expectLater(
        () => repository.getTaskQueue(),
        throwsA(isA<StateError>()),
      );
      expect(apiDataSource.callCount, 1);
    });
  });
}

class _FakeTaskQueueApiDataSource extends TaskQueueApiDataSource {
  _FakeTaskQueueApiDataSource({this.response, this.error})
    : super(httpClient: _NoopAppHttpClient());

  final List<TaskItemDto>? response;
  final Object? error;

  int callCount = 0;

  @override
  Future<List<TaskItemDto>> getTaskQueue() async {
    callCount += 1;
    if (error != null) {
      throw error!;
    }

    return response ?? const <TaskItemDto>[];
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
