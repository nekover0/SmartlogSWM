import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/app/router/app_router.dart';
import 'package:smartlog_swm_mobile/core/permissions/permission_service.dart';
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
import 'package:smartlog_swm_mobile/features/inbound/presentation/pages/receipt_list_page.dart';
import 'package:smartlog_swm_mobile/features/scan/domain/models/scan_launch_context.dart';
import 'package:smartlog_swm_mobile/features/scan/presentation/pages/barcode_scan_page.dart';
import 'package:smartlog_swm_mobile/features/tasks/data/contracts/task_item_contract.dart';
import 'package:smartlog_swm_mobile/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/tasks/domain/repositories/task_repository.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_theme.dart';
import 'package:smartlog_swm_mobile/shared/widgets/app_forbidden_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> setLargeSurface(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(1440, 2600);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
  }

  Future<void> settleUi(WidgetTester tester, {int passes = 6}) async {
    await tester.pump();
    for (var index = 0; index < passes; index++) {
      await tester.pump(const Duration(milliseconds: 140));
    }
  }

  testWidgets('empty task queue shows the shared empty state', (
    WidgetTester tester,
  ) async {
    await setLargeSurface(tester);
    final harness = _RouterHarness(
      authRepository: const _FakeAuthRepository(role: 'Warehouse Keeper'),
      taskRepository: const _EmptyTaskRepository(),
    );
    addTearDown(harness.dispose);

    await tester.pumpWidget(harness.build());
    await settleUi(tester);

    harness.router.go(AppRoutePaths.tasks);
    await settleUi(tester);

    expect(find.text('Không có task phù hợp'), findsOneWidget);
    expect(find.text('Chưa có task nào đang mở trong ca hiện tại.'), findsOneWidget);
  });

  testWidgets('receipt list shows no-result empty state after search misses', (
    WidgetTester tester,
  ) async {
    await setLargeSurface(tester);

    await tester.pumpWidget(
      _buildReceiptListSubject(
        authRepository: const _FakeAuthRepository(role: 'Warehouse Keeper'),
        receiptRepository: const _StaticReceiptRepository(),
      ),
    );
    await settleUi(tester);

    await tester.enterText(
      find.byKey(const Key('receipt_search_field')),
      'no-match-2026',
    );
    await settleUi(tester);

    expect(find.text('Không có phiếu phù hợp'), findsOneWidget);
    expect(
      find.text('Thử nới bộ lọc hoặc tìm bằng từ khóa khác.'),
      findsOneWidget,
    );
  });

  testWidgets('missing receipt detail shows explicit not-found state', (
    WidgetTester tester,
  ) async {
    await setLargeSurface(tester);

    await tester.pumpWidget(
      _buildReceiptDetailSubject(
        authRepository: const _FakeAuthRepository(role: 'Warehouse Keeper'),
        receiptRepository: const _MissingReceiptRepository(),
        receiptId: 'missing-receipt-001',
      ),
    );
    await settleUi(tester, passes: 8);

    expect(find.text('Không tìm thấy phiếu nhập'), findsOneWidget);
    expect(
      find.text('Phiếu nhập này không còn tồn tại hoặc bạn cần tải lại queue inbound.'),
      findsOneWidget,
    );
  });

  testWidgets('denied scan permission falls back to shared forbidden state', (
    WidgetTester tester,
  ) async {
    await setLargeSurface(tester);

    await tester.pumpWidget(
      _buildScanSubject(
        permissionService: const FakePermissionService(
          currentStatus: CameraPermissionStatus.denied,
          requestStatus: CameraPermissionStatus.denied,
        ),
      ),
    );
    await settleUi(tester);

    expect(find.byType(AppForbiddenState), findsOneWidget);
    expect(find.text('Cần quyền camera'), findsOneWidget);
    expect(find.text('Cấp quyền lại'), findsOneWidget);
  });

  testWidgets('forbidden route redirects to the first allowed shell route', (
    WidgetTester tester,
  ) async {
    await setLargeSurface(tester);
    final harness = _RouterHarness(
      authRepository: const _FakeAuthRepository(role: 'Billing Officer'),
      taskRepository: const _EmptyTaskRepository(),
      permissionService: const FakePermissionService(
        currentStatus: CameraPermissionStatus.granted,
      ),
    );
    addTearDown(harness.dispose);

    await tester.pumpWidget(harness.build());
    await settleUi(tester);

    harness.router.go(
      buildScanBarcodeLocation(
        launchContext: const ScanLaunchContext(
          mode: ScanMode.receive,
          referenceId: 'rcp-20260323-001',
          warehouseId: 'warehouse-001',
        ),
      ),
    );
    await settleUi(tester);

    expect(
      harness.router.routeInformationProvider.value.uri.path,
      AppRoutePaths.tasks,
    );
  });
}

