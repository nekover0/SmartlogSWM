import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/core/storage/secure_storage_provider.dart';
import 'package:smartlog_swm_mobile/core/storage/secure_storage_service.dart';
import 'package:smartlog_swm_mobile/features/auth/data/datasources/auth_fixture_data_source.dart';
import 'package:smartlog_swm_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/login_request_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_sample_account.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_session.dart';
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
  Future<void> logout() {
    return _secureStorageService.deleteSession();
  }
}
