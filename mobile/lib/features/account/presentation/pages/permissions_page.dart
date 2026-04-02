import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/app/shell/application/controllers/app_shell_controller.dart';
import 'package:smartlog_swm_mobile/core/permissions/permission_snapshot_mapper.dart';
import 'package:smartlog_swm_mobile/core/permissions/role_matrix.dart';
import 'package:smartlog_swm_mobile/features/auth/application/controllers/auth_controller.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_permissions_snapshot_dto.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';

class PermissionsPage extends ConsumerWidget {
  const PermissionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final permissionsState = ref.watch(authPermissionsSnapshotProvider);
    final shellState = ref.watch(appShellControllerProvider);
    final session = authState.valueOrNull;
    final permissionsSnapshot = permissionsState.valueOrNull;
    final roleName = _resolvePrimaryRoleLabel(
      permissionsSnapshot: permissionsSnapshot,
      fallbackRole: shellState.currentRole.label,
    );
    final role = _parseRole(roleName);

    final snapshotAccessByModule = permissionsSnapshot == null
        ? const <AppModule, ModuleAccess>{}
        : PermissionSnapshotMapper.toModuleAccess(
            roleCodes: permissionsSnapshot.roleCodes,
            permissions: permissionsSnapshot.permissions,
          );

    final permissionRows = AppModule.values
        .map((module) {
          return _PermissionRowData(
            moduleLabel: _moduleLabel(module),
            access: snapshotAccessByModule[module] ?? _accessFor(role, module),
          );
        })
        .toList(growable: false);

    final canAccessAdmin =
        (snapshotAccessByModule[AppModule.admin] ??
                _accessFor(role, AppModule.admin))
            .canView;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Phân quyền'),
        leading: IconButton(
          tooltip: 'Quay lại',
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              context.pop();
              return;
            }
            context.go(AppRoutePaths.account);
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
      ),
      body: ListView(
        padding: AppSpacing.pagePadding,
        children: [
          _ProfileSummaryCard(
            displayName: shellState.displayName,
            roleName: roleName,
            siteName: shellState.currentSite.label,
            statusLabel: session == null ? 'Offline' : 'Active',
          ),
          const SizedBox(height: AppSpacing.md),
          _PermissionMatrixCard(rows: permissionRows),
          const SizedBox(height: AppSpacing.md),
          _ActivityLogCard(logs: _buildActivityLogs(session?.loggedInAt)),
          const SizedBox(height: AppSpacing.md),
          FilledButton.icon(
            onPressed: canAccessAdmin
                ? () {
                    context.go(AppRoutePaths.userAdmin);
                  }
                : null,
            icon: const Icon(Icons.manage_accounts_outlined),
            label: const Text('Quản lý người dùng'),
          ),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton.icon(
            onPressed: canAccessAdmin
                ? () {
                    context.go(AppRoutePaths.roleAdmin);
                  }
                : null,
            icon: const Icon(Icons.rule_folder_outlined),
            label: const Text('Quản lý vai trò'),
          ),
        ],
      ),
    );
  }

  AppRole? _parseRole(String roleName) {
    try {
      return AppRole.fromName(roleName);
    } catch (_) {
      return null;
    }
  }

  String _resolvePrimaryRoleLabel({
    required AuthPermissionsSnapshotDto? permissionsSnapshot,
    required String fallbackRole,
  }) {
    for (final roleCode in permissionsSnapshot?.roleCodes ?? const <String>[]) {
      if (roleCode.trim().isEmpty) {
        continue;
      }

      try {
        return AppRole.fromName(roleCode).label;
      } catch (_) {
        continue;
      }
    }

    return fallbackRole;
  }

  ModuleAccess _accessFor(AppRole? role, AppModule module) {
    if (role == null) {
      return ModuleAccess.hidden;
    }

    return RoleMatrix.accessFor(role: role, module: module);
  }

  String _moduleLabel(AppModule module) {
    return switch (module) {
      AppModule.home => 'Tổng quan',
      AppModule.tasks => 'Công việc',
      AppModule.scan => 'Scan',
      AppModule.inventory => 'Tồn kho',
      AppModule.inbound => 'Inbound',
      AppModule.outbound => 'Outbound',
      AppModule.ocr => 'OCR',
      AppModule.inventoryControl => 'Kiểm kê & chuyển vị trí',
      AppModule.reports => 'Báo cáo',
      AppModule.account => 'Tài khoản',
      AppModule.admin => 'Quản trị',
    };
  }

  List<_ActivityLogData> _buildActivityLogs(DateTime? loggedInAt) {
    final now = DateTime.now();
    final loginAt = (loggedInAt ?? now).toLocal();

    return [
      _ActivityLogData(
        label: 'Đăng nhập gần nhất',
        value: _formatDateTime(loginAt),
      ),
      const _ActivityLogData(
        label: 'Tác vụ gần nhất',
        value: 'Xem danh sách quyền theo module',
      ),
      const _ActivityLogData(
        label: 'Thiết bị',
        value: 'Zebra TC21 · Android 10',
      ),
    ];
  }

  String _formatDateTime(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$day/$month/${value.year} $hour:$minute';
  }
}

