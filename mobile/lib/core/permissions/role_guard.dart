import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/core/permissions/role_matrix.dart';

abstract final class RoleGuard {
  static const List<String> _fallbackShellPaths = <String>[
    AppRoutePaths.tasks,
    AppRoutePaths.home,
    AppRoutePaths.inventory,
    AppRoutePaths.more,
  ];

  static ModuleAccess accessForRoleName({
    required String roleName,
    required AppModule module,
  }) {
    return RoleMatrix.accessFor(role: AppRole.fromName(roleName), module: module);
  }

  static bool canAccessModule({
    required String roleName,
    required AppModule module,
  }) {
    return accessForRoleName(roleName: roleName, module: module).canView;
  }

  static bool canMutateModule({
    required String roleName,
    required AppModule module,
  }) {
    return accessForRoleName(roleName: roleName, module: module).canMutate;
  }

  static String defaultLandingPathForRoleName(String roleName) {
    return defaultLandingPathForRole(AppRole.fromName(roleName));
  }

  static String defaultLandingPathForRole(AppRole role) {
    switch (role) {
      case AppRole.administrator:
        return AppRoutePaths.home;
      case AppRole.operationsSupervisor:
        return AppRoutePaths.tasks;
      case AppRole.warehouseManager:
        return AppRoutePaths.home;
      case AppRole.warehouseKeeper:
        return AppRoutePaths.tasks;
      case AppRole.weighbridgeOperator:
        return AppRoutePaths.tasksPath(type: 'weighing');
      case AppRole.customerViewer:
        return AppRoutePaths.inventory;
      case AppRole.billingOfficer:
        return AppRoutePaths.reports;
      case AppRole.governanceManager:
        return AppRoutePaths.reports;
    }
  }

  static String firstAllowedShellPathForRoleName(String roleName) {
    return firstAllowedShellPathForRole(AppRole.fromName(roleName));
  }

  static String firstAllowedShellPathForRole(AppRole role) {
    for (final location in _fallbackShellPaths) {
      if (canAccessLocationForRole(role: role, location: location)) {
        return location;
      }
    }

    return AppRoutePaths.more;
  }

  static bool canAccessLocation({
    required String roleName,
    required String location,
  }) {
    return canAccessLocationForRole(
      role: AppRole.fromName(roleName),
      location: location,
    );
  }

  static bool canAccessLocationForRole({
    required AppRole role,
    required String location,
  }) {
    final module = moduleForLocation(location);
    if (module == null) {
      return true;
    }

    return RoleMatrix.canAccess(role: role, module: module);
  }

  static bool showsTasksTab(String roleName) {
    return canAccessModule(roleName: roleName, module: AppModule.tasks);
  }

  static bool showsScanFab(String roleName) {
    return canMutateModule(roleName: roleName, module: AppModule.scan);
  }

  static AppModule? moduleForLocation(String location) {
    final normalizedLocation = _normalizeLocation(location);

    if (normalizedLocation == AppRoutePaths.login ||
        normalizedLocation == AppRoutePaths.more ||
        normalizedLocation == AppRoutePaths.notifications) {
      return null;
    }

    if (normalizedLocation == AppRoutePaths.home) {
      return AppModule.home;
    }
    if (normalizedLocation == AppRoutePaths.tasks) {
      return AppModule.tasks;
    }
    if (normalizedLocation == AppRoutePaths.inventory ||
        normalizedLocation.startsWith('${AppRoutePaths.inventory}/')) {
      return AppModule.inventory;
    }
    if (normalizedLocation == AppRoutePaths.inventoryControl ||
        normalizedLocation.startsWith('${AppRoutePaths.inventoryControl}/')) {
      return AppModule.inventoryControl;
    }
    if (normalizedLocation == AppRoutePaths.receiptList ||
        normalizedLocation.startsWith('${AppRoutePaths.receiptList}/')) {
      return AppModule.inbound;
    }
    if (normalizedLocation == AppRoutePaths.shipmentList ||
        normalizedLocation.startsWith('${AppRoutePaths.shipmentList}/')) {
      return AppModule.outbound;
    }
    if (normalizedLocation == AppRoutePaths.scanBarcode ||
        normalizedLocation == AppRoutePaths.scanManual ||
        normalizedLocation.startsWith('/scan/')) {
      return AppModule.scan;
    }
    if (normalizedLocation == AppRoutePaths.ocrInbox ||
        normalizedLocation.startsWith('${AppRoutePaths.ocrInbox}/')) {
      return AppModule.ocr;
    }
    if (normalizedLocation == AppRoutePaths.reports) {
      return AppModule.reports;
    }
    if (normalizedLocation == AppRoutePaths.account ||
        normalizedLocation.startsWith('${AppRoutePaths.account}/')) {
      return AppModule.account;
    }
    if (normalizedLocation.startsWith('/admin/')) {
      return AppModule.admin;
    }

    return null;
  }

  static String _normalizeLocation(String location) {
    final uri = Uri.parse(location);
    final normalizedPath = uri.path.trim();
    return normalizedPath.isEmpty ? '/' : normalizedPath;
  }
}
