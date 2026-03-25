import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/login_request_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_sample_account.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_session.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_user.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartlog_swm_mobile/features/inbound/data/contracts/receipt_contract.dart';
import 'package:smartlog_swm_mobile/features/inbound/data/repositories/receipt_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/inbound/domain/repositories/receipt_repository.dart';
import 'package:smartlog_swm_mobile/features/inbound/presentation/pages/receipt_list_page.dart';
import 'package:smartlog_swm_mobile/shared/contracts/shared_contracts.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_theme.dart';

void main() {
  Future<void> setLargeSurface(WidgetTester tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(1440, 2600);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
  }

  Widget buildSubject({
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

  testWidgets('renders receipt list and create CTA for mutable inbound role', (
    WidgetTester tester,
  ) async {
    await setLargeSurface(tester);
    await tester.pumpWidget(
      buildSubject(
        authRepository: const _FakeAuthRepository(role: 'Warehouse Keeper'),
        receiptRepository: _FakeReceiptRepository(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('receipt_list_back_button')), findsOneWidget);
    expect(find.byKey(const Key('receipt_list_create_button')), findsOneWidget);
    expect(find.text('RCP-240323-001'), findsOneWidget);
    expect(find.text('RCP-240323-004'), findsOneWidget);
  });

  testWidgets('filters by status chip and search query', (
    WidgetTester tester,
  ) async {
    await setLargeSurface(tester);
    await tester.pumpWidget(
      buildSubject(
        authRepository: const _FakeAuthRepository(role: 'Warehouse Keeper'),
        receiptRepository: _FakeReceiptRepository(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('receipt_status_chip_completed')));
    await tester.pumpAndSettle();

    expect(find.text('RCP-240323-004'), findsOneWidget);
    expect(find.text('RCP-240323-001'), findsNothing);

    await tester.tap(find.byKey(const Key('receipt_filter_clear_button')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('receipt_search_field')),
      '50H-22114',
    );
    await tester.pumpAndSettle();

    expect(find.text('RCP-240323-003'), findsOneWidget);
    expect(find.text('RCP-240323-001'), findsNothing);
    expect(find.text('RCP-240323-004'), findsNothing);
  });
}

class _FakeReceiptRepository implements ReceiptRepository {
  @override
  Future<List<ReceiptEntity>> getReceipts() async {
    return <ReceiptEntity>[
      _buildReceipt(
        id: 'rcp-20260323-001',
        receiptNo: 'RCP-240323-001',
        status: ReceiptStatus.waitingForWeighing,
        ownerCode: 'VINAMILK',
        ownerName: 'Vinamilk Logistics',
        warehouseCode: 'BDG-WH-02',
        warehouseName: 'Binh Duong Overflow Warehouse',
        plateNumber: '51D-12345',
        purchaseOrderNo: 'PO-240323-001',
        billOfLadingNo: 'BL-240323-001',
        expectedWeightKg: 18250,
        receivedWeightKg: 0,
        varianceWeightKg: 0,
        syncState: SyncState.synced,
        note: 'Xe đã vào cổng, đang chờ vào trạm cân.',
        updatedAt: DateTime.utc(2026, 3, 24, 8, 5),
      ),
      _buildReceipt(
        id: 'rcp-20260323-003',
        receiptNo: 'RCP-240323-003',
        status: ReceiptStatus.weighing1,
        ownerCode: 'NESTLE',
        ownerName: 'Nestle Vietnam',
        warehouseCode: 'SGN-DC-01',
        warehouseName: 'Sai Gon Distribution Center',
        plateNumber: '50H-22114',
        purchaseOrderNo: 'PO-240323-003',
        billOfLadingNo: 'BL-8899-003',
        expectedWeightKg: 12400,
        receivedWeightKg: 12180,
        varianceWeightKg: -220,
        syncState: SyncState.synced,
        note: 'Đã cân lần 1, chờ nhập kết quả cân lần 2.',
        updatedAt: DateTime.utc(2026, 3, 24, 7, 20),
      ),
      _buildReceipt(
        id: 'rcp-20260323-004',
        receiptNo: 'RCP-240323-004',
        status: ReceiptStatus.completed,
        ownerCode: 'AJINOMOTO',
        ownerName: 'Ajinomoto Vietnam',
        warehouseCode: 'SGN-DC-01',
        warehouseName: 'Sai Gon Distribution Center',
        plateNumber: '51C-90909',
        purchaseOrderNo: 'PO-240322-014',
        billOfLadingNo: 'BL-240322-014',
        expectedWeightKg: 9800,
        receivedWeightKg: 9810,
        varianceWeightKg: 10,
        syncState: SyncState.synced,
        note: 'Phiếu đã hoàn tất.',
        updatedAt: DateTime.utc(2026, 3, 23, 16, 50),
      ),
    ];
  }

  @override
  Future<ReceiptEntity> getReceiptById(String receiptId) async {
    return (await getReceipts()).firstWhere(
      (receipt) => receipt.id == receiptId,
    );
  }
}

ReceiptEntity _buildReceipt({
  required String id,
  required String receiptNo,
  required ReceiptStatus status,
  required String ownerCode,
  required String ownerName,
  required String warehouseCode,
  required String warehouseName,
  required String plateNumber,
  required String purchaseOrderNo,
  required String billOfLadingNo,
  required double expectedWeightKg,
  required double receivedWeightKg,
  required double varianceWeightKg,
  required SyncState syncState,
  required String note,
  required DateTime updatedAt,
}) {
  return ReceiptEntity(
    id: id,
    receiptNo: receiptNo,
    status: status,
    owner: OwnerSummary(id: 'owner-$id', code: ownerCode, name: ownerName),
    warehouse: WarehouseSummary(
      id: 'warehouse-$id',
      code: warehouseCode,
      name: warehouseName,
    ),
    vehicle: VehicleInfo(plateNumber: plateNumber, driverName: 'Driver $id'),
    purchaseOrderNo: purchaseOrderNo,
    billOfLadingNo: billOfLadingNo,
    expectedWeightKg: expectedWeightKg,
    receivedWeightKg: receivedWeightKg,
    varianceWeightKg: varianceWeightKg,
    syncState: syncState,
    availableActions: const <ActionCapability>[
      ActionCapability(type: TaskActionType.open, label: 'Xem phiếu'),
    ],
    note: note,
    createdAt: DateTime.utc(2026, 3, 24, 6, 40),
    updatedAt: updatedAt,
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
