import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/core/storage/secure_storage_service.dart';
import 'package:smartlog_swm_mobile/features/auth/application/controllers/auth_controller.dart';
import 'package:smartlog_swm_mobile/features/auth/application/services/auth_security_service.dart';
import 'package:smartlog_swm_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_permissions_snapshot_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_profile_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_refresh_response_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_session_summary_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_warehouse_option_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/change_password_request_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/login_request_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/login_response_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/select_warehouse_response_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_sample_account.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_session.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_user.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartlog_swm_mobile/features/auth/presentation/pages/warehouse_context_page.dart';

void main() {
  testWidgets('selecting warehouse updates auth session context', (
    WidgetTester tester,
  ) async {
    final repository = _MutableAuthRepository(
      session: _TestData.sessionWithoutWarehouse,
      profile: _TestData.profile,
    );

    final fakeSecurityService = _FakeAuthSecurityService(
      onSelect: (String warehouseId, String warehouseName) async {
        final current = repository.session;
        if (current == null) {
          return;
        }

        repository.session = AuthSession(
          accessToken: 'token-after-select',
          refreshToken: current.refreshToken,
          expiresIn: current.expiresIn,
          sessionId: current.sessionId,
          tokenType: current.tokenType,
          currentUser: AuthUser(
            id: current.currentUser.id,
            username: current.currentUser.username,
            displayName: current.currentUser.displayName,
            role: current.currentUser.role,
            siteId: warehouseId,
            siteName: warehouseName,
          ),
          loggedInAt: current.loggedInAt,
          persistedAt: DateTime.utc(2026, 4, 3, 10, 0),
        );
      },
    );

    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(repository),
        authSecurityServiceProvider.overrideWithValue(fakeSecurityService),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: WarehouseContextPage()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.text('Kho 5.1 - Phu My'), findsOneWidget);
    expect(find.text('Kho 3 - Sai Gon'), findsOneWidget);

    await tester.tap(find.byKey(const Key('warehouse_context_option_wh-03')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 120));
    await tester.tap(find.byKey(const Key('warehouse_context_submit_button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    expect(fakeSecurityService.lastSelectedWarehouseId, 'wh-03');
    final updatedSession = container.read(authControllerProvider).valueOrNull;
    expect(updatedSession, isNotNull);
    expect(updatedSession!.accessToken, 'token-after-select');
    expect(updatedSession.currentUser.siteId, 'wh-03');
    expect(updatedSession.currentUser.siteName, 'Kho 3 - Sai Gon');
  });
}

class _MutableAuthRepository implements AuthRepository {
  _MutableAuthRepository({required this.session, required this.profile});

  AuthSession? session;
  final AuthProfileDto profile;

  @override
  Future<List<AuthSampleAccount>> getSampleAccounts() async {
    return const <AuthSampleAccount>[];
  }

  @override
  Future<AuthSession> login(LoginRequestDto request) async {
    return session!;
  }

  @override
  Future<AuthProfileDto> getMe() async {
    return profile;
  }

  @override
  Future<AuthPermissionsSnapshotDto> getMyPermissions() async {
    return const AuthPermissionsSnapshotDto(
      roleCodes: <String>[],
      permissions: <String>[],
      warehouseScope: <String>[],
      ownerScope: <String>[],
    );
  }

  @override
  Future<void> logout() async {}

  @override
  Future<AuthSession?> restoreSession() async {
    return session;
  }
}

class _FakeAuthSecurityService extends AuthSecurityService {
  _FakeAuthSecurityService({required this.onSelect})
    : super(
        remoteDataSource: _NoopAuthRemoteDataSource(),
        secureStorageService: _NoopSecureStorageService(),
        clock: () => DateTime.utc(2026, 4, 3, 10, 0),
      );

  final Future<void> Function(String warehouseId, String warehouseName)
  onSelect;
  String? lastSelectedWarehouseId;

  @override
  Future<void> selectWarehouse({
    required String warehouseId,
    required String warehouseName,
  }) async {
    lastSelectedWarehouseId = warehouseId;
    await onSelect(warehouseId, warehouseName);
  }
}

class _NoopAuthRemoteDataSource implements AuthRemoteDataSource {
  @override
  Future<void> changePassword(ChangePasswordRequestDto request) {
    throw UnimplementedError();
  }

  @override
  Future<AuthProfileDto> getMe() {
    throw UnimplementedError();
  }

  @override
  Future<AuthPermissionsSnapshotDto> getMyPermissions() {
    throw UnimplementedError();
  }

  @override
  Future<List<AuthSessionSummaryDto>> getSessions() {
    throw UnimplementedError();
  }

  @override
  Future<LoginResponseDto> login(LoginRequestDto request) {
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    throw UnimplementedError();
  }

  @override
  Future<void> logoutAll() {
    throw UnimplementedError();
  }

  @override
  Future<AuthRefreshResponseDto> refresh({required String refreshToken}) {
    throw UnimplementedError();
  }

  @override
  Future<void> revokeSession({required String sessionId}) {
    throw UnimplementedError();
  }

  @override
  Future<SelectWarehouseResponseDto> selectWarehouse({
    required String warehouseId,
  }) {
    throw UnimplementedError();
  }
}

class _NoopSecureStorageService implements SecureStorageService {
  @override
  Future<void> deleteSession() async {}

  @override
  Future<AuthSession?> getSession() async {
    return null;
  }

  @override
  Future<void> saveSession(AuthSession session) async {}
}

class _TestData {
  static final sessionWithoutWarehouse = AuthSession(
    accessToken: 'token-before-select',
    refreshToken: 'refresh-token',
    currentUser: const AuthUser(
      id: 'user-001',
      username: 'warehouse.keeper',
      displayName: 'Warehouse Keeper',
      role: 'Warehouse Keeper',
      siteId: '',
      siteName: '',
    ),
    loggedInAt: DateTime.utc(2026, 4, 3, 8, 0),
    persistedAt: DateTime.utc(2026, 4, 3, 8, 0),
  );

  static const profile = AuthProfileDto(
    id: 'user-001',
    userCode: 'warehouse.keeper',
    username: 'warehouse.keeper',
    fullName: 'Warehouse Keeper',
    roleCodes: <String>['WAREHOUSE_KEEPER'],
    selectedWarehouseId: null,
    warehouseOptions: <AuthWarehouseOptionDto>[
      AuthWarehouseOptionDto(
        id: 'wh-01',
        code: 'WH5.1',
        name: 'Kho 5.1 - Phu My',
      ),
      AuthWarehouseOptionDto(id: 'wh-03', code: 'WH3', name: 'Kho 3 - Sai Gon'),
    ],
    ownerScope: <String>[],
    channel: 'MOBILE',
    mustChangePassword: false,
  );
}
