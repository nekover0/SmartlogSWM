import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/core/storage/secure_storage_provider.dart';
import 'package:smartlog_swm_mobile/core/storage/secure_storage_service.dart';
import 'package:smartlog_swm_mobile/features/auth/application/services/auth_security_service.dart';
import 'package:smartlog_swm_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_permissions_snapshot_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_profile_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_refresh_response_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_session_summary_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/change_password_request_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/login_request_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/login_response_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/select_warehouse_response_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_session.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_user.dart';

void main() {
  group('AuthSecurityService', () {
    late _FakeAuthRemoteDataSource remoteDataSource;
    late _FakeSecureStorageService secureStorageService;
    late ProviderContainer container;

    setUp(() {
      remoteDataSource = _FakeAuthRemoteDataSource();
      secureStorageService = _FakeSecureStorageService();
      container = ProviderContainer(
        overrides: [
          authRemoteDataSourceProvider.overrideWithValue(remoteDataSource),
          secureStorageServiceProvider.overrideWithValue(secureStorageService),
        ],
      );
      addTearDown(container.dispose);
    });

    test('loads active sessions from remote datasource', () async {
      remoteDataSource.sessions = const <AuthSessionSummaryDto>[
        AuthSessionSummaryDto(
          id: 'ses-001',
          sessionCode: 'SES-001',
          channel: 'MOBILE',
          isCurrent: true,
        ),
      ];

      final service = container.read(authSecurityServiceProvider);
      final sessions = await service.getSessions();

      expect(remoteDataSource.getSessionsCallCount, 1);
      expect(sessions, hasLength(1));
      expect(sessions.single.id, 'ses-001');
    });

    test('forwards change-password payload to remote datasource', () async {
      final service = container.read(authSecurityServiceProvider);

      await service.changePassword(
        oldPassword: 'old-pass',
        newPassword: 'new-pass',
        confirmPassword: 'new-pass',
      );

      final request = remoteDataSource.lastChangePasswordRequest;
      expect(request, isNotNull);
      expect(request!.oldPassword, 'old-pass');
      expect(request.newPassword, 'new-pass');
      expect(request.confirmPassword, 'new-pass');
    });

    test('forwards revoke-session request to remote datasource', () async {
      final service = container.read(authSecurityServiceProvider);

      await service.revokeSession(sessionId: 'ses-002');

      expect(remoteDataSource.lastRevokedSessionId, 'ses-002');
    });

    test('logs out all and clears local session', () async {
      await secureStorageService.saveSession(_TestData.session);
      final service = container.read(authSecurityServiceProvider);

      await service.logoutAllAndClearLocalSession();

      expect(remoteDataSource.logoutAllCallCount, 1);
      expect(await secureStorageService.getSession(), isNull);
    });

    test(
      'applies selected warehouse and refreshed token to local session',
      () async {
        await secureStorageService.saveSession(_TestData.session);
        remoteDataSource.selectWarehouseResponse =
            const SelectWarehouseResponseDto(
              selectedWarehouseId: 'wh-03',
              accessToken: 'new-access-token-after-select',
            );

        final service = container.read(authSecurityServiceProvider);

        await service.selectWarehouse(
          warehouseId: 'wh-03',
          warehouseName: 'Kho 3 - Sai Gon',
        );

        final updated = await secureStorageService.getSession();
        expect(remoteDataSource.lastSelectedWarehouseId, 'wh-03');
        expect(updated, isNotNull);
        expect(updated!.accessToken, 'new-access-token-after-select');
        expect(updated.currentUser.siteId, 'wh-03');
        expect(updated.currentUser.siteName, 'Kho 3 - Sai Gon');
      },
    );
  });
}

class _FakeAuthRemoteDataSource implements AuthRemoteDataSource {
  List<AuthSessionSummaryDto> sessions = const <AuthSessionSummaryDto>[];
  int getSessionsCallCount = 0;
  int logoutAllCallCount = 0;
  ChangePasswordRequestDto? lastChangePasswordRequest;
  String? lastSelectedWarehouseId;
  String? lastRevokedSessionId;
  SelectWarehouseResponseDto? selectWarehouseResponse;

  @override
  Future<void> changePassword(ChangePasswordRequestDto request) async {
    lastChangePasswordRequest = request;
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
  Future<List<AuthSessionSummaryDto>> getSessions() async {
    getSessionsCallCount += 1;
    return sessions;
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
  Future<void> logoutAll() async {
    logoutAllCallCount += 1;
  }

  @override
  Future<AuthRefreshResponseDto> refresh({required String refreshToken}) {
    throw UnimplementedError();
  }

  @override
  Future<void> revokeSession({required String sessionId}) async {
    lastRevokedSessionId = sessionId;
  }

  @override
  Future<SelectWarehouseResponseDto> selectWarehouse({
    required String warehouseId,
  }) {
    lastSelectedWarehouseId = warehouseId;
    return Future<SelectWarehouseResponseDto>.value(
      selectWarehouseResponse ??
          const SelectWarehouseResponseDto(
            selectedWarehouseId: 'wh-default',
            accessToken: 'token-default',
          ),
    );
  }
}

class _FakeSecureStorageService implements SecureStorageService {
  AuthSession? _session;

  @override
  Future<void> deleteSession() async {
    _session = null;
  }

  @override
  Future<AuthSession?> getSession() async {
    return _session;
  }

  @override
  Future<void> saveSession(AuthSession session) async {
    _session = session;
  }
}

class _TestData {
  static final session = AuthSession(
    accessToken: 'access-token',
    currentUser: const AuthUser(
      id: 'user-001',
      username: 'warehouse.keeper',
      displayName: 'Warehouse Keeper',
      role: 'Warehouse Keeper',
      siteId: 'bdg-wh-02',
      siteName: 'Binh Duong Overflow Warehouse',
    ),
    loggedInAt: DateTime.utc(2026, 4, 3, 8, 0),
    persistedAt: DateTime.utc(2026, 4, 3, 8, 0),
  );
}
