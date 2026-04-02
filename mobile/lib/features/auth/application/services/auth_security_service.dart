import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/core/storage/secure_storage_provider.dart';
import 'package:smartlog_swm_mobile/core/storage/secure_storage_service.dart';
import 'package:smartlog_swm_mobile/features/auth/application/controllers/auth_controller.dart';
import 'package:smartlog_swm_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_session_summary_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/change_password_request_dto.dart';

final authSecurityServiceProvider = Provider<AuthSecurityService>((
  Ref<Object?> ref,
) {
  return AuthSecurityService(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    secureStorageService: ref.watch(secureStorageServiceProvider),
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
  }) : _remoteDataSource = remoteDataSource,
       _secureStorageService = secureStorageService;

  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageService _secureStorageService;

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
}
