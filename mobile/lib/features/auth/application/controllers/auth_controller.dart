import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/login_request_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_session.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/repositories/auth_repository.dart';

final authControllerProvider =
    AsyncNotifierProvider<AuthController, AuthSession?>(AuthController.new);

class AuthController extends AsyncNotifier<AuthSession?> {
  AuthRepository get _repository => ref.read(authRepositoryProvider);

  @override
  Future<AuthSession?> build() {
    return _repository.restoreSession();
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    state = const AsyncLoading<AuthSession?>().copyWithPrevious(state);
    state = await AsyncValue.guard(() async {
      return _repository.login(
        LoginRequestDto(username: username, password: password),
      );
    });
  }

  Future<void> logout() async {
    state = const AsyncLoading<AuthSession?>().copyWithPrevious(state);
    state = await AsyncValue.guard(() async {
      await _repository.logout();
      return null;
    });
  }

  Future<void> restoreSession() async {
    state = const AsyncLoading<AuthSession?>().copyWithPrevious(state);
    state = await AsyncValue.guard(_repository.restoreSession);
  }
}
