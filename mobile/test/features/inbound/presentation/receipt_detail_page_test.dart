import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:smartlog_swm_mobile/app/router/app_router.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_permissions_snapshot_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_profile_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/login_request_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_sample_account.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_session.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_user.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartlog_swm_mobile/features/inbound/data/contracts/receipt_contract.dart';
import 'package:smartlog_swm_mobile/features/inbound/data/repositories/receipt_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/inbound/domain/repositories/receipt_repository.dart';
import 'package:smartlog_swm_mobile/features/inbound/presentation/pages/receipt_detail_page.dart';
import 'package:smartlog_swm_mobile/features/tasks/data/contracts/task_item_contract.dart';
import 'package:smartlog_swm_mobile/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/tasks/domain/repositories/task_repository.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_theme.dart';

void main() {
  Future<void> setLargeSurface(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(1440, 2600);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
  }

  Widget buildPageSubject({
    required AuthRepository authRepository,
    required ReceiptRepository receiptRepository,
    required String receiptId,
  }) {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
        receiptRepositoryProvider.overrideWithValue(receiptRepository),
      ],
      child: MaterialApp(
        theme: AppTheme.light(),
        home: ReceiptDetailPage(receiptId: receiptId),
      ),
    );
  }

  testWidgets('renders detail payload and footer actions', (
    WidgetTester tester,
  ) async {
    await setLargeSurface(tester);
    await tester.pumpWidget(
      buildPageSubject(
        authRepository: const _FakeAuthRepository(role: 'Warehouse Keeper'),
        receiptRepository: _FakeReceiptRepository(),
        receiptId: 'rcp-20260323-001',
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('RCP-240323-001'), findsWidgets);
    expect(find.text('Vinamilk Logistics'), findsOneWidget);
    expect(find.text('SKU-MILK-18L'), findsOneWidget);
    expect(
      find.text('Tài xế đã xác nhận số seal, chờ bắt đầu cân tại trạm số 1.'),
      findsOneWidget,
    );

    final startButton = find.byKey(const Key('receipt_action_startWeighing'));
    final approveButton = find.byKey(const Key('receipt_action_approve'));
    final dismissButton = find.byKey(const Key('receipt_action_dismiss'));
    final reviewButton = find.byKey(const Key('receipt_action_reviewOcr'));

    expect(startButton, findsOneWidget);
    expect(approveButton, findsOneWidget);
    expect(dismissButton, findsOneWidget);
    expect(reviewButton, findsOneWidget);

    expect(tester.widget<ElevatedButton>(startButton).onPressed, isNotNull);
    expect(tester.widget<OutlinedButton>(approveButton).onPressed, isNull);
  });

  testWidgets('shows variance warning when variance crosses threshold', (
    WidgetTester tester,
  ) async {
    await setLargeSurface(tester);
    await tester.pumpWidget(
      buildPageSubject(
        authRepository: const _FakeAuthRepository(role: 'Warehouse Keeper'),
        receiptRepository: _FakeReceiptRepository(),
        receiptId: 'rcp-variance-001',
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('receipt_variance_warning')), findsOneWidget);
  });

  testWidgets('loads receipt detail from route parameter', (
    WidgetTester tester,
  ) async {
    await setLargeSurface(tester);

    final receiptRepository = _FakeReceiptRepository();
    final taskRepository = _FakeTaskRepository();
    late ProviderContainer container;
    late GoRouter router;

    container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          const _FakeAuthRepository(role: 'Warehouse Keeper'),
        ),
        receiptRepositoryProvider.overrideWithValue(receiptRepository),
        taskRepositoryProvider.overrideWithValue(taskRepository),
      ],
    );
    addTearDown(container.dispose);
    router = container.read(appRouterProvider);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerConfig: router,
          theme: AppTheme.light(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    router.go(AppRoutePaths.receiptDetailPath('rcp-20260323-001'));
    await tester.pumpAndSettle();

    expect(find.byType(ReceiptDetailPage), findsOneWidget);
    expect(find.text('RCP-240323-001'), findsWidgets);
  });
}

class _FakeReceiptRepository implements ReceiptRepository {
  @override
  Future<List<ReceiptEntity>> getReceipts() async {
    return <ReceiptEntity>[_receipt001, _varianceReceipt];
  }

  @override
  Future<ReceiptEntity> getReceiptById(String receiptId) async {
    return switch (receiptId) {
      'rcp-20260323-001' => _receipt001,
      'rcp-variance-001' => _varianceReceipt,
      _ => (await getReceipts()).firstWhere(
        (receipt) => receipt.id == receiptId,
      ),
    };
  }

