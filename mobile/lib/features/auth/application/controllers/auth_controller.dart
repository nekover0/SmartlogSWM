import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/login_request_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_sample_account.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_session.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/repositories/auth_repository.dart';

enum AuthOperation { restore, login, logout }

final authSampleAccountsProvider = FutureProvider<List<AuthSampleAccount>>((
  Ref<Object?> ref,
) {
  return ref.watch(authRepositoryProvider).getSampleAccounts();
});

final authControllerProvider =
    AsyncNotifierProvider<AuthController, AuthSession?>(AuthController.new);

class AuthController extends AsyncNotifier<AuthSession?> {
  AuthOperation _lastOperation = AuthOperation.restore;

  AuthRepository get _repository => ref.read(authRepositoryProvider);

  AuthOperation get lastOperation => _lastOperation;

  @override
  Future<AuthSession?> build() {
    _lastOperation = AuthOperation.restore;
    return _repository.restoreSession();
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    _lastOperation = AuthOperation.login;
    state = const AsyncLoading<AuthSession?>().copyWithPrevious(state);
    state = await AsyncValue.guard(() async {
      return _repository.login(
        LoginRequestDto(username: username, password: password),
      );
    });
  }

  Future<void> logout() async {
    _lastOperation = AuthOperation.logout;
    state = const AsyncLoading<AuthSession?>().copyWithPrevious(state);
    state = await AsyncValue.guard(() async {
      await _repository.logout();
      return null;
    });
  }

  Future<void> restoreSession() async {
    _lastOperation = AuthOperation.restore;
    state = const AsyncLoading<AuthSession?>().copyWithPrevious(state);
    state = await AsyncValue.guard(_repository.restoreSession);
  }
}
