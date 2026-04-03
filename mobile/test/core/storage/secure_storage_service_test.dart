import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/core/storage/secure_storage_service.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_session.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_user.dart';

void main() {
  group('FlutterSecureStorageService', () {
    late _FakeSecureKeyValueStore keyValueStore;
    late FlutterSecureStorageService service;

    setUp(() {
      keyValueStore = _FakeSecureKeyValueStore();
      service = FlutterSecureStorageService(keyValueStore: keyValueStore);
    });

    test('persists and restores full auth session payload', () async {
      final session = AuthSession(
        accessToken: 'access-001',
        refreshToken: 'refresh-001',
        expiresIn: 900,
        sessionId: 'session-001',
        tokenType: 'Bearer',
        currentUser: const AuthUser(
          id: 'user-001',
          username: 'warehouse.keeper',
          displayName: 'Warehouse Keeper',
          role: 'Warehouse Keeper',
          siteId: 'bdg-wh-02',
          siteName: 'Binh Duong Overflow Warehouse',
        ),
        loggedInAt: DateTime.utc(2026, 3, 24, 9, 0),
        persistedAt: DateTime.utc(2026, 3, 24, 9, 0),
      );

      await service.saveSession(session);
      final restored = await service.getSession();

      expect(restored, session);
    });

    test('returns null for malformed storage payload', () async {
      await keyValueStore.write('auth_session_v1', '{invalid-json');

      final restored = await service.getSession();

      expect(restored, isNull);
    });

    test('deletes stored session', () async {
      final session = AuthSession(
        accessToken: 'access-001',
        currentUser: const AuthUser(
          id: 'user-001',
          username: 'warehouse.keeper',
          displayName: 'Warehouse Keeper',
          role: 'Warehouse Keeper',
          siteId: 'bdg-wh-02',
          siteName: 'Binh Duong Overflow Warehouse',
        ),
        loggedInAt: DateTime.utc(2026, 3, 24, 9, 0),
        persistedAt: DateTime.utc(2026, 3, 24, 9, 0),
      );

      await service.saveSession(session);
      await service.deleteSession();

      expect(await service.getSession(), isNull);
    });
  });
}

class _FakeSecureKeyValueStore implements SecureKeyValueStore {
  final Map<String, String> _values = <String, String>{};

  @override
  Future<void> delete(String key) async {
    _values.remove(key);
  }

  @override
  Future<String?> read(String key) async {
    return _values[key];
  }

  @override
  Future<void> write(String key, String value) async {
    _values[key] = value;
  }
}