  ReceiptEntity get _receipt001 {
    return ReceiptEntity(
      id: 'rcp-20260323-001',
      receiptNo: 'RCP-240323-001',
      status: ReceiptStatus.waitingForWeighing,
      owner: const OwnerSummary(
        id: 'owner-001',
        code: 'VINAMILK',
        name: 'Vinamilk Logistics',
      ),
      warehouse: const WarehouseSummary(
        id: 'warehouse-001',
        code: 'BDG-WH-02',
        name: 'Binh Duong Overflow Warehouse',
      ),
      vehicle: const VehicleInfo(
        plateNumber: '51D-12345',
        driverName: 'Nguyen Minh Quan',
        vesselName: 'MV Mekong Star',
      ),
      purchaseOrderNo: 'PO-240323-001',
      billOfLadingNo: 'BL-240323-001',
      vesselName: 'MV Mekong Star',
      expectedWeightKg: 18250,
      receivedWeightKg: 0,
      portWeightKg: 18300,
      varianceWeightKg: 0,
      sourceOcrRecordId: 'ocr-20260323-001',
      syncState: SyncState.synced,
      availableActions: const <ActionCapability>[
        ActionCapability(
          type: TaskActionType.startWeighing,
          label: 'Bắt đầu cân',
        ),
        ActionCapability(
          type: TaskActionType.approve,
          label: 'Xác nhận nhập',
          enabled: false,
        ),
        ActionCapability(type: TaskActionType.dismiss, label: 'Báo lỗi'),
        ActionCapability(type: TaskActionType.reviewOcr, label: 'Liên kết OCR'),
      ],
      lines: const <ReceiptLineEntity>[
        ReceiptLineEntity(
          id: 'receipt-line-001',
          itemCode: 'SKU-MILK-18L',
          itemName: 'Sữa tươi tiệt trùng 18L',
          uomCode: 'CAN',
          expectedQty: 320,
          receivedQty: 0,
          varianceQty: 0,
        ),
        ReceiptLineEntity(
          id: 'receipt-line-002',
          itemCode: 'SKU-CREAM-05L',
          itemName: 'Kem sữa nguyên liệu 5L',
          uomCode: 'BOX',
          expectedQty: 180,
          receivedQty: 0,
          varianceQty: 0,
        ),
      ],
      note: 'Tài xế đã xác nhận số seal, chờ bắt đầu cân tại trạm số 1.',
      createdAt: DateTime.utc(2026, 3, 24, 6, 40),
      updatedAt: DateTime.utc(2026, 3, 24, 8, 10),
    );
  }

  ReceiptEntity get _varianceReceipt {
    return ReceiptEntity(
      id: 'rcp-variance-001',
      receiptNo: 'RCP-VARIANCE-001',
      status: ReceiptStatus.weighing1,
      owner: const OwnerSummary(
        id: 'owner-variance',
        code: 'NESTLE',
        name: 'Nestle Vietnam',
      ),
      warehouse: const WarehouseSummary(
        id: 'warehouse-variance',
        code: 'SGN-DC-01',
        name: 'Sai Gon Distribution Center',
      ),
      vehicle: const VehicleInfo(
        plateNumber: '50H-22114',
        driverName: 'Le Van Tuan',
      ),
      purchaseOrderNo: 'PO-240323-003',
      billOfLadingNo: 'BL-8899-003',
      expectedWeightKg: 12400,
      receivedWeightKg: 12180,
      portWeightKg: 12400,
      varianceWeightKg: -220,
      syncState: SyncState.synced,
      availableActions: const <ActionCapability>[
        ActionCapability(
          type: TaskActionType.startWeighing,
          label: 'Cập nhật cân',
        ),
      ],
      lines: const <ReceiptLineEntity>[
        ReceiptLineEntity(
          id: 'variance-line-001',
          itemCode: 'SKU-NES-01',
          itemName: 'Nguyên liệu pha chế',
          uomCode: 'BAG',
          expectedQty: 100,
          receivedQty: 96,
          varianceQty: -4,
        ),
      ],
      note: 'Cần xác nhận chênh lệch lớn trước khi duyệt.',
      createdAt: DateTime.utc(2026, 3, 24, 5, 30),
      updatedAt: DateTime.utc(2026, 3, 24, 7, 20),
    );
  }
}

class _FakeTaskRepository implements TaskRepository {
  @override
  Future<List<TaskItemEntity>> getTaskQueue() async {
    return const <TaskItemEntity>[];
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
