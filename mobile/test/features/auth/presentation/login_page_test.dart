import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/features/auth/data/datasources/auth_fixture_data_source.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_permissions_snapshot_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_profile_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/login_request_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_sample_account.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_session.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_user.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:smartlog_swm_mobile/features/auth/presentation/pages/login_page.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_theme.dart';

void main() {
  group('LoginPage', () {
    late _FakeAuthRepository repository;

    Widget buildSubject() {
      return ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(repository)],
        child: MaterialApp(theme: AppTheme.light(), home: const LoginPage()),
      );
    }

    setUp(() {
      repository = _FakeAuthRepository();
    });

    testWidgets('keeps submit button disabled until minimum data exists', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildSubject());

      expect(
        tester
            .widget<ElevatedButton>(
              find.byKey(const Key('login_submit_button')),
            )
            .onPressed,
        isNull,
      );

      await tester.enterText(
        find.byKey(const Key('login_username_field')),
        'ops.supervisor',
      );
      await tester.pump();

      expect(
        tester
            .widget<ElevatedButton>(
              find.byKey(const Key('login_submit_button')),
            )
            .onPressed,
        isNull,
      );

      await tester.enterText(
        find.byKey(const Key('login_password_field')),
        'smartlog123',
      );
      await tester.pump();

      expect(
        tester
            .widget<ElevatedButton>(
              find.byKey(const Key('login_submit_button')),
            )
            .onPressed,
        isNotNull,
      );
    });

    testWidgets('toggles password visibility', (WidgetTester tester) async {
      await tester.pumpWidget(buildSubject());

      TextField passwordField() {
        return tester.widget<TextField>(
          find.byKey(const Key('login_password_field')),
        );
      }

      expect(passwordField().obscureText, isTrue);

      await tester.tap(find.byKey(const Key('login_password_toggle')));
      await tester.pump();

      expect(passwordField().obscureText, isFalse);
    });

    testWidgets('shows inline error for invalid credentials', (
      WidgetTester tester,
    ) async {
      final Finder submitButton = find.byKey(const Key('login_submit_button'));

      repository.loginError = const InvalidCredentialsException(
        'Sai tên đăng nhập hoặc mật khẩu.',
      );

      await tester.pumpWidget(buildSubject());
      await tester.enterText(
        find.byKey(const Key('login_username_field')),
        'ops.supervisor',
      );
      await tester.enterText(
        find.byKey(const Key('login_password_field')),
        'wrong-password',
      );
      await tester.pump();
      await tester.ensureVisible(submitButton);
      expect(tester.widget<ElevatedButton>(submitButton).onPressed, isNotNull);

      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('login_inline_error')), findsOneWidget);
      expect(find.text('Sai tên đăng nhập hoặc mật khẩu.'), findsOneWidget);
    });

    testWidgets('dispatches successful submit through auth controller', (
      WidgetTester tester,
    ) async {
      final Finder submitButton = find.byKey(const Key('login_submit_button'));

      await tester.pumpWidget(buildSubject());
      await tester.enterText(
        find.byKey(const Key('login_username_field')),
        'ops.supervisor',
      );
      await tester.enterText(
        find.byKey(const Key('login_password_field')),
        'smartlog123',
      );
      await tester.pump();
      await tester.ensureVisible(submitButton);
      expect(tester.widget<ElevatedButton>(submitButton).onPressed, isNotNull);

      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      expect(
        repository.lastLoginRequest,
        const LoginRequestDto(
          username: 'ops.supervisor',
          password: 'smartlog123',
        ),
      );
      expect(find.byKey(const Key('login_inline_error')), findsNothing);
    });
  });
}

class _FakeAuthRepository implements AuthRepository {
  InvalidCredentialsException? loginError;
  LoginRequestDto? lastLoginRequest;

  @override
  Future<List<AuthSampleAccount>> getSampleAccounts() async {
    return const <AuthSampleAccount>[
      AuthSampleAccount(
        id: 'user-ops-001',
        username: 'ops.supervisor',
        password: 'smartlog123',
        displayName: 'Operations Supervisor',
        role: 'Operations Supervisor',
        siteId: 'sgn-dc-01',
        siteName: 'Sai Gon Distribution Center',
      ),
    ];
  }

  @override
  Future<AuthSession> login(LoginRequestDto request) async {
    lastLoginRequest = request;
    if (loginError != null) {
      throw loginError!;
    }

    return AuthSession(
      accessToken: 'fixture-token-user-ops-001',
      currentUser: const AuthUser(
        id: 'user-ops-001',
        username: 'ops.supervisor',
        displayName: 'Operations Supervisor',
        role: 'Operations Supervisor',
        siteId: 'sgn-dc-01',
        siteName: 'Sai Gon Distribution Center',
      ),
      loggedInAt: DateTime.utc(2026, 3, 23, 9),
      persistedAt: DateTime.utc(2026, 3, 23, 9),
    );
  }

  @override
  Future<AuthProfileDto> getMe() async {
    return const AuthProfileDto(
      id: 'user-ops-001',
      userCode: 'ops.supervisor',
      username: 'ops.supervisor',
      fullName: 'Operations Supervisor',
      roleCodes: <String>['OPERATIONS_SUPERVISOR'],
      selectedWarehouseId: 'sgn-dc-01',
      warehouseOptions: [],
      ownerScope: <String>[],
      channel: 'MOBILE',
      mustChangePassword: false,
    );
  }

  @override
  Future<AuthPermissionsSnapshotDto> getMyPermissions() async {
    return const AuthPermissionsSnapshotDto(
      roleCodes: <String>['OPERATIONS_SUPERVISOR'],
      permissions: <String>[],
      warehouseScope: <String>[],
      ownerScope: <String>[],
    );
  }

  @override
  Future<void> logout() async {}

  @override
  Future<AuthSession?> restoreSession() async {
    return null;
  }
}
