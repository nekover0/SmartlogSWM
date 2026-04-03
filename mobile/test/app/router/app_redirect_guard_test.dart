import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartlog_swm_mobile/app/router/app_redirect_guard.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/core/permissions/role_guard.dart';
import 'package:smartlog_swm_mobile/features/auth/application/controllers/auth_controller.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_session.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_user.dart';

void main() {
  AuthSession buildSession({
    required String role,
    String displayName = 'Test User',
    String siteName = 'Test Site',
    String siteId = 'site-1',
  }) {
    return AuthSession(
      accessToken: 'token',
      currentUser: AuthUser(
        id: 'user-1',
        username: 'test.user',
        displayName: displayName,
        role: role,
        siteId: siteId,
        siteName: siteName,
      ),
      loggedInAt: DateTime.utc(2026, 3, 24),
      persistedAt: DateTime.utc(2026, 3, 24),
    );
  }

  test('redirects unauthenticated users to login from protected routes', () {
    final result = resolveAppRedirectTarget(
      location: AppRoutePaths.inventory,
      authState: const AsyncLoading<AuthSession?>(),
      lastOperation: AuthOperation.restore,
    );

    expect(result, AppRoutePaths.login);
  });

  test('keeps the login bootstrap page while restoring session', () {
    final result = resolveAppRedirectTarget(
      location: AppRoutePaths.login,
      authState: const AsyncLoading<AuthSession?>(),
      lastOperation: AuthOperation.restore,
    );

    expect(result, isNull);
  });

  test('sends authenticated users from login to auth bootstrap', () {
    final session = buildSession(role: 'Weighbridge Operator');
    final result = resolveAppRedirectTarget(
      location: AppRoutePaths.login,
      authState: AsyncData<AuthSession?>(session),
      lastOperation: AuthOperation.login,
    );

    expect(result, AppRoutePaths.authBootstrap);
  });

  test('keeps authenticated users on auth bootstrap route', () {
    final session = buildSession(role: 'Warehouse Keeper');
    final result = resolveAppRedirectTarget(
      location: AppRoutePaths.authBootstrap,
      authState: AsyncData<AuthSession?>(session),
      lastOperation: AuthOperation.login,
    );

    expect(result, isNull);
  });

  test('keeps allowed routes and falls back from unknown routes', () {
    final session = buildSession(role: 'Warehouse Keeper');

    final allowedRouteResult = resolveAppRedirectTarget(
      location: AppRoutePaths.home,
      authState: AsyncData<AuthSession?>(session),
      lastOperation: AuthOperation.login,
    );
    final unknownRouteResult = resolveAppRedirectTarget(
      location: '/mystery/route',
      authState: AsyncData<AuthSession?>(session),
      lastOperation: AuthOperation.login,
    );

    expect(allowedRouteResult, isNull);
    expect(unknownRouteResult, AppRoutePaths.tasks);
  });

  test('falls back to the first shell route the role can access', () {
    final session = buildSession(role: 'Customer Viewer');

    final result = resolveAppRedirectTarget(
      location: '/admin/users',
      authState: AsyncData<AuthSession?>(session),
      lastOperation: AuthOperation.login,
    );

    expect(result, AppRoutePaths.home);
    expect(
      RoleGuard.firstAllowedShellPathForRoleName('Customer Viewer'),
      AppRoutePaths.home,
    );
  });

  test(
    'keeps authenticated user on login while waiting warehouse selection',
    () {
      final session = buildSession(role: 'Warehouse Keeper', siteId: '');

      final result = resolveAppRedirectTarget(
        location: AppRoutePaths.login,
        authState: AsyncData<AuthSession?>(session),
        lastOperation: AuthOperation.login,
      );

      expect(result, isNull);
    },
  );

  test(
    'redirects protected routes to login when warehouse context is missing',
    () {
      final session = buildSession(role: 'Warehouse Keeper', siteId: '');

      final result = resolveAppRedirectTarget(
        location: AppRoutePaths.inventory,
        authState: AsyncData<AuthSession?>(session),
        lastOperation: AuthOperation.login,
      );

      expect(result, AppRoutePaths.login);
    },
  );
}
