import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_session.dart';

abstract interface class SecureStorageService {
  Future<AuthSession?> getSession();

  Future<void> saveSession(AuthSession session);

  Future<void> deleteSession();
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
