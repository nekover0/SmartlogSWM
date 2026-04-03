import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/core/permissions/role_guard.dart';
import 'package:smartlog_swm_mobile/features/auth/application/controllers/auth_controller.dart';
import 'package:smartlog_swm_mobile/features/auth/domain/entities/auth_session.dart';

String? resolveAppRedirectTarget({
  required String location,
  required AsyncValue<AuthSession?> authState,
  required AuthOperation lastOperation,
}) {
  final normalizedLocation = _normalizeLocation(location);
  final session = authState.valueOrNull;

  if (authState.isLoading &&
      lastOperation == AuthOperation.restore &&
      session == null) {
    return normalizedLocation == AppRoutePaths.login
        ? null
        : AppRoutePaths.login;
  }

  if (session == null) {
    return normalizedLocation == AppRoutePaths.login
        ? null
        : AppRoutePaths.login;
  }

  final hasWarehouseContext = session.currentUser.siteId.trim().isNotEmpty;
  final roleName = session.currentUser.role;
  if (normalizedLocation == AppRoutePaths.login) {
    if (!hasWarehouseContext) {
      return null;
    }

    return AppRoutePaths.authBootstrap;
  }

  if (normalizedLocation == AppRoutePaths.authBootstrap) {
    if (!hasWarehouseContext) {
      return AppRoutePaths.login;
    }

    return null;
  }

  if (!hasWarehouseContext) {
    return AppRoutePaths.login;
  }

  if (!RoleGuard.canAccessLocation(
    roleName: roleName,
    location: normalizedLocation,
  )) {
    return RoleGuard.firstAllowedShellPathForRoleName(roleName);
  }

  return null;
}

String? appRedirectGuard({
  required GoRouterState state,
  required AsyncValue<AuthSession?> authState,
  required AuthOperation lastOperation,
}) {
  return resolveAppRedirectTarget(
    location: state.uri.toString(),
    authState: authState,
    lastOperation: lastOperation,
  );
}

String _normalizeLocation(String location) {
  final uri = Uri.parse(location);
  final normalizedPath = uri.path.trim();
  return normalizedPath.isEmpty ? '/' : normalizedPath;
}
