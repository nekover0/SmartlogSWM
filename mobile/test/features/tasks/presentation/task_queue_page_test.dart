import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:smartlog_swm_mobile/app/router/app_router.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_permissions_snapshot_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_profile_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/login_request_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_sample_account.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_session.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_user.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartlog_swm_mobile/features/inbound/presentation/pages/receipt_detail_page.dart';
import 'package:smartlog_swm_mobile/features/tasks/data/contracts/task_item_contract.dart';
import 'package:smartlog_swm_mobile/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/tasks/domain/repositories/task_repository.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_theme.dart';

void main() {
  late ProviderContainer container;
  late GoRouter router;
  late _FakeTaskRepository taskRepository;

  Widget buildSubject({required _FakeAuthRepository authRepository}) {
    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
        taskRepositoryProvider.overrideWithValue(taskRepository),
      ],
    );
    addTearDown(container.dispose);
    router = container.read(appRouterProvider);

    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(routerConfig: router, theme: AppTheme.light()),
    );
  }

  setUp(() {
    taskRepository = _FakeTaskRepository();
  });

  Future<void> setLargeSurface(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(1440, 2600);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
  }

  testWidgets('renders task cards and shows shell badge from controller data', (
    WidgetTester tester,
  ) async {
    await setLargeSurface(tester);
    await tester.pumpWidget(
      buildSubject(
        authRepository: const _FakeAuthRepository(role: 'Warehouse Keeper'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('task_queue_header_total')), findsOneWidget);
    expect(find.byKey(const Key('task_queue_header_critical')), findsOneWidget);
    expect(
      find.text('Phiếu nhập RCP-240323-001 chờ cân lần 1'),
      findsOneWidget,
    );
    expect(find.text('3 chứng từ OCR cần xem xét'), findsOneWidget);

    final badge = find.byKey(const Key('bottom_nav_badge_1'));
    expect(badge, findsOneWidget);
    expect(
      find.descendant(of: badge, matching: find.text('3')),
      findsOneWidget,
    );
  });

  testWidgets(
    'filters by severity and type and shows empty state when no task matches',
    (WidgetTester tester) async {
      await setLargeSurface(tester);
      await tester.pumpWidget(
        buildSubject(
          authRepository: const _FakeAuthRepository(role: 'Warehouse Keeper'),
        ),
      );
      await tester.pumpAndSettle();

      final criticalSeverityFilter = find.byKey(
        const Key('task_filter_severity_critical'),
      );
      await tester.ensureVisible(criticalSeverityFilter);
      await tester.tap(criticalSeverityFilter);
      await tester.pumpAndSettle();

      expect(
        find.text('Phiếu nhập RCP-240323-001 chờ cân lần 1'),
        findsOneWidget,
      );
      expect(find.text('3 chứng từ OCR cần xem xét'), findsNothing);

      final ocrTypeFilter = find.byKey(const Key('task_filter_type_ocr'));
      await tester.ensureVisible(ocrTypeFilter);
      await tester.tap(ocrTypeFilter);
      await tester.pumpAndSettle();

      expect(find.text('Không có task phù hợp'), findsOneWidget);

      final clearButton = find.byKey(const Key('task_filter_clear_button'));
      await tester.ensureVisible(clearButton);
      await tester.tap(clearButton);
      await tester.pumpAndSettle();

      await tester.ensureVisible(ocrTypeFilter);
      await tester.tap(ocrTypeFilter);
      await tester.pumpAndSettle();

      expect(find.text('3 chứng từ OCR cần xem xét'), findsOneWidget);
      expect(
        find.text('Phiếu nhập RCP-240323-001 chờ cân lần 1'),
        findsNothing,
      );
    },
  );

  testWidgets('task CTA deep-links into the receipt detail route', (
    WidgetTester tester,
  ) async {
    await setLargeSurface(tester);
    await tester.pumpWidget(
      buildSubject(
        authRepository: const _FakeAuthRepository(role: 'Warehouse Keeper'),
      ),
    );
    await tester.pumpAndSettle();

    final primaryAction = find.byKey(
      const Key('task_card_primary_action_task-receipt-critical-001'),
    );
    await tester.scrollUntilVisible(primaryAction, 300);
    await tester.tap(primaryAction);
    await tester.pumpAndSettle();

    expect(find.byType(ReceiptDetailPage), findsOneWidget);
    expect(find.text('Chi tiết phiếu nhập'), findsOneWidget);
    expect(find.text('RCP-240323-001'), findsWidgets);
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
        routeParams: const <String, String>{'receiptId': 'rcp-20260323-001'},
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
  const _FakeAuthRepository({required this.role});

  final String role;

  @override
  Future<List<AuthSampleAccount>> getSampleAccounts() async {
    return const <AuthSampleAccount>[];
  }

  @override
  Future<AuthSession> login(LoginRequestDto request) async {
    return _session;
  }

  @override
  Future<AuthProfileDto> getMe() async {
    return AuthProfileDto(
      id: _session.currentUser.id,
      userCode: _session.currentUser.username,
      username: _session.currentUser.username,
      fullName: _session.currentUser.displayName,
      roleCodes: <String>[_session.currentUser.role],
      selectedWarehouseId: _session.currentUser.siteId,
      warehouseOptions: const [],
      ownerScope: const <String>[],
      channel: 'MOBILE',
      mustChangePassword: false,
    );
  }

  @override
  Future<AuthPermissionsSnapshotDto> getMyPermissions() async {
    return AuthPermissionsSnapshotDto(
      roleCodes: <String>[_session.currentUser.role],
      permissions: const <String>[],
      warehouseScope: const <String>[],
      ownerScope: const <String>[],
    );
  }

  @override
  Future<void> logout() async {}

  @override
  Future<AuthSession?> restoreSession() async {
    return _session;
  }

  AuthSession get _session {
    return AuthSession(
      accessToken: 'fixture-token-user-keeper-001',
      currentUser: AuthUser(
        id: 'user-keeper-001',
        username: 'warehouse.keeper',
        displayName: 'Warehouse Keeper',
        role: role,
        siteId: 'bdg-wh-02',
        siteName: 'Binh Duong Overflow Warehouse',
      ),
      loggedInAt: DateTime.utc(2026, 3, 24, 9, 0),
      persistedAt: DateTime.utc(2026, 3, 24, 9, 0),
    );
  }
}
