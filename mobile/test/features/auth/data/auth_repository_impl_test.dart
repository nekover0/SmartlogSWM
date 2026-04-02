import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/core/storage/secure_storage_service.dart';
import 'package:smartlog_swm_mobile/features/auth/data/datasources/auth_fixture_data_source.dart';
import 'package:smartlog_swm_mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_permissions_snapshot_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_profile_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_refresh_response_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_session_summary_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/change_password_request_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/login_request_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/login_response_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/select_warehouse_response_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_session.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_user.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthRepositoryImpl', () {
    late _FakeAssetBundle assetBundle;
    late _FakeSecureStorageService secureStorageService;
    late _FakeAuthRemoteDataSource remoteDataSource;
    late AuthRepositoryImpl repository;

    setUp(() {
      assetBundle = _FakeAssetBundle(<String, String>{
        'assets/fixtures/auth/sample_accounts.json': '''
        {
          "accounts": [
            {
              "id": "user-ops-001",
              "username": "ops.supervisor",
              "password": "smartlog123",
              "displayName": "Operations Supervisor",
              "role": "Operations Supervisor",
              "siteId": "sgn-dc-01",
              "siteName": "Sai Gon Distribution Center"
            },
            {
              "id": "user-keeper-001",
              "username": "warehouse.keeper",
              "password": "smartlog123",
              "displayName": "Warehouse Keeper",
              "role": "Warehouse Keeper",
              "siteId": "bdg-wh-02",
              "siteName": "Binh Duong Overflow Warehouse"
            }
          ]
        }
        ''',
      });
      secureStorageService = _FakeSecureStorageService();
      remoteDataSource = _FakeAuthRemoteDataSource();
      repository = AuthRepositoryImpl(
        fixtureDataSource: AuthFixtureDataSource(assetBundle: assetBundle),
        remoteDataSource: remoteDataSource,
        secureStorageService: secureStorageService,
        clock: () => DateTime.utc(2026, 3, 23, 8, 30),
      );
    });

    test('loads sample accounts from fixture json', () async {
      final accounts = await repository.getSampleAccounts();

      expect(accounts, hasLength(2));
      expect(accounts.first.username, 'ops.supervisor');
      expect(accounts.first.role, 'Operations Supervisor');
      expect(accounts.last.siteName, 'Binh Duong Overflow Warehouse');
    });

    test('logs in with remote datasource and persists session', () async {
      remoteDataSource.loginResponse = const LoginResponseDto(
        accessToken: 'api-token-user-ops-001',
        user: AuthUser(
          id: 'user-ops-001',
          username: 'ops.supervisor',
          displayName: 'Operations Supervisor',
          role: 'Operations Supervisor',
          siteId: 'sgn-dc-01',
          siteName: 'Sai Gon Distribution Center',
        ),
      );

      final session = await repository.login(
        const LoginRequestDto(
          username: 'ops.supervisor',
          password: 'smartlog123',
        ),
      );

      expect(session.accessToken, 'api-token-user-ops-001');
      expect(session.currentUser.displayName, 'Operations Supervisor');
      expect(session.currentUser.role, 'Operations Supervisor');
      expect(session.loggedInAt, DateTime.utc(2026, 3, 23, 8, 30));
      expect(
        remoteDataSource.lastLoginRequest,
        const LoginRequestDto(
          username: 'ops.supervisor',
          password: 'smartlog123',
        ),
      );
      expect(await secureStorageService.getSession(), session);
    });

    test('throws on invalid credentials and leaves storage empty', () async {
      remoteDataSource.loginError = const InvalidCredentialsException();

      expect(
        () => repository.login(
          const LoginRequestDto(
            username: 'ops.supervisor',
            password: 'wrong-password',
          ),
        ),
        throwsA(isA<InvalidCredentialsException>()),
      );

      expect(await secureStorageService.getSession(), isNull);
    });

    test('restores null when there is no saved session', () async {
      final restored = await repository.restoreSession();

      expect(restored, isNull);
    });

    test('restores saved session and clears it on logout', () async {
      final session = AuthSession(
        accessToken: 'persisted-token',
        currentUser: _TestData.user,
        loggedInAt: _TestData.loggedInAt,
        persistedAt: _TestData.persistedAt,
      );

      await secureStorageService.saveSession(session);

      expect(await repository.restoreSession(), session);

      await repository.logout();

      expect(await repository.restoreSession(), isNull);
    });
  });
}

class _FakeAssetBundle extends CachingAssetBundle {
  _FakeAssetBundle(this._assets);

  final Map<String, String> _assets;

  @override
  Future<ByteData> load(String key) async {
    final value = _assets[key];
    if (value == null) {
      throw StateError('Missing fake asset for $key');
    }

    final bytes = Uint8List.fromList(value.codeUnits);
    return ByteData.sublistView(bytes);
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    final value = _assets[key];
    if (value == null) {
      throw StateError('Missing fake asset for $key');
    }

    return value;
  }
}

class _FakeSecureStorageService implements SecureStorageService {
  AuthSession? _session;

  @override
  Future<AuthSession?> getSession() async {
    return _session;
  }

  @override
  Future<void> saveSession(AuthSession session) async {
    _session = session;
  }

  @override
  Future<void> deleteSession() async {
    _session = null;
  }
}

class _FakeAuthRemoteDataSource implements AuthRemoteDataSource {
  LoginRequestDto? lastLoginRequest;
  LoginResponseDto? loginResponse;
  Object? loginError;

  @override
  Future<LoginResponseDto> login(LoginRequestDto request) async {
    lastLoginRequest = request;
    if (loginError != null) {
      throw loginError!;
    }

    final configuredResponse = loginResponse;
    if (configuredResponse != null) {
      return configuredResponse;
    }

    return const LoginResponseDto(
      accessToken: 'api-token-default',
      user: AuthUser(
        id: 'user-default',
        username: 'default.user',
        displayName: 'Default User',
        role: 'USER',
        siteId: '',
        siteName: '',
      ),
    );
  }

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

class _TestData {
  static const user = AuthUser(
    id: 'user-001',
    username: 'warehouse.keeper',
    displayName: 'Warehouse Keeper',
    role: 'Warehouse Keeper',
    siteId: 'bdg-wh-02',
    siteName: 'Binh Duong Overflow Warehouse',
  );

  static final loggedInAt = DateTime.utc(2026, 3, 22, 12, 0);
  static final persistedAt = DateTime.utc(2026, 3, 22, 12, 1);
}
