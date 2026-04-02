import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/features/auth/application/controllers/auth_controller.dart';
import 'package:smartlog_swm_mobile/features/auth/data/datasources/auth_fixture_data_source.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_permissions_snapshot_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_profile_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_warehouse_option_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/login_request_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_sample_account.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_session.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_user.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/repositories/auth_repository.dart';

void main() {
  group('AuthController', () {
    late _FakeAuthRepository repository;
    late ProviderContainer container;

    setUp(() {
      repository = _FakeAuthRepository();
      container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);
    });

    test('restores empty session on startup', () async {
      final restored = await container.read(authControllerProvider.future);

      expect(restored, isNull);
      expect(container.read(authControllerProvider).valueOrNull, isNull);
      expect(repository.restoreCallCount, 1);
    });

    test('logs in with valid credentials', () async {
      await container.read(authControllerProvider.future);

      await container
          .read(authControllerProvider.notifier)
          .login(username: 'ops.supervisor', password: 'smartlog123');

      final state = container.read(authControllerProvider);

      expect(state.hasValue, isTrue);
      expect(state.valueOrNull, _TestData.session);
      expect(
        repository.lastLoginRequest,
        const LoginRequestDto(
          username: 'ops.supervisor',
          password: 'smartlog123',
        ),
      );
    });

    test('moves to error state for invalid login', () async {
      repository.loginError = const InvalidCredentialsException();
      await container.read(authControllerProvider.future);

      await container
          .read(authControllerProvider.notifier)
          .login(username: 'ops.supervisor', password: 'wrong-password');

      final state = container.read(authControllerProvider);

      expect(state.hasError, isTrue);
      expect(state.error, isA<InvalidCredentialsException>());
    });

    test('clears current session on logout', () async {
      repository.restoreSessionResult = _TestData.session;
      await container.read(authControllerProvider.future);

      await container.read(authControllerProvider.notifier).logout();

      final state = container.read(authControllerProvider);

      expect(state.hasValue, isTrue);
      expect(state.valueOrNull, isNull);
      expect(repository.logoutCallCount, 1);
    });

    test('authMeProvider returns profile for authenticated session', () async {
      repository.restoreSessionResult = _TestData.session;
      repository.meResult = _TestData.profile;
      await container.read(authControllerProvider.future);

      final profile = await container.read(authMeProvider.future);

      expect(profile, _TestData.profile);
      expect(repository.getMeCallCount, 1);
    });

    test(
      'authPermissionsSnapshotProvider returns null when unauthenticated',
      () async {
        await container.read(authControllerProvider.future);

        final snapshot = await container.read(
          authPermissionsSnapshotProvider.future,
        );

        expect(snapshot, isNull);
        expect(repository.getPermissionsCallCount, 0);
      },
    );

    test(
      'authPermissionsSnapshotProvider loads snapshot for authenticated user',
      () async {
        repository.restoreSessionResult = _TestData.session;
        repository.permissionsResult = _TestData.permissions;
        await container.read(authControllerProvider.future);

        final snapshot = await container.read(
          authPermissionsSnapshotProvider.future,
        );

        expect(snapshot, _TestData.permissions);
        expect(repository.getPermissionsCallCount, 1);
      },
    );
  });
}

class _FakeAuthRepository implements AuthRepository {
  InvalidCredentialsException? loginError;
  LoginRequestDto? lastLoginRequest;
  int logoutCallCount = 0;
  int restoreCallCount = 0;
  int getMeCallCount = 0;
  int getPermissionsCallCount = 0;
  AuthSession? restoreSessionResult;
  AuthProfileDto? meResult;
  AuthPermissionsSnapshotDto? permissionsResult;

  @override
  Future<List<AuthSampleAccount>> getSampleAccounts() async {
    return const <AuthSampleAccount>[];
  }

  @override
  Future<AuthSession> login(LoginRequestDto request) async {
    lastLoginRequest = request;

    if (loginError != null) {
      throw loginError!;
    }

    return _TestData.session;
  }

  @override
  Future<AuthProfileDto> getMe() async {
    getMeCallCount += 1;
    return meResult ?? _TestData.profile;
  }

  @override
  Future<AuthPermissionsSnapshotDto> getMyPermissions() async {
    getPermissionsCallCount += 1;
    return permissionsResult ?? _TestData.permissions;
  }

  @override
  Future<void> logout() async {
    logoutCallCount += 1;
    restoreSessionResult = null;
  }

  @override
  Future<AuthSession?> restoreSession() async {
    restoreCallCount += 1;
    return restoreSessionResult;
  }
}

class _TestData {
  static final session = AuthSession(
    accessToken: 'fixture-token-user-ops-001',
    currentUser: const AuthUser(
      id: 'user-ops-001',
      username: 'ops.supervisor',
      displayName: 'Operations Supervisor',
      role: 'Operations Supervisor',
      siteId: 'sgn-dc-01',
      siteName: 'Sai Gon Distribution Center',
    ),
    loggedInAt: DateTime.utc(2026, 3, 23, 9, 0),
    persistedAt: DateTime.utc(2026, 3, 23, 9, 0),
  );

  static const profile = AuthProfileDto(
    id: 'user-ops-001',
    userCode: 'ops.supervisor',
    username: 'ops.supervisor',
    fullName: 'Operations Supervisor',
    roleCodes: <String>['OPERATIONS_SUPERVISOR'],
    selectedWarehouseId: 'sgn-dc-01',
    warehouseOptions: <AuthWarehouseOptionDto>[],
    ownerScope: <String>[],
    channel: 'MOBILE',
    mustChangePassword: false,
  );

  static const permissions = AuthPermissionsSnapshotDto(
    roleCodes: <String>['OPERATIONS_SUPERVISOR'],
    permissions: <String>['inbound.receipt.view'],
    warehouseScope: <String>['sgn-dc-01'],
    ownerScope: <String>[],
  );
}
