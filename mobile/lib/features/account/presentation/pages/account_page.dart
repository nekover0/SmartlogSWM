import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:smartlog_swm_mobile/app/router/app_route_paths.dart';
import 'package:smartlog_swm_mobile/app/shell/application/controllers/app_shell_controller.dart';
import 'package:smartlog_swm_mobile/core/permissions/role_matrix.dart';
import 'package:smartlog_swm_mobile/features/auth/application/controllers/auth_controller.dart';
import 'package:smartlog_swm_mobile/features/auth/data/dtos/auth_profile_dto.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_colors.dart';
import 'package:smartlog_swm_mobile/shared/theme/app_spacing.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final profileState = ref.watch(authMeProvider);
    final shellState = ref.watch(appShellControllerProvider);
    final session = authState.valueOrNull;
    final profile = profileState.valueOrNull;

    final roleLabel = _resolveRoleLabel(
      roleCodes: profile?.roleCodes,
      fallbackRole: shellState.currentRole.label,
    );
    final siteLabel = _resolveSiteLabel(
      profile: profile,
      fallbackSiteLabel: shellState.currentSite.label,
    );
    final displayName = _resolveDisplayName(
      profile: profile,
      fallbackDisplayName: shellState.displayName,
    );
    final userId = _resolveUserId(
      profile: profile,
      fallbackUserId: session?.currentUser.id,
    );
    final username = _resolveUsername(
      profile: profile,
      fallbackUsername: session?.currentUser.username,
    );

    final activeRole = _tryParseRole(roleLabel);
    final adminAccess = _accessFor(activeRole, AppModule.admin);
    final permissionGroups = _buildPermissionGroups(activeRole);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          key: const Key('account_back_button'),
          tooltip: 'Quay lại',
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              context.pop();
              return;
            }
            context.go(AppRoutePaths.more);
          },
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text('Tài khoản'),
        actions: [
          IconButton(
            tooltip: 'Thiết lập bảo mật',
            onPressed: () {},
            icon: const Icon(Icons.verified_user_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.xxl,
        ),
        children: [
          _ProfileHeaderCard(
            displayName: displayName,
            roleLabel: roleLabel,
            siteLabel: siteLabel,
            userId: userId,
            username: username,
          ),
          const SizedBox(height: AppSpacing.md),
          _RoleSummaryCard(roleLabel: roleLabel),
          const SizedBox(height: AppSpacing.lg),
          const _SectionHeading(
            key: Key('account_permissions_heading'),
            icon: Icons.rule_folder_outlined,
            title: 'QUYỀN HẠN CHI TIẾT',
          ),
          const SizedBox(height: AppSpacing.sm),
          ...permissionGroups.map(
            (group) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _PermissionGroupCard(group: group),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const _SectionHeading(
            key: Key('account_activity_heading'),
            icon: Icons.history_rounded,
            title: 'HOẠT ĐỘNG GẦN ĐÂY',
          ),
          const SizedBox(height: AppSpacing.sm),
          _ActivityLogCard(
            lastLogin: _formatDateTime(session?.loggedInAt ?? DateTime.now()),
            lastAction: 'Phê duyệt lô hàng #WH-9821',
            device: 'Zebra TC21 (Android 10)',
          ),
          const SizedBox(height: AppSpacing.lg),
          FilledButton.tonalIcon(
            key: const Key('account_permission_profile_button'),
            onPressed: () => context.go(AppRoutePaths.permissions),
            icon: const Icon(Icons.rule_outlined),
            label: const Text('HỒ SƠ PHÂN QUYỀN'),
          ),
          const SizedBox(height: AppSpacing.sm),
          FilledButton.icon(
            key: const Key('account_manage_users_roles_button'),
            onPressed: adminAccess.canView
                ? () => context.go(AppRoutePaths.userAdmin)
                : null,
            icon: const Icon(Icons.admin_panel_settings_outlined),
            label: const Text('QUẢN LÝ NGƯỜI DÙNG & VAI TRÒ'),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  key: const Key('account_change_password_button'),
                  onPressed: () {},
                  icon: const Icon(Icons.lock_outline_rounded),
                  label: const Text('ĐỔI MẬT KHẨU'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: OutlinedButton.icon(
                  key: const Key('account_manage_device_button'),
                  onPressed: () {},
                  icon: const Icon(Icons.devices_other_outlined),
                  label: const Text('QUẢN LÝ THIẾT BỊ'),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton.icon(
            key: const Key('account_logout_button'),
            onPressed: () async {
              await ref.read(authControllerProvider.notifier).logout();
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.danger,
              side: const BorderSide(color: AppColors.danger),
            ),
            icon: const Icon(Icons.logout_rounded),
            label: const Text('ĐĂNG XUẤT HỆ THỐNG'),
          ),
          const SizedBox(height: AppSpacing.lg),
          Center(
            child: Text(
              'IRONSTREAM LOGISTICS WMS V2.4.0-PRO',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.textSecondary,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppRole? _tryParseRole(String roleName) {
    try {
      return AppRole.fromName(roleName);
    } catch (_) {
      return null;
    }
  }

  ModuleAccess _accessFor(AppRole? role, AppModule module) {
    if (role == null) {
      return ModuleAccess.hidden;
    }
    return RoleMatrix.accessFor(role: role, module: module);
  }

  String _resolveDisplayName({
    required AuthProfileDto? profile,
    required String fallbackDisplayName,
  }) {
    final profileName = profile?.fullName.trim() ?? '';
    if (profileName.isNotEmpty) {
      return profileName;
    }

    return fallbackDisplayName;
  }

  String _resolveUserId({
    required AuthProfileDto? profile,
    required String? fallbackUserId,
  }) {
    final profileId = profile?.id.trim() ?? '';
    if (profileId.isNotEmpty) {
      return profileId;
    }

    final fallbackId = fallbackUserId?.trim() ?? '';
    return fallbackId.isNotEmpty ? fallbackId : 'N/A';
  }

  String? _resolveUsername({
    required AuthProfileDto? profile,
    required String? fallbackUsername,
  }) {
    final profileUsername = profile?.username.trim() ?? '';
    if (profileUsername.isNotEmpty) {
      return profileUsername;
    }

    final fallback = fallbackUsername?.trim() ?? '';
    return fallback.isNotEmpty ? fallback : null;
  }

  String _resolveRoleLabel({
    required List<String>? roleCodes,
    required String fallbackRole,
  }) {
    for (final roleCode in roleCodes ?? const <String>[]) {
      if (roleCode.trim().isEmpty) {
        continue;
      }

      try {
        return AppRole.fromName(roleCode).label;
      } catch (_) {
        continue;
      }
    }

    try {
      return AppRole.fromName(fallbackRole).label;
    } catch (_) {
      return fallbackRole;
    }
  }

  String _resolveSiteLabel({
    required AuthProfileDto? profile,
    required String fallbackSiteLabel,
  }) {
    if (profile == null || profile.warehouseOptions.isEmpty) {
      return fallbackSiteLabel;
    }

    final selectedWarehouseId = profile.selectedWarehouseId?.trim();
    if (selectedWarehouseId != null && selectedWarehouseId.isNotEmpty) {
      for (final option in profile.warehouseOptions) {
        if (option.id == selectedWarehouseId) {
          return option.name;
        }
      }
    }

    return profile.warehouseOptions.first.name;
  }

  List<_PermissionGroupData> _buildPermissionGroups(AppRole? role) {
    final inventoryAccess = _accessFor(role, AppModule.inventory);
    final inboundAccess = _accessFor(role, AppModule.inbound);
    final outboundAccess = _accessFor(role, AppModule.outbound);
    final reportAccess = _accessFor(role, AppModule.reports);
    final adminAccess = _accessFor(role, AppModule.admin);

    return [
      _PermissionGroupData(
        title: 'Inventory',
        icon: Icons.inventory_2_outlined,
        items: [
          _PermissionItemData(
            label: 'Xem tồn kho thời gian thực',
            granted: inventoryAccess.canView,
          ),
          _PermissionItemData(
            label: 'Điều chỉnh số lượng & audit',
            granted: inventoryAccess.canMutate,
          ),
        ],
      ),
      _PermissionGroupData(
        title: 'Inbound/Outbound',
        icon: Icons.swap_horiz_rounded,
        items: [
          _PermissionItemData(
            label: 'Phê duyệt phiếu nhập/xuất',
            granted: inboundAccess.canMutate && outboundAccess.canMutate,
          ),
          _PermissionItemData(
            label: 'Hủy đơn hàng đã xác nhận',
            granted: adminAccess.canView,
          ),
        ],
      ),
      _PermissionGroupData(
        title: 'Reports & Admin',
        icon: Icons.assessment_outlined,
        items: [
          _PermissionItemData(
            label: 'Xuất báo cáo KPI & Hiệu suất',
            granted: reportAccess.canView,
          ),
          _PermissionItemData(
            label: 'Quản lý người dùng & phân vai',
            granted: adminAccess.canView,
          ),
        ],
      ),
    ];
  }

  String _formatDateTime(DateTime value) {
    final local = value.toLocal();
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$day/$month/${local.year} $hour:$minute';
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  const _ProfileHeaderCard({
    required this.displayName,
    required this.roleLabel,
    required this.siteLabel,
    required this.userId,
    required this.username,
  });

  final String displayName;
  final String roleLabel;
  final String siteLabel;
  final String userId;
  final String? username;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      key: const Key('account_profile_header'),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFFE8EEF7),
              border: Border.all(color: AppColors.border),
            ),
            alignment: Alignment.center,
            child: Text(
              _initialsFromName(displayName),
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.brand,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  roleLabel,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    _SoftPill(label: siteLabel),
                    _SoftPill(label: 'ID: $userId'),
                    if ((username ?? '').trim().isNotEmpty)
                      _SoftPill(label: username!.trim()),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _initialsFromName(String name) {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList(growable: false);

    if (parts.isEmpty) {
      return 'SL';
    }

    final firstInitial = parts.first[0];
    if (parts.length == 1) {
      return firstInitial.toUpperCase();
    }

    return (firstInitial + parts.last[0]).toUpperCase();
  }
}

class _RoleSummaryCard extends StatelessWidget {
  const _RoleSummaryCard({required this.roleLabel});

  final String roleLabel;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('account_role_summary_card'),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const Icon(Icons.badge_outlined, color: AppColors.brand),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'System Role',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  roleLabel,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5EE),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: const Color(0xFFBDE2CB)),
            ),
            child: Text(
              'Active',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({super.key, required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.brand, size: 18),
        const SizedBox(width: AppSpacing.xs),
        Text(
          title,
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _PermissionGroupCard extends StatelessWidget {
  const _PermissionGroupCard({required this.group});

  final _PermissionGroupData group;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: Row(
              children: [
                Icon(group.icon, size: 18, color: AppColors.brand),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  group.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          ...group.items.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final itemWidget = _PermissionItemRow(
              key: Key('account_permission_${group.title}_$index'),
              item: item,
            );

            if (index == group.items.length - 1) {
              return itemWidget;
            }

            return Column(
              children: [
                itemWidget,
                const Divider(height: 1, color: AppColors.border),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _PermissionItemRow extends StatelessWidget {
  const _PermissionItemRow({super.key, required this.item});

  final _PermissionItemData item;

  @override
  Widget build(BuildContext context) {
    final tone = item.granted ? AppColors.success : AppColors.textSecondary;
    return Opacity(
      opacity: item.granted ? 1 : 0.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                item.label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              item.granted ? Icons.check_circle_rounded : Icons.remove_circle,
              color: tone,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityLogCard extends StatelessWidget {
  const _ActivityLogCard({
    required this.lastLogin,
    required this.lastAction,
    required this.device,
  });

  final String lastLogin;
  final String lastAction;
  final String device;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('account_activity_log_card'),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _LogRow(label: 'Đăng nhập gần nhất', value: lastLogin),
          const Divider(height: 1, color: AppColors.border),
          _LogRow(label: 'Tác vụ sau cùng', value: lastAction),
          const Divider(height: 1, color: AppColors.border),
          _LogRow(label: 'Thiết bị', value: device),
        ],
      ),
    );
  }
}

class _LogRow extends StatelessWidget {
  const _LogRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftPill extends StatelessWidget {
  const _SoftPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF3FA),
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _PermissionGroupData {
  const _PermissionGroupData({
    required this.title,
    required this.icon,
    required this.items,
  });

  final String title;
  final IconData icon;
  final List<_PermissionItemData> items;
}

class _PermissionItemData {
  const _PermissionItemData({required this.label, required this.granted});

  final String label;
  final bool granted;
}
