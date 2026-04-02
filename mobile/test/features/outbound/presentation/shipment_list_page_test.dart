import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_permissions_snapshot_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_profile_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/login_request_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_sample_account.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_session.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_user.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartlog_swm_mobile/features/outbound/data/contracts/shipment_contract.dart';
import 'package:smartlog_swm_mobile/features/outbound/data/repositories/shipment_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/outbound/domain/repositories/shipment_repository.dart';
import 'package:smartlog_swm_mobile/features/outbound/presentation/pages/shipment_list_page.dart';
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
    required ShipmentRepository shipmentRepository,
  }) {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
        shipmentRepositoryProvider.overrideWithValue(shipmentRepository),
      ],
      child: MaterialApp(
        theme: AppTheme.light(),
        home: const ShipmentListPage(),
      ),
    );
  }

  testWidgets(
    'renders shipment list and create CTA for mutable outbound role',
    (WidgetTester tester) async {
      await setLargeSurface(tester);
      await tester.pumpWidget(
        buildSubject(
          authRepository: const _FakeAuthRepository(role: 'Warehouse Keeper'),
          shipmentRepository: _FakeShipmentRepository(),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('shipment_list_back_button')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('shipment_list_create_button')),
        findsOneWidget,
      );
      expect(find.text('SHP-240324-001'), findsOneWidget);
      expect(find.text('SHP-240324-004'), findsOneWidget);
    },
  );

  testWidgets('filters by status chip, overdue chip, and search query', (
    WidgetTester tester,
  ) async {
    await setLargeSurface(tester);
    await tester.pumpWidget(
      buildSubject(
        authRepository: const _FakeAuthRepository(role: 'Warehouse Keeper'),
        shipmentRepository: _FakeShipmentRepository(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('shipment_status_chip_shipped')));
    await tester.pumpAndSettle();

    expect(find.text('SHP-240324-003'), findsOneWidget);
    expect(find.text('SHP-240324-001'), findsNothing);

    await tester.tap(find.byKey(const Key('shipment_filter_clear_button')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('shipment_overdue_chip')));
    await tester.pumpAndSettle();

    expect(find.text('SHP-240324-001'), findsOneWidget);
    expect(find.text('SHP-240324-002'), findsOneWidget);
    expect(find.text('SHP-240324-003'), findsNothing);
    expect(find.text('SHP-240324-004'), findsNothing);

    await tester.enterText(
      find.byKey(const Key('shipment_search_field')),
      '50H-22114',
    );
    await tester.pumpAndSettle();

    expect(find.text('SHP-240324-003'), findsNothing);

    await tester.tap(find.byKey(const Key('shipment_filter_clear_button')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('shipment_search_field')),
      '50H-22114',
    );
    await tester.pumpAndSettle();

    expect(find.text('SHP-240324-003'), findsOneWidget);
    expect(find.text('SHP-240324-001'), findsNothing);
  });
}

class _FakeShipmentRepository implements ShipmentRepository {
  @override
  Future<List<ShipmentEntity>> getShipments() async {
    return <ShipmentEntity>[
      _buildShipment(
        id: 'shp-20260324-001',
        shipmentNo: 'SHP-240324-001',
        status: ShipmentStatus.picking,
        ownerCode: 'VINAMILK',
        ownerName: 'Vinamilk Logistics',
        warehouseCode: 'BDG-WH-02',
        warehouseName: 'Binh Duong Overflow Warehouse',
        plateNumber: '51D-12345',
        salesOrderNo: 'SO-240324-001',
        billOfLadingNo: 'BL-240324-001',
        expectedWeightKg: 18250,
        shippedWeightKg: 6400,
        varianceWeightKg: -11850,
        syncState: SyncState.pending,
      ),
      _buildShipment(
        id: 'shp-20260324-002',
        shipmentNo: 'SHP-240324-002',
        status: ShipmentStatus.loading,
        ownerCode: 'MASAN',
        ownerName: 'Masan Consumer',
        warehouseCode: 'BDG-WH-02',
        warehouseName: 'Binh Duong Overflow Warehouse',
        plateNumber: '61H-55088',
        salesOrderNo: 'SO-240324-002',
        billOfLadingNo: 'BL-240324-002',
        expectedWeightKg: 16000,
        shippedWeightKg: 12100,
        varianceWeightKg: -3900,
        syncState: SyncState.pending,
      ),
      _buildShipment(
        id: 'shp-20260324-003',
        shipmentNo: 'SHP-240324-003',
        status: ShipmentStatus.shipped,
        ownerCode: 'NESTLE',
        ownerName: 'Nestle Vietnam',
        warehouseCode: 'SGN-DC-01',
        warehouseName: 'Sai Gon Distribution Center',
        plateNumber: '50H-22114',
        salesOrderNo: 'SO-240324-003',
        billOfLadingNo: 'BL-8899-003',
        expectedWeightKg: 12400,
        shippedWeightKg: 12410,
        varianceWeightKg: 10,
        syncState: SyncState.synced,
      ),
      _buildShipment(
        id: 'shp-20260324-004',
        shipmentNo: 'SHP-240324-004',
        status: ShipmentStatus.error,
        ownerCode: 'AJINOMOTO',
        ownerName: 'Ajinomoto Vietnam',
        warehouseCode: 'SGN-DC-01',
        warehouseName: 'Sai Gon Distribution Center',
        plateNumber: '51C-90909',
        salesOrderNo: 'SO-240324-004',
        billOfLadingNo: 'BL-240324-004',
        expectedWeightKg: 9800,
        shippedWeightKg: 0,
        varianceWeightKg: -9800,
        syncState: SyncState.failed,
      ),
    ];
  }

  @override
  Future<ShipmentEntity> getShipmentById(String shipmentId) async {
    return (await getShipments()).firstWhere(
      (shipment) => shipment.id == shipmentId,
    );
  }
}

ShipmentEntity _buildShipment({
  required String id,
  required String shipmentNo,
  required ShipmentStatus status,
  required String ownerCode,
  required String ownerName,
  required String warehouseCode,
  required String warehouseName,
  required String plateNumber,
  required String salesOrderNo,
  required String billOfLadingNo,
  required double expectedWeightKg,
  required double shippedWeightKg,
  required double varianceWeightKg,
  required SyncState syncState,
}) {
  return ShipmentEntity(
    id: id,
    shipmentNo: shipmentNo,
    status: status,
    owner: OwnerSummary(id: 'owner-$id', code: ownerCode, name: ownerName),
    warehouse: WarehouseSummary(
      id: 'warehouse-$id',
      code: warehouseCode,
      name: warehouseName,
    ),
    vehicle: VehicleInfo(plateNumber: plateNumber, driverName: 'Driver $id'),
    salesOrderNo: salesOrderNo,
    billOfLadingNo: billOfLadingNo,
    expectedWeightKg: expectedWeightKg,
    shippedWeightKg: shippedWeightKg,
    varianceWeightKg: varianceWeightKg,
    syncState: syncState,
    availableActions: const <ActionCapability>[
      ActionCapability(type: TaskActionType.open, label: 'Xem phiếu'),
    ],
    createdAt: DateTime.utc(2026, 3, 24, 6, 10),
    updatedAt: DateTime.utc(2026, 3, 24, 8, 0),
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
