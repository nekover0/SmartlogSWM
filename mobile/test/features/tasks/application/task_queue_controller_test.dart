import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/app/shell/application/controllers/app_shell_controller.dart';
import 'package:smartlog_swm_mobile/features/auth/application/controllers/auth_controller.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/login_request_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_sample_account.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_session.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_user.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartlog_swm_mobile/features/tasks/application/controllers/task_queue_controller.dart';
import 'package:smartlog_swm_mobile/features/tasks/data/contracts/task_item_contract.dart';
import 'package:smartlog_swm_mobile/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/tasks/domain/repositories/task_repository.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';

void main() {
  group('TaskQueueController', () {
    late _FakeTaskRepository taskRepository;
    late ProviderContainer container;

    setUp(() {
      taskRepository = _FakeTaskRepository();
      container = ProviderContainer(
        overrides: [taskRepositoryProvider.overrideWithValue(taskRepository)],
      );
      addTearDown(container.dispose);
    });

    test('loads fixture-backed task data and derives pending counts', () async {
      final state = await container.read(taskQueueControllerProvider.future);

      expect(state.pendingTaskCount, 3);
      expect(state.criticalTaskCount, 1);
      expect(state.availableTypes, [TaskItemType.receipt, TaskItemType.ocr]);
    });

    test('sorts critical work first, then by urgency and age', () async {
      final state = await container.read(taskQueueControllerProvider.future);

      expect(
        state.visibleItems.map((item) => item.id).toList(),
        <String>[
          'task-receipt-critical-001',
          'task-ocr-review-001',
          'task-receipt-normal-001',
        ],
      );
    });

    test('filters by severity and type independently', () async {
      await container.read(taskQueueControllerProvider.future);

      container
          .read(taskQueueControllerProvider.notifier)
          .setSeverityFilter(Severity.critical);
      expect(
        container
            .read(taskQueueControllerProvider)
            .valueOrNull
            ?.visibleItems
            .map((item) => item.id)
            .toList(),
        <String>['task-receipt-critical-001'],
      );

      container
          .read(taskQueueControllerProvider.notifier)
          .setTypeFilter(TaskItemType.ocr);
      expect(
        container.read(taskQueueControllerProvider).valueOrNull?.visibleItems,
        isEmpty,
      );

      container.read(taskQueueControllerProvider.notifier).clearFilters();
      container
          .read(taskQueueControllerProvider.notifier)
          .setTypeFilter(TaskItemType.ocr);
      expect(
        container
            .read(taskQueueControllerProvider)
            .valueOrNull
            ?.visibleItems
            .map((item) => item.id)
            .toList(),
        <String>['task-ocr-review-001'],
      );
    });

    test('derives shell badge counts from the task queue controller', () async {
      final authRepository = _FakeAuthRepository();
      final shellContainer = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(authRepository),
          taskRepositoryProvider.overrideWithValue(taskRepository),
        ],
      );
      addTearDown(shellContainer.dispose);

      await shellContainer.read(authControllerProvider.future);
      await shellContainer.read(taskQueueControllerProvider.future);

      final shellState = shellContainer.read(appShellControllerProvider);

      expect(shellState.badgeCounts.tasks, 3);
      expect(shellState.showTasksTab, isTrue);
    });
  });
}

class _FakeTaskRepository implements TaskRepository {
  @override
  Future<List<TaskItemEntity>> getTaskQueue() async {
    return <TaskItemEntity>[
      TaskItemEntity(
        id: 'task-receipt-critical-001',
        type: TaskItemType.receipt,
        status: TaskItemStatus.open,
        severity: Severity.critical,
        title: 'Phiếu nhập RCP-240323-001 chờ cân lần 1',
        description: 'Xe 51D-12345 đã vào cổng nhưng chưa bắt đầu cân.',
        sourceModule: 'inbound',
        sourceEntityType: 'receipt',
        sourceEntityId: 'rcp-20260323-001',
        sourceEntityNo: 'RCP-240323-001',
        routeName: 'receipt_detail',
        routeParams: const <String, String>{
          'receiptId': 'rcp-20260323-001',
        },
        ageMinutes: 95,
        dueAt: DateTime.utc(2026, 3, 24, 8, 15),
        createdAt: DateTime.utc(2026, 3, 24, 6, 40),
        primaryAction: const ActionCapability(
          type: TaskActionType.startWeighing,
          label: 'Bắt đầu cân',
          routeName: 'receipt_detail',
          routeParams: <String, String>{'receiptId': 'rcp-20260323-001'},
        ),
        secondaryActions: const <ActionCapability>[
          ActionCapability(type: TaskActionType.acknowledge, label: 'Đã hiểu'),
        ],
        syncState: SyncState.synced,
      ),
      TaskItemEntity(
        id: 'task-receipt-normal-001',
        type: TaskItemType.receipt,
        status: TaskItemStatus.open,
        severity: Severity.medium,
        title: '2 phiếu nhập mới cần xác nhận chứng từ',
        description: 'Kiểm tra danh sách phiếu nhập đến trong ca sáng.',
        sourceModule: 'inbound',
        sourceEntityType: 'receipt_list',
        sourceEntityNo: 'Inbound Queue',
        routeName: 'receipt_list',
        ageMinutes: 28,
        createdAt: DateTime.utc(2026, 3, 24, 7, 47),
        primaryAction: const ActionCapability(
          type: TaskActionType.open,
          label: 'Mở danh sách',
          routeName: 'receipt_list',
        ),
        syncState: SyncState.synced,
      ),
      TaskItemEntity(
        id: 'task-ocr-review-001',
        type: TaskItemType.ocr,
        status: TaskItemStatus.acknowledged,
        severity: Severity.high,
        title: '3 chứng từ OCR cần xem xét',
        description: 'Có trường confidence thấp cần người dùng xác nhận lại.',
        sourceModule: 'ocr',
        sourceEntityType: 'ocr_queue',
        sourceEntityNo: 'OCR Inbox',
        routeName: 'ocr_inbox',
        ageMinutes: 44,
        createdAt: DateTime.utc(2026, 3, 24, 7, 31),
        primaryAction: const ActionCapability(
          type: TaskActionType.reviewOcr,
          label: 'Review OCR',
          routeName: 'ocr_inbox',
        ),
        secondaryActions: const <ActionCapability>[
          ActionCapability(type: TaskActionType.dismiss, label: 'Bỏ qua'),
        ],
        syncState: SyncState.pending,
      ),
    ];
  }
}

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<List<AuthSampleAccount>> getSampleAccounts() async {
    return const <AuthSampleAccount>[];
  }

  @override
  Future<AuthSession> login(LoginRequestDto request) async {
    return _session;
  }

  @override
  Future<void> logout() async {}

  @override
  Future<AuthSession?> restoreSession() async {
    return _session;
  }

  static final _session = AuthSession(
    accessToken: 'fixture-token-user-keeper-001',
    currentUser: const AuthUser(
      id: 'user-keeper-001',
      username: 'warehouse.keeper',
      displayName: 'Warehouse Keeper',
      role: 'Warehouse Keeper',
      siteId: 'bdg-wh-02',
      siteName: 'Binh Duong Overflow Warehouse',
    ),
    loggedInAt: DateTime.utc(2026, 3, 24, 9, 0),
    persistedAt: DateTime.utc(2026, 3, 24, 9, 0),
  );
}
