import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/core/permissions/role_matrix.dart';
import 'package:smartlog_swm_mobile/core/storage/secure_storage_provider.dart';
import 'package:smartlog_swm_mobile/core/storage/secure_storage_service.dart';
import 'package:smartlog_swm_mobile/features/auth/data/datasources/auth_fixture_data_source.dart';
import 'package:smartlog_swm_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_permissions_snapshot_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_profile_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_warehouse_option_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/login_request_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_sample_account.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_session.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_user.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/repositories/auth_repository.dart';

final authFixtureDataSourceProvider = Provider<AuthFixtureDataSource>((ref) {
  return AuthFixtureDataSource();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    fixtureDataSource: ref.watch(authFixtureDataSourceProvider),
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    secureStorageService: ref.watch(secureStorageServiceProvider),
  );
});

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthFixtureDataSource fixtureDataSource,
    required AuthRemoteDataSource remoteDataSource,
    required SecureStorageService secureStorageService,
    DateTime Function()? clock,
  }) : _fixtureDataSource = fixtureDataSource,
       _remoteDataSource = remoteDataSource,
       _secureStorageService = secureStorageService,
       _clock = clock ?? DateTime.now;

  final AuthFixtureDataSource _fixtureDataSource;
  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageService _secureStorageService;
  final DateTime Function() _clock;

  @override
  Future<List<AuthSampleAccount>> getSampleAccounts() {
    return _fixtureDataSource.getSampleAccounts();
  }

  @override
  Future<AuthSession> login(LoginRequestDto request) async {
    final response = await _remoteDataSource.login(request);
    final now = _clock().toUtc();
    final session = AuthSession(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
      expiresIn: response.expiresIn,
      sessionId: response.sessionId,
      tokenType: response.tokenType,
      currentUser: response.user,
      loggedInAt: now,
      persistedAt: now,
    );

    await _secureStorageService.saveSession(session);

    return session;
  }

  @override
  Future<AuthSession?> restoreSession() {
    return _secureStorageService.getSession();
  }

  @override
  Future<AuthProfileDto> getMe() async {
    final profile = await _remoteDataSource.getMe();
    await _syncSessionFromProfile(profile);
    return profile;
  }

  @override
  Future<AuthPermissionsSnapshotDto> getMyPermissions() {
    return _remoteDataSource.getMyPermissions();
  }

  @override
  Future<void> logout() {
    return _secureStorageService.deleteSession();
  }

  Future<void> _syncSessionFromProfile(AuthProfileDto profile) async {
    final currentSession = await _secureStorageService.getSession();
    if (currentSession == null) {
      return;
    }

    final selectedWarehouse = _resolveSelectedWarehouse(profile);
    final updatedSession = AuthSession(
      accessToken: currentSession.accessToken,
      refreshToken: currentSession.refreshToken,
      expiresIn: currentSession.expiresIn,
      sessionId: currentSession.sessionId,
      tokenType: currentSession.tokenType,
      currentUser: AuthUser(
        id: profile.id.trim().isEmpty
            ? currentSession.currentUser.id
            : profile.id,
        username: profile.username.trim().isEmpty
            ? currentSession.currentUser.username
            : profile.username,
        displayName: profile.fullName.trim().isEmpty
            ? currentSession.currentUser.displayName
            : profile.fullName,
        role: _resolveRoleLabel(
          roleCodes: profile.roleCodes,
          fallbackRole: currentSession.currentUser.role,
        ),
        siteId: selectedWarehouse?.id ?? currentSession.currentUser.siteId,
        siteName:
            selectedWarehouse?.name ?? currentSession.currentUser.siteName,
      ),
      loggedInAt: currentSession.loggedInAt,
      persistedAt: _clock().toUtc(),
    );

    await _secureStorageService.saveSession(updatedSession);
  }

  AuthWarehouseOptionDto? _resolveSelectedWarehouse(AuthProfileDto profile) {
    if (profile.warehouseOptions.isEmpty) {
      return null;
    }

    final selectedWarehouseId = profile.selectedWarehouseId?.trim();
    if (selectedWarehouseId == null || selectedWarehouseId.isEmpty) {
      return profile.warehouseOptions.first;
    }

    for (final option in profile.warehouseOptions) {
      if (option.id == selectedWarehouseId) {
        return option;
      }
    }

    return profile.warehouseOptions.first;
  }

  String _resolveRoleLabel({
    required List<String> roleCodes,
    required String fallbackRole,
  }) {
    for (final roleCode in roleCodes) {
      if (roleCode.trim().isEmpty) {
        continue;
      }

      try {
        return AppRole.fromName(roleCode).label;
      } catch (_) {
        continue;
      }
    }

    try {
      return AppRole.fromName(fallbackRole).label;
    } catch (_) {
      return fallbackRole.trim().isEmpty
          ? AppRole.customerViewer.label
          : fallbackRole;
    }
  }
}