class _ProfileSummaryCard extends StatelessWidget {
  const _ProfileSummaryCard({
    required this.displayName,
    required this.roleName,
    required this.siteName,
    required this.statusLabel,
  });

  final String displayName;
  final String roleName;
  final String siteName;
  final String statusLabel;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.brand.withValues(alpha: 0.1),
              foregroundColor: AppColors.brand,
              child: Text(_initials(displayName)),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$roleName · $siteName',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            _AccessBadge(
              label: statusLabel,
              access: statusLabel == 'Active'
                  ? ModuleAccess.full
                  : ModuleAccess.hidden,
            ),
          ],
        ),
      ),
    );
  }

  String _initials(String name) {
    final segments = name.trim().split(RegExp(r'\s+'));
    if (segments.isEmpty || segments.first.isEmpty) {
      return 'U';
    }
    if (segments.length == 1) {
      return segments.first[0].toUpperCase();
    }

    return '${segments.first[0]}${segments.last[0]}'.toUpperCase();
  }
}

class _PermissionMatrixCard extends StatelessWidget {
  const _PermissionMatrixCard({required this.rows});

  final List<_PermissionRowData> rows;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Danh sách quyền theo module',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.sm),
            ...rows.map(
              (row) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Row(
                  children: [
                    Expanded(child: Text(row.moduleLabel)),
                    _AccessBadge(
                      label: _accessLabel(row.access),
                      access: row.access,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _accessLabel(ModuleAccess access) {
    return switch (access) {
      ModuleAccess.full => 'Toàn quyền',
      ModuleAccess.readOnly => 'Chỉ xem',
      ModuleAccess.hidden => 'Ẩn',
    };
  }
}

class _ActivityLogCard extends StatelessWidget {
  const _ActivityLogCard({required this.logs});

  final List<_ActivityLogData> logs;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Activity log',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.sm),
            ...logs.map(
              (log) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 140,
                      child: Text(
                        log.label,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: Text(log.value)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccessBadge extends StatelessWidget {
  const _AccessBadge({required this.label, required this.access});

  final String label;
  final ModuleAccess access;

  @override
  Widget build(BuildContext context) {
    final color = switch (access) {
      ModuleAccess.full => AppColors.success,
      ModuleAccess.readOnly => AppColors.warning,
      ModuleAccess.hidden => AppColors.textSecondary,
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _PermissionRowData {
  const _PermissionRowData({required this.moduleLabel, required this.access});

  final String moduleLabel;
  final ModuleAccess access;
}

class _ActivityLogData {
  const _ActivityLogData({required this.label, required this.value});

  final String label;
  final String value;
}
