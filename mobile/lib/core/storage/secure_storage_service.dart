import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_session.dart';

abstract interface class SecureStorageService {
  Future<AuthSession?> getSession();

  Future<void> saveSession(AuthSession session);

  Future<void> deleteSession();
}

abstract interface class SecureKeyValueStore {
  Future<String?> read(String key);

  Future<void> write(String key, String value);

  Future<void> delete(String key);
}

class FlutterSecureKeyValueStore implements SecureKeyValueStore {
  FlutterSecureKeyValueStore({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) {
    return _storage.read(key: key);
  }

  @override
  Future<void> write(String key, String value) {
    return _storage.write(key: key, value: value);
  }

  @override
  Future<void> delete(String key) {
    return _storage.delete(key: key);
  }
}

class FlutterSecureStorageService implements SecureStorageService {
  FlutterSecureStorageService({SecureKeyValueStore? keyValueStore})
    : _keyValueStore = keyValueStore ?? FlutterSecureKeyValueStore();

  static const String _sessionStorageKey = 'auth_session_v1';

  final SecureKeyValueStore _keyValueStore;

  @override
  Future<AuthSession?> getSession() async {
    final rawValue = await _keyValueStore.read(_sessionStorageKey);
    if (rawValue == null || rawValue.trim().isEmpty) {
      return null;
    }

    try {
      final decoded = jsonDecode(rawValue);
      if (decoded is! Map) {
        return null;
      }

      return AuthSession.fromJson(
        decoded.map(
          (Object? key, Object? value) =>
              MapEntry(key?.toString() ?? '', value),
        ),
      );
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveSession(AuthSession session) {
    return _keyValueStore.write(
      _sessionStorageKey,
      jsonEncode(session.toJson()),
    );
  }

  @override
  Future<void> deleteSession() {
    return _keyValueStore.delete(_sessionStorageKey);
  }
}

class InMemorySecureStorageService implements SecureStorageService {
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