class _RouterHarness {
  _RouterHarness({
    required AuthRepository authRepository,
    TaskRepository? taskRepository,
    PermissionService? permissionService,
  }) : container = ProviderContainer(
         overrides: [
           authRepositoryProvider.overrideWithValue(authRepository),
           if (taskRepository != null)
             taskRepositoryProvider.overrideWithValue(taskRepository),
           if (permissionService != null)
             permissionServiceProvider.overrideWithValue(permissionService),
         ],
       ) {
    router = container.read(appRouterProvider);
  }

  final ProviderContainer container;
  late final GoRouter router;

  Widget build() {
    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        routerConfig: router,
        theme: AppTheme.light(),
      ),
    );
  }

  void dispose() {
    container.dispose();
  }
}

Widget _buildReceiptListSubject({
  required AuthRepository authRepository,
  required ReceiptRepository receiptRepository,
}) {
  return ProviderScope(
    overrides: [
      authRepositoryProvider.overrideWithValue(authRepository),
      receiptRepositoryProvider.overrideWithValue(receiptRepository),
    ],
    child: MaterialApp(
      theme: AppTheme.light(),
      home: const ReceiptListPage(),
    ),
  );
}

Widget _buildReceiptDetailSubject({
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

Widget _buildScanSubject({
  required PermissionService permissionService,
}) {
  return ProviderScope(
    overrides: [
      permissionServiceProvider.overrideWithValue(permissionService),
    ],
    child: MaterialApp(
      theme: AppTheme.light(),
      home: const BarcodeScanPage(
        launchContext: ScanLaunchContext(
          mode: ScanMode.receive,
          referenceId: 'rcp-20260323-001',
          warehouseId: 'warehouse-001',
        ),
      ),
    ),
  );
}

class _StaticReceiptRepository implements ReceiptRepository {
  const _StaticReceiptRepository();

  @override
  Future<List<ReceiptEntity>> getReceipts() async {
    return <ReceiptEntity>[
      _buildReceipt(
        id: 'rcp-20260323-001',
        receiptNo: 'RCP-240323-001',
        status: ReceiptStatus.waitingForWeighing,
        plateNumber: '51D-12345',
      ),
      _buildReceipt(
        id: 'rcp-20260323-003',
        receiptNo: 'RCP-240323-003',
        status: ReceiptStatus.weighing1,
        plateNumber: '50H-22114',
      ),
    ];
  }

  @override
  Future<ReceiptEntity> getReceiptById(String receiptId) async {
    return (await getReceipts()).firstWhere((receipt) => receipt.id == receiptId);
  }
}

class _MissingReceiptRepository implements ReceiptRepository {
  const _MissingReceiptRepository();

  @override
  Future<List<ReceiptEntity>> getReceipts() async {
    return const <ReceiptEntity>[];
  }

  @override
  Future<ReceiptEntity> getReceiptById(String receiptId) async {
    throw StateError('Receipt $receiptId was not found');
  }
}

class _EmptyTaskRepository implements TaskRepository {
  const _EmptyTaskRepository();

  @override
  Future<List<TaskItemEntity>> getTaskQueue() async {
    return const <TaskItemEntity>[];
  }
}

ReceiptEntity _buildReceipt({
  required String id,
  required String receiptNo,
  required ReceiptStatus status,
  required String plateNumber,
}) {
  return ReceiptEntity(
    id: id,
    receiptNo: receiptNo,
    status: status,
    owner: OwnerSummary(
      id: 'owner-$id',
      code: 'VINAMILK',
      name: 'Vinamilk Logistics',
    ),
    warehouse: WarehouseSummary(
      id: 'warehouse-$id',
      code: 'BDG-WH-02',
      name: 'Binh Duong Overflow Warehouse',
    ),
    vehicle: VehicleInfo(
      plateNumber: plateNumber,
      driverName: 'Driver $id',
    ),
    purchaseOrderNo: 'PO-$id',
    billOfLadingNo: 'BL-$id',
    expectedWeightKg: 18250,
    receivedWeightKg: 0,
    varianceWeightKg: 0,
    syncState: SyncState.synced,
    availableActions: const <ActionCapability>[
      ActionCapability(type: TaskActionType.open, label: 'Xem phiếu'),
    ],
    note: 'Receipt fixture $receiptNo',
    createdAt: DateTime.utc(2026, 3, 24, 6, 40),
    updatedAt: DateTime.utc(2026, 3, 24, 8, 5),
  );
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
  Future<void> logout() async {}

  @override
  Future<AuthSession?> restoreSession() async {
    return _session;
  }

  AuthSession get _session {
    return AuthSession(
      accessToken: 'fixture-token-${role.toLowerCase().replaceAll(' ', '-')}',
      currentUser: AuthUser(
        id: 'user-${role.toLowerCase().replaceAll(' ', '-')}',
        username: 'fixture.user',
        displayName: role,
        role: role,
        siteId: 'bdg-wh-02',
        siteName: 'Binh Duong Overflow Warehouse',
      ),
      loggedInAt: DateTime.utc(2026, 3, 24, 9, 0),
      persistedAt: DateTime.utc(2026, 3, 24, 9, 0),
    );
  }
}
