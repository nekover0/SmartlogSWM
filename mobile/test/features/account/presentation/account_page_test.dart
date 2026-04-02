import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/features/account/presentation/pages/account_page.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_permissions_snapshot_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_profile_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/login_request_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_sample_account.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_session.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_user.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/repositories/auth_repository.dart';

void main() {
  group('AccountPage', () {
    testWidgets('renders account and RBAC sections from the new design', (
      WidgetTester tester,
    ) async {
      await _pumpAccountPage(
        tester,
        session: _buildSession(role: 'Warehouse Manager'),
      );

      expect(find.byKey(const Key('account_back_button')), findsOneWidget);
      expect(find.byKey(const Key('account_profile_header')), findsOneWidget);
      expect(
        find.byKey(const Key('account_role_summary_card')),
        findsOneWidget,
      );
      expect(
        find.byKey(const Key('account_permissions_heading')),
        findsOneWidget,
      );
      await tester.scrollUntilVisible(
        find.byKey(const Key('account_activity_heading')),
        400,
        scrollable: find.byType(Scrollable),
      );
      expect(find.byKey(const Key('account_activity_heading')), findsOneWidget);
      expect(
        find.byKey(const Key('account_activity_log_card')),
        findsOneWidget,
      );
      await tester.scrollUntilVisible(
        find.byKey(const Key('account_manage_users_roles_button')),
        400,
        scrollable: find.byType(Scrollable),
      );
      expect(
        find.byKey(const Key('account_manage_users_roles_button')),
        findsOneWidget,
      );
    });

    testWidgets('disables admin action for non-admin role', (
      WidgetTester tester,
    ) async {
      await _pumpAccountPage(
        tester,
        session: _buildSession(role: 'Customer Viewer'),
      );

      await tester.scrollUntilVisible(
        find.byKey(const Key('account_manage_users_roles_button')),
        400,
        scrollable: find.byType(Scrollable),
      );

      final manageButton = tester.widget<FilledButton>(
        find.byKey(const Key('account_manage_users_roles_button')),
      );

      expect(manageButton.onPressed, isNull);
    });

    testWidgets('enables admin action for administrator role', (
      WidgetTester tester,
    ) async {
      await _pumpAccountPage(
        tester,
        session: _buildSession(role: 'Administrator'),
      );

      await tester.scrollUntilVisible(
        find.byKey(const Key('account_manage_users_roles_button')),
        400,
        scrollable: find.byType(Scrollable),
      );

      final manageButton = tester.widget<FilledButton>(
        find.byKey(const Key('account_manage_users_roles_button')),
      );

      expect(manageButton.onPressed, isNotNull);
    });
  });
}

Future<void> _pumpAccountPage(
  WidgetTester tester, {
  required AuthSession session,
}) async {
  final repository = _FakeAuthRepository(restoreSessionResult: session);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
      child: const MaterialApp(home: AccountPage()),
    ),
  );

  await tester.pumpAndSettle();
}

AuthSession _buildSession({required String role}) {
  return AuthSession(
    accessToken: 'fixture-token',
    currentUser: AuthUser(
      id: 'WMS-9921',
      username: 'nguyenvana',
      displayName: 'Nguyễn Văn A',
      role: role,
      siteId: 'site-a1',
      siteName: 'Site A1 - Main Hub',
    ),
    loggedInAt: DateTime.utc(2026, 3, 25, 1, 42),
    persistedAt: DateTime.utc(2026, 3, 25, 1, 42),
  );
}

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({required this.restoreSessionResult});

  final AuthSession? restoreSessionResult;

  @override
  Future<List<AuthSampleAccount>> getSampleAccounts() async {
    return const <AuthSampleAccount>[];
  }

  @override
  Future<AuthSession> login(LoginRequestDto request) async {
    return restoreSessionResult!;
  }

  @override
  Future<AuthProfileDto> getMe() async {
    final session = restoreSessionResult;
    if (session == null) {
      throw StateError('No session');
    }

    return AuthProfileDto(
      id: session.currentUser.id,
      userCode: session.currentUser.username,
      username: session.currentUser.username,
      fullName: session.currentUser.displayName,
      roleCodes: <String>[session.currentUser.role],
      selectedWarehouseId: session.currentUser.siteId,
      warehouseOptions: const [],
      ownerScope: const <String>[],
      channel: 'MOBILE',
      mustChangePassword: false,
    );
  }

  @override
  Future<AuthPermissionsSnapshotDto> getMyPermissions() async {
    return const AuthPermissionsSnapshotDto(
      roleCodes: <String>[],
      permissions: <String>[],
      warehouseScope: <String>[],
      ownerScope: <String>[],
    );
  }

  @override
  Future<void> logout() async {}

  @override
  Future<AuthSession?> restoreSession() async {
    return restoreSessionResult;
  }
}
