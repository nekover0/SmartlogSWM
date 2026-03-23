import 'package:smartlog_swm_mobile/features/auth/data/dtos/login_request_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_sample_account.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_session.dart';

abstract interface class AuthRepository {
  Future<List<AuthSampleAccount>> getSampleAccounts();

  Future<AuthSession> login(LoginRequestDto request);

  Future<AuthSession?> restoreSession();

  Future<void> logout();
}
