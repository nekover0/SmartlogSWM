import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/core/storage/secure_storage_provider.dart';
import 'package:smartlog_swm_mobile/core/storage/secure_storage_service.dart';
import 'package:smartlog_swm_mobile/features/auth/application/controllers/auth_controller.dart';
import 'package:smartlog_swm_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_session_summary_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/change_password_request_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_session.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_user.dart';

final authSecurityServiceProvider = Provider<AuthSecurityService>((
  Ref<Object?> ref,
) {
  return AuthSecurityService(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    secureStorageService: ref.watch(secureStorageServiceProvider),
    clock: () => DateTime.now().toUtc(),
  );
});

final authSessionsProvider = FutureProvider<List<AuthSessionSummaryDto>>((
  Ref<Object?> ref,
) async {
  final session = ref.watch(authControllerProvider).valueOrNull;
  if (session == null) {
    return const <AuthSessionSummaryDto>[];
  }

  return ref.watch(authSecurityServiceProvider).getSessions();
});

class AuthSecurityService {
  AuthSecurityService({
    required AuthRemoteDataSource remoteDataSource,
    required SecureStorageService secureStorageService,
    required DateTime Function() clock,
  }) : _remoteDataSource = remoteDataSource,
       _secureStorageService = secureStorageService,
       _clock = clock;

  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageService _secureStorageService;
  final DateTime Function() _clock;

  Future<List<AuthSessionSummaryDto>> getSessions() {
    return _remoteDataSource.getSessions();
  }

  Future<void> revokeSession({required String sessionId}) {
    return _remoteDataSource.revokeSession(sessionId: sessionId);
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) {
    return _remoteDataSource.changePassword(
      ChangePasswordRequestDto(
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      ),
    );
  }

  Future<void> logoutAllAndClearLocalSession() async {
    await _remoteDataSource.logoutAll();
    await _secureStorageService.deleteSession();
  }

  Future<void> selectWarehouse({
    required String warehouseId,
    required String warehouseName,
  }) async {
    final response = await _remoteDataSource.selectWarehouse(
      warehouseId: warehouseId,
    );
    final currentSession = await _secureStorageService.getSession();
    if (currentSession == null) {
      return;
    }

    final selectedWarehouseId = response.selectedWarehouseId.trim().isEmpty
        ? warehouseId
        : response.selectedWarehouseId.trim();
    final updatedAccessToken = response.accessToken.trim().isEmpty
        ? currentSession.accessToken
        : response.accessToken.trim();

    final updatedSession = AuthSession(
      accessToken: updatedAccessToken,
      refreshToken: currentSession.refreshToken,
      expiresIn: currentSession.expiresIn,
      sessionId: currentSession.sessionId,
      tokenType: currentSession.tokenType,
      currentUser: AuthUser(
        id: currentSession.currentUser.id,
        username: currentSession.currentUser.username,
        displayName: currentSession.currentUser.displayName,
        role: currentSession.currentUser.role,
        siteId: selectedWarehouseId,
        siteName: warehouseName.trim().isEmpty
            ? currentSession.currentUser.siteName
            : warehouseName.trim(),
      ),
      loggedInAt: currentSession.loggedInAt,
      persistedAt: _clock(),
    );

    await _secureStorageService.saveSession(updatedSession);
  }
}
