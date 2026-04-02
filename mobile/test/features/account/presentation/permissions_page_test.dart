import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/features/account/presentation/pages/permissions_page.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_permissions_snapshot_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_profile_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/login_request_dto.dart';
import 'package:smartlog_swm_mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_sample_account.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_session.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_user.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/repositories/auth_repository.dart';

void main() {
  group('PermissionsPage', () {
    testWidgets(
      'keeps admin management actions disabled without admin rights',
      (WidgetTester tester) async {
        await _pumpPermissionsPage(
          tester,
          session: _buildSession(role: 'Customer Viewer'),
          permissions: const AuthPermissionsSnapshotDto(
            roleCodes: <String>['CUSTOMER_VIEWER'],
            permissions: <String>['reports.kpi.view'],
            warehouseScope: <String>['site-a1'],
            ownerScope: <String>[],
          ),
        );

        await tester.scrollUntilVisible(
          find.byKey(const Key('permissions_manage_users_button')),
          300,
          scrollable: find.byType(Scrollable),
        );

        final manageUsersButton = tester.widget<FilledButton>(
          find.byKey(const Key('permissions_manage_users_button')),
        );
        expect(manageUsersButton.onPressed, isNull);
      },
    );

    testWidgets('enables admin actions from permissions snapshot mapping', (
      WidgetTester tester,
    ) async {
      await _pumpPermissionsPage(
        tester,
        session: _buildSession(role: 'Customer Viewer'),
        permissions: const AuthPermissionsSnapshotDto(
          roleCodes: <String>['ADMIN'],
          permissions: <String>[
            'foundation.roles.view',
            'foundation.roles.create',
          ],
          warehouseScope: <String>['site-a1'],
          ownerScope: <String>[],
        ),
      );

      expect(find.textContaining('Administrator'), findsOneWidget);

      await tester.scrollUntilVisible(
        find.byKey(const Key('permissions_manage_users_button')),
        300,
        scrollable: find.byType(Scrollable),
      );

      final manageUsersButton = tester.widget<FilledButton>(
        find.byKey(const Key('permissions_manage_users_button')),
      );
      expect(manageUsersButton.onPressed, isNotNull);
    });
  });
}

Future<void> _pumpPermissionsPage(
  WidgetTester tester, {
  required AuthSession session,
  required AuthPermissionsSnapshotDto permissions,
}) async {
  final repository = _FakeAuthRepository(
    restoreSessionResult: session,
    permissionsResult: permissions,
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
      child: const MaterialApp(home: PermissionsPage()),
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
      displayName: 'Nguyen Van A',
      role: role,
      siteId: 'site-a1',
      siteName: 'Site A1 - Main Hub',
    ),
    loggedInAt: DateTime.utc(2026, 3, 25, 1, 42),
    persistedAt: DateTime.utc(2026, 3, 25, 1, 42),
  );
}

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({
    required this.restoreSessionResult,
    required this.permissionsResult,
  });

  final AuthSession? restoreSessionResult;
  final AuthPermissionsSnapshotDto permissionsResult;

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
    return permissionsResult;
  }

  @override
  Future<void> logout() async {}

  @override
  Future<AuthSession?> restoreSession() async {
    return restoreSessionResult;
  }
}
