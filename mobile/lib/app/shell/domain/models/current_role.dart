import 'package:smartlog_swm_mobile/core/permissions/role_guard.dart';

class CurrentRole {
  const CurrentRole({
    required this.name,
    required this.showTasksTab,
    required this.showScanFab,
  });

  final String name;
  final bool showTasksTab;
  final bool showScanFab;

  factory CurrentRole.fromRoleName(String roleName) {
    final normalizedRoleName = roleName.trim().isEmpty
        ? 'Customer Viewer'
        : roleName.trim();

    return CurrentRole(
      name: normalizedRoleName,
      showTasksTab: RoleGuard.showsTasksTab(normalizedRoleName),
      showScanFab: RoleGuard.showsScanFab(normalizedRoleName),
    );
  }

  String get label => name;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is CurrentRole &&
            runtimeType == other.runtimeType &&
            name == other.name &&
            showTasksTab == other.showTasksTab &&
            showScanFab == other.showScanFab;
  }

  @override
  int get hashCode => Object.hash(name, showTasksTab, showScanFab);
}
