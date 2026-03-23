import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/core/storage/secure_storage_service.dart';
import 'package:smartlog_swm_mobile/features/auth/data/datasources/auth_fixture_data_source.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/login_request_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_session.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_user.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthRepositoryImpl', () {
    late _FakeAssetBundle assetBundle;
    late _FakeSecureStorageService secureStorageService;
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
      repository = AuthRepositoryImpl(
        fixtureDataSource: AuthFixtureDataSource(assetBundle: assetBundle),
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

    test('logs in with fixture account and persists session', () async {
      final session = await repository.login(
        const LoginRequestDto(
          username: 'ops.supervisor',
          password: 'smartlog123',
        ),
      );

      expect(session.accessToken, 'fixture-token-user-ops-001');
      expect(session.currentUser.displayName, 'Operations Supervisor');
      expect(session.currentUser.role, 'Operations Supervisor');
      expect(session.loggedInAt, DateTime.utc(2026, 3, 23, 8, 30));
      expect(await secureStorageService.getSession(), session);
    });

    test('throws on invalid credentials and leaves storage empty', () async {
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
